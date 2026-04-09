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
static int ng2[] = {31, 0};
static int ng3[] = {0, 0};
static unsigned int ng4[] = {1U, 0U};
static int ng5[] = {63, 0};
static int ng6[] = {32, 0};
static unsigned int ng7[] = {2U, 0U};
static int ng8[] = {95, 0};
static int ng9[] = {64, 0};
static unsigned int ng10[] = {3U, 0U};
static int ng11[] = {127, 0};
static int ng12[] = {96, 0};
static unsigned int ng13[] = {4U, 0U};
static int ng14[] = {159, 0};
static int ng15[] = {128, 0};
static int ng16[] = {1, 0};
static int ng17[] = {3, 0};
static int ng18[] = {4, 0};
static int ng19[] = {2, 0};
static unsigned int ng20[] = {8U, 0U};
static int ng21[] = {0, 0, 0, 0};
static const char *ng22 = "=== tb_host_cpu_gpu_fifo: reset at cycle %0d ===";
static const char *ng23 = "--- Host DMEM write @0x00 (64b) ---";
static unsigned int ng24[] = {2864434397U, 0U};
static unsigned int ng25[] = {287454020U, 0U};
static const char *ng26 = "--- Host DMEM read @0x00 ---";
static const char *ng27 = "    dmem_out (64b) = %h  (expect 11223344AABBCCDD if aligned read matches write)";
static const char *ng28 = "--- GPU: IMEM[0]=0, address=32'h00000100 (len=1, PC=0), GPU_START ---";
static unsigned int ng29[] = {256U, 0U};
static int ng30[] = {80, 0};
static const char *ng31 = "    After GPU window: tensor_out (hw) = %h";
static const char *ng32 = "    Host readback dmem_out = %h";
static const char *ng33 = "--- ARM: IMEM[0] = B self, cpu_start pulse ---";
static unsigned int ng34[] = {3942645758U, 0U};
static int ng35[] = {20, 0};
static const char *ng36 = "=== tb_host_cpu_gpu_fifo done ===";
static const char *ng37 = "    (ids) arm_mem_stall=%0d at end ? 1 means ARM still waiting on GPU/host SRAM";
static const char *ng38 = "TIMEOUT";



