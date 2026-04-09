/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                         */
/*  \   \        Copyright (c) 2003-2007 Xilinx, Inc.                 */
/*  /   /        All Right Reserved.                                  */
/* /---/   /\                                                         */
/* \   \  /  \                                                        */
/*  \___\/\___\                                                       */
/**********************************************************************/

/* This file is designed for use with ISim build 0x734844ce */

#include "xsi.h"
#include <memory.h>
#ifdef __GNUC__
#include <stdlib.h>
#else
#include <malloc.h>
#define alloca _alloca
#endif
static const char *ng0 = "C:/Xilinx/10.1/ISE/ISEexamples/ee533-lab9/tb_host_cpu_gpu_fifo.v";
static unsigned int ng1[] = {0U, 0U};
static unsigned int ng2[] = {1U, 0U};
static unsigned int ng3[] = {132U, 0U};
static unsigned int ng4[] = {129U, 0U};
static unsigned int ng5[] = {128U, 0U};
static unsigned int ng6[] = {131U, 0U};
static unsigned int ng7[] = {2U, 0U};
static unsigned int ng8[] = {4U, 0U};
static int ng9[] = {3, 0};
static unsigned int ng10[] = {130U, 0U};
static unsigned int ng11[] = {8U, 0U};
static int ng12[] = {0, 0};
static int ng13[] = {1, 0};
static int ng14[] = {0, 0, 0, 0};
static int ng15[] = {4, 0};
static const char *ng16 = "=== tb_host_cpu_gpu_fifo: reset at cycle %0d ===";
static const char *ng17 = "--- Host DMEM write @0x00 (64b) ---";
static unsigned int ng18[] = {2864434397U, 0U};
static unsigned int ng19[] = {287454020U, 0U};
static int ng20[] = {2, 0};
static const char *ng21 = "--- Host DMEM read @0x00 ---";
static const char *ng22 = "    dmem_out (64b) = %h  (expect 11223344AABBCCDD if aligned read matches write)";
static const char *ng23 = "--- GPU: IMEM[0]=0, address=32'h00000100 (len=1, PC=0), GPU_START ---";
static unsigned int ng24[] = {256U, 0U};
static int ng25[] = {80, 0};
static const char *ng26 = "    After GPU window: tensor_out (hw) = %h";
static const char *ng27 = "    Host readback dmem_out = %h";
static const char *ng28 = "--- ARM: IMEM[0] = B self, cpu_start pulse ---";
static unsigned int ng29[] = {3942645758U, 0U};
static int ng30[] = {20, 0};
static const char *ng31 = "=== tb_host_cpu_gpu_fifo done ===";
static const char *ng32 = "    (ids) arm_mem_stall=%0d at end — 1 means ARM still waiting on GPU/host SRAM";
static const char *ng33 = "TIMEOUT";



static int sp_reg_write(char *t1, char *t2)
{
    int t0;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;

LAB0:    t0 = 1;
    t3 = (t2 + 24U);
    t4 = *((char **)t3);
    if (t4 == 0)
        goto LAB2;

LAB3:    goto *t4;

LAB2:    t4 = (t1 + 1216);
    xsi_vlog_subprogram_setdisablestate(t4, &&LAB4);
    xsi_set_current_line(165, ng0);

LAB5:    xsi_set_current_line(166, ng0);
    t5 = (t2 + 44U);
    t6 = *((char **)t5);
    t7 = (t6 + 0U);
    xsi_wp_set_status(t7, 1);
    *((char **)t3) = &&LAB6;

LAB1:    return t0;
LAB4:    xsi_vlog_dispose_subprogram_invocation(t2);
    t4 = (t2 + 24U);
    *((char **)t4) = &&LAB2;
    t0 = 0;
    goto LAB1;

LAB6:    xsi_set_current_line(167, ng0);
    t4 = (t1 + 5732);
    t5 = (t4 + 32U);
    t6 = *((char **)t5);
    t7 = (t1 + 4812);
    xsi_vlogvar_assign_value(t7, t6, 0, 0, 23);
    xsi_set_current_line(168, ng0);
    t4 = (t1 + 5824);
    t5 = (t4 + 32U);
    t6 = *((char **)t5);
    t7 = (t1 + 4904);
    xsi_vlogvar_assign_value(t7, t6, 0, 0, 32);
    xsi_set_current_line(169, ng0);
    t4 = ((char*)((ng1)));
    t5 = (t1 + 4720);
    xsi_vlogvar_assign_value(t5, t4, 0, 0, 1);
    xsi_set_current_line(170, ng0);
    t4 = ((char*)((ng2)));
    t5 = (t1 + 4628);
    xsi_vlogvar_assign_value(t5, t4, 0, 0, 1);
    xsi_set_current_line(171, ng0);
    t4 = (t2 + 44U);
    t5 = *((char **)t4);
    t6 = (t5 + 8U);
    xsi_wp_set_status(t6, 1);
    *((char **)t3) = &&LAB7;
    goto LAB1;

LAB7:    xsi_set_current_line(172, ng0);
    t4 = (t2 + 44U);
    t5 = *((char **)t4);
    t6 = (t5 + 16U);
    xsi_wp_set_status(t6, 1);
    *((char **)t3) = &&LAB8;
    goto LAB1;

LAB8:    xsi_set_current_line(173, ng0);
    t4 = ((char*)((ng1)));
    t5 = (t1 + 4628);
    xsi_vlogvar_assign_value(t5, t4, 0, 0, 1);
    xsi_set_current_line(174, ng0);
    t4 = ((char*)((ng2)));
    t5 = (t1 + 4720);
    xsi_vlogvar_assign_value(t5, t4, 0, 0, 1);
    xsi_set_current_line(175, ng0);
    t4 = (t2 + 44U);
    t5 = *((char **)t4);
    t6 = (t5 + 24U);
    xsi_wp_set_status(t6, 1);
    *((char **)t3) = &&LAB9;
    goto LAB1;

LAB9:    goto LAB4;

}

