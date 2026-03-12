# Lab 8: CPU + GPU + FIFO Integration Guide

This document describes how to integrate the CPU pipeline (`pipeline_pseudoARM`), GPU pipeline (`pipeline_backup`), and convertible FIFO. **CPU and GPU share the same FIFO BRAM** for DMEM. Control registers (0xF0–0xFF) are written by the CPU during CUDA-style calls to orchestrate the GPU.

---

## 1. Architecture Overview

```
                         ┌─────────────────────────────────────────────────────────────┐
                         │                    IDS (integrated)                          │
                         │                                                              │
  Host (ARM/CPU) ───────►│  ┌────────────────────────────────────────────────────────┐  │
  Registers              │  │              SHARED FIFO BRAM (256 x 72b)                │  │
  (INPUT_TYPE,            │  │  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  │  │
   ADDRESS,               │  │  │ Data 0x00-   │  │ Control       │  │ FIFO         │  │  │
   IMEM, DMEM)            │  │  │ 0xEF         │  │ 0xF0-0xFF     │  │ 0xFE, 0xFF   │  │  │
                         │  │  │ CPU + GPU     │  │ CPU writes    │  │ head/tail    │  │  │
                         │  │  │ data (SW     │  │ GPU control   │  │              │  │  │
                         │  │  │ convention)  │  │ GPU writes    │  │              │  │  │
                         │  │  └──────┬───────┘  │ 0xF3 (done)   │  └──────────────┘  │  │
                         │  │         │          └──────────────┘                     │  │
                         │  └─────────┼───────────────────────────────────────────────┘  │
                         │            │                                                  │
                         │  ┌─────────▼─────────┐    ┌──────────────────────────────┐   │
                         │  │ pipeline_pseudoARM│    │ pipeline_backup (GPU)         │   │
                         │  │ (CPU)             │    │ Reads 0xF0,0xF1,0xF2;        │   │
                         │  │ Loads/stores data │    │ Writes 0xF3 when done         │   │
                         │  └───────────────────┘    └───────────────────────────────┘   │
                         └─────────────────────────────────────────────────────────────┘
```

---

## 2. Memory Map (Shared FIFO BRAM)

**All of 0x00–0xFF lives in the same convertible FIFO BRAM.** CPU and GPU both access it; software convention partitions the data region.

### 2.1 Memory Map Table (Screenshot-ready)

| Addr Range   | Name           | R/W    | Description |
|--------------|----------------|--------|-------------|
| **0x00–0xEF**| Data           | CPU+GPU| Shared data. CPU and GPU operands/results. Partition by SW (e.g. CPU 0x00–0x6F, GPU 0x70–0xEF). |
| **0xF0**     | GPU_INST_BASE  | W (CPU)| Base address in BRAM for GPU to fetch instructions. CPU writes during CUDA launch. |
| **0xF1**     | GPU_INST_CNT   | W (CPU)| Number of contiguous instructions to fetch. CPU writes. |
| **0xF2**     | GPU_GO         | W (CPU)| Signal: CPU has written all instructions; GPU may begin fetching. CPU writes. |
| **0xF3**     | GPU_DONE       | W (GPU)| GPU writes when tensor execution completes. CPU reads to synchronize. |
| **0xF4–0xFD**| Reserved       | —      | Future control. |
| **0xFE**     | FIFO_HEAD      | FIFO   | Head pointer (network packet mode). |
| **0xFF**     | FIFO_TAIL      | FIFO   | Tail pointer (network packet mode). |

### 2.2 CUDA-Style Launch Sequence (CPU → GPU)

1. CPU writes GPU instructions into BRAM (e.g. starting at chosen base).
2. CPU writes **0xF0** = base address for instruction fetch.
3. CPU writes **0xF1** = number of instructions.
4. CPU writes **0xF2** = GO signal (GPU may start fetching).
5. GPU reads 0xF0, 0xF1, 0xF2; fetches instructions from BRAM; executes.
6. GPU writes **0xF3** when tensor is done.
7. CPU reads **0xF3** to detect completion.

### 2.3 Data Region Convention (ptx2custom.py)

| Addr   | Use |
|--------|-----|
| 0x90   | ARRAY_A_BASE (operands) |
| 0x94   | ARRAY_B_BASE |
| 0x98   | ARRAY_C_BASE (results) |
| 0x9C   | ARRAY_D_BASE (MAC accumulator) |

**gpu_dotprod.pl**: 0x70–0x75 data, 0xC0–0xC1 results.

---

## 3. Interface Comparison (Both Use Same FIFO)

| Signal / Feature   | pipeline_pseudoARM (CPU)     | pipeline_backup (GPU)        |
|--------------------|-----------------------------|------------------------------|
| DMEM source        | **Same FIFO BRAM**          | **Same FIFO BRAM**           |
| Pipeline load/store| me_alu_res[7:0], me_store_data, me_wme | pipeline_addr, pipeline_data, pipeline_we |
| Pipeline DMEM out  | dmem_raw_output (32b)       | dmem_out (64b from FIFO)     |
| Control regs       | Writes 0xF0, 0xF1, 0xF2; reads 0xF3 | Reads 0xF0–0xF2; writes 0xF3 |

**Note:** CPU pipeline currently uses `memory.v` internally. For shared FIFO, replace `memory.v` with external FIFO ports (like GPU) so both pipelines drive the same BRAM.