static int sp_sw_write(char *t1, char *t2)
{
    char t14[8];
    char t15[8];
    char t16[8];
    int t0;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;
    int t8;
    char *t9;
    char *t10;
    char *t11;
    char *t12;
    char *t13;
    char *t17;
    char *t18;
    char *t19;
    char *t20;
    char *t21;
    char *t22;
    char *t23;
    unsigned int t24;
    int t25;
    char *t26;
    unsigned int t27;
    int t28;
    int t29;
    char *t30;
    unsigned int t31;
    int t32;
    int t33;
    unsigned int t34;
    int t35;
    unsigned int t36;
    unsigned int t37;
    int t38;
    int t39;

LAB0:    t0 = 1;
    t3 = (t2 + 24U);
    t4 = *((char **)t3);
    if (t4 == 0)
        goto LAB2;

LAB3:    goto *t4;

LAB2:    t4 = (t1 + 532);
    xsi_vlog_subprogram_setdisablestate(t4, &&LAB4);
    xsi_set_current_line(137, ng0);

LAB5:    xsi_set_current_line(138, ng0);
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

LAB6:    xsi_set_current_line(139, ng0);
    t4 = (t1 + 4900);
    t5 = (t4 + 32U);
    t6 = *((char **)t5);

LAB7:    t7 = ((char*)((ng1)));
    t8 = xsi_vlog_unsigned_case_compare(t6, 3, t7, 3);
    if (t8 == 1)
        goto LAB8;

LAB9:    t4 = ((char*)((ng4)));
    t8 = xsi_vlog_unsigned_case_compare(t6, 3, t4, 3);
    if (t8 == 1)
        goto LAB10;

LAB11:    t4 = ((char*)((ng7)));
    t8 = xsi_vlog_unsigned_case_compare(t6, 3, t4, 3);
    if (t8 == 1)
        goto LAB12;

LAB13:    t4 = ((char*)((ng10)));
    t8 = xsi_vlog_unsigned_case_compare(t6, 3, t4, 3);
    if (t8 == 1)
        goto LAB14;

LAB15:    t4 = ((char*)((ng13)));
    t8 = xsi_vlog_unsigned_case_compare(t6, 3, t4, 3);
    if (t8 == 1)
        goto LAB16;

LAB17:
LAB19:
LAB18:
LAB20:    xsi_set_current_line(147, ng0);
    t4 = (t2 + 44U);
    t5 = *((char **)t4);
    t7 = (t5 + 8U);
    xsi_wp_set_status(t7, 1);
    *((char **)t3) = &&LAB31;
    goto LAB1;

LAB8:    xsi_set_current_line(140, ng0);
    t9 = (t1 + 4992);
    t10 = (t9 + 32U);
    t11 = *((char **)t10);
    t12 = (t1 + 10168);
    t13 = *((char **)t12);
    t17 = (t1 + 10196);
    t18 = *((char **)t17);
    t19 = ((((char*)(t18))) + 40U);
    t20 = *((char **)t19);
    t21 = ((char*)((ng2)));
    t22 = ((char*)((ng3)));
    xsi_vlog_convert_partindices(t14, t15, t16, ((int*)(t20)), 2, t21, 32, 1, t22, 32, 1);
    t23 = (t14 + 4U);
    t24 = *((unsigned int *)t23);
    t25 = (!(t24));
    t26 = (t15 + 4U);
    t27 = *((unsigned int *)t26);
    t28 = (!(t27));
    t29 = (t25 && t28);
    t30 = (t16 + 4U);
    t31 = *((unsigned int *)t30);
    t32 = (!(t31));
    t33 = (t29 && t32);
    if (t33 == 1)
        goto LAB21;

LAB22:    goto LAB20;

LAB10:    xsi_set_current_line(141, ng0);
    t5 = (t1 + 4992);
    t7 = (t5 + 32U);
    t9 = *((char **)t7);
    t10 = (t1 + 10224);
    t11 = *((char **)t10);
    t12 = (t1 + 10252);
    t13 = *((char **)t12);
    t17 = ((((char*)(t13))) + 40U);
    t18 = *((char **)t17);
    t19 = ((char*)((ng5)));
    t20 = ((char*)((ng6)));
    xsi_vlog_convert_partindices(t14, t15, t16, ((int*)(t18)), 2, t19, 32, 1, t20, 32, 1);
    t21 = (t14 + 4U);
    t24 = *((unsigned int *)t21);
    t25 = (!(t24));
    t22 = (t15 + 4U);
    t27 = *((unsigned int *)t22);
    t28 = (!(t27));
    t29 = (t25 && t28);
    t23 = (t16 + 4U);
    t31 = *((unsigned int *)t23);
    t32 = (!(t31));
    t33 = (t29 && t32);
    if (t33 == 1)
        goto LAB23;

LAB24:    goto LAB20;

LAB12:    xsi_set_current_line(142, ng0);
    t5 = (t1 + 4992);
    t7 = (t5 + 32U);
    t9 = *((char **)t7);
    t10 = (t1 + 10280);
    t11 = *((char **)t10);
    t12 = (t1 + 10308);
    t13 = *((char **)t12);
    t17 = ((((char*)(t13))) + 40U);
    t18 = *((char **)t17);
    t19 = ((char*)((ng8)));
    t20 = ((char*)((ng9)));
    xsi_vlog_convert_partindices(t14, t15, t16, ((int*)(t18)), 2, t19, 32, 1, t20, 32, 1);
    t21 = (t14 + 4U);
    t24 = *((unsigned int *)t21);
    t25 = (!(t24));
    t22 = (t15 + 4U);
    t27 = *((unsigned int *)t22);
    t28 = (!(t27));
    t29 = (t25 && t28);
    t23 = (t16 + 4U);
    t31 = *((unsigned int *)t23);
    t32 = (!(t31));
    t33 = (t29 && t32);
    if (t33 == 1)
        goto LAB25;

LAB26:    goto LAB20;

LAB14:    xsi_set_current_line(143, ng0);
    t5 = (t1 + 4992);
    t7 = (t5 + 32U);
    t9 = *((char **)t7);
    t10 = (t1 + 10336);
    t11 = *((char **)t10);
    t12 = (t1 + 10364);
    t13 = *((char **)t12);
    t17 = ((((char*)(t13))) + 40U);
    t18 = *((char **)t17);
    t19 = ((char*)((ng11)));
    t20 = ((char*)((ng12)));
    xsi_vlog_convert_partindices(t14, t15, t16, ((int*)(t18)), 2, t19, 32, 1, t20, 32, 1);
    t21 = (t14 + 4U);
    t24 = *((unsigned int *)t21);
    t25 = (!(t24));
    t22 = (t15 + 4U);
    t27 = *((unsigned int *)t22);
    t28 = (!(t27));
    t29 = (t25 && t28);
    t23 = (t16 + 4U);
    t31 = *((unsigned int *)t23);
    t32 = (!(t31));
    t33 = (t29 && t32);
    if (t33 == 1)
        goto LAB27;

LAB28:    goto LAB20;

LAB16:    xsi_set_current_line(144, ng0);
    t5 = (t1 + 4992);
    t7 = (t5 + 32U);
    t9 = *((char **)t7);
    t10 = (t1 + 10392);
    t11 = *((char **)t10);
    t12 = (t1 + 10420);
    t13 = *((char **)t12);
    t17 = ((((char*)(t13))) + 40U);
    t18 = *((char **)t17);
    t19 = ((char*)((ng14)));
    t20 = ((char*)((ng15)));
    xsi_vlog_convert_partindices(t14, t15, t16, ((int*)(t18)), 2, t19, 32, 1, t20, 32, 1);
    t21 = (t14 + 4U);
    t24 = *((unsigned int *)t21);
    t25 = (!(t24));
    t22 = (t15 + 4U);
    t27 = *((unsigned int *)t22);
    t28 = (!(t27));
    t29 = (t25 && t28);
    t23 = (t16 + 4U);
    t31 = *((unsigned int *)t23);
    t32 = (!(t31));
    t33 = (t29 && t32);
    if (t33 == 1)
        goto LAB29;

LAB30:    goto LAB20;

LAB21:    t34 = *((unsigned int *)t16);
    t35 = (t34 + 0);
    t36 = *((unsigned int *)t14);
    t37 = *((unsigned int *)t15);
    t38 = (t36 - t37);
    t39 = (t38 + 1);
    xsi_vlogvar_assign_value(((char*)(t13)), t11, t35, *((unsigned int *)t15), t39);
    goto LAB22;

LAB23:    t34 = *((unsigned int *)t16);
    t35 = (t34 + 0);
    t36 = *((unsigned int *)t14);
    t37 = *((unsigned int *)t15);
    t38 = (t36 - t37);
    t39 = (t38 + 1);
    xsi_vlogvar_assign_value(((char*)(t11)), t9, t35, *((unsigned int *)t15), t39);
    goto LAB24;

LAB25:    t34 = *((unsigned int *)t16);
    t35 = (t34 + 0);
    t36 = *((unsigned int *)t14);
    t37 = *((unsigned int *)t15);
    t38 = (t36 - t37);
    t39 = (t38 + 1);
    xsi_vlogvar_assign_value(((char*)(t11)), t9, t35, *((unsigned int *)t15), t39);
    goto LAB26;

LAB27:    t34 = *((unsigned int *)t16);
    t35 = (t34 + 0);
    t36 = *((unsigned int *)t14);
    t37 = *((unsigned int *)t15);
    t38 = (t36 - t37);
    t39 = (t38 + 1);
    xsi_vlogvar_assign_value(((char*)(t11)), t9, t35, *((unsigned int *)t15), t39);
    goto LAB28;

LAB29:    t34 = *((unsigned int *)t16);
    t35 = (t34 + 0);
    t36 = *((unsigned int *)t14);
    t37 = *((unsigned int *)t15);
    t38 = (t36 - t37);
    t39 = (t38 + 1);
    xsi_vlogvar_assign_value(((char*)(t11)), t9, t35, *((unsigned int *)t15), t39);
    goto LAB30;

LAB31:    xsi_set_current_line(148, ng0);
    t4 = (t2 + 28U);
    t5 = *((char **)t4);
    xsi_process_wait(t5, 1000000LL);
    *((char **)t3) = &&LAB32;
    t0 = 1;
    goto LAB1;

LAB32:    goto LAB4;

}

static int sp_host_dmem_write(char *t1, char *t2)
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

LAB0:    t0 = 1;
    t3 = (t2 + 24U);
    t4 = *((char **)t3);
    if (t4 == 0)
        goto LAB2;

LAB3:    goto *t4;

LAB2:    t4 = (t1 + 772);
    xsi_vlog_subprogram_setdisablestate(t4, &&LAB4);
    xsi_set_current_line(156, ng0);

LAB5:    xsi_set_current_line(157, ng0);
    t5 = ((char*)((ng16)));
    t7 = (t1 + 5084);
    t8 = (t7 + 32U);
    t9 = *((char **)t8);
    t10 = ((char*)((ng1)));
    xsi_vlogtype_concat(t6, 32, 32, 2U, t10, 24, t9, 8);
    t11 = (t2 + 28U);
    t12 = *((char **)t11);
    t13 = (t1 + 532);
    t14 = xsi_create_subprogram_invocation(t12, 0, t1, t13, 0, t2);
    xsi_vlog_subprogram_pushinvocation(t13, t14);
    t15 = (t1 + 4900);
    xsi_vlogvar_assign_value(t15, t5, 0, 0, 3);
    t16 = (t1 + 4992);
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

LAB8:    t18 = (t1 + 532);
    xsi_vlog_subprogram_popinvocation(t18);

LAB6:    t26 = (t2 + 32U);
    t27 = *((char **)t26);
    t26 = (t1 + 532);
    t28 = (t2 + 32U);
    t29 = *((char **)t28);
    t28 = (t2 + 28U);
    t30 = *((char **)t28);
    xsi_delete_subprogram_invocation(t26, t29, t1, t30, t2);
    xsi_set_current_line(158, ng0);
    t4 = ((char*)((ng17)));
    t5 = (t1 + 5176);
    t7 = (t5 + 32U);
    t8 = *((char **)t7);
    t9 = (t2 + 28U);
    t10 = *((char **)t9);
    t11 = (t1 + 532);
    t12 = xsi_create_subprogram_invocation(t10, 0, t1, t11, 0, t2);
    xsi_vlog_subprogram_pushinvocation(t11, t12);
    t13 = (t1 + 4900);
    xsi_vlogvar_assign_value(t13, t4, 0, 0, 3);
    t14 = (t1 + 4992);
    xsi_vlogvar_assign_value(t14, t8, 0, 0, 32);

