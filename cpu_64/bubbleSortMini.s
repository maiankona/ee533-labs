@ E3A01009	Initialize outer loop counter (Passes).
MOV R1, #9	

@ E3A02000 Initialize inner loop counter (Index).
MOV R2, #0	


@ E0873002 Calculate address of current element [R7 + R2].
ADD R3, R7, R2	

@ E5934000 Load Data[i] into R4.
LDR R4, [R3, #0]	

@ E2835001 Calculate address of next element [R3 + 1].
ADD R5, R3, #1	


@ E5956000 Load Data[i+1] into R6.
LDR R6, [R5, #0]	

@ A9560044 Part 1: Compare Data[i+1] and Data[i].
CMP R6, R4	


@ Part 2: Branch if Data[i+1] >= Data[i] (using your 1010 cond).
BGE SKIP_SWAP	


@ E1A00000 Pipeline bubble / Delay slot.
NOP	

@ E5836000 Swap: Store Data[i+1] into index i.
STR R6, [R3, #0]	


@ E5854000 Swap: Store Data[i] into index i+1.
STR R4, [R5, #0]	

@ E2822001 Increment inner loop index.
ADD R2, R2, #1	

@ 19520F71	Part 1: Compare current index with max pass count.
CMP R2, R1	

@ Part 2: If index != max, branch back (using your 0001 cond).
BNE INNER_LOOP	

@ E1A00000	Pipeline bubble / Delay slot.
NOP	

@ E2411001 Decrement outer loop counter.	
SUB R1, R1, #1	

@ 18510F30 Part 1: Compare pass counter with zero.
CMP R1, #0	

@ Part 2: If passes != 0, restart outer loop.
BNE OUTER_LOOP	