static int sp_pulse_input_type(char *t1, char *t2)
{
    int t0;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;
    char *t8;
    char *t9;
    char *t10;
    char *t11;
    char *t12;
    char *t13;
    char *t14;
    char *t15;
    char *t16;
    char *t17;
    char *t18;
    char *t19;
    char *t20;
    int t21;
    char *t22;
    char *t23;
    char *t24;
    char *t25;
    char *t26;
    char *t27;

LAB0:    t0 = 1;
    t3 = (t2 + 24U);
    t4 = *((char **)t3);
    if (t4 == 0)
        goto LAB2;

LAB3:    goto *t4;

LAB2:    t4 = (t1 + 1456);
    xsi_vlog_subprogram_setdisablestate(t4, &&LAB4);
    xsi_set_current_line(181, ng0);

LAB5:    xsi_set_current_line(182, ng0);
    t5 = ((char*)((ng3)));
    t6 = ((char*)((ng1)));
    t7 = (t2 + 28U);
    t8 = *((char **)t7);
    t9 = (t1 + 1216);
    t10 = xsi_create_subprogram_invocation(t8, 0, t1, t9, 0, t2);
    xsi_vlog_subprogram_pushinvocation(t9, t10);
    t11 = (t1 + 5732);
    xsi_vlogvar_assign_value(t11, t5, 0, 0, 23);
    t12 = (t1 + 5824);
    xsi_vlogvar_assign_value(t12, t6, 0, 0, 32);

LAB7:    t13 = (t2 + 32U);
    t14 = *((char **)t13);
    t15 = (t14 + 40U);
    t16 = *((char **)t15);
    t17 = (t16 + 132U);
    t18 = *((char **)t17);
    t19 = (t18 + 0U);
    t20 = *((char **)t19);
    t21 = ((int  (*)(char *, char *))t20)(t1, t14);
    if (t21 != 0)
        goto LAB9;

LAB8:    t14 = (t1 + 1216);
    xsi_vlog_subprogram_popinvocation(t14);

LAB6:    t22 = (t2 + 32U);
    t23 = *((char **)t22);
    t22 = (t1 + 1216);
    t24 = (t2 + 32U);
    t25 = *((char **)t24);
    t24 = (t2 + 28U);
    t26 = *((char **)t24);
    xsi_delete_subprogram_invocation(t22, t25, t1, t26, t2);
    xsi_set_current_line(183, ng0);
    t4 = ((char*)((ng3)));
    t5 = (t1 + 5916);
    t6 = (t5 + 32U);
    t7 = *((char **)t6);
    t8 = (t2 + 28U);
    t9 = *((char **)t8);
    t10 = (t1 + 1216);
    t11 = xsi_create_subprogram_invocation(t9, 0, t1, t10, 0, t2);
    xsi_vlog_subprogram_pushinvocation(t10, t11);
    t12 = (t1 + 5732);
    xsi_vlogvar_assign_value(t12, t4, 0, 0, 23);
    t13 = (t1 + 5824);
    xsi_vlogvar_assign_value(t13, t7, 0, 0, 32);

LAB11:    t14 = (t2 + 32U);
    t15 = *((char **)t14);
    t16 = (t15 + 40U);
    t17 = *((char **)t16);
    t18 = (t17 + 132U);
    t19 = *((char **)t18);
    t20 = (t19 + 0U);
    t22 = *((char **)t20);
    t21 = ((int  (*)(char *, char *))t22)(t1, t15);
    if (t21 != 0)
        goto LAB13;

LAB12:    t15 = (t1 + 1216);
    xsi_vlog_subprogram_popinvocation(t15);

LAB10:    t23 = (t2 + 32U);
    t24 = *((char **)t23);
    t23 = (t1 + 1216);
    t25 = (t2 + 32U);
    t26 = *((char **)t25);
    t25 = (t2 + 28U);
    t27 = *((char **)t25);
    xsi_delete_subprogram_invocation(t23, t26, t1, t27, t2);
    xsi_set_current_line(184, ng0);
    t4 = ((char*)((ng3)));
    t5 = ((char*)((ng1)));
    t6 = (t2 + 28U);
    t7 = *((char **)t6);
    t8 = (t1 + 1216);
    t9 = xsi_create_subprogram_invocation(t7, 0, t1, t8, 0, t2);
    xsi_vlog_subprogram_pushinvocation(t8, t9);
    t10 = (t1 + 5732);
    xsi_vlogvar_assign_value(t10, t4, 0, 0, 23);
    t11 = (t1 + 5824);
    xsi_vlogvar_assign_value(t11, t5, 0, 0, 32);

LAB15:    t12 = (t2 + 32U);
    t13 = *((char **)t12);
    t14 = (t13 + 40U);
    t15 = *((char **)t14);
    t16 = (t15 + 132U);
    t17 = *((char **)t16);
    t18 = (t17 + 0U);
    t19 = *((char **)t18);
    t21 = ((int  (*)(char *, char *))t19)(t1, t13);
    if (t21 != 0)
        goto LAB17;

LAB16:    t13 = (t1 + 1216);
    xsi_vlog_subprogram_popinvocation(t13);

LAB14:    t20 = (t2 + 32U);
    t22 = *((char **)t20);
    t20 = (t1 + 1216);
    t23 = (t2 + 32U);
    t24 = *((char **)t23);
    t23 = (t2 + 28U);
    t25 = *((char **)t23);
    xsi_delete_subprogram_invocation(t20, t24, t1, t25, t2);

LAB4:    xsi_vlog_dispose_subprogram_invocation(t2);
    t4 = (t2 + 24U);
    *((char **)t4) = &&LAB2;
    t0 = 0;

LAB1:    return t0;
LAB9:    t13 = (t2 + 24U);
    *((char **)t13) = &&LAB7;
    goto LAB1;

LAB13:    t14 = (t2 + 24U);
    *((char **)t14) = &&LAB11;
    goto LAB1;

LAB17:    t12 = (t2 + 24U);
    *((char **)t12) = &&LAB15;
    goto LAB1;

}