---

## 4. Integration Steps (Reference Design)

### Step 4.1: Modify CPU Pipeline for Shared FIFO

Replace `memory.v` in `pipeline_pseudoARM` with external DMEM ports connected to the FIFO (same pattern as `pipeline_backup`). Both pipelines then share the same BRAM.

### Step 4.2: GPU Control Register Logic

The GPU must:
- Read **0xF0** (inst base), **0xF1** (inst count), **0xF2** (GO) from BRAM.
- Start fetching when 0xF2 is written.
- Write **0xF3** when tensor execution completes.

### Step 4.3: ids_integrated.v Skeleton (Verilog)

```verilog
// Both pipelines connect to same FIFO
wire [7:0]  bram_addr;   // Mux: host, cpu_pipeline, or gpu_pipeline
wire [63:0] bram_din;    // Mux: host, cpu_store, or gpu_store
wire        bram_we;     // Any writer

// Arbitration: host has priority when active; else CPU vs GPU by... (e.g. round-robin or GPU-only for tensor)
// GPU control: GPU reads 0xF0,0xF1,0xF2; writes 0xF3 on completion
```

---

## 5. Lab 8 Report Next Steps

### 5.1 Verification Order

1. **GPU + FIFO only** (current): Run `gpu_dotprod.pl`; confirm dot product result.
2. **CPU + memory only**: If you have a CPU test script, run it with the original ids (CPU path).
3. **Full integration**: Swap `ids.v` for `ids_integrated.v` (or merge logic into ids.v); run both tests with the memory map.

### 5.2 Report Sections to Complete

| Section | Content |
|---------|---------|
| **Architecture** | Block diagram: CPU pipeline, GPU pipeline, FIFO, memory map, arbitration. |
| **Memory Map** | Table of regions (CPU 0x00–0x6F, GPU 0x70–0xFD, FIFO 0xFE–0xFF). |
| **Integration** | How ids routes host accesses; how CPU and GPU share/partition DMEM. |
| **Testing** | gpu_dotprod.pl results; CPU test (if any); combined test procedure. |
| **Results** | Screenshots of regread outputs; expected vs actual values. |

### 5.3 Files to Create (When Ready)

| File | Purpose |
|------|---------|
| `docs/LAB8_INTEGRATION_GUIDE.md` | This document |
| `test/mem_map.pl` | Memory map constants and helpers for Perl tests |
| `src/ids_integrated.v` | Full CPU+GPU+FIFO ids (after GPU test passes) |

### 5.4 Prj / Makefile Updates (When Integrating)

- Add `ids_integrated.v` to `nf2_top.prj` (or replace `ids.v`).
- Add `pipeline_pseudoARM.v` if not already present.
- Add `memory.v` for CPU path.
- Ensure `alu_32bit.v` (or equivalent) is included for CPU ALU.

---

## 6. Quick Reference: Current vs Integrated

| Component | Current (GPU-only) | Integrated |
|-----------|--------------------|------------|
| FIFO BRAM | GPU only | **Shared by CPU + GPU** |
| pipeline_backup | ✓ | ✓ |
| pipeline_pseudoARM | ✗ | ✓ (modified for FIFO) |
| Control regs 0xF0–0xF3 | ✗ | ✓ (GPU launch/done) |
| Mem map | Implicit | 0x00–0xEF data, 0xF0–0xFF control |

---

## 7. Checklist Before Full Integration

- [ ] `gpu_dotprod.pl` passes on FPGA
- [ ] CPU pipeline modified to use FIFO instead of memory.v
- [ ] GPU reads 0xF0, 0xF1, 0xF2; writes 0xF3 on done
- [ ] `mem_map.pl` updated with control reg constants
- [ ] Combined test: CPU writes instructions, sets 0xF0–0xF2, GPU runs, CPU reads 0xF3

---

## 8. Memory Map Diagram (for Report Screenshot)

A diagram image (`mem_map_diagram.png`) may be in `assets/` for report inclusion. See **Section 2.1** table for the full spec. ASCII version:

```
┌─────────────────────────────────────────────────────────────────┐
│  FIFO BRAM (Shared DMEM) - 256 x 72-bit words                    │
├─────────────┬───────────────────────────────────────────────────┤
│ 0x00-0xEF   │ DATA: CPU + GPU operands/results (SW convention)   │
├─────────────┼───────────────────────────────────────────────────┤
│ 0xF0        │ GPU_INST_BASE  (CPU W) Base addr for inst fetch    │
│ 0xF1        │ GPU_INST_CNT   (CPU W) Num instructions           │
│ 0xF2        │ GPU_GO         (CPU W) Signal: begin fetch         │
│ 0xF3        │ GPU_DONE       (GPU W) Tensor complete            │
│ 0xF4-0xFD   │ Reserved                                            │
│ 0xFE        │ FIFO_HEAD     (FIFO)                               │
│ 0xFF        │ FIFO_TAIL     (FIFO)                               │
└─────────────┴───────────────────────────────────────────────────┘
```

---

## 9. Files Created (This Session)

| File | Purpose |
|------|---------|
| `docs/LAB8_INTEGRATION_GUIDE.md` | This integration guide |
| `docs/ids_integrated_reference.v` | Verilog skeleton |
| `test/mem_map.pl` | Memory map + control reg constants |