LAB11:    t15 = (t2 + 32U);
    t16 = *((char **)t15);
    t17 = (t16 + 40U);
    t18 = *((char **)t17);
    t19 = (t18 + 132U);
    t20 = *((char **)t19);
    t21 = (t20 + 0U);
    t22 = *((char **)t21);
    t25 = ((int  (*)(char *, char *))t22)(t1, t16);
    if (t25 != 0)
        goto LAB13;

LAB12:    t16 = (t1 + 532);
    xsi_vlog_subprogram_popinvocation(t16);

LAB10:    t23 = (t2 + 32U);
    t24 = *((char **)t23);
    t23 = (t1 + 532);
    t26 = (t2 + 32U);
    t27 = *((char **)t26);
    t26 = (t2 + 28U);
    t28 = *((char **)t26);
    xsi_delete_subprogram_invocation(t23, t27, t1, t28, t2);
    xsi_set_current_line(159, ng0);
    t4 = ((char*)((ng18)));
    t5 = (t1 + 5268);
    t7 = (t5 + 32U);
    t8 = *((char **)t7);
    t9 = (t2 + 28U);
    t10 = *((char **)t9);
    t11 = (t1 + 532);
    t12 = xsi_create_subprogram_invocation(t10, 0, t1, t11, 0, t2);
    xsi_vlog_subprogram_pushinvocation(t11, t12);
    t13 = (t1 + 4900);
    xsi_vlogvar_assign_value(t13, t4, 0, 0, 3);
    t14 = (t1 + 4992);
    xsi_vlogvar_assign_value(t14, t8, 0, 0, 32);

LAB15:    t15 = (t2 + 32U);
    t16 = *((char **)t15);
    t17 = (t16 + 40U);
    t18 = *((char **)t17);
    t19 = (t18 + 132U);
    t20 = *((char **)t19);
    t21 = (t20 + 0U);
    t22 = *((char **)t21);
    t25 = ((int  (*)(char *, char *))t22)(t1, t16);
    if (t25 != 0)
        goto LAB17;

LAB16:    t16 = (t1 + 532);
    xsi_vlog_subprogram_popinvocation(t16);

LAB14:    t23 = (t2 + 32U);
    t24 = *((char **)t23);
    t23 = (t1 + 532);
    t26 = (t2 + 32U);
    t27 = *((char **)t26);
    t26 = (t2 + 28U);
    t28 = *((char **)t26);
    xsi_delete_subprogram_invocation(t23, t27, t1, t28, t2);
    xsi_set_current_line(160, ng0);
    t4 = ((char*)((ng3)));
    t5 = ((char*)((ng7)));
    t7 = (t2 + 28U);
    t8 = *((char **)t7);
    t9 = (t1 + 532);
    t10 = xsi_create_subprogram_invocation(t8, 0, t1, t9, 0, t2);
    xsi_vlog_subprogram_pushinvocation(t9, t10);
    t11 = (t1 + 4900);
    xsi_vlogvar_assign_value(t11, t4, 0, 0, 3);
    t12 = (t1 + 4992);
    xsi_vlogvar_assign_value(t12, t5, 0, 0, 32);

LAB19:    t13 = (t2 + 32U);
    t14 = *((char **)t13);
    t15 = (t14 + 40U);
    t16 = *((char **)t15);
    t17 = (t16 + 132U);
    t18 = *((char **)t17);
    t19 = (t18 + 0U);
    t20 = *((char **)t19);
    t25 = ((int  (*)(char *, char *))t20)(t1, t14);
    if (t25 != 0)
        goto LAB21;

LAB20:    t14 = (t1 + 532);
    xsi_vlog_subprogram_popinvocation(t14);

LAB18:    t21 = (t2 + 32U);
    t22 = *((char **)t21);
    t21 = (t1 + 532);
    t23 = (t2 + 32U);
    t24 = *((char **)t23);
    t23 = (t2 + 28U);
    t26 = *((char **)t23);
    xsi_delete_subprogram_invocation(t21, t24, t1, t26, t2);
    xsi_set_current_line(161, ng0);
    t4 = ((char*)((ng3)));
    t5 = ((char*)((ng1)));
    t7 = (t2 + 28U);
    t8 = *((char **)t7);
    t9 = (t1 + 532);
    t10 = xsi_create_subprogram_invocation(t8, 0, t1, t9, 0, t2);
    xsi_vlog_subprogram_pushinvocation(t9, t10);
    t11 = (t1 + 4900);
    xsi_vlogvar_assign_value(t11, t4, 0, 0, 3);
    t12 = (t1 + 4992);
    xsi_vlogvar_assign_value(t12, t5, 0, 0, 32);

LAB23:    t13 = (t2 + 32U);
    t14 = *((char **)t13);
    t15 = (t14 + 40U);
    t16 = *((char **)t15);
    t17 = (t16 + 132U);
    t18 = *((char **)t17);
    t19 = (t18 + 0U);
    t20 = *((char **)t19);
    t25 = ((int  (*)(char *, char *))t20)(t1, t14);
    if (t25 != 0)
        goto LAB25;

LAB24:    t14 = (t1 + 532);
    xsi_vlog_subprogram_popinvocation(t14);

LAB22:    t21 = (t2 + 32U);
    t22 = *((char **)t21);
    t21 = (t1 + 532);
    t23 = (t2 + 32U);
    t24 = *((char **)t23);
    t23 = (t2 + 28U);
    t26 = *((char **)t23);
    xsi_delete_subprogram_invocation(t21, t24, t1, t26, t2);

LAB4:    xsi_vlog_dispose_subprogram_invocation(t2);
    t4 = (t2 + 24U);
    *((char **)t4) = &&LAB2;
    t0 = 0;

LAB1:    return t0;
LAB9:    t17 = (t2 + 24U);
    *((char **)t17) = &&LAB7;
    goto LAB1;

LAB13:    t15 = (t2 + 24U);
    *((char **)t15) = &&LAB11;
    goto LAB1;

LAB17:    t15 = (t2 + 24U);
    *((char **)t15) = &&LAB15;
    goto LAB1;

LAB21:    t13 = (t2 + 24U);
    *((char **)t13) = &&LAB19;
    goto LAB1;

LAB25:    t13 = (t2 + 24U);
    *((char **)t13) = &&LAB23;
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

LAB2:    t4 = (t1 + 1012);
    xsi_vlog_subprogram_setdisablestate(t4, &&LAB4);
    xsi_set_current_line(167, ng0);

LAB5:    xsi_set_current_line(168, ng0);
    t5 = ((char*)((ng16)));
    t7 = (t1 + 5360);
    t8 = (t7 + 32U);
    t9 = *((char **)t8);
    t10 = ((char*)((ng1)));
    xsi_vlogtype_concat(t6, 32, 32, 2U, t10, 24, t9, 8);
    t11 = (t2 + 28U);
    t12 = *((char **)t11);
    t13 = (t1 + 532);
    t14 = xsi_create_subprogram_invocation(t12, 0, t1, t13, 0, t2);
    xsi_vlog_subprogram_pushinvocation(t13, t14);
    t15 = (t1 + 4900);
    xsi_vlogvar_assign_value(t15, t5, 0, 0, 3);
    t16 = (t1 + 4992);
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