static int sp_host_dmem_write(char *t1, char *t2)
{
    char t29[8];
    int t0;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;
    char *t8;
    char *t9;
    char *t10;
    char *t11;
    char *t12;
    char *t13;
    char *t14;
    char *t15;
    char *t16;
    char *t17;
    char *t18;
    char *t19;
    char *t20;
    char *t21;
    char *t22;
    int t23;
    char *t24;
    char *t25;
    char *t26;
    char *t27;
    char *t28;

LAB0:    t0 = 1;
    t3 = (t2 + 24U);
    t4 = *((char **)t3);
    if (t4 == 0)
        goto LAB2;

LAB3:    goto *t4;

LAB2:    t4 = (t1 + 1696);
    xsi_vlog_subprogram_setdisablestate(t4, &&LAB4);
    xsi_set_current_line(192, ng0);

LAB5:    xsi_set_current_line(193, ng0);
    t5 = ((char*)((ng4)));
    t6 = (t1 + 6100);
    t7 = (t6 + 32U);
    t8 = *((char **)t7);
    t9 = (t2 + 28U);
    t10 = *((char **)t9);
    t11 = (t1 + 1216);
    t12 = xsi_create_subprogram_invocation(t10, 0, t1, t11, 0, t2);
    xsi_vlog_subprogram_pushinvocation(t11, t12);
    t13 = (t1 + 5732);
    xsi_vlogvar_assign_value(t13, t5, 0, 0, 23);
    t14 = (t1 + 5824);
    xsi_vlogvar_assign_value(t14, t8, 0, 0, 32);

LAB7:    t15 = (t2 + 32U);
    t16 = *((char **)t15);
    t17 = (t16 + 40U);
    t18 = *((char **)t17);
    t19 = (t18 + 132U);
    t20 = *((char **)t19);
    t21 = (t20 + 0U);
    t22 = *((char **)t21);
    t23 = ((int  (*)(char *, char *))t22)(t1, t16);
    if (t23 != 0)
        goto LAB9;

LAB8:    t16 = (t1 + 1216);
    xsi_vlog_subprogram_popinvocation(t16);

LAB6:    t24 = (t2 + 32U);
    t25 = *((char **)t24);
    t24 = (t1 + 1216);
    t26 = (t2 + 32U);
    t27 = *((char **)t26);
    t26 = (t2 + 28U);
    t28 = *((char **)t26);
    xsi_delete_subprogram_invocation(t24, t27, t1, t28, t2);
    xsi_set_current_line(194, ng0);
    t4 = ((char*)((ng5)));
    t5 = (t1 + 6192);
    t6 = (t5 + 32U);
    t7 = *((char **)t6);
    t8 = (t2 + 28U);
    t9 = *((char **)t8);
    t10 = (t1 + 1216);
    t11 = xsi_create_subprogram_invocation(t9, 0, t1, t10, 0, t2);
    xsi_vlog_subprogram_pushinvocation(t10, t11);
    t12 = (t1 + 5732);
    xsi_vlogvar_assign_value(t12, t4, 0, 0, 23);
    t13 = (t1 + 5824);
    xsi_vlogvar_assign_value(t13, t7, 0, 0, 32);

LAB11:    t14 = (t2 + 32U);
    t15 = *((char **)t14);
    t16 = (t15 + 40U);
    t17 = *((char **)t16);
    t18 = (t17 + 132U);
    t19 = *((char **)t18);
    t20 = (t19 + 0U);
    t21 = *((char **)t20);
    t23 = ((int  (*)(char *, char *))t21)(t1, t15);
    if (t23 != 0)
        goto LAB13;

LAB12:    t15 = (t1 + 1216);
    xsi_vlog_subprogram_popinvocation(t15);

LAB10:    t22 = (t2 + 32U);
    t24 = *((char **)t22);
    t22 = (t1 + 1216);
    t25 = (t2 + 32U);
    t26 = *((char **)t25);
    t25 = (t2 + 28U);
    t27 = *((char **)t25);
    xsi_delete_subprogram_invocation(t22, t26, t1, t27, t2);
    xsi_set_current_line(195, ng0);
    t4 = ((char*)((ng6)));
    t5 = (t1 + 6008);
    t6 = (t5 + 32U);
    t7 = *((char **)t6);
    t8 = ((char*)((ng1)));
    xsi_vlogtype_concat(t29, 32, 32, 2U, t8, 24, t7, 8);
    t9 = (t2 + 28U);
    t10 = *((char **)t9);
    t11 = (t1 + 1216);
    t12 = xsi_create_subprogram_invocation(t10, 0, t1, t11, 0, t2);
    xsi_vlog_subprogram_pushinvocation(t11, t12);
    t13 = (t1 + 5732);
    xsi_vlogvar_assign_value(t13, t4, 0, 0, 23);
    t14 = (t1 + 5824);
    xsi_vlogvar_assign_value(t14, t29, 0, 0, 32);

LAB15:    t15 = (t2 + 32U);
    t16 = *((char **)t15);
    t17 = (t16 + 40U);
    t18 = *((char **)t17);
    t19 = (t18 + 132U);
    t20 = *((char **)t19);
    t21 = (t20 + 0U);
    t22 = *((char **)t21);
    t23 = ((int  (*)(char *, char *))t22)(t1, t16);
    if (t23 != 0)
        goto LAB17;

LAB16:    t16 = (t1 + 1216);
    xsi_vlog_subprogram_popinvocation(t16);

LAB14:    t24 = (t2 + 32U);
    t25 = *((char **)t24);
    t24 = (t1 + 1216);
    t26 = (t2 + 32U);
    t27 = *((char **)t26);
    t26 = (t2 + 28U);
    t28 = *((char **)t26);
    xsi_delete_subprogram_invocation(t24, t27, t1, t28, t2);
    xsi_set_current_line(196, ng0);
    t4 = ((char*)((ng7)));
    t5 = (t2 + 28U);
    t6 = *((char **)t5);
    t7 = (t1 + 1456);
    t8 = xsi_create_subprogram_invocation(t6, 0, t1, t7, 0, t2);
    xsi_vlog_subprogram_pushinvocation(t7, t8);
    t9 = (t1 + 5916);
    xsi_vlogvar_assign_value(t9, t4, 0, 0, 32);

LAB19:    t10 = (t2 + 32U);
    t11 = *((char **)t10);
    t12 = (t11 + 40U);
    t13 = *((char **)t12);
    t14 = (t13 + 132U);
    t15 = *((char **)t14);
    t16 = (t15 + 0U);
    t17 = *((char **)t16);
    t23 = ((int  (*)(char *, char *))t17)(t1, t11);
    if (t23 != 0)
        goto LAB21;

LAB20:    t11 = (t1 + 1456);
    xsi_vlog_subprogram_popinvocation(t11);

LAB18:    t18 = (t2 + 32U);
    t19 = *((char **)t18);
    t18 = (t1 + 1456);
    t20 = (t2 + 32U);
    t21 = *((char **)t20);
    t20 = (t2 + 28U);
    t22 = *((char **)t20);
    xsi_delete_subprogram_invocation(t18, t21, t1, t22, t2);

LAB4:    xsi_vlog_dispose_subprogram_invocation(t2);
    t4 = (t2 + 24U);
    *((char **)t4) = &&LAB2;
    t0 = 0;

LAB1:    return t0;
LAB9:    t15 = (t2 + 24U);
    *((char **)t15) = &&LAB7;
    goto LAB1;

LAB13:    t14 = (t2 + 24U);
    *((char **)t14) = &&LAB11;
    goto LAB1;

LAB17:    t15 = (t2 + 24U);
    *((char **)t15) = &&LAB15;
    goto LAB1;

LAB21:    t10 = (t2 + 24U);
    *((char **)t10) = &&LAB19;
    goto LAB1;

}

static int sp_host_dmem_read_req(char *t1, char *t2)
{
    char t6[8];
    int t0;
    char *t3;
    char *t4;
    char *t5;
    char *t7;
    char *t8;
    char *t9;
    char *t10;
    char *t11;
    char *t12;
    char *t13;
    char *t14;
    char *t15;
    char *t16;
    char *t17;
    char *t18;
    char *t19;
    char *t20;
    char *t21;
    char *t22;
    char *t23;
    char *t24;
    int t25;
    char *t26;
    char *t27;
    char *t28;
    char *t29;
    char *t30;
    unsigned int t31;
    unsigned int t32;
    unsigned int t33;

LAB0:    t0 = 1;
    t3 = (t2 + 24U);
    t4 = *((char **)t3);
    if (t4 == 0)
        goto LAB2;

LAB3:    goto *t4;

LAB2:    t4 = (t1 + 1936);
    xsi_vlog_subprogram_setdisablestate(t4, &&LAB4);
    xsi_set_current_line(202, ng0);

LAB5:    xsi_set_current_line(203, ng0);
    t5 = ((char*)((ng6)));
    t7 = (t1 + 6284);
    t8 = (t7 + 32U);
    t9 = *((char **)t8);
    t10 = ((char*)((ng1)));
    xsi_vlogtype_concat(t6, 32, 32, 2U, t10, 24, t9, 8);
    t11 = (t2 + 28U);
    t12 = *((char **)t11);
    t13 = (t1 + 1216);
    t14 = xsi_create_subprogram_invocation(t12, 0, t1, t13, 0, t2);
    xsi_vlog_subprogram_pushinvocation(t13, t14);
    t15 = (t1 + 5732);
    xsi_vlogvar_assign_value(t15, t5, 0, 0, 23);
    t16 = (t1 + 5824);
    xsi_vlogvar_assign_value(t16, t6, 0, 0, 32);

LAB7:    t17 = (t2 + 32U);
    t18 = *((char **)t17);
    t19 = (t18 + 40U);
    t20 = *((char **)t19);
    t21 = (t20 + 132U);
    t22 = *((char **)t21);
    t23 = (t22 + 0U);
    t24 = *((char **)t23);
    t25 = ((int  (*)(char *, char *))t24)(t1, t18);
    if (t25 != 0)
        goto LAB9;

LAB8:    t18 = (t1 + 1216);
    xsi_vlog_subprogram_popinvocation(t18);

LAB6:    t26 = (t2 + 32U);
    t27 = *((char **)t26);
    t26 = (t1 + 1216);
    t28 = (t2 + 32U);
    t29 = *((char **)t28);
    t28 = (t2 + 28U);
    t30 = *((char **)t28);
    xsi_delete_subprogram_invocation(t26, t29, t1, t30, t2);
    xsi_set_current_line(204, ng0);
    t4 = ((char*)((ng8)));
    t5 = (t2 + 28U);
    t7 = *((char **)t5);
    t8 = (t1 + 1456);
    t9 = xsi_create_subprogram_invocation(t7, 0, t1, t8, 0, t2);
    xsi_vlog_subprogram_pushinvocation(t8, t9);
    t10 = (t1 + 5916);
    xsi_vlogvar_assign_value(t10, t4, 0, 0, 32);

LAB11:    t11 = (t2 + 32U);
    t12 = *((char **)t11);
    t13 = (t12 + 40U);
    t14 = *((char **)t13);
    t15 = (t14 + 132U);
    t16 = *((char **)t15);
    t17 = (t16 + 0U);
    t18 = *((char **)t17);
    t25 = ((int  (*)(char *, char *))t18)(t1, t12);
    if (t25 != 0)
        goto LAB13;

LAB12:    t12 = (t1 + 1456);
    xsi_vlog_subprogram_popinvocation(t12);

LAB10:    t19 = (t2 + 32U);
    t20 = *((char **)t19);
    t19 = (t1 + 1456);
    t21 = (t2 + 32U);
    t22 = *((char **)t21);
    t21 = (t2 + 28U);
    t23 = *((char **)t21);
    xsi_delete_subprogram_invocation(t19, t22, t1, t23, t2);
    xsi_set_current_line(205, ng0);
    t4 = ((char*)((ng9)));
    t5 = (t4 + 4U);
    t31 = *((unsigned int *)t5);
    t32 = (~(t31));
    t33 = *((unsigned int *)t4);
    t25 = (t33 & t32);
    t7 = (t1 + 11440);
    *((int *)t7) = t25;

LAB14:    t8 = (t1 + 11440);
    if (*((int *)t8) > 0)
        goto LAB15;

LAB16:
LAB4:    xsi_vlog_dispose_subprogram_invocation(t2);
    t4 = (t2 + 24U);
    *((char **)t4) = &&LAB2;
    t0 = 0;

LAB1:    return t0;
LAB9:    t17 = (t2 + 24U);
    *((char **)t17) = &&LAB7;
    goto LAB1;

LAB13:    t11 = (t2 + 24U);
    *((char **)t11) = &&LAB11;
    goto LAB1;

LAB15:    xsi_set_current_line(205, ng0);
    t9 = (t2 + 44U);
    t10 = *((char **)t9);
    t11 = (t10 + 0U);
    xsi_wp_set_status(t11, 1);
    *((char **)t3) = &&LAB17;
    goto LAB1;

LAB17:    t4 = (t1 + 11440);
    t25 = *((int *)t4);
    *((int *)t4) = (t25 - 1);
    goto LAB14;

}

static int sp_gpu_host_imem_word(char *t1, char *t2)
{
    int t0;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;
    char *t8;
    char *t9;
    char *t10;
    char *t11;
    char *t12;
    char *t13;
    char *t14;
    char *t15;
    char *t16;
    char *t17;
    char *t18;
    char *t19;
    char *t20;
    char *t21;
    char *t22;
    int t23;
    char *t24;
    char *t25;
    char *t26;
    char *t27;
    char *t28;

LAB0:    t0 = 1;
    t3 = (t2 + 24U);
    t4 = *((char **)t3);
    if (t4 == 0)
        goto LAB2;

LAB3:    goto *t4;

LAB2:    t4 = (t1 + 2176);
    xsi_vlog_subprogram_setdisablestate(t4, &&LAB4);
    xsi_set_current_line(212, ng0);

LAB5:    xsi_set_current_line(213, ng0);
    t5 = ((char*)((ng6)));
    t6 = (t1 + 6376);
    t7 = (t6 + 32U);
    t8 = *((char **)t7);
    t9 = (t2 + 28U);
    t10 = *((char **)t9);
    t11 = (t1 + 1216);
    t12 = xsi_create_subprogram_invocation(t10, 0, t1, t11, 0, t2);
    xsi_vlog_subprogram_pushinvocation(t11, t12);
    t13 = (t1 + 5732);
    xsi_vlogvar_assign_value(t13, t5, 0, 0, 23);
    t14 = (t1 + 5824);
    xsi_vlogvar_assign_value(t14, t8, 0, 0, 32);

LAB7:    t15 = (t2 + 32U);
    t16 = *((char **)t15);
    t17 = (t16 + 40U);
    t18 = *((char **)t17);
    t19 = (t18 + 132U);
    t20 = *((char **)t19);
    t21 = (t20 + 0U);
    t22 = *((char **)t21);
    t23 = ((int  (*)(char *, char *))t22)(t1, t16);
    if (t23 != 0)
        goto LAB9;

LAB8:    t16 = (t1 + 1216);
    xsi_vlog_subprogram_popinvocation(t16);

LAB6:    t24 = (t2 + 32U);
    t25 = *((char **)t24);
    t24 = (t1 + 1216);
    t26 = (t2 + 32U);
    t27 = *((char **)t26);
    t26 = (t2 + 28U);
    t28 = *((char **)t26);
    xsi_delete_subprogram_invocation(t24, t27, t1, t28, t2);
    xsi_set_current_line(214, ng0);
    t4 = ((char*)((ng10)));
    t5 = (t1 + 6468);
    t6 = (t5 + 32U);
    t7 = *((char **)t6);
    t8 = (t2 + 28U);
    t9 = *((char **)t8);
    t10 = (t1 + 1216);
    t11 = xsi_create_subprogram_invocation(t9, 0, t1, t10, 0, t2);
    xsi_vlog_subprogram_pushinvocation(t10, t11);
    t12 = (t1 + 5732);
    xsi_vlogvar_assign_value(t12, t4, 0, 0, 23);
    t13 = (t1 + 5824);
    xsi_vlogvar_assign_value(t13, t7, 0, 0, 32);

LAB11:    t14 = (t2 + 32U);
    t15 = *((char **)t14);
    t16 = (t15 + 40U);
    t17 = *((char **)t16);
    t18 = (t17 + 132U);
    t19 = *((char **)t18);
    t20 = (t19 + 0U);
    t21 = *((char **)t20);
    t23 = ((int  (*)(char *, char *))t21)(t1, t15);
    if (t23 != 0)
        goto LAB13;

LAB12:    t15 = (t1 + 1216);
    xsi_vlog_subprogram_popinvocation(t15);

LAB10:    t22 = (t2 + 32U);
    t24 = *((char **)t22);
    t22 = (t1 + 1216);
    t25 = (t2 + 32U);
    t26 = *((char **)t25);
    t25 = (t2 + 28U);
    t27 = *((char **)t25);
    xsi_delete_subprogram_invocation(t22, t26, t1, t27, t2);
    xsi_set_current_line(215, ng0);
    t4 = ((char*)((ng2)));
    t5 = (t2 + 28U);
    t6 = *((char **)t5);
    t7 = (t1 + 1456);
    t8 = xsi_create_subprogram_invocation(t6, 0, t1, t7, 0, t2);
    xsi_vlog_subprogram_pushinvocation(t7, t8);
    t9 = (t1 + 5916);
    xsi_vlogvar_assign_value(t9, t4, 0, 0, 32);

LAB15:    t10 = (t2 + 32U);
    t11 = *((char **)t10);
    t12 = (t11 + 40U);
    t13 = *((char **)t12);
    t14 = (t13 + 132U);
    t15 = *((char **)t14);
    t16 = (t15 + 0U);
    t17 = *((char **)t16);
    t23 = ((int  (*)(char *, char *))t17)(t1, t11);
    if (t23 != 0)
        goto LAB17;

LAB16:    t11 = (t1 + 1456);
    xsi_vlog_subprogram_popinvocation(t11);

LAB14:    t18 = (t2 + 32U);
    t19 = *((char **)t18);
    t18 = (t1 + 1456);
    t20 = (t2 + 32U);
    t21 = *((char **)t20);
    t20 = (t2 + 28U);
    t22 = *((char **)t20);
    xsi_delete_subprogram_invocation(t18, t21, t1, t22, t2);

LAB4:    xsi_vlog_dispose_subprogram_invocation(t2);
    t4 = (t2 + 24U);
    *((char **)t4) = &&LAB2;
    t0 = 0;

LAB1:    return t0;
LAB9:    t15 = (t2 + 24U);
    *((char **)t15) = &&LAB7;
    goto LAB1;

LAB13:    t14 = (t2 + 24U);
    *((char **)t14) = &&LAB11;
    goto LAB1;

LAB17:    t10 = (t2 + 24U);
    *((char **)t10) = &&LAB15;
    goto LAB1;

}