LAB8:    t18 = (t1 + 532);
    xsi_vlog_subprogram_popinvocation(t18);

LAB6:    t26 = (t2 + 32U);
    t27 = *((char **)t26);
    t26 = (t1 + 532);
    t28 = (t2 + 32U);
    t29 = *((char **)t28);
    t28 = (t2 + 28U);
    t30 = *((char **)t28);
    xsi_delete_subprogram_invocation(t26, t29, t1, t30, t2);
    xsi_set_current_line(169, ng0);
    t4 = ((char*)((ng3)));
    t5 = ((char*)((ng13)));
    t7 = (t2 + 28U);
    t8 = *((char **)t7);
    t9 = (t1 + 532);
    t10 = xsi_create_subprogram_invocation(t8, 0, t1, t9, 0, t2);
    xsi_vlog_subprogram_pushinvocation(t9, t10);
    t11 = (t1 + 4900);
    xsi_vlogvar_assign_value(t11, t4, 0, 0, 3);
    t12 = (t1 + 4992);
    xsi_vlogvar_assign_value(t12, t5, 0, 0, 32);

LAB11:    t13 = (t2 + 32U);
    t14 = *((char **)t13);
    t15 = (t14 + 40U);
    t16 = *((char **)t15);
    t17 = (t16 + 132U);
    t18 = *((char **)t17);
    t19 = (t18 + 0U);
    t20 = *((char **)t19);
    t25 = ((int  (*)(char *, char *))t20)(t1, t14);
    if (t25 != 0)
        goto LAB13;

LAB12:    t14 = (t1 + 532);
    xsi_vlog_subprogram_popinvocation(t14);

LAB10:    t21 = (t2 + 32U);
    t22 = *((char **)t21);
    t21 = (t1 + 532);
    t23 = (t2 + 32U);
    t24 = *((char **)t23);
    t23 = (t2 + 28U);
    t26 = *((char **)t23);
    xsi_delete_subprogram_invocation(t21, t24, t1, t26, t2);
    xsi_set_current_line(170, ng0);
    t4 = ((char*)((ng3)));
    t5 = ((char*)((ng1)));
    t7 = (t2 + 28U);
    t8 = *((char **)t7);
    t9 = (t1 + 532);
    t10 = xsi_create_subprogram_invocation(t8, 0, t1, t9, 0, t2);
    xsi_vlog_subprogram_pushinvocation(t9, t10);
    t11 = (t1 + 4900);
    xsi_vlogvar_assign_value(t11, t4, 0, 0, 3);
    t12 = (t1 + 4992);
    xsi_vlogvar_assign_value(t12, t5, 0, 0, 32);

LAB15:    t13 = (t2 + 32U);
    t14 = *((char **)t13);
    t15 = (t14 + 40U);
    t16 = *((char **)t15);
    t17 = (t16 + 132U);
    t18 = *((char **)t17);
    t19 = (t18 + 0U);
    t20 = *((char **)t19);
    t25 = ((int  (*)(char *, char *))t20)(t1, t14);
    if (t25 != 0)
        goto LAB17;

LAB16:    t14 = (t1 + 532);
    xsi_vlog_subprogram_popinvocation(t14);

LAB14:    t21 = (t2 + 32U);
    t22 = *((char **)t21);
    t21 = (t1 + 532);
    t23 = (t2 + 32U);
    t24 = *((char **)t23);
    t23 = (t2 + 28U);
    t26 = *((char **)t23);
    xsi_delete_subprogram_invocation(t21, t24, t1, t26, t2);
    xsi_set_current_line(171, ng0);
    t4 = ((char*)((ng18)));
    t5 = (t4 + 4U);
    t31 = *((unsigned int *)t5);
    t32 = (~(t31));
    t33 = *((unsigned int *)t4);
    t25 = (t33 & t32);
    t7 = (t1 + 10424);
    *((int *)t7) = t25;

LAB18:    t8 = (t1 + 10424);
    if (*((int *)t8) > 0)
        goto LAB19;

LAB20:
LAB4:    xsi_vlog_dispose_subprogram_invocation(t2);
    t4 = (t2 + 24U);
    *((char **)t4) = &&LAB2;
    t0 = 0;

LAB1:    return t0;
LAB9:    t17 = (t2 + 24U);
    *((char **)t17) = &&LAB7;
    goto LAB1;

LAB13:    t13 = (t2 + 24U);
    *((char **)t13) = &&LAB11;
    goto LAB1;

LAB17:    t13 = (t2 + 24U);
    *((char **)t13) = &&LAB15;
    goto LAB1;

LAB19:    xsi_set_current_line(171, ng0);
    t9 = (t2 + 44U);
    t10 = *((char **)t9);
    t11 = (t10 + 0U);
    xsi_wp_set_status(t11, 1);
    *((char **)t3) = &&LAB21;
    goto LAB1;

LAB21:    t4 = (t1 + 10424);
    t25 = *((int *)t4);
    *((int *)t4) = (t25 - 1);
    goto LAB18;

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

LAB2:    t4 = (t1 + 1252);
    xsi_vlog_subprogram_setdisablestate(t4, &&LAB4);
    xsi_set_current_line(178, ng0);

LAB5:    xsi_set_current_line(179, ng0);
    t5 = ((char*)((ng16)));
    t6 = (t1 + 5452);
    t7 = (t6 + 32U);
    t8 = *((char **)t7);
    t9 = (t2 + 28U);
    t10 = *((char **)t9);
    t11 = (t1 + 532);
    t12 = xsi_create_subprogram_invocation(t10, 0, t1, t11, 0, t2);
    xsi_vlog_subprogram_pushinvocation(t11, t12);
    t13 = (t1 + 4900);
    xsi_vlogvar_assign_value(t13, t5, 0, 0, 3);
    t14 = (t1 + 4992);
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

LAB8:    t16 = (t1 + 532);
    xsi_vlog_subprogram_popinvocation(t16);

LAB6:    t24 = (t2 + 32U);
    t25 = *((char **)t24);
    t24 = (t1 + 532);
    t26 = (t2 + 32U);
    t27 = *((char **)t26);
    t26 = (t2 + 28U);
    t28 = *((char **)t26);
    xsi_delete_subprogram_invocation(t24, t27, t1, t28, t2);
    xsi_set_current_line(180, ng0);
    t4 = ((char*)((ng19)));
    t5 = (t1 + 5544);
    t6 = (t5 + 32U);
    t7 = *((char **)t6);
    t8 = (t2 + 28U);
    t9 = *((char **)t8);
    t10 = (t1 + 532);
    t11 = xsi_create_subprogram_invocation(t9, 0, t1, t10, 0, t2);
    xsi_vlog_subprogram_pushinvocation(t10, t11);
    t12 = (t1 + 4900);
    xsi_vlogvar_assign_value(t12, t4, 0, 0, 3);
    t13 = (t1 + 4992);
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

LAB12:    t15 = (t1 + 532);
    xsi_vlog_subprogram_popinvocation(t15);