static int sp_gpu_host_start_pulse(char *t1, char *t2)
{
    int t0;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;
    char *t8;
    char *t9;
    char *t10;
    char *t11;
    char *t12;
    char *t13;
    char *t14;
    char *t15;
    char *t16;
    char *t17;
    char *t18;
    char *t19;
    char *t20;
    char *t21;
    char *t22;
    int t23;
    char *t24;
    char *t25;
    char *t26;
    char *t27;
    char *t28;

LAB0:    t0 = 1;
    t3 = (t2 + 24U);
    t4 = *((char **)t3);
    if (t4 == 0)
        goto LAB2;

LAB3:    goto *t4;

LAB2:    t4 = (t1 + 2416);
    xsi_vlog_subprogram_setdisablestate(t4, &&LAB4);
    xsi_set_current_line(221, ng0);

LAB5:    xsi_set_current_line(222, ng0);
    t5 = ((char*)((ng6)));
    t6 = (t1 + 6560);
    t7 = (t6 + 32U);
    t8 = *((char **)t7);
    t9 = (t2 + 28U);
    t10 = *((char **)t9);
    t11 = (t1 + 1216);
    t12 = xsi_create_subprogram_invocation(t10, 0, t1, t11, 0, t2);
    xsi_vlog_subprogram_pushinvocation(t11, t12);
    t13 = (t1 + 5732);
    xsi_vlogvar_assign_value(t13, t5, 0, 0, 23);
    t14 = (t1 + 5824);
    xsi_vlogvar_assign_value(t14, t8, 0, 0, 32);

LAB7:    t15 = (t2 + 32U);
    t16 = *((char **)t15);
    t17 = (t16 + 40U);
    t18 = *((char **)t17);
    t19 = (t18 + 132U);
    t20 = *((char **)t19);
    t21 = (t20 + 0U);
    t22 = *((char **)t21);
    t23 = ((int  (*)(char *, char *))t22)(t1, t16);
    if (t23 != 0)
        goto LAB9;

LAB8:    t16 = (t1 + 1216);
    xsi_vlog_subprogram_popinvocation(t16);

LAB6:    t24 = (t2 + 32U);
    t25 = *((char **)t24);
    t24 = (t1 + 1216);
    t26 = (t2 + 32U);
    t27 = *((char **)t26);
    t26 = (t2 + 28U);
    t28 = *((char **)t26);
    xsi_delete_subprogram_invocation(t24, t27, t1, t28, t2);
    xsi_set_current_line(223, ng0);
    t4 = ((char*)((ng11)));
    t5 = (t2 + 28U);
    t6 = *((char **)t5);
    t7 = (t1 + 1456);
    t8 = xsi_create_subprogram_invocation(t6, 0, t1, t7, 0, t2);
    xsi_vlog_subprogram_pushinvocation(t7, t8);
    t9 = (t1 + 5916);
    xsi_vlogvar_assign_value(t9, t4, 0, 0, 32);

LAB11:    t10 = (t2 + 32U);
    t11 = *((char **)t10);
    t12 = (t11 + 40U);
    t13 = *((char **)t12);
    t14 = (t13 + 132U);
    t15 = *((char **)t14);
    t16 = (t15 + 0U);
    t17 = *((char **)t16);
    t23 = ((int  (*)(char *, char *))t17)(t1, t11);
    if (t23 != 0)
        goto LAB13;

LAB12:    t11 = (t1 + 1456);
    xsi_vlog_subprogram_popinvocation(t11);

LAB10:    t18 = (t2 + 32U);
    t19 = *((char **)t18);
    t18 = (t1 + 1456);
    t20 = (t2 + 32U);
    t21 = *((char **)t20);
    t20 = (t2 + 28U);
    t22 = *((char **)t20);
    xsi_delete_subprogram_invocation(t18, t21, t1, t22, t2);

LAB4:    xsi_vlog_dispose_subprogram_invocation(t2);
    t4 = (t2 + 24U);
    *((char **)t4) = &&LAB2;
    t0 = 0;

LAB1:    return t0;
LAB9:    t15 = (t2 + 24U);
    *((char **)t15) = &&LAB7;
    goto LAB1;

LAB13:    t10 = (t2 + 24U);
    *((char **)t10) = &&LAB11;
    goto LAB1;

}

static int sp_arm_imem_write(char *t1, char *t2)
{
    int t0;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;

LAB0:    t0 = 1;
    t3 = (t2 + 24U);
    t4 = *((char **)t3);
    if (t4 == 0)
        goto LAB2;

LAB3:    goto *t4;

LAB2:    t4 = (t1 + 2656);
    xsi_vlog_subprogram_setdisablestate(t4, &&LAB4);
    xsi_set_current_line(230, ng0);

LAB5:    xsi_set_current_line(231, ng0);
    t5 = (t2 + 44U);
    t6 = *((char **)t5);
    t7 = (t6 + 0U);
    xsi_wp_set_status(t7, 1);
    *((char **)t3) = &&LAB6;

LAB1:    return t0;
LAB4:    xsi_vlog_dispose_subprogram_invocation(t2);
    t4 = (t2 + 24U);
    *((char **)t4) = &&LAB2;
    t0 = 0;
    goto LAB1;

LAB6:    xsi_set_current_line(232, ng0);
    t4 = ((char*)((ng2)));
    t5 = (t1 + 5364);
    xsi_vlogvar_assign_value(t5, t4, 0, 0, 1);
    xsi_set_current_line(233, ng0);
    t4 = (t1 + 6652);
    t5 = (t4 + 32U);
    t6 = *((char **)t5);
    t7 = (t1 + 5456);
    xsi_vlogvar_assign_value(t7, t6, 0, 0, 9);
    xsi_set_current_line(234, ng0);
    t4 = (t1 + 6744);
    t5 = (t4 + 32U);
    t6 = *((char **)t5);
    t7 = (t1 + 5548);
    xsi_vlogvar_assign_value(t7, t6, 0, 0, 32);
    xsi_set_current_line(235, ng0);
    t4 = (t2 + 44U);
    t5 = *((char **)t4);
    t6 = (t5 + 8U);
    xsi_wp_set_status(t6, 1);
    *((char **)t3) = &&LAB7;
    goto LAB1;

LAB7:    xsi_set_current_line(236, ng0);
    t4 = ((char*)((ng1)));
    t5 = (t1 + 5364);
    xsi_vlogvar_assign_value(t5, t4, 0, 0, 1);
    goto LAB4;

}

static int sp_cpu_start_pulse(char *t1, char *t2)
{
    int t0;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;

LAB0:    t0 = 1;
    t3 = (t2 + 24U);
    t4 = *((char **)t3);
    if (t4 == 0)
        goto LAB2;

LAB3:    goto *t4;

LAB2:    t4 = (t1 + 2896);
    xsi_vlog_subprogram_setdisablestate(t4, &&LAB4);
    xsi_set_current_line(241, ng0);

LAB5:    xsi_set_current_line(242, ng0);
    t5 = (t2 + 44U);
    t6 = *((char **)t5);
    t7 = (t6 + 0U);
    xsi_wp_set_status(t7, 1);
    *((char **)t3) = &&LAB6;

LAB1:    return t0;
LAB4:    xsi_vlog_dispose_subprogram_invocation(t2);
    t4 = (t2 + 24U);
    *((char **)t4) = &&LAB2;
    t0 = 0;
    goto LAB1;

LAB6:    xsi_set_current_line(243, ng0);
    t4 = ((char*)((ng2)));
    t5 = (t1 + 5272);
    xsi_vlogvar_assign_value(t5, t4, 0, 0, 1);
    xsi_set_current_line(244, ng0);
    t4 = (t2 + 44U);
    t5 = *((char **)t4);
    t6 = (t5 + 8U);
    xsi_wp_set_status(t6, 1);
    *((char **)t3) = &&LAB7;
    goto LAB1;

LAB7:    xsi_set_current_line(245, ng0);
    t4 = ((char*)((ng1)));
    t5 = (t1 + 5272);
    xsi_vlogvar_assign_value(t5, t4, 0, 0, 1);
    goto LAB4;

}