LAB10:    t22 = (t2 + 32U);
    t24 = *((char **)t22);
    t22 = (t1 + 532);
    t25 = (t2 + 32U);
    t26 = *((char **)t25);
    t25 = (t2 + 28U);
    t27 = *((char **)t25);
    xsi_delete_subprogram_invocation(t22, t26, t1, t27, t2);
    xsi_set_current_line(181, ng0);
    t4 = ((char*)((ng3)));
    t5 = ((char*)((ng4)));
    t6 = (t2 + 28U);
    t7 = *((char **)t6);
    t8 = (t1 + 532);
    t9 = xsi_create_subprogram_invocation(t7, 0, t1, t8, 0, t2);
    xsi_vlog_subprogram_pushinvocation(t8, t9);
    t10 = (t1 + 4900);
    xsi_vlogvar_assign_value(t10, t4, 0, 0, 3);
    t11 = (t1 + 4992);
    xsi_vlogvar_assign_value(t11, t5, 0, 0, 32);

LAB15:    t12 = (t2 + 32U);
    t13 = *((char **)t12);
    t14 = (t13 + 40U);
    t15 = *((char **)t14);
    t16 = (t15 + 132U);
    t17 = *((char **)t16);
    t18 = (t17 + 0U);
    t19 = *((char **)t18);
    t23 = ((int  (*)(char *, char *))t19)(t1, t13);
    if (t23 != 0)
        goto LAB17;

LAB16:    t13 = (t1 + 532);
    xsi_vlog_subprogram_popinvocation(t13);

LAB14:    t20 = (t2 + 32U);
    t21 = *((char **)t20);
    t20 = (t1 + 532);
    t22 = (t2 + 32U);
    t24 = *((char **)t22);
    t22 = (t2 + 28U);
    t25 = *((char **)t22);
    xsi_delete_subprogram_invocation(t20, t24, t1, t25, t2);
    xsi_set_current_line(182, ng0);
    t4 = ((char*)((ng3)));
    t5 = ((char*)((ng1)));
    t6 = (t2 + 28U);
    t7 = *((char **)t6);
    t8 = (t1 + 532);
    t9 = xsi_create_subprogram_invocation(t7, 0, t1, t8, 0, t2);
    xsi_vlog_subprogram_pushinvocation(t8, t9);
    t10 = (t1 + 4900);
    xsi_vlogvar_assign_value(t10, t4, 0, 0, 3);
    t11 = (t1 + 4992);
    xsi_vlogvar_assign_value(t11, t5, 0, 0, 32);

LAB19:    t12 = (t2 + 32U);
    t13 = *((char **)t12);
    t14 = (t13 + 40U);
    t15 = *((char **)t14);
    t16 = (t15 + 132U);
    t17 = *((char **)t16);
    t18 = (t17 + 0U);
    t19 = *((char **)t18);
    t23 = ((int  (*)(char *, char *))t19)(t1, t13);
    if (t23 != 0)
        goto LAB21;

LAB20:    t13 = (t1 + 532);
    xsi_vlog_subprogram_popinvocation(t13);

LAB18:    t20 = (t2 + 32U);
    t21 = *((char **)t20);
    t20 = (t1 + 532);
    t22 = (t2 + 32U);
    t24 = *((char **)t22);
    t22 = (t2 + 28U);
    t25 = *((char **)t22);
    xsi_delete_subprogram_invocation(t20, t24, t1, t25, t2);

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

LAB17:    t12 = (t2 + 24U);
    *((char **)t12) = &&LAB15;
    goto LAB1;

LAB21:    t12 = (t2 + 24U);
    *((char **)t12) = &&LAB19;
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

LAB2:    t4 = (t1 + 1492);
    xsi_vlog_subprogram_setdisablestate(t4, &&LAB4);
    xsi_set_current_line(188, ng0);

LAB5:    xsi_set_current_line(189, ng0);
    t5 = ((char*)((ng16)));
    t6 = (t1 + 5636);
    t7 = (t6 + 32U);
    t8 = *((char **)t7);
    t9 = (t2 + 28U);
    t10 = *((char **)t9);
    t11 = (t1 + 532);
    t12 = xsi_create_subprogram_invocation(t10, 0, t1, t11, 0, t2);
    xsi_vlog_subprogram_pushinvocation(t11, t12);
    t13 = (t1 + 4900);
    xsi_vlogvar_assign_value(t13, t5, 0, 0, 3);
    t14 = (t1 + 4992);
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

LAB8:    t16 = (t1 + 532);
    xsi_vlog_subprogram_popinvocation(t16);

LAB6:    t24 = (t2 + 32U);
    t25 = *((char **)t24);
    t24 = (t1 + 532);
    t26 = (t2 + 32U);
    t27 = *((char **)t26);
    t26 = (t2 + 28U);
    t28 = *((char **)t26);
    xsi_delete_subprogram_invocation(t24, t27, t1, t28, t2);
    xsi_set_current_line(190, ng0);
    t4 = ((char*)((ng3)));
    t5 = ((char*)((ng20)));
    t6 = (t2 + 28U);
    t7 = *((char **)t6);
    t8 = (t1 + 532);
    t9 = xsi_create_subprogram_invocation(t7, 0, t1, t8, 0, t2);
    xsi_vlog_subprogram_pushinvocation(t8, t9);
    t10 = (t1 + 4900);
    xsi_vlogvar_assign_value(t10, t4, 0, 0, 3);
    t11 = (t1 + 4992);
    xsi_vlogvar_assign_value(t11, t5, 0, 0, 32);

LAB11:    t12 = (t2 + 32U);
    t13 = *((char **)t12);
    t14 = (t13 + 40U);
    t15 = *((char **)t14);
    t16 = (t15 + 132U);
    t17 = *((char **)t16);
    t18 = (t17 + 0U);
    t19 = *((char **)t18);
    t23 = ((int  (*)(char *, char *))t19)(t1, t13);
    if (t23 != 0)
        goto LAB13;

LAB12:    t13 = (t1 + 532);
    xsi_vlog_subprogram_popinvocation(t13);

LAB10:    t20 = (t2 + 32U);
    t21 = *((char **)t20);
    t20 = (t1 + 532);
    t22 = (t2 + 32U);
    t24 = *((char **)t22);
    t22 = (t2 + 28U);
    t25 = *((char **)t22);
    xsi_delete_subprogram_invocation(t20, t24, t1, t25, t2);
    xsi_set_current_line(191, ng0);
    t4 = ((char*)((ng3)));
    t5 = ((char*)((ng1)));
    t6 = (t2 + 28U);
    t7 = *((char **)t6);
    t8 = (t1 + 532);
    t9 = xsi_create_subprogram_invocation(t7, 0, t1, t8, 0, t2);
    xsi_vlog_subprogram_pushinvocation(t8, t9);
    t10 = (t1 + 4900);
    xsi_vlogvar_assign_value(t10, t4, 0, 0, 3);
    t11 = (t1 + 4992);
    xsi_vlogvar_assign_value(t11, t5, 0, 0, 32);

LAB15:    t12 = (t2 + 32U);
    t13 = *((char **)t12);
    t14 = (t13 + 40U);
    t15 = *((char **)t14);
    t16 = (t15 + 132U);
    t17 = *((char **)t16);
    t18 = (t17 + 0U);
    t19 = *((char **)t18);
    t23 = ((int  (*)(char *, char *))t19)(t1, t13);
    if (t23 != 0)
        goto LAB17;

LAB16:    t13 = (t1 + 532);
    xsi_vlog_subprogram_popinvocation(t13);

LAB14:    t20 = (t2 + 32U);
    t21 = *((char **)t20);
    t20 = (t1 + 532);
    t22 = (t2 + 32U);
    t24 = *((char **)t22);
    t22 = (t2 + 28U);
    t25 = *((char **)t22);
    xsi_delete_subprogram_invocation(t20, t24, t1, t25, t2);

LAB4:    xsi_vlog_dispose_subprogram_invocation(t2);
    t4 = (t2 + 24U);
    *((char **)t4) = &&LAB2;
    t0 = 0;

LAB1:    return t0;
LAB9:    t15 = (t2 + 24U);
    *((char **)t15) = &&LAB7;
    goto LAB1;

LAB13:    t12 = (t2 + 24U);
    *((char **)t12) = &&LAB11;
    goto LAB1;

LAB17:    t12 = (t2 + 24U);
    *((char **)t12) = &&LAB15;
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

LAB2:    t4 = (t1 + 1732);
    xsi_vlog_subprogram_setdisablestate(t4, &&LAB4);
    xsi_set_current_line(198, ng0);

LAB5:    xsi_set_current_line(199, ng0);
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

LAB6:    xsi_set_current_line(200, ng0);
    t4 = ((char*)((ng4)));
    t5 = (t1 + 4532);
    xsi_vlogvar_assign_value(t5, t4, 0, 0, 1);
    xsi_set_current_line(201, ng0);
    t4 = (t1 + 5728);
    t5 = (t4 + 32U);
    t6 = *((char **)t5);
    t7 = (t1 + 4624);
    xsi_vlogvar_assign_value(t7, t6, 0, 0, 9);
    xsi_set_current_line(202, ng0);
    t4 = (t1 + 5820);
    t5 = (t4 + 32U);
    t6 = *((char **)t5);
    t7 = (t1 + 4716);
    xsi_vlogvar_assign_value(t7, t6, 0, 0, 32);
    xsi_set_current_line(203, ng0);
    t4 = (t2 + 44U);
    t5 = *((char **)t4);
    t6 = (t5 + 8U);
    xsi_wp_set_status(t6, 1);
    *((char **)t3) = &&LAB7;
    goto LAB1;

LAB7:    xsi_set_current_line(204, ng0);
    t4 = ((char*)((ng1)));
    t5 = (t1 + 4532);
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

LAB2:    t4 = (t1 + 1972);
    xsi_vlog_subprogram_setdisablestate(t4, &&LAB4);
    xsi_set_current_line(209, ng0);

LAB5:    xsi_set_current_line(210, ng0);
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

LAB6:    xsi_set_current_line(211, ng0);
    t4 = ((char*)((ng4)));
    t5 = (t1 + 4440);
    xsi_vlogvar_assign_value(t5, t4, 0, 0, 1);
    xsi_set_current_line(212, ng0);
    t4 = (t2 + 44U);
    t5 = *((char **)t4);
    t6 = (t5 + 8U);
    xsi_wp_set_status(t6, 1);
    *((char **)t3) = &&LAB7;
    goto LAB1;

LAB7:    xsi_set_current_line(213, ng0);
    t4 = ((char*)((ng1)));
    t5 = (t1 + 4440);
    xsi_vlogvar_assign_value(t5, t4, 0, 0, 1);
    goto LAB4;

}

static void I126_0(char *t0)
{
    char *t1;
    char *t2;

LAB0:    xsi_set_current_line(126, ng0);
    t1 = ((char*)((ng3)));
    t2 = (t0 + 4256);
    xsi_vlogvar_assign_value(t2, t1, 0, 0, 1);

LAB1:    return;
}

static void A127_1(char *t0)
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

LAB0:    t1 = (t0 + 6424U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(127, ng0);
    t2 = (t0 + 6340);
    xsi_process_wait(t2, 4000000LL);
    *((char **)t1) = &&LAB4;

LAB1:    return;
LAB4:    xsi_set_current_line(127, ng0);
    t4 = (t0 + 4256);
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
    t17 = (t0 + 4256);
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

static void I130_2(char *t0)
{
    char *t1;
    char *t2;

LAB0:    xsi_set_current_line(130, ng0);
    t1 = ((char*)((ng3)));
    t2 = (t0 + 4808);
    xsi_vlogvar_assign_value(t2, t1, 0, 0, 32);

LAB1:    return;
}

static void A131_3(char *t0)
{
    char t7[8];
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    char *t8;

LAB0:    t1 = (t0 + 6680U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(131, ng0);
    t2 = (t0 + 7116);
    *((int *)t2) = 1;
    *((char **)t1) = &&LAB4;

LAB1:    return;
LAB4:    xsi_set_current_line(131, ng0);
    t3 = (t0 + 4808);
    t4 = (t3 + 32U);
    t5 = *((char **)t4);
    t6 = ((char*)((ng16)));
    memset(t7, 0, 8);
    xsi_vlog_signed_add(t7, 32, t5, 32, t6, 32);
    t8 = (t0 + 4808);
    xsi_vlogvar_assign_value(t8, t7, 0, 0, 32);
    goto LAB2;

}

static void I219_4(char *t0)
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

LAB0:    t1 = (t0 + 6808U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(219, ng0);

LAB4:    xsi_set_current_line(220, ng0);
    t2 = ((char*)((ng21)));
    t3 = (t0 + 3336);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 64);
    xsi_set_current_line(221, ng0);
    t2 = ((char*)((ng3)));
    t3 = (t0 + 3428);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 8);
    xsi_set_current_line(222, ng0);
    t2 = ((char*)((ng3)));
    t3 = (t0 + 3520);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(223, ng0);
    t2 = ((char*)((ng16)));
    t3 = (t0 + 3612);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(224, ng0);
    t2 = ((char*)((ng3)));
    t3 = (t0 + 3704);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(225, ng0);
    t2 = ((char*)((ng3)));
    t3 = (t0 + 4164);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(226, ng0);
    t2 = ((char*)((ng16)));
    t3 = (t0 + 3796);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(227, ng0);
    t2 = ((char*)((ng3)));
    t3 = (t0 + 3888);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 23);
    xsi_set_current_line(228, ng0);
    t2 = ((char*)((ng3)));
    t3 = (t0 + 3980);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 32);
    xsi_set_current_line(229, ng0);
    t2 = ((char*)((ng3)));
    t3 = (t0 + 4072);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 2);
    xsi_set_current_line(230, ng0);
    t2 = ((char*)((ng3)));
    t3 = (t0 + 4440);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(231, ng0);
    t2 = ((char*)((ng3)));
    t3 = (t0 + 4532);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(232, ng0);
    t2 = ((char*)((ng3)));
    t3 = (t0 + 4624);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 9);
    xsi_set_current_line(233, ng0);
    t2 = ((char*)((ng3)));
    t3 = (t0 + 4716);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 32);
    xsi_set_current_line(235, ng0);
    t2 = ((char*)((ng16)));
    t3 = (t0 + 4348);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(236, ng0);
    t2 = ((char*)((ng18)));
    t3 = (t2 + 4U);
    t4 = *((unsigned int *)t3);
    t5 = (~(t4));
    t6 = *((unsigned int *)t2);
    t7 = (t6 & t5);
    t8 = (t0 + 10428);
    *((int *)t8) = t7;