static void I154_0(char *t0)
{
    char *t1;
    char *t2;

LAB0:    xsi_set_current_line(154, ng0);
    t1 = ((char*)((ng12)));
    t2 = (t0 + 5088);
    xsi_vlogvar_assign_value(t2, t1, 0, 0, 1);

LAB1:    return;
}

static void A155_1(char *t0)
{
    char t3[8];
    char *t1;
    char *t2;
    char *t4;
    char *t5;
    char *t6;
    char *t7;
    char *t8;
    unsigned int t9;
    unsigned int t10;
    unsigned int t11;
    unsigned int t12;
    unsigned int t13;
    unsigned int t14;
    unsigned int t15;
    unsigned int t16;
    char *t17;

LAB0:    t1 = (t0 + 7348U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(155, ng0);
    t2 = (t0 + 7264);
    xsi_process_wait(t2, 4000000LL);
    *((char **)t1) = &&LAB4;

LAB1:    return;
LAB4:    xsi_set_current_line(155, ng0);
    t4 = (t0 + 5088);
    t5 = (t4 + 32U);
    t6 = *((char **)t5);
    memset(t3, 0, 8);
    t7 = (t3 + 4U);
    t8 = (t6 + 4U);
    t9 = *((unsigned int *)t6);
    t10 = (~(t9));
    *((unsigned int *)t3) = t10;
    *((unsigned int *)t7) = 0;
    if (*((unsigned int *)t8) != 0)
        goto LAB6;

LAB5:    t15 = *((unsigned int *)t3);
    *((unsigned int *)t3) = (t15 & 1U);
    t16 = *((unsigned int *)t7);
    *((unsigned int *)t7) = (t16 & 1U);
    t17 = (t0 + 5088);
    xsi_vlogvar_assign_value(t17, t3, 0, 0, 1);
    goto LAB2;

LAB6:    t11 = *((unsigned int *)t3);
    t12 = *((unsigned int *)t8);
    *((unsigned int *)t3) = (t11 | t12);
    t13 = *((unsigned int *)t7);
    t14 = *((unsigned int *)t8);
    *((unsigned int *)t7) = (t13 | t14);
    goto LAB5;

}

static void I158_2(char *t0)
{
    char *t1;
    char *t2;

LAB0:    xsi_set_current_line(158, ng0);
    t1 = ((char*)((ng12)));
    t2 = (t0 + 5640);
    xsi_vlogvar_assign_value(t2, t1, 0, 0, 32);

LAB1:    return;
}

static void A159_3(char *t0)
{
    char t7[8];
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    char *t8;

LAB0:    t1 = (t0 + 7604U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(159, ng0);
    t2 = (t0 + 8040);
    *((int *)t2) = 1;
    *((char **)t1) = &&LAB4;

LAB1:    return;
LAB4:    xsi_set_current_line(159, ng0);
    t3 = (t0 + 5640);
    t4 = (t3 + 32U);
    t5 = *((char **)t4);
    t6 = ((char*)((ng13)));
    memset(t7, 0, 8);
    xsi_vlog_signed_add(t7, 32, t5, 32, t6, 32);
    t8 = (t0 + 5640);
    xsi_vlogvar_assign_value(t8, t7, 0, 0, 32);
    goto LAB2;

}

static void I251_4(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    unsigned int t4;
    unsigned int t5;
    unsigned int t6;
    int t7;
    char *t8;
    char *t9;
    char *t10;
    char *t11;
    char *t12;
    char *t13;
    char *t14;
    char *t15;
    char *t16;
    char *t17;
    char *t18;
    char *t19;
    char *t20;
    char *t21;
    char *t22;
    char *t23;
    char *t24;
    char *t25;
    char *t26;
    char *t27;

LAB0:    t1 = (t0 + 7732U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(251, ng0);

LAB4:    xsi_set_current_line(252, ng0);
    t2 = ((char*)((ng14)));
    t3 = (t0 + 4260);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 64);
    xsi_set_current_line(253, ng0);
    t2 = ((char*)((ng12)));
    t3 = (t0 + 4352);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 8);
    xsi_set_current_line(254, ng0);
    t2 = ((char*)((ng12)));
    t3 = (t0 + 4444);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(255, ng0);
    t2 = ((char*)((ng13)));
    t3 = (t0 + 4536);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(256, ng0);
    t2 = ((char*)((ng12)));
    t3 = (t0 + 4628);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(257, ng0);
    t2 = ((char*)((ng13)));
    t3 = (t0 + 4720);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(258, ng0);
    t2 = ((char*)((ng12)));
    t3 = (t0 + 4812);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 23);
    xsi_set_current_line(259, ng0);
    t2 = ((char*)((ng12)));
    t3 = (t0 + 4904);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 32);
    xsi_set_current_line(260, ng0);
    t2 = ((char*)((ng12)));
    t3 = (t0 + 4996);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 2);
    xsi_set_current_line(261, ng0);
    t2 = ((char*)((ng12)));
    t3 = (t0 + 5272);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(262, ng0);
    t2 = ((char*)((ng12)));
    t3 = (t0 + 5364);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(263, ng0);
    t2 = ((char*)((ng12)));
    t3 = (t0 + 5456);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 9);
    xsi_set_current_line(264, ng0);
    t2 = ((char*)((ng12)));
    t3 = (t0 + 5548);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 32);
    xsi_set_current_line(266, ng0);
    t2 = ((char*)((ng13)));
    t3 = (t0 + 5180);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(267, ng0);
    t2 = ((char*)((ng15)));
    t3 = (t2 + 4U);
    t4 = *((unsigned int *)t3);
    t5 = (~(t4));
    t6 = *((unsigned int *)t2);
    t7 = (t6 & t5);
    t8 = (t0 + 11444);
    *((int *)t8) = t7;

LAB5:    t9 = (t0 + 11444);
    if (*((int *)t9) > 0)
        goto LAB6;

LAB7:    xsi_set_current_line(268, ng0);
    t2 = (t0 + 7648);
    xsi_process_wait(t2, 1000000LL);
    *((char **)t1) = &&LAB9;

LAB1:    return;
LAB6:    xsi_set_current_line(267, ng0);
    t10 = (t0 + 8120);
    *((int *)t10) = 1;
    *((char **)t1) = &&LAB8;
    goto LAB1;

LAB8:    t2 = (t0 + 11444);
    t7 = *((int *)t2);
    *((int *)t2) = (t7 - 1);
    goto LAB5;

LAB9:    xsi_set_current_line(268, ng0);
    t3 = ((char*)((ng12)));
    t8 = (t0 + 5180);
    xsi_vlogvar_assign_value(t8, t3, 0, 0, 1);
    xsi_set_current_line(269, ng0);
    t2 = (t0 + 5640);
    t3 = (t2 + 32U);
    t8 = *((char **)t3);
    xsi_vlogfile_write(1, 0, ng16, 2, t0, (char)119, t8, 32);
    xsi_set_current_line(274, ng0);
    xsi_vlogfile_write(1, 0, ng17, 1, t0);
    xsi_set_current_line(275, ng0);
    t2 = ((char*)((ng1)));
    t3 = ((char*)((ng18)));
    t8 = ((char*)((ng19)));
    t9 = (t0 + 7648);
    t10 = (t0 + 1696);
    t11 = xsi_create_subprogram_invocation(t9, 0, t0, t10, 0, 0);
    xsi_vlog_subprogram_pushinvocation(t10, t11);
    t12 = (t0 + 6008);
    xsi_vlogvar_assign_value(t12, t2, 0, 0, 8);
    t13 = (t0 + 6100);
    xsi_vlogvar_assign_value(t13, t3, 0, 0, 32);
    t14 = (t0 + 6192);
    xsi_vlogvar_assign_value(t14, t8, 0, 0, 32);