LAB5:    t9 = (t0 + 10428);
    if (*((int *)t9) > 0)
        goto LAB6;

LAB7:    xsi_set_current_line(237, ng0);
    t2 = (t0 + 6724);
    xsi_process_wait(t2, 1000000LL);
    *((char **)t1) = &&LAB9;

LAB1:    return;
LAB6:    xsi_set_current_line(236, ng0);
    t10 = (t0 + 7180);
    *((int *)t10) = 1;
    *((char **)t1) = &&LAB8;
    goto LAB1;

LAB8:    t2 = (t0 + 10428);
    t7 = *((int *)t2);
    *((int *)t2) = (t7 - 1);
    goto LAB5;

LAB9:    xsi_set_current_line(237, ng0);
    t3 = ((char*)((ng3)));
    t8 = (t0 + 4348);
    xsi_vlogvar_assign_value(t8, t3, 0, 0, 1);
    xsi_set_current_line(238, ng0);
    t2 = (t0 + 4808);
    t3 = (t2 + 32U);
    t8 = *((char **)t3);
    xsi_vlogfile_write(1, 0, ng22, 2, t0, (char)119, t8, 32);
    xsi_set_current_line(243, ng0);
    xsi_vlogfile_write(1, 0, ng23, 1, t0);
    xsi_set_current_line(244, ng0);
    t2 = ((char*)((ng1)));
    t3 = ((char*)((ng24)));
    t8 = ((char*)((ng25)));
    t9 = (t0 + 6724);
    t10 = (t0 + 772);
    t11 = xsi_create_subprogram_invocation(t9, 0, t0, t10, 0, 0);
    xsi_vlog_subprogram_pushinvocation(t10, t11);
    t12 = (t0 + 5084);
    xsi_vlogvar_assign_value(t12, t2, 0, 0, 8);
    t13 = (t0 + 5176);
    xsi_vlogvar_assign_value(t13, t3, 0, 0, 32);
    t14 = (t0 + 5268);
    xsi_vlogvar_assign_value(t14, t8, 0, 0, 32);

LAB11:    t15 = (t0 + 6772);
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

LAB12:    t16 = (t0 + 772);
    xsi_vlog_subprogram_popinvocation(t16);

LAB10:    t23 = (t0 + 6772);
    t24 = *((char **)t23);
    t23 = (t0 + 772);
    t25 = (t0 + 6772);
    t26 = *((char **)t25);
    t25 = (t0 + 6724);
    t27 = 0;
    xsi_delete_subprogram_invocation(t23, t26, t0, t25, t27);
    xsi_set_current_line(245, ng0);
    t2 = ((char*)((ng19)));
    t3 = (t2 + 4U);
    t4 = *((unsigned int *)t3);
    t5 = (~(t4));
    t6 = *((unsigned int *)t2);
    t7 = (t6 & t5);
    t8 = (t0 + 10432);
    *((int *)t8) = t7;

LAB14:    t9 = (t0 + 10432);
    if (*((int *)t9) > 0)
        goto LAB15;

LAB16:    xsi_set_current_line(247, ng0);
    xsi_vlogfile_write(1, 0, ng26, 1, t0);
    xsi_set_current_line(248, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 6724);
    t8 = (t0 + 1012);
    t9 = xsi_create_subprogram_invocation(t3, 0, t0, t8, 0, 0);
    xsi_vlog_subprogram_pushinvocation(t8, t9);
    t10 = (t0 + 5360);
    xsi_vlogvar_assign_value(t10, t2, 0, 0, 8);

LAB19:    t11 = (t0 + 6772);
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

LAB20:    t12 = (t0 + 1012);
    xsi_vlog_subprogram_popinvocation(t12);

LAB18:    t19 = (t0 + 6772);
    t20 = *((char **)t19);
    t19 = (t0 + 1012);
    t21 = (t0 + 6772);
    t22 = *((char **)t21);
    t21 = (t0 + 6724);
    t23 = 0;
    xsi_delete_subprogram_invocation(t19, t22, t0, t21, t23);
    xsi_set_current_line(249, ng0);
    t2 = (t0 + 10452);
    t3 = *((char **)t2);
    t8 = ((((char*)(t3))) + 20U);
    t9 = *((char **)t8);
    xsi_vlogfile_write(1, 0, ng27, 2, t0, (char)118, t9, 64);
    xsi_set_current_line(255, ng0);
    xsi_vlogfile_write(1, 0, ng28, 1, t0);
    xsi_set_current_line(256, ng0);
    t2 = ((char*)((ng29)));
    t3 = ((char*)((ng1)));
    t8 = (t0 + 6724);
    t9 = (t0 + 1252);
    t10 = xsi_create_subprogram_invocation(t8, 0, t0, t9, 0, 0);
    xsi_vlog_subprogram_pushinvocation(t9, t10);
    t11 = (t0 + 5452);
    xsi_vlogvar_assign_value(t11, t2, 0, 0, 32);
    t12 = (t0 + 5544);
    xsi_vlogvar_assign_value(t12, t3, 0, 0, 32);

LAB23:    t13 = (t0 + 6772);
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

LAB24:    t14 = (t0 + 1252);
    xsi_vlog_subprogram_popinvocation(t14);

LAB22:    t21 = (t0 + 6772);
    t22 = *((char **)t21);
    t21 = (t0 + 1252);
    t23 = (t0 + 6772);
    t24 = *((char **)t23);
    t23 = (t0 + 6724);
    t25 = 0;
    xsi_delete_subprogram_invocation(t21, t24, t0, t23, t25);
    xsi_set_current_line(257, ng0);
    t2 = ((char*)((ng29)));
    t3 = (t0 + 6724);
    t8 = (t0 + 1492);
    t9 = xsi_create_subprogram_invocation(t3, 0, t0, t8, 0, 0);
    xsi_vlog_subprogram_pushinvocation(t8, t9);
    t10 = (t0 + 5636);
    xsi_vlogvar_assign_value(t10, t2, 0, 0, 32);

LAB27:    t11 = (t0 + 6772);
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

LAB28:    t12 = (t0 + 1492);
    xsi_vlog_subprogram_popinvocation(t12);

LAB26:    t19 = (t0 + 6772);
    t20 = *((char **)t19);
    t19 = (t0 + 1492);
    t21 = (t0 + 6772);
    t22 = *((char **)t21);
    t21 = (t0 + 6724);
    t23 = 0;
    xsi_delete_subprogram_invocation(t19, t22, t0, t21, t23);
    xsi_set_current_line(259, ng0);
    t2 = ((char*)((ng30)));
    t3 = (t2 + 4U);
    t4 = *((unsigned int *)t3);
    t5 = (~(t4));
    t6 = *((unsigned int *)t2);
    t7 = (t6 & t5);
    t8 = (t0 + 10456);
    *((int *)t8) = t7;

LAB30:    t9 = (t0 + 10456);
    if (*((int *)t9) > 0)
        goto LAB31;

LAB32:    xsi_set_current_line(260, ng0);
    t2 = (t0 + 10476);
    t3 = *((char **)t2);
    t8 = ((((char*)(t3))) + 32U);
    t9 = *((char **)t8);
    xsi_vlogfile_write(1, 0, ng31, 2, t0, (char)118, t9, 32);
    xsi_set_current_line(262, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 6724);
    t8 = (t0 + 1012);
    t9 = xsi_create_subprogram_invocation(t3, 0, t0, t8, 0, 0);
    xsi_vlog_subprogram_pushinvocation(t8, t9);
    t10 = (t0 + 5360);
    xsi_vlogvar_assign_value(t10, t2, 0, 0, 8);

LAB35:    t11 = (t0 + 6772);
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

LAB36:    t12 = (t0 + 1012);
    xsi_vlog_subprogram_popinvocation(t12);

LAB34:    t19 = (t0 + 6772);
    t20 = *((char **)t19);
    t19 = (t0 + 1012);
    t21 = (t0 + 6772);
    t22 = *((char **)t21);
    t21 = (t0 + 6724);
    t23 = 0;
    xsi_delete_subprogram_invocation(t19, t22, t0, t21, t23);
    xsi_set_current_line(263, ng0);
    t2 = (t0 + 10496);
    t3 = *((char **)t2);
    t8 = ((((char*)(t3))) + 20U);
    t9 = *((char **)t8);
    xsi_vlogfile_write(1, 0, ng32, 2, t0, (char)118, t9, 64);
    xsi_set_current_line(268, ng0);
    xsi_vlogfile_write(1, 0, ng33, 1, t0);
    xsi_set_current_line(269, ng0);
    t2 = ((char*)((ng1)));
    t3 = ((char*)((ng34)));
    t8 = (t0 + 6724);
    t9 = (t0 + 1732);
    t10 = xsi_create_subprogram_invocation(t8, 0, t0, t9, 0, 0);
    xsi_vlog_subprogram_pushinvocation(t9, t10);
    t11 = (t0 + 5728);
    xsi_vlogvar_assign_value(t11, t2, 0, 0, 9);
    t12 = (t0 + 5820);
    xsi_vlogvar_assign_value(t12, t3, 0, 0, 32);

LAB39:    t13 = (t0 + 6772);
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

LAB40:    t14 = (t0 + 1732);
    xsi_vlog_subprogram_popinvocation(t14);

LAB38:    t21 = (t0 + 6772);
    t22 = *((char **)t21);
    t21 = (t0 + 1732);
    t23 = (t0 + 6772);
    t24 = *((char **)t23);
    t23 = (t0 + 6724);
    t25 = 0;
    xsi_delete_subprogram_invocation(t21, t24, t0, t23, t25);
    xsi_set_current_line(270, ng0);
    t2 = (t0 + 6724);
    t3 = (t0 + 1972);
    t8 = xsi_create_subprogram_invocation(t2, 0, t0, t3, 0, 0);
    xsi_vlog_subprogram_pushinvocation(t3, t8);

LAB43:    t9 = (t0 + 6772);
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

LAB44:    t10 = (t0 + 1972);
    xsi_vlog_subprogram_popinvocation(t10);

LAB42:    t17 = (t0 + 6772);
    t18 = *((char **)t17);
    t17 = (t0 + 1972);
    t19 = (t0 + 6772);
    t20 = *((char **)t19);
    t19 = (t0 + 6724);
    t21 = 0;
    xsi_delete_subprogram_invocation(t17, t20, t0, t19, t21);
    xsi_set_current_line(271, ng0);
    t2 = ((char*)((ng35)));
    t3 = (t2 + 4U);
    t4 = *((unsigned int *)t3);
    t5 = (~(t4));
    t6 = *((unsigned int *)t2);
    t7 = (t6 & t5);
    t8 = (t0 + 10500);
    *((int *)t8) = t7;

LAB46:    t9 = (t0 + 10500);
    if (*((int *)t9) > 0)
        goto LAB47;

LAB48:    xsi_set_current_line(273, ng0);
    xsi_vlogfile_write(1, 0, ng36, 1, t0);
    xsi_set_current_line(274, ng0);
    t2 = (t0 + 10524);
    t3 = *((char **)t2);
    t8 = ((((char*)(t3))) + 20U);
    t9 = *((char **)t8);
    xsi_vlogfile_write(1, 0, ng37, 2, t0, (char)118, t9, 1);
    xsi_set_current_line(276, ng0);
    xsi_vlog_finish(1);
    goto LAB1;

LAB13:    t15 = (t0 + 6808U);
    *((char **)t15) = &&LAB11;
    goto LAB1;

LAB15:    xsi_set_current_line(245, ng0);
    t10 = (t0 + 7188);
    *((int *)t10) = 1;
    *((char **)t1) = &&LAB17;
    goto LAB1;

LAB17:    t2 = (t0 + 10432);
    t7 = *((int *)t2);
    *((int *)t2) = (t7 - 1);
    goto LAB14;

LAB21:    t11 = (t0 + 6808U);
    *((char **)t11) = &&LAB19;
    goto LAB1;

LAB25:    t13 = (t0 + 6808U);
    *((char **)t13) = &&LAB23;
    goto LAB1;

LAB29:    t11 = (t0 + 6808U);
    *((char **)t11) = &&LAB27;
    goto LAB1;

LAB31:    xsi_set_current_line(259, ng0);
    t10 = (t0 + 7196);
    *((int *)t10) = 1;
    *((char **)t1) = &&LAB33;
    goto LAB1;

LAB33:    t2 = (t0 + 10456);
    t7 = *((int *)t2);
    *((int *)t2) = (t7 - 1);
    goto LAB30;

LAB37:    t11 = (t0 + 6808U);
    *((char **)t11) = &&LAB35;
    goto LAB1;

LAB41:    t13 = (t0 + 6808U);
    *((char **)t13) = &&LAB39;
    goto LAB1;

LAB45:    t9 = (t0 + 6808U);
    *((char **)t9) = &&LAB43;
    goto LAB1;

LAB47:    xsi_set_current_line(271, ng0);
    t10 = (t0 + 7204);
    *((int *)t10) = 1;
    *((char **)t1) = &&LAB49;
    goto LAB1;

LAB49:    t2 = (t0 + 10500);
    t7 = *((int *)t2);
    *((int *)t2) = (t7 - 1);
    goto LAB46;

}

static void I279_5(char *t0)
{
    char *t1;
    char *t2;

LAB0:    t1 = (t0 + 6936U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(279, ng0);

LAB4:    xsi_set_current_line(280, ng0);
    t2 = (t0 + 6852);
    xsi_process_wait(t2, 500000000000LL);
    *((char **)t1) = &&LAB5;

LAB1:    return;
LAB5:    xsi_set_current_line(281, ng0);
    xsi_vlogfile_write(1, 0, ng38, 1, t0);
    xsi_set_current_line(282, ng0);
    xsi_vlog_finish(1);
    goto LAB1;

}


extern void work_m_00000000003156809338_3326411051_init()
{
	static char *pe[] = {(void *)I126_0,(void *)A127_1,(void *)I130_2,(void *)A131_3,(void *)I219_4,(void *)I279_5};
	static char *se[] = {(void *)sp_sw_write,(void *)sp_host_dmem_write,(void *)sp_host_dmem_read_req,(void *)sp_gpu_host_imem_word,(void *)sp_gpu_host_start_pulse,(void *)sp_arm_imem_write,(void *)sp_cpu_start_pulse};
	xsi_register_didat("work_m_00000000003156809338_3326411051", "isim/_tmp/work/m_00000000003156809338_3326411051.didat");
	xsi_register_executes(pe);
	xsi_register_subprogram_executes(se);
}