LAB11:    t15 = (t0 + 7696);
    t16 = *((char **)t15);
    t17 = (t16 + 40U);
    t18 = *((char **)t17);
    t19 = (t18 + 132U);
    t20 = *((char **)t19);
    t21 = (t20 + 0U);
    t22 = *((char **)t21);
    t7 = ((int  (*)(char *, char *))t22)(t0, t16);
    if (t7 != 0)
        goto LAB13;

LAB12:    t16 = (t0 + 1696);
    xsi_vlog_subprogram_popinvocation(t16);

LAB10:    t23 = (t0 + 7696);
    t24 = *((char **)t23);
    t23 = (t0 + 1696);
    t25 = (t0 + 7696);
    t26 = *((char **)t25);
    t25 = (t0 + 7648);
    t27 = 0;
    xsi_delete_subprogram_invocation(t23, t26, t0, t25, t27);
    xsi_set_current_line(276, ng0);
    t2 = ((char*)((ng20)));
    t3 = (t2 + 4U);
    t4 = *((unsigned int *)t3);
    t5 = (~(t4));
    t6 = *((unsigned int *)t2);
    t7 = (t6 & t5);
    t8 = (t0 + 11448);
    *((int *)t8) = t7;

LAB14:    t9 = (t0 + 11448);
    if (*((int *)t9) > 0)
        goto LAB15;

LAB16:    xsi_set_current_line(278, ng0);
    xsi_vlogfile_write(1, 0, ng21, 1, t0);
    xsi_set_current_line(279, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 7648);
    t8 = (t0 + 1936);
    t9 = xsi_create_subprogram_invocation(t3, 0, t0, t8, 0, 0);
    xsi_vlog_subprogram_pushinvocation(t8, t9);
    t10 = (t0 + 6284);
    xsi_vlogvar_assign_value(t10, t2, 0, 0, 8);

LAB19:    t11 = (t0 + 7696);
    t12 = *((char **)t11);
    t13 = (t12 + 40U);
    t14 = *((char **)t13);
    t15 = (t14 + 132U);
    t16 = *((char **)t15);
    t17 = (t16 + 0U);
    t18 = *((char **)t17);
    t7 = ((int  (*)(char *, char *))t18)(t0, t12);
    if (t7 != 0)
        goto LAB21;

LAB20:    t12 = (t0 + 1936);
    xsi_vlog_subprogram_popinvocation(t12);

LAB18:    t19 = (t0 + 7696);
    t20 = *((char **)t19);
    t19 = (t0 + 1936);
    t21 = (t0 + 7696);
    t22 = *((char **)t21);
    t21 = (t0 + 7648);
    t23 = 0;
    xsi_delete_subprogram_invocation(t19, t22, t0, t21, t23);
    xsi_set_current_line(280, ng0);
    t2 = (t0 + 11468);
    t3 = *((char **)t2);
    t8 = ((((char*)(t3))) + 20U);
    t9 = *((char **)t8);
    xsi_vlogfile_write(1, 0, ng22, 2, t0, (char)118, t9, 64);
    xsi_set_current_line(286, ng0);
    xsi_vlogfile_write(1, 0, ng23, 1, t0);
    xsi_set_current_line(287, ng0);
    t2 = ((char*)((ng24)));
    t3 = ((char*)((ng1)));
    t8 = (t0 + 7648);
    t9 = (t0 + 2176);
    t10 = xsi_create_subprogram_invocation(t8, 0, t0, t9, 0, 0);
    xsi_vlog_subprogram_pushinvocation(t9, t10);
    t11 = (t0 + 6376);
    xsi_vlogvar_assign_value(t11, t2, 0, 0, 32);
    t12 = (t0 + 6468);
    xsi_vlogvar_assign_value(t12, t3, 0, 0, 32);

LAB23:    t13 = (t0 + 7696);
    t14 = *((char **)t13);
    t15 = (t14 + 40U);
    t16 = *((char **)t15);
    t17 = (t16 + 132U);
    t18 = *((char **)t17);
    t19 = (t18 + 0U);
    t20 = *((char **)t19);
    t7 = ((int  (*)(char *, char *))t20)(t0, t14);
    if (t7 != 0)
        goto LAB25;

LAB24:    t14 = (t0 + 2176);
    xsi_vlog_subprogram_popinvocation(t14);

LAB22:    t21 = (t0 + 7696);
    t22 = *((char **)t21);
    t21 = (t0 + 2176);
    t23 = (t0 + 7696);
    t24 = *((char **)t23);
    t23 = (t0 + 7648);
    t25 = 0;
    xsi_delete_subprogram_invocation(t21, t24, t0, t23, t25);
    xsi_set_current_line(288, ng0);
    t2 = ((char*)((ng24)));
    t3 = (t0 + 7648);
    t8 = (t0 + 2416);
    t9 = xsi_create_subprogram_invocation(t3, 0, t0, t8, 0, 0);
    xsi_vlog_subprogram_pushinvocation(t8, t9);
    t10 = (t0 + 6560);
    xsi_vlogvar_assign_value(t10, t2, 0, 0, 32);

LAB27:    t11 = (t0 + 7696);
    t12 = *((char **)t11);
    t13 = (t12 + 40U);
    t14 = *((char **)t13);
    t15 = (t14 + 132U);
    t16 = *((char **)t15);
    t17 = (t16 + 0U);
    t18 = *((char **)t17);
    t7 = ((int  (*)(char *, char *))t18)(t0, t12);
    if (t7 != 0)
        goto LAB29;

LAB28:    t12 = (t0 + 2416);
    xsi_vlog_subprogram_popinvocation(t12);

LAB26:    t19 = (t0 + 7696);
    t20 = *((char **)t19);
    t19 = (t0 + 2416);
    t21 = (t0 + 7696);
    t22 = *((char **)t21);
    t21 = (t0 + 7648);
    t23 = 0;
    xsi_delete_subprogram_invocation(t19, t22, t0, t21, t23);
    xsi_set_current_line(290, ng0);
    t2 = ((char*)((ng25)));
    t3 = (t2 + 4U);
    t4 = *((unsigned int *)t3);
    t5 = (~(t4));
    t6 = *((unsigned int *)t2);
    t7 = (t6 & t5);
    t8 = (t0 + 11472);
    *((int *)t8) = t7;

LAB30:    t9 = (t0 + 11472);
    if (*((int *)t9) > 0)
        goto LAB31;

LAB32:    xsi_set_current_line(291, ng0);
    t2 = (t0 + 11492);
    t3 = *((char **)t2);
    t8 = ((((char*)(t3))) + 32U);
    t9 = *((char **)t8);
    xsi_vlogfile_write(1, 0, ng26, 2, t0, (char)118, t9, 32);
    xsi_set_current_line(293, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 7648);
    t8 = (t0 + 1936);
    t9 = xsi_create_subprogram_invocation(t3, 0, t0, t8, 0, 0);
    xsi_vlog_subprogram_pushinvocation(t8, t9);
    t10 = (t0 + 6284);
    xsi_vlogvar_assign_value(t10, t2, 0, 0, 8);

LAB35:    t11 = (t0 + 7696);
    t12 = *((char **)t11);
    t13 = (t12 + 40U);
    t14 = *((char **)t13);
    t15 = (t14 + 132U);
    t16 = *((char **)t15);
    t17 = (t16 + 0U);
    t18 = *((char **)t17);
    t7 = ((int  (*)(char *, char *))t18)(t0, t12);
    if (t7 != 0)
        goto LAB37;

LAB36:    t12 = (t0 + 1936);
    xsi_vlog_subprogram_popinvocation(t12);

LAB34:    t19 = (t0 + 7696);
    t20 = *((char **)t19);
    t19 = (t0 + 1936);
    t21 = (t0 + 7696);
    t22 = *((char **)t21);
    t21 = (t0 + 7648);
    t23 = 0;
    xsi_delete_subprogram_invocation(t19, t22, t0, t21, t23);
    xsi_set_current_line(294, ng0);
    t2 = (t0 + 11512);
    t3 = *((char **)t2);
    t8 = ((((char*)(t3))) + 20U);
    t9 = *((char **)t8);
    xsi_vlogfile_write(1, 0, ng27, 2, t0, (char)118, t9, 64);
    xsi_set_current_line(299, ng0);
    xsi_vlogfile_write(1, 0, ng28, 1, t0);
    xsi_set_current_line(300, ng0);
    t2 = ((char*)((ng1)));
    t3 = ((char*)((ng29)));
    t8 = (t0 + 7648);
    t9 = (t0 + 2656);
    t10 = xsi_create_subprogram_invocation(t8, 0, t0, t9, 0, 0);
    xsi_vlog_subprogram_pushinvocation(t9, t10);
    t11 = (t0 + 6652);
    xsi_vlogvar_assign_value(t11, t2, 0, 0, 9);
    t12 = (t0 + 6744);
    xsi_vlogvar_assign_value(t12, t3, 0, 0, 32);

LAB39:    t13 = (t0 + 7696);
    t14 = *((char **)t13);
    t15 = (t14 + 40U);
    t16 = *((char **)t15);
    t17 = (t16 + 132U);
    t18 = *((char **)t17);
    t19 = (t18 + 0U);
    t20 = *((char **)t19);
    t7 = ((int  (*)(char *, char *))t20)(t0, t14);
    if (t7 != 0)
        goto LAB41;

LAB40:    t14 = (t0 + 2656);
    xsi_vlog_subprogram_popinvocation(t14);

LAB38:    t21 = (t0 + 7696);
    t22 = *((char **)t21);
    t21 = (t0 + 2656);
    t23 = (t0 + 7696);
    t24 = *((char **)t23);
    t23 = (t0 + 7648);
    t25 = 0;
    xsi_delete_subprogram_invocation(t21, t24, t0, t23, t25);
    xsi_set_current_line(301, ng0);
    t2 = (t0 + 7648);
    t3 = (t0 + 2896);
    t8 = xsi_create_subprogram_invocation(t2, 0, t0, t3, 0, 0);
    xsi_vlog_subprogram_pushinvocation(t3, t8);

LAB43:    t9 = (t0 + 7696);
    t10 = *((char **)t9);
    t11 = (t10 + 40U);
    t12 = *((char **)t11);
    t13 = (t12 + 132U);
    t14 = *((char **)t13);
    t15 = (t14 + 0U);
    t16 = *((char **)t15);
    t7 = ((int  (*)(char *, char *))t16)(t0, t10);
    if (t7 != 0)
        goto LAB45;

LAB44:    t10 = (t0 + 2896);
    xsi_vlog_subprogram_popinvocation(t10);

LAB42:    t17 = (t0 + 7696);
    t18 = *((char **)t17);
    t17 = (t0 + 2896);
    t19 = (t0 + 7696);
    t20 = *((char **)t19);
    t19 = (t0 + 7648);
    t21 = 0;
    xsi_delete_subprogram_invocation(t17, t20, t0, t19, t21);
    xsi_set_current_line(302, ng0);
    t2 = ((char*)((ng30)));
    t3 = (t2 + 4U);
    t4 = *((unsigned int *)t3);
    t5 = (~(t4));
    t6 = *((unsigned int *)t2);
    t7 = (t6 & t5);
    t8 = (t0 + 11516);
    *((int *)t8) = t7;

LAB46:    t9 = (t0 + 11516);
    if (*((int *)t9) > 0)
        goto LAB47;

LAB48:    xsi_set_current_line(304, ng0);
    xsi_vlogfile_write(1, 0, ng31, 1, t0);
    xsi_set_current_line(305, ng0);
    t2 = (t0 + 11540);
    t3 = *((char **)t2);
    t8 = ((((char*)(t3))) + 20U);
    t9 = *((char **)t8);
    xsi_vlogfile_write(1, 0, ng32, 2, t0, (char)118, t9, 1);
    xsi_set_current_line(307, ng0);
    xsi_vlog_finish(1);
    goto LAB1;

LAB13:    t15 = (t0 + 7732U);
    *((char **)t15) = &&LAB11;
    goto LAB1;

LAB15:    xsi_set_current_line(276, ng0);
    t10 = (t0 + 8128);
    *((int *)t10) = 1;
    *((char **)t1) = &&LAB17;
    goto LAB1;

LAB17:    t2 = (t0 + 11448);
    t7 = *((int *)t2);
    *((int *)t2) = (t7 - 1);
    goto LAB14;

LAB21:    t11 = (t0 + 7732U);
    *((char **)t11) = &&LAB19;
    goto LAB1;

LAB25:    t13 = (t0 + 7732U);
    *((char **)t13) = &&LAB23;
    goto LAB1;

LAB29:    t11 = (t0 + 7732U);
    *((char **)t11) = &&LAB27;
    goto LAB1;

LAB31:    xsi_set_current_line(290, ng0);
    t10 = (t0 + 8136);
    *((int *)t10) = 1;
    *((char **)t1) = &&LAB33;
    goto LAB1;

LAB33:    t2 = (t0 + 11472);
    t7 = *((int *)t2);
    *((int *)t2) = (t7 - 1);
    goto LAB30;

LAB37:    t11 = (t0 + 7732U);
    *((char **)t11) = &&LAB35;
    goto LAB1;

LAB41:    t13 = (t0 + 7732U);
    *((char **)t13) = &&LAB39;
    goto LAB1;

LAB45:    t9 = (t0 + 7732U);
    *((char **)t9) = &&LAB43;
    goto LAB1;

LAB47:    xsi_set_current_line(302, ng0);
    t10 = (t0 + 8144);
    *((int *)t10) = 1;
    *((char **)t1) = &&LAB49;
    goto LAB1;

LAB49:    t2 = (t0 + 11516);
    t7 = *((int *)t2);
    *((int *)t2) = (t7 - 1);
    goto LAB46;

}

static void I310_5(char *t0)
{
    char *t1;
    char *t2;

LAB0:    t1 = (t0 + 7860U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(310, ng0);

LAB4:    xsi_set_current_line(311, ng0);
    t2 = (t0 + 7776);
    xsi_process_wait(t2, 500000000000LL);
    *((char **)t1) = &&LAB5;

LAB1:    return;
LAB5:    xsi_set_current_line(312, ng0);
    xsi_vlogfile_write(1, 0, ng33, 1, t0);
    xsi_set_current_line(313, ng0);
    xsi_vlog_finish(1);
    goto LAB1;

}


extern void work_m_00000000003277815782_3326411051_init()
{
	static char *pe[] = {(void *)I154_0,(void *)A155_1,(void *)I158_2,(void *)A159_3,(void *)I251_4,(void *)I310_5};
	static char *se[] = {(void *)sp_reg_write,(void *)sp_pulse_input_type,(void *)sp_host_dmem_write,(void *)sp_host_dmem_read_req,(void *)sp_gpu_host_imem_word,(void *)sp_gpu_host_start_pulse,(void *)sp_arm_imem_write,(void *)sp_cpu_start_pulse};
	xsi_register_didat("work_m_00000000003277815782_3326411051", "isim/_tmp/work/m_00000000003277815782_3326411051.didat");
	xsi_register_executes(pe);
	xsi_register_subprogram_executes(se);
}
