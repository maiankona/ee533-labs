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
static const char *ng0 = "C:/Xilinx/10.1/ISE/ISEexamples/lab9_net/tb_udp_packet_user_data_path.v";
static const char *ng1 = "[TB][reg_write] addr=%h data=%h t=%0t";
static unsigned int ng2[] = {0U, 0U};
static unsigned int ng3[] = {1U, 0U};
static const char *ng4 = "[TB][pulse_input_type] set mask=%h t=%0t";
static unsigned int ng5[] = {132U, 0U};
static const char *ng6 = "[TB][pulse_input_type] clear mask t=%0t";
static unsigned int ng7[] = {131U, 0U};
static unsigned int ng8[] = {130U, 0U};
static unsigned int ng9[] = {64U, 0U};
static const char *ng10 = "[TB] CPU start pulse requested t=%0t";
static unsigned int ng11[] = {32U, 0U};
static const char *ng12 = "[TB] GPU start pulse requested t=%0t";
static unsigned int ng13[] = {8U, 0U};
static unsigned int ng14[] = {0U, 0U, 0U, 0U};
static const char *ng15 = "[TB][tick] input_type=%h gpu_pulse=%0d cpu_pulse=%0d t=%0t";
static const char *ng16 = "[TB] RX word into ids: ctrl=%02h data=%016h t=%0t";
static int ng17[] = {71, 0};
static int ng18[] = {64, 0};
static int ng19[] = {3, 0};
static int ng20[] = {5, 0};
static const char *ng21 = "[TB] input_type=%h sw_bits(gpu=%0d cpu=%0d) sw_pulses(gpu=%0d cpu=%0d) t=%0t";
static const char *ng22 = "[TB] TX word from user_data_path: out_wr=%b%b%b%b%b%b%b%b ctrl0=%02h data0=%016h t=%0t";
static int ng23[] = {0, 0, 0, 0};
static int ng24[] = {0, 0};
static int ng25[] = {1, 0};
static unsigned int ng26[] = {0U, 0U, 0U, 0U, 0U, 0U};
static const char *ng27 = "\n=== tb_udp_packet_user_data_path: reset released @ %0t ===";
static const char *ng28 = "[TB] Loading minimal GPU program (HALT) and pulsing GPU start...";
static unsigned int ng29[] = {738197504U, 0U};
static unsigned int ng30[] = {256U, 0U};
static const char *ng31 = "[TB] Loading ARM IMEM via UDP (input_type[6] arm_write_to_imem)...";
static unsigned int ng32[] = {3818926080U, 0U};
static unsigned int ng33[] = {3800248384U, 0U};
static unsigned int ng34[] = {2U, 0U};
static unsigned int ng35[] = {3U, 0U};
static unsigned int ng36[] = {4U, 0U};
static unsigned int ng37[] = {5U, 0U};
static unsigned int ng38[] = {3818917889U, 0U};
static unsigned int ng39[] = {6U, 0U};
static unsigned int ng40[] = {3785359360U, 0U};
static unsigned int ng41[] = {7U, 0U};
static unsigned int ng42[] = {9U, 0U};
static unsigned int ng43[] = {10U, 0U};
static unsigned int ng44[] = {3851616260U, 0U};
static unsigned int ng45[] = {11U, 0U};
static unsigned int ng46[] = {12U, 0U};
static unsigned int ng47[] = {3850571784U, 0U};
static unsigned int ng48[] = {13U, 0U};
static unsigned int ng49[] = {3942645758U, 0U};
static const char *ng50 = "[TB] Injecting single packet on in_0...";
static unsigned int ng51[] = {255U, 0U};
static unsigned int ng52[] = {1432778632U, 0U, 287454020U, 0U};
static unsigned int ng53[] = {3405691582U, 0U, 3735928559U, 0U};
static unsigned int ng54[] = {1515870810U, 0U, 2779096485U, 0U};
static int ng55[] = {40, 0};
static const char *ng56 = "[TB] Pulsing ARM cpu_start (UDP input_type[5])...";
static int ng57[] = {120, 0};
static const char *ng58 = "=== tb_udp_packet_user_data_path done @ %0t ===\n";
static const char *ng59 = "[TB] TIMEOUT @ %0t";



static int sp_reg_write(char *t1, char *t2)
{
    char t11[16];
    int t0;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;
    char *t8;
    char *t9;
    char *t10;
    char *t12;

LAB0:    t0 = 1;
    t3 = (t2 + 24U);
    t4 = *((char **)t3);
    if (t4 == 0)
        goto LAB2;

LAB3:    goto *t4;

LAB2:    t4 = (t1 + 1672);
    xsi_vlog_subprogram_setdisablestate(t4, &&LAB4);
    xsi_set_current_line(283, ng0);

LAB5:    xsi_set_current_line(284, ng0);
    t5 = (t1 + 10892);
    t6 = (t5 + 32U);
    t7 = *((char **)t6);
    t8 = (t1 + 10984);
    t9 = (t8 + 32U);
    t10 = *((char **)t9);
    t12 = xsi_vlog_time(t11, 1000000.000000000, 1000.000000000000);
    xsi_vlogfile_write(1, 0, ng1, 4, t1, (char)118, t7, 23, (char)118, t10, 32, (char)118, t11, 64);
    xsi_set_current_line(285, ng0);
    t4 = (t2 + 44U);
    t5 = *((char **)t4);
    t6 = (t5 + 0U);
    xsi_wp_set_status(t6, 1);
    *((char **)t3) = &&LAB6;

LAB1:    return t0;
LAB4:    xsi_vlog_dispose_subprogram_invocation(t2);
    t4 = (t2 + 24U);
    *((char **)t4) = &&LAB2;
    t0 = 0;
    goto LAB1;

LAB6:    xsi_set_current_line(286, ng0);
    t4 = (t1 + 10892);
    t5 = (t4 + 32U);
    t6 = *((char **)t5);
    t7 = (t1 + 10708);
    xsi_vlogvar_assign_value(t7, t6, 0, 0, 23);
    xsi_set_current_line(287, ng0);
    t4 = (t1 + 10984);
    t5 = (t4 + 32U);
    t6 = *((char **)t5);
    t7 = (t1 + 10800);
    xsi_vlogvar_assign_value(t7, t6, 0, 0, 32);
    xsi_set_current_line(288, ng0);
    t4 = ((char*)((ng2)));
    t5 = (t1 + 10616);
    xsi_vlogvar_assign_value(t5, t4, 0, 0, 1);
    xsi_set_current_line(289, ng0);
    t4 = ((char*)((ng3)));
    t5 = (t1 + 10524);
    xsi_vlogvar_assign_value(t5, t4, 0, 0, 1);
    xsi_set_current_line(290, ng0);
    t4 = (t2 + 44U);
    t5 = *((char **)t4);
    t6 = (t5 + 8U);
    xsi_wp_set_status(t6, 1);
    *((char **)t3) = &&LAB7;
    goto LAB1;

LAB7:    xsi_set_current_line(291, ng0);
    t4 = (t2 + 44U);
    t5 = *((char **)t4);
    t6 = (t5 + 16U);
    xsi_wp_set_status(t6, 1);
    *((char **)t3) = &&LAB8;
    goto LAB1;

LAB8:    xsi_set_current_line(292, ng0);
    t4 = ((char*)((ng2)));
    t5 = (t1 + 10524);
    xsi_vlogvar_assign_value(t5, t4, 0, 0, 1);
    xsi_set_current_line(293, ng0);
    t4 = ((char*)((ng3)));
    t5 = (t1 + 10616);
    xsi_vlogvar_assign_value(t5, t4, 0, 0, 1);
    goto LAB4;

}

static int sp_pulse_input_type(char *t1, char *t2)
{
    char t8[16];
    int t0;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;
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

LAB2:    t4 = (t1 + 1912);
    xsi_vlog_subprogram_setdisablestate(t4, &&LAB4);
    xsi_set_current_line(299, ng0);

LAB5:    xsi_set_current_line(300, ng0);
    t5 = (t1 + 11076);
    t6 = (t5 + 32U);
    t7 = *((char **)t6);
    t9 = xsi_vlog_time(t8, 1000000.000000000, 1000.000000000000);
    xsi_vlogfile_write(1, 0, ng4, 3, t1, (char)118, t7, 32, (char)118, t8, 64);
    xsi_set_current_line(301, ng0);
    t4 = ((char*)((ng5)));
    t5 = (t1 + 11076);
    t6 = (t5 + 32U);
    t7 = *((char **)t6);
    t9 = (t2 + 28U);
    t10 = *((char **)t9);
    t11 = (t1 + 1672);
    t12 = xsi_create_subprogram_invocation(t10, 0, t1, t11, 0, t2);
    xsi_vlog_subprogram_pushinvocation(t11, t12);
    t13 = (t1 + 10892);
    xsi_vlogvar_assign_value(t13, t4, 0, 0, 23);
    t14 = (t1 + 10984);
    xsi_vlogvar_assign_value(t14, t7, 0, 0, 32);

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

LAB8:    t16 = (t1 + 1672);
    xsi_vlog_subprogram_popinvocation(t16);

LAB6:    t24 = (t2 + 32U);
    t25 = *((char **)t24);
    t24 = (t1 + 1672);
    t26 = (t2 + 32U);
    t27 = *((char **)t26);
    t26 = (t2 + 28U);
    t28 = *((char **)t26);
    xsi_delete_subprogram_invocation(t24, t27, t1, t28, t2);
    xsi_set_current_line(302, ng0);
    t4 = ((char*)((ng5)));
    t5 = ((char*)((ng2)));
    t6 = (t2 + 28U);
    t7 = *((char **)t6);
    t9 = (t1 + 1672);
    t10 = xsi_create_subprogram_invocation(t7, 0, t1, t9, 0, t2);
    xsi_vlog_subprogram_pushinvocation(t9, t10);
    t11 = (t1 + 10892);
    xsi_vlogvar_assign_value(t11, t4, 0, 0, 23);
    t12 = (t1 + 10984);
    xsi_vlogvar_assign_value(t12, t5, 0, 0, 32);

LAB11:    t13 = (t2 + 32U);
    t14 = *((char **)t13);
    t15 = (t14 + 40U);
    t16 = *((char **)t15);
    t17 = (t16 + 132U);
    t18 = *((char **)t17);
    t19 = (t18 + 0U);
    t20 = *((char **)t19);
    t23 = ((int  (*)(char *, char *))t20)(t1, t14);
    if (t23 != 0)
        goto LAB13;

LAB12:    t14 = (t1 + 1672);
    xsi_vlog_subprogram_popinvocation(t14);

LAB10:    t21 = (t2 + 32U);
    t22 = *((char **)t21);
    t21 = (t1 + 1672);
    t24 = (t2 + 32U);
    t25 = *((char **)t24);
    t24 = (t2 + 28U);
    t26 = *((char **)t24);
    xsi_delete_subprogram_invocation(t21, t25, t1, t26, t2);
    xsi_set_current_line(303, ng0);
    t4 = xsi_vlog_time(t8, 1000000.000000000, 1000.000000000000);
    xsi_vlogfile_write(1, 0, ng6, 2, t1, (char)118, t8, 64);

LAB4:    xsi_vlog_dispose_subprogram_invocation(t2);
    t4 = (t2 + 24U);
    *((char **)t4) = &&LAB2;
    t0 = 0;

LAB1:    return t0;
LAB9:    t15 = (t2 + 24U);
    *((char **)t15) = &&LAB7;
    goto LAB1;

LAB13:    t13 = (t2 + 24U);
    *((char **)t13) = &&LAB11;
    goto LAB1;

}

static int sp_write_gpu_imem(char *t1, char *t2)
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

LAB2:    t4 = (t1 + 2152);
    xsi_vlog_subprogram_setdisablestate(t4, &&LAB4);
    xsi_set_current_line(310, ng0);

LAB5:    xsi_set_current_line(311, ng0);
    t5 = ((char*)((ng7)));
    t7 = (t1 + 11168);
    t8 = (t7 + 32U);
    t9 = *((char **)t8);
    t10 = ((char*)((ng2)));
    xsi_vlogtype_concat(t6, 32, 32, 2U, t10, 23, t9, 9);
    t11 = (t2 + 28U);
    t12 = *((char **)t11);
    t13 = (t1 + 1672);
    t14 = xsi_create_subprogram_invocation(t12, 0, t1, t13, 0, t2);
    xsi_vlog_subprogram_pushinvocation(t13, t14);
    t15 = (t1 + 10892);
    xsi_vlogvar_assign_value(t15, t5, 0, 0, 23);
    t16 = (t1 + 10984);
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

LAB8:    t18 = (t1 + 1672);
    xsi_vlog_subprogram_popinvocation(t18);

LAB6:    t26 = (t2 + 32U);
    t27 = *((char **)t26);
    t26 = (t1 + 1672);
    t28 = (t2 + 32U);
    t29 = *((char **)t28);
    t28 = (t2 + 28U);
    t30 = *((char **)t28);
    xsi_delete_subprogram_invocation(t26, t29, t1, t30, t2);
    xsi_set_current_line(312, ng0);
    t4 = ((char*)((ng8)));
    t5 = (t1 + 11260);
    t7 = (t5 + 32U);
    t8 = *((char **)t7);
    t9 = (t2 + 28U);
    t10 = *((char **)t9);
    t11 = (t1 + 1672);
    t12 = xsi_create_subprogram_invocation(t10, 0, t1, t11, 0, t2);
    xsi_vlog_subprogram_pushinvocation(t11, t12);
    t13 = (t1 + 10892);
    xsi_vlogvar_assign_value(t13, t4, 0, 0, 23);
    t14 = (t1 + 10984);
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

LAB12:    t16 = (t1 + 1672);
    xsi_vlog_subprogram_popinvocation(t16);

LAB10:    t23 = (t2 + 32U);
    t24 = *((char **)t23);
    t23 = (t1 + 1672);
    t26 = (t2 + 32U);
    t27 = *((char **)t26);
    t26 = (t2 + 28U);
    t28 = *((char **)t26);
    xsi_delete_subprogram_invocation(t23, t27, t1, t28, t2);
    xsi_set_current_line(313, ng0);
    t4 = ((char*)((ng3)));
    t5 = (t2 + 28U);
    t7 = *((char **)t5);
    t8 = (t1 + 1912);
    t9 = xsi_create_subprogram_invocation(t7, 0, t1, t8, 0, t2);
    xsi_vlog_subprogram_pushinvocation(t8, t9);
    t10 = (t1 + 11076);
    xsi_vlogvar_assign_value(t10, t4, 0, 0, 32);

LAB15:    t11 = (t2 + 32U);
    t12 = *((char **)t11);
    t13 = (t12 + 40U);
    t14 = *((char **)t13);
    t15 = (t14 + 132U);
    t16 = *((char **)t15);
    t17 = (t16 + 0U);
    t18 = *((char **)t17);
    t25 = ((int  (*)(char *, char *))t18)(t1, t12);
    if (t25 != 0)
        goto LAB17;

LAB16:    t12 = (t1 + 1912);
    xsi_vlog_subprogram_popinvocation(t12);

LAB14:    t19 = (t2 + 32U);
    t20 = *((char **)t19);
    t19 = (t1 + 1912);
    t21 = (t2 + 32U);
    t22 = *((char **)t21);
    t21 = (t2 + 28U);
    t23 = *((char **)t21);
    xsi_delete_subprogram_invocation(t19, t22, t1, t23, t2);

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

LAB17:    t11 = (t2 + 24U);
    *((char **)t11) = &&LAB15;
    goto LAB1;

}

static int sp_arm_imem_write_udp(char *t1, char *t2)
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

LAB2:    t4 = (t1 + 2392);
    xsi_vlog_subprogram_setdisablestate(t4, &&LAB4);
    xsi_set_current_line(320, ng0);

LAB5:    xsi_set_current_line(321, ng0);
    t5 = ((char*)((ng7)));
    t7 = (t1 + 11352);
    t8 = (t7 + 32U);
    t9 = *((char **)t8);
    t10 = ((char*)((ng2)));
    xsi_vlogtype_concat(t6, 32, 32, 2U, t10, 23, t9, 9);
    t11 = (t2 + 28U);
    t12 = *((char **)t11);
    t13 = (t1 + 1672);
    t14 = xsi_create_subprogram_invocation(t12, 0, t1, t13, 0, t2);
    xsi_vlog_subprogram_pushinvocation(t13, t14);
    t15 = (t1 + 10892);
    xsi_vlogvar_assign_value(t15, t5, 0, 0, 23);
    t16 = (t1 + 10984);
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

LAB8:    t18 = (t1 + 1672);
    xsi_vlog_subprogram_popinvocation(t18);

LAB6:    t26 = (t2 + 32U);
    t27 = *((char **)t26);
    t26 = (t1 + 1672);
    t28 = (t2 + 32U);
    t29 = *((char **)t28);
    t28 = (t2 + 28U);
    t30 = *((char **)t28);
    xsi_delete_subprogram_invocation(t26, t29, t1, t30, t2);
    xsi_set_current_line(322, ng0);
    t4 = ((char*)((ng8)));
    t5 = (t1 + 11444);
    t7 = (t5 + 32U);
    t8 = *((char **)t7);
    t9 = (t2 + 28U);
    t10 = *((char **)t9);
    t11 = (t1 + 1672);
    t12 = xsi_create_subprogram_invocation(t10, 0, t1, t11, 0, t2);
    xsi_vlog_subprogram_pushinvocation(t11, t12);
    t13 = (t1 + 10892);
    xsi_vlogvar_assign_value(t13, t4, 0, 0, 23);
    t14 = (t1 + 10984);
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

LAB12:    t16 = (t1 + 1672);
    xsi_vlog_subprogram_popinvocation(t16);

LAB10:    t23 = (t2 + 32U);
    t24 = *((char **)t23);
    t23 = (t1 + 1672);
    t26 = (t2 + 32U);
    t27 = *((char **)t26);
    t26 = (t2 + 28U);
    t28 = *((char **)t26);
    xsi_delete_subprogram_invocation(t23, t27, t1, t28, t2);
    xsi_set_current_line(323, ng0);
    t4 = ((char*)((ng9)));
    t5 = (t2 + 28U);
    t7 = *((char **)t5);
    t8 = (t1 + 1912);
    t9 = xsi_create_subprogram_invocation(t7, 0, t1, t8, 0, t2);
    xsi_vlog_subprogram_pushinvocation(t8, t9);
    t10 = (t1 + 11076);
    xsi_vlogvar_assign_value(t10, t4, 0, 0, 32);

LAB15:    t11 = (t2 + 32U);
    t12 = *((char **)t11);
    t13 = (t12 + 40U);
    t14 = *((char **)t13);
    t15 = (t14 + 132U);
    t16 = *((char **)t15);
    t17 = (t16 + 0U);
    t18 = *((char **)t17);
    t25 = ((int  (*)(char *, char *))t18)(t1, t12);
    if (t25 != 0)
        goto LAB17;

LAB16:    t12 = (t1 + 1912);
    xsi_vlog_subprogram_popinvocation(t12);

LAB14:    t19 = (t2 + 32U);
    t20 = *((char **)t19);
    t19 = (t1 + 1912);
    t21 = (t2 + 32U);
    t22 = *((char **)t21);
    t21 = (t2 + 28U);
    t23 = *((char **)t21);
    xsi_delete_subprogram_invocation(t19, t22, t1, t23, t2);

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

LAB17:    t11 = (t2 + 24U);
    *((char **)t11) = &&LAB15;
    goto LAB1;

}

static int sp_pulse_cpu_start_udp(char *t1, char *t2)
{
    char t5[16];
    int t0;
    char *t3;
    char *t4;
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
    int t19;
    char *t20;
    char *t21;
    char *t22;
    char *t23;
    char *t24;

LAB0:    t0 = 1;
    t3 = (t2 + 24U);
    t4 = *((char **)t3);
    if (t4 == 0)
        goto LAB2;

LAB3:    goto *t4;

LAB2:    t4 = (t1 + 2632);
    xsi_vlog_subprogram_setdisablestate(t4, &&LAB4);
    xsi_set_current_line(328, ng0);

LAB5:    xsi_set_current_line(329, ng0);
    t6 = xsi_vlog_time(t5, 1000000.000000000, 1000.000000000000);
    xsi_vlogfile_write(1, 0, ng10, 2, t1, (char)118, t5, 64);
    xsi_set_current_line(330, ng0);
    t4 = ((char*)((ng11)));
    t6 = (t2 + 28U);
    t7 = *((char **)t6);
    t8 = (t1 + 1912);
    t9 = xsi_create_subprogram_invocation(t7, 0, t1, t8, 0, t2);
    xsi_vlog_subprogram_pushinvocation(t8, t9);
    t10 = (t1 + 11076);
    xsi_vlogvar_assign_value(t10, t4, 0, 0, 32);

LAB7:    t11 = (t2 + 32U);
    t12 = *((char **)t11);
    t13 = (t12 + 40U);
    t14 = *((char **)t13);
    t15 = (t14 + 132U);
    t16 = *((char **)t15);
    t17 = (t16 + 0U);
    t18 = *((char **)t17);
    t19 = ((int  (*)(char *, char *))t18)(t1, t12);
    if (t19 != 0)
        goto LAB9;

LAB8:    t12 = (t1 + 1912);
    xsi_vlog_subprogram_popinvocation(t12);

LAB6:    t20 = (t2 + 32U);
    t21 = *((char **)t20);
    t20 = (t1 + 1912);
    t22 = (t2 + 32U);
    t23 = *((char **)t22);
    t22 = (t2 + 28U);
    t24 = *((char **)t22);
    xsi_delete_subprogram_invocation(t20, t23, t1, t24, t2);

LAB4:    xsi_vlog_dispose_subprogram_invocation(t2);
    t4 = (t2 + 24U);
    *((char **)t4) = &&LAB2;
    t0 = 0;

LAB1:    return t0;
LAB9:    t11 = (t2 + 24U);
    *((char **)t11) = &&LAB7;
    goto LAB1;

}

static int sp_pulse_gpu_start_udp(char *t1, char *t2)
{
    char t5[16];
    int t0;
    char *t3;
    char *t4;
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
    int t19;
    char *t20;
    char *t21;
    char *t22;
    char *t23;
    char *t24;

LAB0:    t0 = 1;
    t3 = (t2 + 24U);
    t4 = *((char **)t3);
    if (t4 == 0)
        goto LAB2;

LAB3:    goto *t4;

LAB2:    t4 = (t1 + 2872);
    xsi_vlog_subprogram_setdisablestate(t4, &&LAB4);
    xsi_set_current_line(335, ng0);

LAB5:    xsi_set_current_line(336, ng0);
    t6 = xsi_vlog_time(t5, 1000000.000000000, 1000.000000000000);
    xsi_vlogfile_write(1, 0, ng12, 2, t1, (char)118, t5, 64);
    xsi_set_current_line(337, ng0);
    t4 = ((char*)((ng13)));
    t6 = (t2 + 28U);
    t7 = *((char **)t6);
    t8 = (t1 + 1912);
    t9 = xsi_create_subprogram_invocation(t7, 0, t1, t8, 0, t2);
    xsi_vlog_subprogram_pushinvocation(t8, t9);
    t10 = (t1 + 11076);
    xsi_vlogvar_assign_value(t10, t4, 0, 0, 32);

LAB7:    t11 = (t2 + 32U);
    t12 = *((char **)t11);
    t13 = (t12 + 40U);
    t14 = *((char **)t13);
    t15 = (t14 + 132U);
    t16 = *((char **)t15);
    t17 = (t16 + 0U);
    t18 = *((char **)t17);
    t19 = ((int  (*)(char *, char *))t18)(t1, t12);
    if (t19 != 0)
        goto LAB9;

LAB8:    t12 = (t1 + 1912);
    xsi_vlog_subprogram_popinvocation(t12);

LAB6:    t20 = (t2 + 32U);
    t21 = *((char **)t20);
    t20 = (t1 + 1912);
    t22 = (t2 + 32U);
    t23 = *((char **)t22);
    t22 = (t2 + 28U);
    t24 = *((char **)t22);
    xsi_delete_subprogram_invocation(t20, t23, t1, t24, t2);

LAB4:    xsi_vlog_dispose_subprogram_invocation(t2);
    t4 = (t2 + 24U);
    *((char **)t4) = &&LAB2;
    t0 = 0;

LAB1:    return t0;
LAB9:    t11 = (t2 + 24U);
    *((char **)t11) = &&LAB7;
    goto LAB1;

}

static int sp_send_word_in0(char *t1, char *t2)
{
    char t8[8];
    int t0;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;
    unsigned int t9;
    unsigned int t10;
    unsigned int t11;
    unsigned int t12;
    unsigned int t13;
    unsigned int t14;
    unsigned int t15;
    unsigned int t16;
    unsigned int t17;
    unsigned int t18;
    char *t19;
    char *t20;
    char *t21;

LAB0:    t0 = 1;
    t3 = (t2 + 24U);
    t4 = *((char **)t3);
    if (t4 == 0)
        goto LAB2;

LAB3:    goto *t4;

LAB2:    t4 = (t1 + 3112);
    xsi_vlog_subprogram_setdisablestate(t4, &&LAB4);
    xsi_set_current_line(344, ng0);

LAB5:    xsi_set_current_line(345, ng0);
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

LAB6:    xsi_set_current_line(346, ng0);

LAB7:    t4 = (t1 + 3460U);
    t5 = *((char **)t4);
    memset(t8, 0, 8);
    t4 = (t8 + 4U);
    t6 = (t5 + 4U);
    t9 = *((unsigned int *)t6);
    t10 = (~(t9));
    t11 = *((unsigned int *)t5);
    t12 = (t11 & t10);
    t13 = (t12 & 1U);
    if (t13 != 0)
        goto LAB11;

LAB9:    if (*((unsigned int *)t6) == 0)
        goto LAB8;

LAB10:    *((unsigned int *)t8) = 1;
    *((unsigned int *)t4) = 1;

LAB11:    t7 = (t8 + 4U);
    t14 = *((unsigned int *)t7);
    t15 = (~(t14));
    t16 = *((unsigned int *)t8);
    t17 = (t16 & t15);
    t18 = (t17 != 0);
    if (t18 > 0)
        goto LAB12;

LAB13:    xsi_set_current_line(347, ng0);
    t4 = (t1 + 11536);
    t5 = (t4 + 32U);
    t6 = *((char **)t5);
    t7 = (t1 + 7948);
    xsi_vlogvar_assign_value(t7, t6, 0, 0, 8);
    xsi_set_current_line(348, ng0);
    t4 = (t1 + 11628);
    t5 = (t4 + 32U);
    t6 = *((char **)t5);
    t7 = (t1 + 7212);
    xsi_vlogvar_assign_value(t7, t6, 0, 0, 64);
    xsi_set_current_line(349, ng0);
    t4 = ((char*)((ng3)));
    t5 = (t1 + 8684);
    xsi_vlogvar_assign_value(t5, t4, 0, 0, 1);
    xsi_set_current_line(350, ng0);
    t4 = (t2 + 44U);
    t5 = *((char **)t4);
    t6 = (t5 + 16U);
    xsi_wp_set_status(t6, 1);
    *((char **)t3) = &&LAB15;
    goto LAB1;

LAB8:    *((unsigned int *)t8) = 1;
    goto LAB11;

LAB12:    xsi_set_current_line(346, ng0);
    t19 = (t2 + 44U);
    t20 = *((char **)t19);
    t21 = (t20 + 8U);
    xsi_wp_set_status(t21, 1);
    *((char **)t3) = &&LAB14;
    goto LAB1;

LAB14:    goto LAB7;

LAB15:    xsi_set_current_line(351, ng0);
    t4 = ((char*)((ng2)));
    t5 = (t1 + 8684);
    xsi_vlogvar_assign_value(t5, t4, 0, 0, 1);
    xsi_set_current_line(352, ng0);
    t4 = ((char*)((ng2)));
    t5 = (t1 + 7948);
    xsi_vlogvar_assign_value(t5, t4, 0, 0, 8);
    xsi_set_current_line(353, ng0);
    t4 = ((char*)((ng14)));
    t5 = (t1 + 7212);
    xsi_vlogvar_assign_value(t5, t4, 0, 0, 64);
    goto LAB4;

}

static void I277_0(char *t0)
{
    char *t1;
    char *t2;

LAB0:    xsi_set_current_line(277, ng0);
    t1 = ((char*)((ng2)));
    t2 = (t0 + 7028);
    xsi_vlogvar_assign_value(t2, t1, 0, 0, 1);

LAB1:    return;
}

static void A278_1(char *t0)
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

LAB0:    t1 = (t0 + 12232U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(278, ng0);
    t2 = (t0 + 12148);
    xsi_process_wait(t2, 4000000LL);
    *((char **)t1) = &&LAB4;

LAB1:    return;
LAB4:    xsi_set_current_line(278, ng0);
    t4 = (t0 + 7028);
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
    t17 = (t0 + 7028);
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

static void A357_2(char *t0)
{
    char t3[8];
    char t30[16];
    char t31[8];
    char t35[8];
    char t41[8];
    char t75[8];
    char t89[16];
    char t90[8];
    char t91[8];
    char t94[8];
    char t111[8];
    char t118[8];
    char t146[8];
    char t163[8];
    char t170[8];
    char t198[8];
    char t206[8];
    char t251[8];
    char t260[8];
    char t308[8];
    char t318[8];
    char t324[8];
    char t347[8];
    char t357[8];
    char t363[8];
    char t386[8];
    char t392[8];
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
    char *t14;
    unsigned int t15;
    unsigned int t16;
    unsigned int t17;
    unsigned int t18;
    unsigned int t19;
    char *t20;
    char *t21;
    char *t22;
    char *t23;
    char *t24;
    char *t25;
    char *t26;
    char *t27;
    char *t28;
    char *t29;
    unsigned int t32;
    unsigned int t33;
    unsigned int t34;
    unsigned int t36;
    unsigned int t37;
    unsigned int t38;
    unsigned int t39;
    unsigned int t40;
    unsigned int t42;
    unsigned int t43;
    unsigned int t44;
    unsigned int t45;
    unsigned int t46;
    unsigned int t47;
    unsigned int t48;
    unsigned int t49;
    unsigned int t50;
    unsigned int t51;
    char *t52;
    unsigned int t53;
    unsigned int t54;
    unsigned int t55;
    unsigned int t56;
    unsigned int t57;
    unsigned int t58;
    unsigned int t59;
    unsigned int t60;
    int t61;
    int t62;
    unsigned int t63;
    unsigned int t64;
    unsigned int t65;
    unsigned int t66;
    unsigned int t67;
    unsigned int t68;
    char *t69;
    unsigned int t70;
    unsigned int t71;
    unsigned int t72;
    unsigned int t73;
    unsigned int t74;
    char *t76;
    char *t77;
    char *t78;
    char *t79;
    char *t80;
    char *t81;
    char *t82;
    char *t83;
    char *t84;
    char *t85;
    char *t86;
    char *t87;
    char *t88;
    char *t92;
    char *t93;
    char *t95;
    char *t96;
    unsigned int t97;
    unsigned int t98;
    unsigned int t99;
    unsigned int t100;
    unsigned int t101;
    char *t102;
    unsigned int t103;
    unsigned int t104;
    unsigned int t105;
    unsigned int t106;
    char *t107;
    char *t108;
    char *t109;
    char *t110;
    char *t112;
    unsigned int t113;
    unsigned int t114;
    unsigned int t115;
    unsigned int t116;
    unsigned int t117;
    unsigned int t119;
    unsigned int t120;
    unsigned int t121;
    char *t122;
    char *t123;
    char *t124;
    unsigned int t125;
    unsigned int t126;
    unsigned int t127;
    unsigned int t128;
    unsigned int t129;
    unsigned int t130;
    unsigned int t131;
    char *t132;
    char *t133;
    unsigned int t134;
    unsigned int t135;
    unsigned int t136;
    int t137;
    unsigned int t138;
    unsigned int t139;
    unsigned int t140;
    int t141;
    unsigned int t142;
    unsigned int t143;
    unsigned int t144;
    unsigned int t145;
    char *t147;
    char *t148;
    unsigned int t149;
    unsigned int t150;
    unsigned int t151;
    unsigned int t152;
    unsigned int t153;
    char *t154;
    unsigned int t155;
    unsigned int t156;
    unsigned int t157;
    unsigned int t158;
    char *t159;
    char *t160;
    char *t161;
    char *t162;
    char *t164;
    unsigned int t165;
    unsigned int t166;
    unsigned int t167;
    unsigned int t168;
    unsigned int t169;
    unsigned int t171;
    unsigned int t172;
    unsigned int t173;
    char *t174;
    char *t175;
    char *t176;
    unsigned int t177;
    unsigned int t178;
    unsigned int t179;
    unsigned int t180;
    unsigned int t181;
    unsigned int t182;
    unsigned int t183;
    char *t184;
    char *t185;
    unsigned int t186;
    unsigned int t187;
    unsigned int t188;
    int t189;
    unsigned int t190;
    unsigned int t191;
    unsigned int t192;
    int t193;
    unsigned int t194;
    unsigned int t195;
    unsigned int t196;
    unsigned int t197;
    char *t199;
    char *t200;
    unsigned int t201;
    unsigned int t202;
    unsigned int t203;
    unsigned int t204;
    unsigned int t205;
    unsigned int t207;
    unsigned int t208;
    unsigned int t209;
    char *t210;
    char *t211;
    char *t212;
    unsigned int t213;
    unsigned int t214;
    unsigned int t215;
    unsigned int t216;
    unsigned int t217;
    unsigned int t218;
    unsigned int t219;
    char *t220;
    char *t221;
    unsigned int t222;
    unsigned int t223;
    unsigned int t224;
    unsigned int t225;
    unsigned int t226;
    unsigned int t227;
    unsigned int t228;
    unsigned int t229;
    int t230;
    int t231;
    unsigned int t232;
    unsigned int t233;
    unsigned int t234;
    unsigned int t235;
    unsigned int t236;
    unsigned int t237;
    char *t238;
    unsigned int t239;
    unsigned int t240;
    unsigned int t241;
    unsigned int t242;
    unsigned int t243;
    char *t244;
    char *t245;
    char *t246;
    char *t247;
    char *t248;
    char *t249;
    char *t250;
    char *t252;
    char *t253;
    char *t254;
    char *t255;
    char *t256;
    char *t257;
    char *t258;
    char *t259;
    char *t261;
    char *t262;
    char *t263;
    char *t264;
    char *t265;
    char *t266;
    char *t267;
    char *t268;
    char *t269;
    char *t270;
    char *t271;
    unsigned int t272;
    unsigned int t273;
    unsigned int t274;
    unsigned int t275;
    unsigned int t276;
    unsigned int t277;
    unsigned int t278;
    unsigned int t279;
    unsigned int t280;
    unsigned int t281;
    unsigned int t282;
    unsigned int t283;
    unsigned int t284;
    unsigned int t285;
    unsigned int t286;
    unsigned int t287;
    unsigned int t288;
    unsigned int t289;
    unsigned int t290;
    unsigned int t291;
    unsigned int t292;
    unsigned int t293;
    unsigned int t294;
    unsigned int t295;
    unsigned int t296;
    unsigned int t297;
    unsigned int t298;
    int t299;
    unsigned int t300;
    unsigned int t301;
    unsigned int t302;
    int t303;
    unsigned int t304;
    unsigned int t305;
    unsigned int t306;
    unsigned int t307;
    unsigned int t309;
    unsigned int t310;
    unsigned int t311;
    unsigned int t312;
    unsigned int t313;
    unsigned int t314;
    unsigned int t315;
    unsigned int t316;
    unsigned int t317;
    unsigned int t319;
    unsigned int t320;
    unsigned int t321;
    unsigned int t322;
    unsigned int t323;
    unsigned int t325;
    unsigned int t326;
    unsigned int t327;
    unsigned int t328;
    unsigned int t329;
    unsigned int t330;
    unsigned int t331;
    unsigned int t332;
    unsigned int t333;
    unsigned int t334;
    unsigned int t335;
    unsigned int t336;
    unsigned int t337;
    int t338;
    unsigned int t339;
    unsigned int t340;
    unsigned int t341;
    int t342;
    unsigned int t343;
    unsigned int t344;
    unsigned int t345;
    unsigned int t346;
    unsigned int t348;
    unsigned int t349;
    unsigned int t350;
    unsigned int t351;
    unsigned int t352;
    unsigned int t353;
    unsigned int t354;
    unsigned int t355;
    unsigned int t356;
    unsigned int t358;
    unsigned int t359;
    unsigned int t360;
    unsigned int t361;
    unsigned int t362;
    unsigned int t364;
    unsigned int t365;
    unsigned int t366;
    unsigned int t367;
    unsigned int t368;
    unsigned int t369;
    unsigned int t370;
    unsigned int t371;
    unsigned int t372;
    unsigned int t373;
    unsigned int t374;
    unsigned int t375;
    unsigned int t376;
    int t377;
    unsigned int t378;
    unsigned int t379;
    unsigned int t380;
    int t381;
    unsigned int t382;
    unsigned int t383;
    unsigned int t384;
    unsigned int t385;
    unsigned int t387;
    unsigned int t388;
    unsigned int t389;
    unsigned int t390;
    unsigned int t391;
    unsigned int t393;
    unsigned int t394;
    unsigned int t395;
    unsigned int t396;
    unsigned int t397;
    unsigned int t398;
    unsigned int t399;
    unsigned int t400;
    unsigned int t401;
    unsigned int t402;
    unsigned int t403;
    unsigned int t404;
    unsigned int t405;
    unsigned int t406;
    unsigned int t407;
    unsigned int t408;
    unsigned int t409;
    unsigned int t410;
    int t411;
    int t412;
    unsigned int t413;
    unsigned int t414;
    unsigned int t415;
    unsigned int t416;
    unsigned int t417;
    unsigned int t418;
    unsigned int t419;
    unsigned int t420;
    unsigned int t421;
    unsigned int t422;
    unsigned int t423;
    char *t424;
    char *t425;
    char *t426;
    char *t427;
    char *t428;
    char *t429;
    char *t430;
    char *t431;
    char *t432;
    char *t433;
    char *t434;

LAB0:    t1 = (t0 + 12360U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(357, ng0);
    t2 = (t0 + 12844);
    *((int *)t2) = 1;
    *((char **)t1) = &&LAB4;

LAB1:    return;
LAB4:    xsi_set_current_line(357, ng0);

LAB5:    xsi_set_current_line(358, ng0);
    t4 = (t0 + 7120);
    t5 = (t4 + 32U);
    t6 = *((char **)t5);
    memset(t3, 0, 8);
    t7 = (t3 + 4U);
    t8 = (t6 + 4U);
    t9 = *((unsigned int *)t8);
    t10 = (~(t9));
    t11 = *((unsigned int *)t6);
    t12 = (t11 & t10);
    t13 = (t12 & 1U);
    if (t13 != 0)
        goto LAB9;

LAB7:    if (*((unsigned int *)t8) == 0)
        goto LAB6;

LAB8:    *((unsigned int *)t3) = 1;
    *((unsigned int *)t7) = 1;

LAB9:    t14 = (t3 + 4U);
    t15 = *((unsigned int *)t14);
    t16 = (~(t15));
    t17 = *((unsigned int *)t3);
    t18 = (t17 & t16);
    t19 = (t18 != 0);
    if (t19 > 0)
        goto LAB10;

LAB11:
LAB12:    xsi_set_current_line(362, ng0);
    t2 = (t0 + 7120);
    t4 = (t2 + 32U);
    t5 = *((char **)t4);
    memset(t3, 0, 8);
    t6 = (t3 + 4U);
    t7 = (t5 + 4U);
    t9 = *((unsigned int *)t7);
    t10 = (~(t9));
    t11 = *((unsigned int *)t5);
    t12 = (t11 & t10);
    t13 = (t12 & 1U);
    if (t13 != 0)
        goto LAB16;

LAB14:    if (*((unsigned int *)t7) == 0)
        goto LAB13;

LAB15:    *((unsigned int *)t3) = 1;
    *((unsigned int *)t6) = 1;

LAB16:    memset(t31, 0, 8);
    t8 = (t31 + 4U);
    t14 = (t3 + 4U);
    t15 = *((unsigned int *)t14);
    t16 = (~(t15));
    t17 = *((unsigned int *)t3);
    t18 = (t17 & t16);
    t19 = (t18 & 1U);
    if (t19 != 0)
        goto LAB17;

LAB18:    if (*((unsigned int *)t14) != 0)
        goto LAB19;

LAB20:    t20 = (t31 + 4U);
    t32 = *((unsigned int *)t31);
    t33 = *((unsigned int *)t20);
    t34 = (t32 || t33);
    if (t34 > 0)
        goto LAB21;

LAB22:    memcpy(t41, t31, 8);

LAB23:    t69 = (t41 + 4U);
    t70 = *((unsigned int *)t69);
    t71 = (~(t70));
    t72 = *((unsigned int *)t41);
    t73 = (t72 & t71);
    t74 = (t73 != 0);
    if (t74 > 0)
        goto LAB31;

LAB32:
LAB33:    xsi_set_current_line(366, ng0);
    t2 = (t0 + 7120);
    t4 = (t2 + 32U);
    t5 = *((char **)t4);
    memset(t3, 0, 8);
    t6 = (t3 + 4U);
    t7 = (t5 + 4U);
    t9 = *((unsigned int *)t7);
    t10 = (~(t9));
    t11 = *((unsigned int *)t5);
    t12 = (t11 & t10);
    t13 = (t12 & 1U);
    if (t13 != 0)
        goto LAB37;

LAB35:    if (*((unsigned int *)t7) == 0)
        goto LAB34;

LAB36:    *((unsigned int *)t3) = 1;
    *((unsigned int *)t6) = 1;

LAB37:    memset(t31, 0, 8);
    t8 = (t31 + 4U);
    t14 = (t3 + 4U);
    t15 = *((unsigned int *)t14);
    t16 = (~(t15));
    t17 = *((unsigned int *)t3);
    t18 = (t17 & t16);
    t19 = (t18 & 1U);
    if (t19 != 0)
        goto LAB38;

LAB39:    if (*((unsigned int *)t14) != 0)
        goto LAB40;

LAB41:    t20 = (t31 + 4U);
    t32 = *((unsigned int *)t31);
    t33 = *((unsigned int *)t20);
    t34 = (t32 || t33);
    if (t34 > 0)
        goto LAB42;

LAB43:    memcpy(t206, t31, 8);

LAB44:    t238 = (t206 + 4U);
    t239 = *((unsigned int *)t238);
    t240 = (~(t239));
    t241 = *((unsigned int *)t206);
    t242 = (t241 & t240);
    t243 = (t242 != 0);
    if (t243 > 0)
        goto LAB94;

LAB95:
LAB96:    xsi_set_current_line(374, ng0);
    t2 = (t0 + 7120);
    t4 = (t2 + 32U);
    t5 = *((char **)t4);
    memset(t3, 0, 8);
    t6 = (t3 + 4U);
    t7 = (t5 + 4U);
    t9 = *((unsigned int *)t7);
    t10 = (~(t9));
    t11 = *((unsigned int *)t5);
    t12 = (t11 & t10);
    t13 = (t12 & 1U);
    if (t13 != 0)
        goto LAB100;

LAB98:    if (*((unsigned int *)t7) == 0)
        goto LAB97;

LAB99:    *((unsigned int *)t3) = 1;
    *((unsigned int *)t6) = 1;

LAB100:    memset(t31, 0, 8);
    t8 = (t31 + 4U);
    t14 = (t3 + 4U);
    t15 = *((unsigned int *)t14);
    t16 = (~(t15));
    t17 = *((unsigned int *)t3);
    t18 = (t17 & t16);
    t19 = (t18 & 1U);
    if (t19 != 0)
        goto LAB101;

LAB102:    if (*((unsigned int *)t14) != 0)
        goto LAB103;

LAB104:    t20 = (t31 + 4U);
    t32 = *((unsigned int *)t31);
    t33 = *((unsigned int *)t20);
    t34 = (t32 || t33);
    if (t34 > 0)
        goto LAB105;

LAB106:    memcpy(t392, t31, 8);

LAB107:    t271 = (t392 + 4U);
    t419 = *((unsigned int *)t271);
    t420 = (~(t419));
    t421 = *((unsigned int *)t392);
    t422 = (t421 & t420);
    t423 = (t422 != 0);
    if (t423 > 0)
        goto LAB213;

LAB214:
LAB215:    goto LAB2;

LAB6:    *((unsigned int *)t3) = 1;
    goto LAB9;

LAB10:    xsi_set_current_line(359, ng0);
    t20 = (t0 + 17480);
    t21 = *((char **)t20);
    t22 = ((((char*)(t21))) + 20U);
    t23 = *((char **)t22);
    t22 = (t0 + 17512);
    t24 = *((char **)t22);
    t25 = ((((char*)(t24))) + 20U);
    t26 = *((char **)t25);
    t25 = (t0 + 17544);
    t27 = *((char **)t25);
    t28 = ((((char*)(t27))) + 20U);
    t29 = *((char **)t28);
    t28 = xsi_vlog_time(t30, 1000000.000000000, 1000.000000000000);
    xsi_vlogfile_write(1, 0, ng15, 5, t0, (char)118, t23, 32, (char)118, t26, 1, (char)118, t29, 1, (char)118, t30, 64);
    goto LAB12;

LAB13:    *((unsigned int *)t3) = 1;
    goto LAB16;

LAB17:    *((unsigned int *)t31) = 1;
    goto LAB20;

LAB19:    *((unsigned int *)t31) = 1;
    *((unsigned int *)t8) = 1;
    goto LAB20;

LAB21:    t21 = (t0 + 17572);
    t22 = *((char **)t21);
    t23 = ((((char*)(t22))) + 20U);
    t24 = *((char **)t23);
    memset(t35, 0, 8);
    t23 = (t35 + 4U);
    t25 = (t24 + 4U);
    t36 = *((unsigned int *)t25);
    t37 = (~(t36));
    t38 = *((unsigned int *)t24);
    t39 = (t38 & t37);
    t40 = (t39 & 1U);
    if (t40 != 0)
        goto LAB24;

LAB25:    if (*((unsigned int *)t25) != 0)
        goto LAB26;

LAB27:    t42 = *((unsigned int *)t31);
    t43 = *((unsigned int *)t35);
    t44 = (t42 & t43);
    *((unsigned int *)t41) = t44;
    t26 = (t31 + 4U);
    t27 = (t35 + 4U);
    t28 = (t41 + 4U);
    t45 = *((unsigned int *)t26);
    t46 = *((unsigned int *)t27);
    t47 = (t45 | t46);
    *((unsigned int *)t28) = t47;
    t48 = *((unsigned int *)t28);
    t49 = (t48 != 0);
    if (t49 == 1)
        goto LAB28;

LAB29:
LAB30:    goto LAB23;

LAB24:    *((unsigned int *)t35) = 1;
    goto LAB27;

LAB26:    *((unsigned int *)t35) = 1;
    *((unsigned int *)t23) = 1;
    goto LAB27;

LAB28:    t50 = *((unsigned int *)t41);
    t51 = *((unsigned int *)t28);
    *((unsigned int *)t41) = (t50 | t51);
    t29 = (t31 + 4U);
    t52 = (t35 + 4U);
    t53 = *((unsigned int *)t31);
    t54 = (~(t53));
    t55 = *((unsigned int *)t29);
    t56 = (~(t55));
    t57 = *((unsigned int *)t35);
    t58 = (~(t57));
    t59 = *((unsigned int *)t52);
    t60 = (~(t59));
    t61 = (t54 & t56);
    t62 = (t58 & t60);
    t63 = (~(t61));
    t64 = (~(t62));
    t65 = *((unsigned int *)t28);
    *((unsigned int *)t28) = (t65 & t63);
    t66 = *((unsigned int *)t28);
    *((unsigned int *)t28) = (t66 & t64);
    t67 = *((unsigned int *)t41);
    *((unsigned int *)t41) = (t67 & t63);
    t68 = *((unsigned int *)t41);
    *((unsigned int *)t41) = (t68 & t64);
    goto LAB30;

LAB31:    xsi_set_current_line(363, ng0);
    t76 = (t0 + 17596);
    t77 = *((char **)t76);
    t78 = ((((char*)(t77))) + 20U);
    t79 = *((char **)t78);
    t78 = (t0 + 17620);
    t80 = *((char **)t78);
    t81 = ((((char*)(t80))) + 40U);
    t82 = *((char **)t81);
    t83 = ((char*)((ng17)));
    t84 = ((char*)((ng18)));
    xsi_vlog_generic_get_part_select_value(t75, 8, t79, t82, 2, t83, 32U, 1, t84, 32U, 1);
    t85 = (t0 + 17644);
    t86 = *((char **)t85);
    t87 = ((((char*)(t86))) + 20U);
    t88 = *((char **)t87);
    xsi_vlog_get_part_select_value(t30, 64, t88, 63, 0);
    t87 = xsi_vlog_time(t89, 1000000.000000000, 1000.000000000000);
    xsi_vlogfile_write(1, 0, ng16, 4, t0, (char)118, t75, 8, (char)118, t30, 64, (char)118, t89, 64);
    goto LAB33;

LAB34:    *((unsigned int *)t3) = 1;
    goto LAB37;

LAB38:    *((unsigned int *)t31) = 1;
    goto LAB41;

LAB40:    *((unsigned int *)t31) = 1;
    *((unsigned int *)t8) = 1;
    goto LAB41;

LAB42:    t21 = (t0 + 17668);
    t22 = *((char **)t21);
    t23 = ((((char*)(t22))) + 20U);
    t24 = *((char **)t23);
    t23 = (t0 + 17692);
    t25 = *((char **)t23);
    t26 = ((((char*)(t25))) + 40U);
    t27 = *((char **)t26);
    t28 = ((char*)((ng19)));
    xsi_vlog_generic_get_index_select_value(t35, 1, t24, t27, 2, t28, 32, 1);
    memset(t41, 0, 8);
    t29 = (t41 + 4U);
    t52 = (t35 + 4U);
    t36 = *((unsigned int *)t52);
    t37 = (~(t36));
    t38 = *((unsigned int *)t35);
    t39 = (t38 & t37);
    t40 = (t39 & 1U);
    if (t40 != 0)
        goto LAB45;

LAB46:    if (*((unsigned int *)t52) != 0)
        goto LAB47;

LAB48:    t69 = (t41 + 4U);
    t42 = *((unsigned int *)t41);
    t43 = (!(t42));
    t44 = *((unsigned int *)t69);
    t45 = (t43 || t44);
    if (t45 > 0)
        goto LAB49;

LAB50:    memcpy(t91, t41, 8);

LAB51:    memset(t94, 0, 8);
    t95 = (t94 + 4U);
    t96 = (t91 + 4U);
    t97 = *((unsigned int *)t96);
    t98 = (~(t97));
    t99 = *((unsigned int *)t91);
    t100 = (t99 & t98);
    t101 = (t100 & 1U);
    if (t101 != 0)
        goto LAB59;

LAB60:    if (*((unsigned int *)t96) != 0)
        goto LAB61;

LAB62:    t102 = (t94 + 4U);
    t103 = *((unsigned int *)t94);
    t104 = (!(t103));
    t105 = *((unsigned int *)t102);
    t106 = (t104 || t105);
    if (t106 > 0)
        goto LAB63;

LAB64:    memcpy(t118, t94, 8);

LAB65:    memset(t146, 0, 8);
    t147 = (t146 + 4U);
    t148 = (t118 + 4U);
    t149 = *((unsigned int *)t148);
    t150 = (~(t149));
    t151 = *((unsigned int *)t118);
    t152 = (t151 & t150);
    t153 = (t152 & 1U);
    if (t153 != 0)
        goto LAB73;

LAB74:    if (*((unsigned int *)t148) != 0)
        goto LAB75;

LAB76:    t154 = (t146 + 4U);
    t155 = *((unsigned int *)t146);
    t156 = (!(t155));
    t157 = *((unsigned int *)t154);
    t158 = (t156 || t157);
    if (t158 > 0)
        goto LAB77;

LAB78:    memcpy(t170, t146, 8);

LAB79:    memset(t198, 0, 8);
    t199 = (t198 + 4U);
    t200 = (t170 + 4U);
    t201 = *((unsigned int *)t200);
    t202 = (~(t201));
    t203 = *((unsigned int *)t170);
    t204 = (t203 & t202);
    t205 = (t204 & 1U);
    if (t205 != 0)
        goto LAB87;

LAB88:    if (*((unsigned int *)t200) != 0)
        goto LAB89;

LAB90:    t207 = *((unsigned int *)t31);
    t208 = *((unsigned int *)t198);
    t209 = (t207 & t208);
    *((unsigned int *)t206) = t209;
    t210 = (t31 + 4U);
    t211 = (t198 + 4U);
    t212 = (t206 + 4U);
    t213 = *((unsigned int *)t210);
    t214 = *((unsigned int *)t211);
    t215 = (t213 | t214);
    *((unsigned int *)t212) = t215;
    t216 = *((unsigned int *)t212);
    t217 = (t216 != 0);
    if (t217 == 1)
        goto LAB91;

LAB92:
LAB93:    goto LAB44;

LAB45:    *((unsigned int *)t41) = 1;
    goto LAB48;

LAB47:    *((unsigned int *)t41) = 1;
    *((unsigned int *)t29) = 1;
    goto LAB48;

LAB49:    t76 = (t0 + 17716);
    t77 = *((char **)t76);
    t78 = ((((char*)(t77))) + 20U);
    t79 = *((char **)t78);
    t78 = (t0 + 17740);
    t80 = *((char **)t78);
    t81 = ((((char*)(t80))) + 40U);
    t82 = *((char **)t81);
    t83 = ((char*)((ng20)));
    xsi_vlog_generic_get_index_select_value(t75, 1, t79, t82, 2, t83, 32, 1);
    memset(t90, 0, 8);
    t84 = (t90 + 4U);
    t85 = (t75 + 4U);
    t46 = *((unsigned int *)t85);
    t47 = (~(t46));
    t48 = *((unsigned int *)t75);
    t49 = (t48 & t47);
    t50 = (t49 & 1U);
    if (t50 != 0)
        goto LAB52;

LAB53:    if (*((unsigned int *)t85) != 0)
        goto LAB54;

LAB55:    t51 = *((unsigned int *)t41);
    t53 = *((unsigned int *)t90);
    t54 = (t51 | t53);
    *((unsigned int *)t91) = t54;
    t86 = (t41 + 4U);
    t87 = (t90 + 4U);
    t88 = (t91 + 4U);
    t55 = *((unsigned int *)t86);
    t56 = *((unsigned int *)t87);
    t57 = (t55 | t56);
    *((unsigned int *)t88) = t57;
    t58 = *((unsigned int *)t88);
    t59 = (t58 != 0);
    if (t59 == 1)
        goto LAB56;

LAB57:
LAB58:    goto LAB51;

LAB52:    *((unsigned int *)t90) = 1;
    goto LAB55;

LAB54:    *((unsigned int *)t90) = 1;
    *((unsigned int *)t84) = 1;
    goto LAB55;

LAB56:    t60 = *((unsigned int *)t91);
    t63 = *((unsigned int *)t88);
    *((unsigned int *)t91) = (t60 | t63);
    t92 = (t41 + 4U);
    t93 = (t90 + 4U);
    t64 = *((unsigned int *)t92);
    t65 = (~(t64));
    t66 = *((unsigned int *)t41);
    t61 = (t66 & t65);
    t67 = *((unsigned int *)t93);
    t68 = (~(t67));
    t70 = *((unsigned int *)t90);
    t62 = (t70 & t68);
    t71 = (~(t61));
    t72 = (~(t62));
    t73 = *((unsigned int *)t88);
    *((unsigned int *)t88) = (t73 & t71);
    t74 = *((unsigned int *)t88);
    *((unsigned int *)t88) = (t74 & t72);
    goto LAB58;

LAB59:    *((unsigned int *)t94) = 1;
    goto LAB62;

LAB61:    *((unsigned int *)t94) = 1;
    *((unsigned int *)t95) = 1;
    goto LAB62;

LAB63:    t107 = (t0 + 17772);
    t108 = *((char **)t107);
    t109 = ((((char*)(t108))) + 20U);
    t110 = *((char **)t109);
    memset(t111, 0, 8);
    t109 = (t111 + 4U);
    t112 = (t110 + 4U);
    t113 = *((unsigned int *)t112);
    t114 = (~(t113));
    t115 = *((unsigned int *)t110);
    t116 = (t115 & t114);
    t117 = (t116 & 1U);
    if (t117 != 0)
        goto LAB66;

LAB67:    if (*((unsigned int *)t112) != 0)
        goto LAB68;

LAB69:    t119 = *((unsigned int *)t94);
    t120 = *((unsigned int *)t111);
    t121 = (t119 | t120);
    *((unsigned int *)t118) = t121;
    t122 = (t94 + 4U);
    t123 = (t111 + 4U);
    t124 = (t118 + 4U);
    t125 = *((unsigned int *)t122);
    t126 = *((unsigned int *)t123);
    t127 = (t125 | t126);
    *((unsigned int *)t124) = t127;
    t128 = *((unsigned int *)t124);
    t129 = (t128 != 0);
    if (t129 == 1)
        goto LAB70;

LAB71:
LAB72:    goto LAB65;

LAB66:    *((unsigned int *)t111) = 1;
    goto LAB69;

LAB68:    *((unsigned int *)t111) = 1;
    *((unsigned int *)t109) = 1;
    goto LAB69;

LAB70:    t130 = *((unsigned int *)t118);
    t131 = *((unsigned int *)t124);
    *((unsigned int *)t118) = (t130 | t131);
    t132 = (t94 + 4U);
    t133 = (t111 + 4U);
    t134 = *((unsigned int *)t132);
    t135 = (~(t134));
    t136 = *((unsigned int *)t94);
    t137 = (t136 & t135);
    t138 = *((unsigned int *)t133);
    t139 = (~(t138));
    t140 = *((unsigned int *)t111);
    t141 = (t140 & t139);
    t142 = (~(t137));
    t143 = (~(t141));
    t144 = *((unsigned int *)t124);
    *((unsigned int *)t124) = (t144 & t142);
    t145 = *((unsigned int *)t124);
    *((unsigned int *)t124) = (t145 & t143);
    goto LAB72;

LAB73:    *((unsigned int *)t146) = 1;
    goto LAB76;

LAB75:    *((unsigned int *)t146) = 1;
    *((unsigned int *)t147) = 1;
    goto LAB76;

LAB77:    t159 = (t0 + 17804);
    t160 = *((char **)t159);
    t161 = ((((char*)(t160))) + 20U);
    t162 = *((char **)t161);
    memset(t163, 0, 8);
    t161 = (t163 + 4U);
    t164 = (t162 + 4U);
    t165 = *((unsigned int *)t164);
    t166 = (~(t165));
    t167 = *((unsigned int *)t162);
    t168 = (t167 & t166);
    t169 = (t168 & 1U);
    if (t169 != 0)
        goto LAB80;

LAB81:    if (*((unsigned int *)t164) != 0)
        goto LAB82;

LAB83:    t171 = *((unsigned int *)t146);
    t172 = *((unsigned int *)t163);
    t173 = (t171 | t172);
    *((unsigned int *)t170) = t173;
    t174 = (t146 + 4U);
    t175 = (t163 + 4U);
    t176 = (t170 + 4U);
    t177 = *((unsigned int *)t174);
    t178 = *((unsigned int *)t175);
    t179 = (t177 | t178);
    *((unsigned int *)t176) = t179;
    t180 = *((unsigned int *)t176);
    t181 = (t180 != 0);
    if (t181 == 1)
        goto LAB84;

LAB85:
LAB86:    goto LAB79;

LAB80:    *((unsigned int *)t163) = 1;
    goto LAB83;

LAB82:    *((unsigned int *)t163) = 1;
    *((unsigned int *)t161) = 1;
    goto LAB83;

LAB84:    t182 = *((unsigned int *)t170);
    t183 = *((unsigned int *)t176);
    *((unsigned int *)t170) = (t182 | t183);
    t184 = (t146 + 4U);
    t185 = (t163 + 4U);
    t186 = *((unsigned int *)t184);
    t187 = (~(t186));
    t188 = *((unsigned int *)t146);
    t189 = (t188 & t187);
    t190 = *((unsigned int *)t185);
    t191 = (~(t190));
    t192 = *((unsigned int *)t163);
    t193 = (t192 & t191);
    t194 = (~(t189));
    t195 = (~(t193));
    t196 = *((unsigned int *)t176);
    *((unsigned int *)t176) = (t196 & t194);
    t197 = *((unsigned int *)t176);
    *((unsigned int *)t176) = (t197 & t195);
    goto LAB86;

LAB87:    *((unsigned int *)t198) = 1;
    goto LAB90;

LAB89:    *((unsigned int *)t198) = 1;
    *((unsigned int *)t199) = 1;
    goto LAB90;

LAB91:    t218 = *((unsigned int *)t206);
    t219 = *((unsigned int *)t212);
    *((unsigned int *)t206) = (t218 | t219);
    t220 = (t31 + 4U);
    t221 = (t198 + 4U);
    t222 = *((unsigned int *)t31);
    t223 = (~(t222));
    t224 = *((unsigned int *)t220);
    t225 = (~(t224));
    t226 = *((unsigned int *)t198);
    t227 = (~(t226));
    t228 = *((unsigned int *)t221);
    t229 = (~(t228));
    t230 = (t223 & t225);
    t231 = (t227 & t229);
    t232 = (~(t230));
    t233 = (~(t231));
    t234 = *((unsigned int *)t212);
    *((unsigned int *)t212) = (t234 & t232);
    t235 = *((unsigned int *)t212);
    *((unsigned int *)t212) = (t235 & t233);
    t236 = *((unsigned int *)t206);
    *((unsigned int *)t206) = (t236 & t232);
    t237 = *((unsigned int *)t206);
    *((unsigned int *)t206) = (t237 & t233);
    goto LAB93;

LAB94:    xsi_set_current_line(368, ng0);
    t244 = (t0 + 17828);
    t245 = *((char **)t244);
    t246 = ((((char*)(t245))) + 20U);
    t247 = *((char **)t246);
    t246 = (t0 + 17852);
    t248 = *((char **)t246);
    t249 = ((((char*)(t248))) + 20U);
    t250 = *((char **)t249);
    t249 = (t0 + 17876);
    t252 = *((char **)t249);
    t253 = ((((char*)(t252))) + 40U);
    t254 = *((char **)t253);
    t255 = ((char*)((ng19)));
    xsi_vlog_generic_get_index_select_value(t251, 1, t250, t254, 2, t255, 32, 1);
    t256 = (t0 + 17900);
    t257 = *((char **)t256);
    t258 = ((((char*)(t257))) + 20U);
    t259 = *((char **)t258);
    t258 = (t0 + 17924);
    t261 = *((char **)t258);
    t262 = ((((char*)(t261))) + 40U);
    t263 = *((char **)t262);
    t264 = ((char*)((ng20)));
    xsi_vlog_generic_get_index_select_value(t260, 1, t259, t263, 2, t264, 32, 1);
    t265 = (t0 + 17956);
    t266 = *((char **)t265);
    t267 = ((((char*)(t266))) + 20U);
    t268 = *((char **)t267);
    t267 = (t0 + 17988);
    t269 = *((char **)t267);
    t270 = ((((char*)(t269))) + 20U);
    t271 = *((char **)t270);
    t270 = xsi_vlog_time(t30, 1000000.000000000, 1000.000000000000);
    xsi_vlogfile_write(1, 0, ng21, 7, t0, (char)118, t247, 32, (char)118, t251, 1, (char)118, t260, 1, (char)118, t268, 1, (char)118, t271, 1, (char)118, t30, 64);
    goto LAB96;

LAB97:    *((unsigned int *)t3) = 1;
    goto LAB100;

LAB101:    *((unsigned int *)t31) = 1;
    goto LAB104;

LAB103:    *((unsigned int *)t31) = 1;
    *((unsigned int *)t8) = 1;
    goto LAB104;

LAB105:    t21 = (t0 + 5572U);
    t22 = *((char **)t21);
    memset(t35, 0, 8);
    t21 = (t35 + 4U);
    t23 = (t22 + 4U);
    t36 = *((unsigned int *)t23);
    t37 = (~(t36));
    t38 = *((unsigned int *)t22);
    t39 = (t38 & t37);
    t40 = (t39 & 1U);
    if (t40 != 0)
        goto LAB108;

LAB109:    if (*((unsigned int *)t23) != 0)
        goto LAB110;

LAB111:    t24 = (t35 + 4U);
    t42 = *((unsigned int *)t35);
    t43 = (!(t42));
    t44 = *((unsigned int *)t24);
    t45 = (t43 || t44);
    if (t45 > 0)
        goto LAB112;

LAB113:    memcpy(t75, t35, 8);

LAB114:    memset(t90, 0, 8);
    t77 = (t90 + 4U);
    t78 = (t75 + 4U);
    t97 = *((unsigned int *)t78);
    t98 = (~(t97));
    t99 = *((unsigned int *)t75);
    t100 = (t99 & t98);
    t101 = (t100 & 1U);
    if (t101 != 0)
        goto LAB122;

LAB123:    if (*((unsigned int *)t78) != 0)
        goto LAB124;

LAB125:    t79 = (t90 + 4U);
    t103 = *((unsigned int *)t90);
    t104 = (!(t103));
    t105 = *((unsigned int *)t79);
    t106 = (t104 || t105);
    if (t106 > 0)
        goto LAB126;

LAB127:    memcpy(t94, t90, 8);

LAB128:    memset(t111, 0, 8);
    t88 = (t111 + 4U);
    t92 = (t94 + 4U);
    t149 = *((unsigned int *)t92);
    t150 = (~(t149));
    t151 = *((unsigned int *)t94);
    t152 = (t151 & t150);
    t153 = (t152 & 1U);
    if (t153 != 0)
        goto LAB136;

LAB137:    if (*((unsigned int *)t92) != 0)
        goto LAB138;

LAB139:    t93 = (t111 + 4U);
    t155 = *((unsigned int *)t111);
    t156 = (!(t155));
    t157 = *((unsigned int *)t93);
    t158 = (t156 || t157);
    if (t158 > 0)
        goto LAB140;

LAB141:    memcpy(t146, t111, 8);

LAB142:    memset(t163, 0, 8);
    t122 = (t163 + 4U);
    t123 = (t146 + 4U);
    t201 = *((unsigned int *)t123);
    t202 = (~(t201));
    t203 = *((unsigned int *)t146);
    t204 = (t203 & t202);
    t205 = (t204 & 1U);
    if (t205 != 0)
        goto LAB150;

LAB151:    if (*((unsigned int *)t123) != 0)
        goto LAB152;

LAB153:    t124 = (t163 + 4U);
    t207 = *((unsigned int *)t163);
    t208 = (!(t207));
    t209 = *((unsigned int *)t124);
    t213 = (t208 || t209);
    if (t213 > 0)
        goto LAB154;

LAB155:    memcpy(t198, t163, 8);

LAB156:    memset(t206, 0, 8);
    t162 = (t206 + 4U);
    t164 = (t198 + 4U);
    t272 = *((unsigned int *)t164);
    t273 = (~(t272));
    t274 = *((unsigned int *)t198);
    t275 = (t274 & t273);
    t276 = (t275 & 1U);
    if (t276 != 0)
        goto LAB164;

LAB165:    if (*((unsigned int *)t164) != 0)
        goto LAB166;

LAB167:    t174 = (t206 + 4U);
    t277 = *((unsigned int *)t206);
    t278 = (!(t277));
    t279 = *((unsigned int *)t174);
    t280 = (t278 || t279);
    if (t280 > 0)
        goto LAB168;

LAB169:    memcpy(t260, t206, 8);

LAB170:    memset(t308, 0, 8);
    t212 = (t308 + 4U);
    t220 = (t260 + 4U);
    t309 = *((unsigned int *)t220);
    t310 = (~(t309));
    t311 = *((unsigned int *)t260);
    t312 = (t311 & t310);
    t313 = (t312 & 1U);
    if (t313 != 0)
        goto LAB178;

LAB179:    if (*((unsigned int *)t220) != 0)
        goto LAB180;

LAB181:    t221 = (t308 + 4U);
    t314 = *((unsigned int *)t308);
    t315 = (!(t314));
    t316 = *((unsigned int *)t221);
    t317 = (t315 || t316);
    if (t317 > 0)
        goto LAB182;

LAB183:    memcpy(t324, t308, 8);

LAB184:    memset(t347, 0, 8);
    t252 = (t347 + 4U);
    t253 = (t324 + 4U);
    t348 = *((unsigned int *)t253);
    t349 = (~(t348));
    t350 = *((unsigned int *)t324);
    t351 = (t350 & t349);
    t352 = (t351 & 1U);
    if (t352 != 0)
        goto LAB192;

LAB193:    if (*((unsigned int *)t253) != 0)
        goto LAB194;

LAB195:    t254 = (t347 + 4U);
    t353 = *((unsigned int *)t347);
    t354 = (!(t353));
    t355 = *((unsigned int *)t254);
    t356 = (t354 || t355);
    if (t356 > 0)
        goto LAB196;

LAB197:    memcpy(t363, t347, 8);

LAB198:    memset(t386, 0, 8);
    t264 = (t386 + 4U);
    t265 = (t363 + 4U);
    t387 = *((unsigned int *)t265);
    t388 = (~(t387));
    t389 = *((unsigned int *)t363);
    t390 = (t389 & t388);
    t391 = (t390 & 1U);
    if (t391 != 0)
        goto LAB206;

LAB207:    if (*((unsigned int *)t265) != 0)
        goto LAB208;

LAB209:    t393 = *((unsigned int *)t31);
    t394 = *((unsigned int *)t386);
    t395 = (t393 & t394);
    *((unsigned int *)t392) = t395;
    t266 = (t31 + 4U);
    t267 = (t386 + 4U);
    t268 = (t392 + 4U);
    t396 = *((unsigned int *)t266);
    t397 = *((unsigned int *)t267);
    t398 = (t396 | t397);
    *((unsigned int *)t268) = t398;
    t399 = *((unsigned int *)t268);
    t400 = (t399 != 0);
    if (t400 == 1)
        goto LAB210;

LAB211:
LAB212:    goto LAB107;

LAB108:    *((unsigned int *)t35) = 1;
    goto LAB111;

LAB110:    *((unsigned int *)t35) = 1;
    *((unsigned int *)t21) = 1;
    goto LAB111;

LAB112:    t25 = (t0 + 5660U);
    t26 = *((char **)t25);
    memset(t41, 0, 8);
    t25 = (t41 + 4U);
    t27 = (t26 + 4U);
    t46 = *((unsigned int *)t27);
    t47 = (~(t46));
    t48 = *((unsigned int *)t26);
    t49 = (t48 & t47);
    t50 = (t49 & 1U);
    if (t50 != 0)
        goto LAB115;

LAB116:    if (*((unsigned int *)t27) != 0)
        goto LAB117;

LAB118:    t51 = *((unsigned int *)t35);
    t53 = *((unsigned int *)t41);
    t54 = (t51 | t53);
    *((unsigned int *)t75) = t54;
    t28 = (t35 + 4U);
    t29 = (t41 + 4U);
    t52 = (t75 + 4U);
    t55 = *((unsigned int *)t28);
    t56 = *((unsigned int *)t29);
    t57 = (t55 | t56);
    *((unsigned int *)t52) = t57;
    t58 = *((unsigned int *)t52);
    t59 = (t58 != 0);
    if (t59 == 1)
        goto LAB119;

LAB120:
LAB121:    goto LAB114;

LAB115:    *((unsigned int *)t41) = 1;
    goto LAB118;

LAB117:    *((unsigned int *)t41) = 1;
    *((unsigned int *)t25) = 1;
    goto LAB118;

LAB119:    t60 = *((unsigned int *)t75);
    t63 = *((unsigned int *)t52);
    *((unsigned int *)t75) = (t60 | t63);
    t69 = (t35 + 4U);
    t76 = (t41 + 4U);
    t64 = *((unsigned int *)t69);
    t65 = (~(t64));
    t66 = *((unsigned int *)t35);
    t61 = (t66 & t65);
    t67 = *((unsigned int *)t76);
    t68 = (~(t67));
    t70 = *((unsigned int *)t41);
    t62 = (t70 & t68);
    t71 = (~(t61));
    t72 = (~(t62));
    t73 = *((unsigned int *)t52);
    *((unsigned int *)t52) = (t73 & t71);
    t74 = *((unsigned int *)t52);
    *((unsigned int *)t52) = (t74 & t72);
    goto LAB121;

LAB122:    *((unsigned int *)t90) = 1;
    goto LAB125;

LAB124:    *((unsigned int *)t90) = 1;
    *((unsigned int *)t77) = 1;
    goto LAB125;

LAB126:    t80 = (t0 + 5748U);
    t81 = *((char **)t80);
    memset(t91, 0, 8);
    t80 = (t91 + 4U);
    t82 = (t81 + 4U);
    t113 = *((unsigned int *)t82);
    t114 = (~(t113));
    t115 = *((unsigned int *)t81);
    t116 = (t115 & t114);
    t117 = (t116 & 1U);
    if (t117 != 0)
        goto LAB129;

LAB130:    if (*((unsigned int *)t82) != 0)
        goto LAB131;

LAB132:    t119 = *((unsigned int *)t90);
    t120 = *((unsigned int *)t91);
    t121 = (t119 | t120);
    *((unsigned int *)t94) = t121;
    t83 = (t90 + 4U);
    t84 = (t91 + 4U);
    t85 = (t94 + 4U);
    t125 = *((unsigned int *)t83);
    t126 = *((unsigned int *)t84);
    t127 = (t125 | t126);
    *((unsigned int *)t85) = t127;
    t128 = *((unsigned int *)t85);
    t129 = (t128 != 0);
    if (t129 == 1)
        goto LAB133;

LAB134:
LAB135:    goto LAB128;

LAB129:    *((unsigned int *)t91) = 1;
    goto LAB132;

LAB131:    *((unsigned int *)t91) = 1;
    *((unsigned int *)t80) = 1;
    goto LAB132;

LAB133:    t130 = *((unsigned int *)t94);
    t131 = *((unsigned int *)t85);
    *((unsigned int *)t94) = (t130 | t131);
    t86 = (t90 + 4U);
    t87 = (t91 + 4U);
    t134 = *((unsigned int *)t86);
    t135 = (~(t134));
    t136 = *((unsigned int *)t90);
    t137 = (t136 & t135);
    t138 = *((unsigned int *)t87);
    t139 = (~(t138));
    t140 = *((unsigned int *)t91);
    t141 = (t140 & t139);
    t142 = (~(t137));
    t143 = (~(t141));
    t144 = *((unsigned int *)t85);
    *((unsigned int *)t85) = (t144 & t142);
    t145 = *((unsigned int *)t85);
    *((unsigned int *)t85) = (t145 & t143);
    goto LAB135;

LAB136:    *((unsigned int *)t111) = 1;
    goto LAB139;

LAB138:    *((unsigned int *)t111) = 1;
    *((unsigned int *)t88) = 1;
    goto LAB139;

LAB140:    t95 = (t0 + 5836U);
    t96 = *((char **)t95);
    memset(t118, 0, 8);
    t95 = (t118 + 4U);
    t102 = (t96 + 4U);
    t165 = *((unsigned int *)t102);
    t166 = (~(t165));
    t167 = *((unsigned int *)t96);
    t168 = (t167 & t166);
    t169 = (t168 & 1U);
    if (t169 != 0)
        goto LAB143;

LAB144:    if (*((unsigned int *)t102) != 0)
        goto LAB145;

LAB146:    t171 = *((unsigned int *)t111);
    t172 = *((unsigned int *)t118);
    t173 = (t171 | t172);
    *((unsigned int *)t146) = t173;
    t107 = (t111 + 4U);
    t108 = (t118 + 4U);
    t109 = (t146 + 4U);
    t177 = *((unsigned int *)t107);
    t178 = *((unsigned int *)t108);
    t179 = (t177 | t178);
    *((unsigned int *)t109) = t179;
    t180 = *((unsigned int *)t109);
    t181 = (t180 != 0);
    if (t181 == 1)
        goto LAB147;

LAB148:
LAB149:    goto LAB142;

LAB143:    *((unsigned int *)t118) = 1;
    goto LAB146;

LAB145:    *((unsigned int *)t118) = 1;
    *((unsigned int *)t95) = 1;
    goto LAB146;

LAB147:    t182 = *((unsigned int *)t146);
    t183 = *((unsigned int *)t109);
    *((unsigned int *)t146) = (t182 | t183);
    t110 = (t111 + 4U);
    t112 = (t118 + 4U);
    t186 = *((unsigned int *)t110);
    t187 = (~(t186));
    t188 = *((unsigned int *)t111);
    t189 = (t188 & t187);
    t190 = *((unsigned int *)t112);
    t191 = (~(t190));
    t192 = *((unsigned int *)t118);
    t193 = (t192 & t191);
    t194 = (~(t189));
    t195 = (~(t193));
    t196 = *((unsigned int *)t109);
    *((unsigned int *)t109) = (t196 & t194);
    t197 = *((unsigned int *)t109);
    *((unsigned int *)t109) = (t197 & t195);
    goto LAB149;

LAB150:    *((unsigned int *)t163) = 1;
    goto LAB153;

LAB152:    *((unsigned int *)t163) = 1;
    *((unsigned int *)t122) = 1;
    goto LAB153;

LAB154:    t132 = (t0 + 5924U);
    t133 = *((char **)t132);
    memset(t170, 0, 8);
    t132 = (t170 + 4U);
    t147 = (t133 + 4U);
    t214 = *((unsigned int *)t147);
    t215 = (~(t214));
    t216 = *((unsigned int *)t133);
    t217 = (t216 & t215);
    t218 = (t217 & 1U);
    if (t218 != 0)
        goto LAB157;

LAB158:    if (*((unsigned int *)t147) != 0)
        goto LAB159;

LAB160:    t219 = *((unsigned int *)t163);
    t222 = *((unsigned int *)t170);
    t223 = (t219 | t222);
    *((unsigned int *)t198) = t223;
    t148 = (t163 + 4U);
    t154 = (t170 + 4U);
    t159 = (t198 + 4U);
    t224 = *((unsigned int *)t148);
    t225 = *((unsigned int *)t154);
    t226 = (t224 | t225);
    *((unsigned int *)t159) = t226;
    t227 = *((unsigned int *)t159);
    t228 = (t227 != 0);
    if (t228 == 1)
        goto LAB161;

LAB162:
LAB163:    goto LAB156;

LAB157:    *((unsigned int *)t170) = 1;
    goto LAB160;

LAB159:    *((unsigned int *)t170) = 1;
    *((unsigned int *)t132) = 1;
    goto LAB160;

LAB161:    t229 = *((unsigned int *)t198);
    t232 = *((unsigned int *)t159);
    *((unsigned int *)t198) = (t229 | t232);
    t160 = (t163 + 4U);
    t161 = (t170 + 4U);
    t233 = *((unsigned int *)t160);
    t234 = (~(t233));
    t235 = *((unsigned int *)t163);
    t230 = (t235 & t234);
    t236 = *((unsigned int *)t161);
    t237 = (~(t236));
    t239 = *((unsigned int *)t170);
    t231 = (t239 & t237);
    t240 = (~(t230));
    t241 = (~(t231));
    t242 = *((unsigned int *)t159);
    *((unsigned int *)t159) = (t242 & t240);
    t243 = *((unsigned int *)t159);
    *((unsigned int *)t159) = (t243 & t241);
    goto LAB163;

LAB164:    *((unsigned int *)t206) = 1;
    goto LAB167;

LAB166:    *((unsigned int *)t206) = 1;
    *((unsigned int *)t162) = 1;
    goto LAB167;

LAB168:    t175 = (t0 + 6012U);
    t176 = *((char **)t175);
    memset(t251, 0, 8);
    t175 = (t251 + 4U);
    t184 = (t176 + 4U);
    t281 = *((unsigned int *)t184);
    t282 = (~(t281));
    t283 = *((unsigned int *)t176);
    t284 = (t283 & t282);
    t285 = (t284 & 1U);
    if (t285 != 0)
        goto LAB171;

LAB172:    if (*((unsigned int *)t184) != 0)
        goto LAB173;

LAB174:    t286 = *((unsigned int *)t206);
    t287 = *((unsigned int *)t251);
    t288 = (t286 | t287);
    *((unsigned int *)t260) = t288;
    t185 = (t206 + 4U);
    t199 = (t251 + 4U);
    t200 = (t260 + 4U);
    t289 = *((unsigned int *)t185);
    t290 = *((unsigned int *)t199);
    t291 = (t289 | t290);
    *((unsigned int *)t200) = t291;
    t292 = *((unsigned int *)t200);
    t293 = (t292 != 0);
    if (t293 == 1)
        goto LAB175;

LAB176:
LAB177:    goto LAB170;

LAB171:    *((unsigned int *)t251) = 1;
    goto LAB174;

LAB173:    *((unsigned int *)t251) = 1;
    *((unsigned int *)t175) = 1;
    goto LAB174;

LAB175:    t294 = *((unsigned int *)t260);
    t295 = *((unsigned int *)t200);
    *((unsigned int *)t260) = (t294 | t295);
    t210 = (t206 + 4U);
    t211 = (t251 + 4U);
    t296 = *((unsigned int *)t210);
    t297 = (~(t296));
    t298 = *((unsigned int *)t206);
    t299 = (t298 & t297);
    t300 = *((unsigned int *)t211);
    t301 = (~(t300));
    t302 = *((unsigned int *)t251);
    t303 = (t302 & t301);
    t304 = (~(t299));
    t305 = (~(t303));
    t306 = *((unsigned int *)t200);
    *((unsigned int *)t200) = (t306 & t304);
    t307 = *((unsigned int *)t200);
    *((unsigned int *)t200) = (t307 & t305);
    goto LAB177;

LAB178:    *((unsigned int *)t308) = 1;
    goto LAB181;

LAB180:    *((unsigned int *)t308) = 1;
    *((unsigned int *)t212) = 1;
    goto LAB181;

LAB182:    t238 = (t0 + 6100U);
    t244 = *((char **)t238);
    memset(t318, 0, 8);
    t238 = (t318 + 4U);
    t245 = (t244 + 4U);
    t319 = *((unsigned int *)t245);
    t320 = (~(t319));
    t321 = *((unsigned int *)t244);
    t322 = (t321 & t320);
    t323 = (t322 & 1U);
    if (t323 != 0)
        goto LAB185;

LAB186:    if (*((unsigned int *)t245) != 0)
        goto LAB187;

LAB188:    t325 = *((unsigned int *)t308);
    t326 = *((unsigned int *)t318);
    t327 = (t325 | t326);
    *((unsigned int *)t324) = t327;
    t246 = (t308 + 4U);
    t247 = (t318 + 4U);
    t248 = (t324 + 4U);
    t328 = *((unsigned int *)t246);
    t329 = *((unsigned int *)t247);
    t330 = (t328 | t329);
    *((unsigned int *)t248) = t330;
    t331 = *((unsigned int *)t248);
    t332 = (t331 != 0);
    if (t332 == 1)
        goto LAB189;

LAB190:
LAB191:    goto LAB184;

LAB185:    *((unsigned int *)t318) = 1;
    goto LAB188;

LAB187:    *((unsigned int *)t318) = 1;
    *((unsigned int *)t238) = 1;
    goto LAB188;

LAB189:    t333 = *((unsigned int *)t324);
    t334 = *((unsigned int *)t248);
    *((unsigned int *)t324) = (t333 | t334);
    t249 = (t308 + 4U);
    t250 = (t318 + 4U);
    t335 = *((unsigned int *)t249);
    t336 = (~(t335));
    t337 = *((unsigned int *)t308);
    t338 = (t337 & t336);
    t339 = *((unsigned int *)t250);
    t340 = (~(t339));
    t341 = *((unsigned int *)t318);
    t342 = (t341 & t340);
    t343 = (~(t338));
    t344 = (~(t342));
    t345 = *((unsigned int *)t248);
    *((unsigned int *)t248) = (t345 & t343);
    t346 = *((unsigned int *)t248);
    *((unsigned int *)t248) = (t346 & t344);
    goto LAB191;

LAB192:    *((unsigned int *)t347) = 1;
    goto LAB195;

LAB194:    *((unsigned int *)t347) = 1;
    *((unsigned int *)t252) = 1;
    goto LAB195;

LAB196:    t255 = (t0 + 6188U);
    t256 = *((char **)t255);
    memset(t357, 0, 8);
    t255 = (t357 + 4U);
    t257 = (t256 + 4U);
    t358 = *((unsigned int *)t257);
    t359 = (~(t358));
    t360 = *((unsigned int *)t256);
    t361 = (t360 & t359);
    t362 = (t361 & 1U);
    if (t362 != 0)
        goto LAB199;

LAB200:    if (*((unsigned int *)t257) != 0)
        goto LAB201;

LAB202:    t364 = *((unsigned int *)t347);
    t365 = *((unsigned int *)t357);
    t366 = (t364 | t365);
    *((unsigned int *)t363) = t366;
    t258 = (t347 + 4U);
    t259 = (t357 + 4U);
    t261 = (t363 + 4U);
    t367 = *((unsigned int *)t258);
    t368 = *((unsigned int *)t259);
    t369 = (t367 | t368);
    *((unsigned int *)t261) = t369;
    t370 = *((unsigned int *)t261);
    t371 = (t370 != 0);
    if (t371 == 1)
        goto LAB203;

LAB204:
LAB205:    goto LAB198;

LAB199:    *((unsigned int *)t357) = 1;
    goto LAB202;

LAB201:    *((unsigned int *)t357) = 1;
    *((unsigned int *)t255) = 1;
    goto LAB202;

LAB203:    t372 = *((unsigned int *)t363);
    t373 = *((unsigned int *)t261);
    *((unsigned int *)t363) = (t372 | t373);
    t262 = (t347 + 4U);
    t263 = (t357 + 4U);
    t374 = *((unsigned int *)t262);
    t375 = (~(t374));
    t376 = *((unsigned int *)t347);
    t377 = (t376 & t375);
    t378 = *((unsigned int *)t263);
    t379 = (~(t378));
    t380 = *((unsigned int *)t357);
    t381 = (t380 & t379);
    t382 = (~(t377));
    t383 = (~(t381));
    t384 = *((unsigned int *)t261);
    *((unsigned int *)t261) = (t384 & t382);
    t385 = *((unsigned int *)t261);
    *((unsigned int *)t261) = (t385 & t383);
    goto LAB205;

LAB206:    *((unsigned int *)t386) = 1;
    goto LAB209;

LAB208:    *((unsigned int *)t386) = 1;
    *((unsigned int *)t264) = 1;
    goto LAB209;

LAB210:    t401 = *((unsigned int *)t392);
    t402 = *((unsigned int *)t268);
    *((unsigned int *)t392) = (t401 | t402);
    t269 = (t31 + 4U);
    t270 = (t386 + 4U);
    t403 = *((unsigned int *)t31);
    t404 = (~(t403));
    t405 = *((unsigned int *)t269);
    t406 = (~(t405));
    t407 = *((unsigned int *)t386);
    t408 = (~(t407));
    t409 = *((unsigned int *)t270);
    t410 = (~(t409));
    t411 = (t404 & t406);
    t412 = (t408 & t410);
    t413 = (~(t411));
    t414 = (~(t412));
    t415 = *((unsigned int *)t268);
    *((unsigned int *)t268) = (t415 & t413);
    t416 = *((unsigned int *)t268);
    *((unsigned int *)t268) = (t416 & t414);
    t417 = *((unsigned int *)t392);
    *((unsigned int *)t392) = (t417 & t413);
    t418 = *((unsigned int *)t392);
    *((unsigned int *)t392) = (t418 & t414);
    goto LAB212;

LAB213:    xsi_set_current_line(375, ng0);
    t424 = (t0 + 6188U);
    t425 = *((char **)t424);
    t424 = (t0 + 6100U);
    t426 = *((char **)t424);
    t424 = (t0 + 6012U);
    t427 = *((char **)t424);
    t424 = (t0 + 5924U);
    t428 = *((char **)t424);
    t424 = (t0 + 5836U);
    t429 = *((char **)t424);
    t424 = (t0 + 5748U);
    t430 = *((char **)t424);
    t424 = (t0 + 5660U);
    t431 = *((char **)t424);
    t424 = (t0 + 5572U);
    t432 = *((char **)t424);
    t424 = (t0 + 4868U);
    t433 = *((char **)t424);
    t424 = (t0 + 4164U);
    t434 = *((char **)t424);
    t424 = xsi_vlog_time(t30, 1000000.000000000, 1000.000000000000);
    xsi_vlogfile_write(1, 0, ng22, 12, t0, (char)118, t425, 1, (char)118, t426, 1, (char)118, t427, 1, (char)118, t428, 1, (char)118, t429, 1, (char)118, t430, 1, (char)118, t431, 1, (char)118, t432, 1, (char)118, t433, 8, (char)118, t434, 64, (char)118, t30, 64);
    goto LAB215;

}

static void I380_3(char *t0)
{
    char t11[16];
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

LAB0:    t1 = (t0 + 12488U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(380, ng0);

LAB4:    xsi_set_current_line(381, ng0);
    t2 = ((char*)((ng23)));
    t3 = (t0 + 7212);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 64);
    xsi_set_current_line(381, ng0);
    t2 = ((char*)((ng23)));
    t3 = (t0 + 7304);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 64);
    xsi_set_current_line(381, ng0);
    t2 = ((char*)((ng23)));
    t3 = (t0 + 7396);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 64);
    xsi_set_current_line(381, ng0);
    t2 = ((char*)((ng23)));
    t3 = (t0 + 7488);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 64);
    xsi_set_current_line(381, ng0);
    t2 = ((char*)((ng23)));
    t3 = (t0 + 7580);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 64);
    xsi_set_current_line(381, ng0);
    t2 = ((char*)((ng23)));
    t3 = (t0 + 7672);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 64);
    xsi_set_current_line(381, ng0);
    t2 = ((char*)((ng23)));
    t3 = (t0 + 7764);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 64);
    xsi_set_current_line(381, ng0);
    t2 = ((char*)((ng23)));
    t3 = (t0 + 7856);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 64);
    xsi_set_current_line(382, ng0);
    t2 = ((char*)((ng24)));
    t3 = (t0 + 7948);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 8);
    xsi_set_current_line(382, ng0);
    t2 = ((char*)((ng24)));
    t3 = (t0 + 8040);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 8);
    xsi_set_current_line(382, ng0);
    t2 = ((char*)((ng24)));
    t3 = (t0 + 8132);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 8);
    xsi_set_current_line(382, ng0);
    t2 = ((char*)((ng24)));
    t3 = (t0 + 8224);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 8);
    xsi_set_current_line(382, ng0);
    t2 = ((char*)((ng24)));
    t3 = (t0 + 8316);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 8);
    xsi_set_current_line(382, ng0);
    t2 = ((char*)((ng24)));
    t3 = (t0 + 8408);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 8);
    xsi_set_current_line(382, ng0);
    t2 = ((char*)((ng24)));
    t3 = (t0 + 8500);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 8);
    xsi_set_current_line(382, ng0);
    t2 = ((char*)((ng24)));
    t3 = (t0 + 8592);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 8);
    xsi_set_current_line(383, ng0);
    t2 = ((char*)((ng24)));
    t3 = (t0 + 8684);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(383, ng0);
    t2 = ((char*)((ng24)));
    t3 = (t0 + 8776);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(383, ng0);
    t2 = ((char*)((ng24)));
    t3 = (t0 + 8868);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(383, ng0);
    t2 = ((char*)((ng24)));
    t3 = (t0 + 8960);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(383, ng0);
    t2 = ((char*)((ng24)));
    t3 = (t0 + 9052);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(383, ng0);
    t2 = ((char*)((ng24)));
    t3 = (t0 + 9144);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(383, ng0);
    t2 = ((char*)((ng24)));
    t3 = (t0 + 9236);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(383, ng0);
    t2 = ((char*)((ng24)));
    t3 = (t0 + 9328);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(384, ng0);
    t2 = ((char*)((ng25)));
    t3 = (t0 + 9420);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(384, ng0);
    t2 = ((char*)((ng25)));
    t3 = (t0 + 9512);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(384, ng0);
    t2 = ((char*)((ng25)));
    t3 = (t0 + 9604);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(384, ng0);
    t2 = ((char*)((ng25)));
    t3 = (t0 + 9696);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(384, ng0);
    t2 = ((char*)((ng25)));
    t3 = (t0 + 9788);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(384, ng0);
    t2 = ((char*)((ng25)));
    t3 = (t0 + 9880);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(384, ng0);
    t2 = ((char*)((ng25)));
    t3 = (t0 + 9972);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(384, ng0);
    t2 = ((char*)((ng25)));
    t3 = (t0 + 10064);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(385, ng0);
    t2 = ((char*)((ng25)));
    t3 = (t0 + 10156);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(385, ng0);
    t2 = ((char*)((ng25)));
    t3 = (t0 + 10248);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(385, ng0);
    t2 = ((char*)((ng26)));
    t3 = (t0 + 10340);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 72);
    xsi_set_current_line(385, ng0);
    t2 = ((char*)((ng2)));
    t3 = (t0 + 10432);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(386, ng0);
    t2 = ((char*)((ng24)));
    t3 = (t0 + 10524);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(386, ng0);
    t2 = ((char*)((ng3)));
    t3 = (t0 + 10616);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(386, ng0);
    t2 = ((char*)((ng24)));
    t3 = (t0 + 10708);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 23);
    xsi_set_current_line(386, ng0);
    t2 = ((char*)((ng24)));
    t3 = (t0 + 10800);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 32);
    xsi_set_current_line(388, ng0);
    t2 = ((char*)((ng3)));
    t3 = (t0 + 7120);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(389, ng0);
    t2 = ((char*)((ng20)));
    t3 = (t2 + 4U);
    t4 = *((unsigned int *)t3);
    t5 = (~(t4));
    t6 = *((unsigned int *)t2);
    t7 = (t6 & t5);
    t8 = (t0 + 17992);
    *((int *)t8) = t7;

LAB5:    t9 = (t0 + 17992);
    if (*((int *)t9) > 0)
        goto LAB6;

LAB7:    xsi_set_current_line(390, ng0);
    t2 = ((char*)((ng2)));
    t3 = (t0 + 7120);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(391, ng0);
    t2 = xsi_vlog_time(t11, 1000000.000000000, 1000.000000000000);
    xsi_vlogfile_write(1, 0, ng27, 2, t0, (char)118, t11, 64);
    xsi_set_current_line(394, ng0);
    xsi_vlogfile_write(1, 0, ng28, 1, t0);
    xsi_set_current_line(395, ng0);
    t2 = ((char*)((ng2)));
    t3 = ((char*)((ng29)));
    t8 = (t0 + 12404);
    t9 = (t0 + 2152);
    t10 = xsi_create_subprogram_invocation(t8, 0, t0, t9, 0, 0);
    xsi_vlog_subprogram_pushinvocation(t9, t10);
    t12 = (t0 + 11168);
    xsi_vlogvar_assign_value(t12, t2, 0, 0, 9);
    t13 = (t0 + 11260);
    xsi_vlogvar_assign_value(t13, t3, 0, 0, 32);

LAB10:    t14 = (t0 + 12452);
    t15 = *((char **)t14);
    t16 = (t15 + 40U);
    t17 = *((char **)t16);
    t18 = (t17 + 132U);
    t19 = *((char **)t18);
    t20 = (t19 + 0U);
    t21 = *((char **)t20);
    t7 = ((int  (*)(char *, char *))t21)(t0, t15);
    if (t7 != 0)
        goto LAB12;

LAB11:    t15 = (t0 + 2152);
    xsi_vlog_subprogram_popinvocation(t15);

LAB9:    t22 = (t0 + 12452);
    t23 = *((char **)t22);
    t22 = (t0 + 2152);
    t24 = (t0 + 12452);
    t25 = *((char **)t24);
    t24 = (t0 + 12404);
    t26 = 0;
    xsi_delete_subprogram_invocation(t22, t25, t0, t24, t26);
    xsi_set_current_line(396, ng0);
    t2 = ((char*)((ng7)));
    t3 = ((char*)((ng30)));
    t8 = (t0 + 12404);
    t9 = (t0 + 1672);
    t10 = xsi_create_subprogram_invocation(t8, 0, t0, t9, 0, 0);
    xsi_vlog_subprogram_pushinvocation(t9, t10);
    t12 = (t0 + 10892);
    xsi_vlogvar_assign_value(t12, t2, 0, 0, 23);
    t13 = (t0 + 10984);
    xsi_vlogvar_assign_value(t13, t3, 0, 0, 32);

LAB14:    t14 = (t0 + 12452);
    t15 = *((char **)t14);
    t16 = (t15 + 40U);
    t17 = *((char **)t16);
    t18 = (t17 + 132U);
    t19 = *((char **)t18);
    t20 = (t19 + 0U);
    t21 = *((char **)t20);
    t7 = ((int  (*)(char *, char *))t21)(t0, t15);
    if (t7 != 0)
        goto LAB16;

LAB15:    t15 = (t0 + 1672);
    xsi_vlog_subprogram_popinvocation(t15);

LAB13:    t22 = (t0 + 12452);
    t23 = *((char **)t22);
    t22 = (t0 + 1672);
    t24 = (t0 + 12452);
    t25 = *((char **)t24);
    t24 = (t0 + 12404);
    t26 = 0;
    xsi_delete_subprogram_invocation(t22, t25, t0, t24, t26);
    xsi_set_current_line(397, ng0);
    t2 = (t0 + 12404);
    t3 = (t0 + 2872);
    t8 = xsi_create_subprogram_invocation(t2, 0, t0, t3, 0, 0);
    xsi_vlog_subprogram_pushinvocation(t3, t8);

LAB18:    t9 = (t0 + 12452);
    t10 = *((char **)t9);
    t12 = (t10 + 40U);
    t13 = *((char **)t12);
    t14 = (t13 + 132U);
    t15 = *((char **)t14);
    t16 = (t15 + 0U);
    t17 = *((char **)t16);
    t7 = ((int  (*)(char *, char *))t17)(t0, t10);
    if (t7 != 0)
        goto LAB20;

LAB19:    t10 = (t0 + 2872);
    xsi_vlog_subprogram_popinvocation(t10);

LAB17:    t18 = (t0 + 12452);
    t19 = *((char **)t18);
    t18 = (t0 + 2872);
    t20 = (t0 + 12452);
    t21 = *((char **)t20);
    t20 = (t0 + 12404);
    t22 = 0;
    xsi_delete_subprogram_invocation(t18, t21, t0, t20, t22);
    xsi_set_current_line(400, ng0);
    xsi_vlogfile_write(1, 0, ng31, 1, t0);
    xsi_set_current_line(401, ng0);
    t2 = ((char*)((ng2)));
    t3 = ((char*)((ng32)));
    t8 = (t0 + 12404);
    t9 = (t0 + 2392);
    t10 = xsi_create_subprogram_invocation(t8, 0, t0, t9, 0, 0);
    xsi_vlog_subprogram_pushinvocation(t9, t10);
    t12 = (t0 + 11352);
    xsi_vlogvar_assign_value(t12, t2, 0, 0, 9);
    t13 = (t0 + 11444);
    xsi_vlogvar_assign_value(t13, t3, 0, 0, 32);

LAB22:    t14 = (t0 + 12452);
    t15 = *((char **)t14);
    t16 = (t15 + 40U);
    t17 = *((char **)t16);
    t18 = (t17 + 132U);
    t19 = *((char **)t18);
    t20 = (t19 + 0U);
    t21 = *((char **)t20);
    t7 = ((int  (*)(char *, char *))t21)(t0, t15);
    if (t7 != 0)
        goto LAB24;

LAB23:    t15 = (t0 + 2392);
    xsi_vlog_subprogram_popinvocation(t15);

LAB21:    t22 = (t0 + 12452);
    t23 = *((char **)t22);
    t22 = (t0 + 2392);
    t24 = (t0 + 12452);
    t25 = *((char **)t24);
    t24 = (t0 + 12404);
    t26 = 0;
    xsi_delete_subprogram_invocation(t22, t25, t0, t24, t26);
    xsi_set_current_line(402, ng0);
    t2 = ((char*)((ng3)));
    t3 = ((char*)((ng33)));
    t8 = (t0 + 12404);
    t9 = (t0 + 2392);
    t10 = xsi_create_subprogram_invocation(t8, 0, t0, t9, 0, 0);
    xsi_vlog_subprogram_pushinvocation(t9, t10);
    t12 = (t0 + 11352);
    xsi_vlogvar_assign_value(t12, t2, 0, 0, 9);
    t13 = (t0 + 11444);
    xsi_vlogvar_assign_value(t13, t3, 0, 0, 32);

LAB26:    t14 = (t0 + 12452);
    t15 = *((char **)t14);
    t16 = (t15 + 40U);
    t17 = *((char **)t16);
    t18 = (t17 + 132U);
    t19 = *((char **)t18);
    t20 = (t19 + 0U);
    t21 = *((char **)t20);
    t7 = ((int  (*)(char *, char *))t21)(t0, t15);
    if (t7 != 0)
        goto LAB28;

LAB27:    t15 = (t0 + 2392);
    xsi_vlog_subprogram_popinvocation(t15);

LAB25:    t22 = (t0 + 12452);
    t23 = *((char **)t22);
    t22 = (t0 + 2392);
    t24 = (t0 + 12452);
    t25 = *((char **)t24);
    t24 = (t0 + 12404);
    t26 = 0;
    xsi_delete_subprogram_invocation(t22, t25, t0, t24, t26);
    xsi_set_current_line(403, ng0);
    t2 = ((char*)((ng34)));
    t3 = ((char*)((ng33)));
    t8 = (t0 + 12404);
    t9 = (t0 + 2392);
    t10 = xsi_create_subprogram_invocation(t8, 0, t0, t9, 0, 0);
    xsi_vlog_subprogram_pushinvocation(t9, t10);
    t12 = (t0 + 11352);
    xsi_vlogvar_assign_value(t12, t2, 0, 0, 9);
    t13 = (t0 + 11444);
    xsi_vlogvar_assign_value(t13, t3, 0, 0, 32);

LAB30:    t14 = (t0 + 12452);
    t15 = *((char **)t14);
    t16 = (t15 + 40U);
    t17 = *((char **)t16);
    t18 = (t17 + 132U);
    t19 = *((char **)t18);
    t20 = (t19 + 0U);
    t21 = *((char **)t20);
    t7 = ((int  (*)(char *, char *))t21)(t0, t15);
    if (t7 != 0)
        goto LAB32;

LAB31:    t15 = (t0 + 2392);
    xsi_vlog_subprogram_popinvocation(t15);

LAB29:    t22 = (t0 + 12452);
    t23 = *((char **)t22);
    t22 = (t0 + 2392);
    t24 = (t0 + 12452);
    t25 = *((char **)t24);
    t24 = (t0 + 12404);
    t26 = 0;
    xsi_delete_subprogram_invocation(t22, t25, t0, t24, t26);
    xsi_set_current_line(404, ng0);
    t2 = ((char*)((ng35)));
    t3 = ((char*)((ng33)));
    t8 = (t0 + 12404);
    t9 = (t0 + 2392);
    t10 = xsi_create_subprogram_invocation(t8, 0, t0, t9, 0, 0);
    xsi_vlog_subprogram_pushinvocation(t9, t10);
    t12 = (t0 + 11352);
    xsi_vlogvar_assign_value(t12, t2, 0, 0, 9);
    t13 = (t0 + 11444);
    xsi_vlogvar_assign_value(t13, t3, 0, 0, 32);

LAB34:    t14 = (t0 + 12452);
    t15 = *((char **)t14);
    t16 = (t15 + 40U);
    t17 = *((char **)t16);
    t18 = (t17 + 132U);
    t19 = *((char **)t18);
    t20 = (t19 + 0U);
    t21 = *((char **)t20);
    t7 = ((int  (*)(char *, char *))t21)(t0, t15);
    if (t7 != 0)
        goto LAB36;

LAB35:    t15 = (t0 + 2392);
    xsi_vlog_subprogram_popinvocation(t15);

LAB33:    t22 = (t0 + 12452);
    t23 = *((char **)t22);
    t22 = (t0 + 2392);
    t24 = (t0 + 12452);
    t25 = *((char **)t24);
    t24 = (t0 + 12404);
    t26 = 0;
    xsi_delete_subprogram_invocation(t22, t25, t0, t24, t26);
    xsi_set_current_line(405, ng0);
    t2 = ((char*)((ng36)));
    t3 = ((char*)((ng33)));
    t8 = (t0 + 12404);
    t9 = (t0 + 2392);
    t10 = xsi_create_subprogram_invocation(t8, 0, t0, t9, 0, 0);
    xsi_vlog_subprogram_pushinvocation(t9, t10);
    t12 = (t0 + 11352);
    xsi_vlogvar_assign_value(t12, t2, 0, 0, 9);
    t13 = (t0 + 11444);
    xsi_vlogvar_assign_value(t13, t3, 0, 0, 32);

LAB38:    t14 = (t0 + 12452);
    t15 = *((char **)t14);
    t16 = (t15 + 40U);
    t17 = *((char **)t16);
    t18 = (t17 + 132U);
    t19 = *((char **)t18);
    t20 = (t19 + 0U);
    t21 = *((char **)t20);
    t7 = ((int  (*)(char *, char *))t21)(t0, t15);
    if (t7 != 0)
        goto LAB40;

LAB39:    t15 = (t0 + 2392);
    xsi_vlog_subprogram_popinvocation(t15);

LAB37:    t22 = (t0 + 12452);
    t23 = *((char **)t22);
    t22 = (t0 + 2392);
    t24 = (t0 + 12452);
    t25 = *((char **)t24);
    t24 = (t0 + 12404);
    t26 = 0;
    xsi_delete_subprogram_invocation(t22, t25, t0, t24, t26);
    xsi_set_current_line(406, ng0);
    t2 = ((char*)((ng37)));
    t3 = ((char*)((ng38)));
    t8 = (t0 + 12404);
    t9 = (t0 + 2392);
    t10 = xsi_create_subprogram_invocation(t8, 0, t0, t9, 0, 0);
    xsi_vlog_subprogram_pushinvocation(t9, t10);
    t12 = (t0 + 11352);
    xsi_vlogvar_assign_value(t12, t2, 0, 0, 9);
    t13 = (t0 + 11444);
    xsi_vlogvar_assign_value(t13, t3, 0, 0, 32);

LAB42:    t14 = (t0 + 12452);
    t15 = *((char **)t14);
    t16 = (t15 + 40U);
    t17 = *((char **)t16);
    t18 = (t17 + 132U);
    t19 = *((char **)t18);
    t20 = (t19 + 0U);
    t21 = *((char **)t20);
    t7 = ((int  (*)(char *, char *))t21)(t0, t15);
    if (t7 != 0)
        goto LAB44;

LAB43:    t15 = (t0 + 2392);
    xsi_vlog_subprogram_popinvocation(t15);

LAB41:    t22 = (t0 + 12452);
    t23 = *((char **)t22);
    t22 = (t0 + 2392);
    t24 = (t0 + 12452);
    t25 = *((char **)t24);
    t24 = (t0 + 12404);
    t26 = 0;
    xsi_delete_subprogram_invocation(t22, t25, t0, t24, t26);
    xsi_set_current_line(407, ng0);
    t2 = ((char*)((ng39)));
    t3 = ((char*)((ng40)));
    t8 = (t0 + 12404);
    t9 = (t0 + 2392);
    t10 = xsi_create_subprogram_invocation(t8, 0, t0, t9, 0, 0);
    xsi_vlog_subprogram_pushinvocation(t9, t10);
    t12 = (t0 + 11352);
    xsi_vlogvar_assign_value(t12, t2, 0, 0, 9);
    t13 = (t0 + 11444);
    xsi_vlogvar_assign_value(t13, t3, 0, 0, 32);

LAB46:    t14 = (t0 + 12452);
    t15 = *((char **)t14);
    t16 = (t15 + 40U);
    t17 = *((char **)t16);
    t18 = (t17 + 132U);
    t19 = *((char **)t18);
    t20 = (t19 + 0U);
    t21 = *((char **)t20);
    t7 = ((int  (*)(char *, char *))t21)(t0, t15);
    if (t7 != 0)
        goto LAB48;

LAB47:    t15 = (t0 + 2392);
    xsi_vlog_subprogram_popinvocation(t15);

LAB45:    t22 = (t0 + 12452);
    t23 = *((char **)t22);
    t22 = (t0 + 2392);
    t24 = (t0 + 12452);
    t25 = *((char **)t24);
    t24 = (t0 + 12404);
    t26 = 0;
    xsi_delete_subprogram_invocation(t22, t25, t0, t24, t26);
    xsi_set_current_line(408, ng0);
    t2 = ((char*)((ng41)));
    t3 = ((char*)((ng40)));
    t8 = (t0 + 12404);
    t9 = (t0 + 2392);
    t10 = xsi_create_subprogram_invocation(t8, 0, t0, t9, 0, 0);
    xsi_vlog_subprogram_pushinvocation(t9, t10);
    t12 = (t0 + 11352);
    xsi_vlogvar_assign_value(t12, t2, 0, 0, 9);
    t13 = (t0 + 11444);
    xsi_vlogvar_assign_value(t13, t3, 0, 0, 32);

LAB50:    t14 = (t0 + 12452);
    t15 = *((char **)t14);
    t16 = (t15 + 40U);
    t17 = *((char **)t16);
    t18 = (t17 + 132U);
    t19 = *((char **)t18);
    t20 = (t19 + 0U);
    t21 = *((char **)t20);
    t7 = ((int  (*)(char *, char *))t21)(t0, t15);
    if (t7 != 0)
        goto LAB52;

LAB51:    t15 = (t0 + 2392);
    xsi_vlog_subprogram_popinvocation(t15);

LAB49:    t22 = (t0 + 12452);
    t23 = *((char **)t22);
    t22 = (t0 + 2392);
    t24 = (t0 + 12452);
    t25 = *((char **)t24);
    t24 = (t0 + 12404);
    t26 = 0;
    xsi_delete_subprogram_invocation(t22, t25, t0, t24, t26);
    xsi_set_current_line(409, ng0);
    t2 = ((char*)((ng13)));
    t3 = ((char*)((ng40)));
    t8 = (t0 + 12404);
    t9 = (t0 + 2392);
    t10 = xsi_create_subprogram_invocation(t8, 0, t0, t9, 0, 0);
    xsi_vlog_subprogram_pushinvocation(t9, t10);
    t12 = (t0 + 11352);
    xsi_vlogvar_assign_value(t12, t2, 0, 0, 9);
    t13 = (t0 + 11444);
    xsi_vlogvar_assign_value(t13, t3, 0, 0, 32);

LAB54:    t14 = (t0 + 12452);
    t15 = *((char **)t14);
    t16 = (t15 + 40U);
    t17 = *((char **)t16);
    t18 = (t17 + 132U);
    t19 = *((char **)t18);
    t20 = (t19 + 0U);
    t21 = *((char **)t20);
    t7 = ((int  (*)(char *, char *))t21)(t0, t15);
    if (t7 != 0)
        goto LAB56;

LAB55:    t15 = (t0 + 2392);
    xsi_vlog_subprogram_popinvocation(t15);

LAB53:    t22 = (t0 + 12452);
    t23 = *((char **)t22);
    t22 = (t0 + 2392);
    t24 = (t0 + 12452);
    t25 = *((char **)t24);
    t24 = (t0 + 12404);
    t26 = 0;
    xsi_delete_subprogram_invocation(t22, t25, t0, t24, t26);
    xsi_set_current_line(410, ng0);
    t2 = ((char*)((ng42)));
    t3 = ((char*)((ng40)));
    t8 = (t0 + 12404);
    t9 = (t0 + 2392);
    t10 = xsi_create_subprogram_invocation(t8, 0, t0, t9, 0, 0);
    xsi_vlog_subprogram_pushinvocation(t9, t10);
    t12 = (t0 + 11352);
    xsi_vlogvar_assign_value(t12, t2, 0, 0, 9);
    t13 = (t0 + 11444);
    xsi_vlogvar_assign_value(t13, t3, 0, 0, 32);

LAB58:    t14 = (t0 + 12452);
    t15 = *((char **)t14);
    t16 = (t15 + 40U);
    t17 = *((char **)t16);
    t18 = (t17 + 132U);
    t19 = *((char **)t18);
    t20 = (t19 + 0U);
    t21 = *((char **)t20);
    t7 = ((int  (*)(char *, char *))t21)(t0, t15);
    if (t7 != 0)
        goto LAB60;

LAB59:    t15 = (t0 + 2392);
    xsi_vlog_subprogram_popinvocation(t15);

LAB57:    t22 = (t0 + 12452);
    t23 = *((char **)t22);
    t22 = (t0 + 2392);
    t24 = (t0 + 12452);
    t25 = *((char **)t24);
    t24 = (t0 + 12404);
    t26 = 0;
    xsi_delete_subprogram_invocation(t22, t25, t0, t24, t26);
    xsi_set_current_line(411, ng0);
    t2 = ((char*)((ng43)));
    t3 = ((char*)((ng44)));
    t8 = (t0 + 12404);
    t9 = (t0 + 2392);
    t10 = xsi_create_subprogram_invocation(t8, 0, t0, t9, 0, 0);
    xsi_vlog_subprogram_pushinvocation(t9, t10);
    t12 = (t0 + 11352);
    xsi_vlogvar_assign_value(t12, t2, 0, 0, 9);
    t13 = (t0 + 11444);
    xsi_vlogvar_assign_value(t13, t3, 0, 0, 32);

LAB62:    t14 = (t0 + 12452);
    t15 = *((char **)t14);
    t16 = (t15 + 40U);
    t17 = *((char **)t16);
    t18 = (t17 + 132U);
    t19 = *((char **)t18);
    t20 = (t19 + 0U);
    t21 = *((char **)t20);
    t7 = ((int  (*)(char *, char *))t21)(t0, t15);
    if (t7 != 0)
        goto LAB64;

LAB63:    t15 = (t0 + 2392);
    xsi_vlog_subprogram_popinvocation(t15);

LAB61:    t22 = (t0 + 12452);
    t23 = *((char **)t22);
    t22 = (t0 + 2392);
    t24 = (t0 + 12452);
    t25 = *((char **)t24);
    t24 = (t0 + 12404);
    t26 = 0;
    xsi_delete_subprogram_invocation(t22, t25, t0, t24, t26);
    xsi_set_current_line(412, ng0);
    t2 = ((char*)((ng45)));
    t3 = ((char*)((ng40)));
    t8 = (t0 + 12404);
    t9 = (t0 + 2392);
    t10 = xsi_create_subprogram_invocation(t8, 0, t0, t9, 0, 0);
    xsi_vlog_subprogram_pushinvocation(t9, t10);
    t12 = (t0 + 11352);
    xsi_vlogvar_assign_value(t12, t2, 0, 0, 9);
    t13 = (t0 + 11444);
    xsi_vlogvar_assign_value(t13, t3, 0, 0, 32);

LAB66:    t14 = (t0 + 12452);
    t15 = *((char **)t14);
    t16 = (t15 + 40U);
    t17 = *((char **)t16);
    t18 = (t17 + 132U);
    t19 = *((char **)t18);
    t20 = (t19 + 0U);
    t21 = *((char **)t20);
    t7 = ((int  (*)(char *, char *))t21)(t0, t15);
    if (t7 != 0)
        goto LAB68;

LAB67:    t15 = (t0 + 2392);
    xsi_vlog_subprogram_popinvocation(t15);

LAB65:    t22 = (t0 + 12452);
    t23 = *((char **)t22);
    t22 = (t0 + 2392);
    t24 = (t0 + 12452);
    t25 = *((char **)t24);
    t24 = (t0 + 12404);
    t26 = 0;
    xsi_delete_subprogram_invocation(t22, t25, t0, t24, t26);
    xsi_set_current_line(413, ng0);
    t2 = ((char*)((ng46)));
    t3 = ((char*)((ng47)));
    t8 = (t0 + 12404);
    t9 = (t0 + 2392);
    t10 = xsi_create_subprogram_invocation(t8, 0, t0, t9, 0, 0);
    xsi_vlog_subprogram_pushinvocation(t9, t10);
    t12 = (t0 + 11352);
    xsi_vlogvar_assign_value(t12, t2, 0, 0, 9);
    t13 = (t0 + 11444);
    xsi_vlogvar_assign_value(t13, t3, 0, 0, 32);

LAB70:    t14 = (t0 + 12452);
    t15 = *((char **)t14);
    t16 = (t15 + 40U);
    t17 = *((char **)t16);
    t18 = (t17 + 132U);
    t19 = *((char **)t18);
    t20 = (t19 + 0U);
    t21 = *((char **)t20);
    t7 = ((int  (*)(char *, char *))t21)(t0, t15);
    if (t7 != 0)
        goto LAB72;

LAB71:    t15 = (t0 + 2392);
    xsi_vlog_subprogram_popinvocation(t15);

LAB69:    t22 = (t0 + 12452);
    t23 = *((char **)t22);
    t22 = (t0 + 2392);
    t24 = (t0 + 12452);
    t25 = *((char **)t24);
    t24 = (t0 + 12404);
    t26 = 0;
    xsi_delete_subprogram_invocation(t22, t25, t0, t24, t26);
    xsi_set_current_line(414, ng0);
    t2 = ((char*)((ng48)));
    t3 = ((char*)((ng49)));
    t8 = (t0 + 12404);
    t9 = (t0 + 2392);
    t10 = xsi_create_subprogram_invocation(t8, 0, t0, t9, 0, 0);
    xsi_vlog_subprogram_pushinvocation(t9, t10);
    t12 = (t0 + 11352);
    xsi_vlogvar_assign_value(t12, t2, 0, 0, 9);
    t13 = (t0 + 11444);
    xsi_vlogvar_assign_value(t13, t3, 0, 0, 32);

LAB74:    t14 = (t0 + 12452);
    t15 = *((char **)t14);
    t16 = (t15 + 40U);
    t17 = *((char **)t16);
    t18 = (t17 + 132U);
    t19 = *((char **)t18);
    t20 = (t19 + 0U);
    t21 = *((char **)t20);
    t7 = ((int  (*)(char *, char *))t21)(t0, t15);
    if (t7 != 0)
        goto LAB76;

LAB75:    t15 = (t0 + 2392);
    xsi_vlog_subprogram_popinvocation(t15);

LAB73:    t22 = (t0 + 12452);
    t23 = *((char **)t22);
    t22 = (t0 + 2392);
    t24 = (t0 + 12452);
    t25 = *((char **)t24);
    t24 = (t0 + 12404);
    t26 = 0;
    xsi_delete_subprogram_invocation(t22, t25, t0, t24, t26);
    xsi_set_current_line(417, ng0);
    xsi_vlogfile_write(1, 0, ng50, 1, t0);
    xsi_set_current_line(418, ng0);
    t2 = ((char*)((ng51)));
    t3 = ((char*)((ng52)));
    t8 = (t0 + 12404);
    t9 = (t0 + 3112);
    t10 = xsi_create_subprogram_invocation(t8, 0, t0, t9, 0, 0);
    xsi_vlog_subprogram_pushinvocation(t9, t10);
    t12 = (t0 + 11536);
    xsi_vlogvar_assign_value(t12, t2, 0, 0, 8);
    t13 = (t0 + 11628);
    xsi_vlogvar_assign_value(t13, t3, 0, 0, 64);

LAB78:    t14 = (t0 + 12452);
    t15 = *((char **)t14);
    t16 = (t15 + 40U);
    t17 = *((char **)t16);
    t18 = (t17 + 132U);
    t19 = *((char **)t18);
    t20 = (t19 + 0U);
    t21 = *((char **)t20);
    t7 = ((int  (*)(char *, char *))t21)(t0, t15);
    if (t7 != 0)
        goto LAB80;

LAB79:    t15 = (t0 + 3112);
    xsi_vlog_subprogram_popinvocation(t15);

LAB77:    t22 = (t0 + 12452);
    t23 = *((char **)t22);
    t22 = (t0 + 3112);
    t24 = (t0 + 12452);
    t25 = *((char **)t24);
    t24 = (t0 + 12404);
    t26 = 0;
    xsi_delete_subprogram_invocation(t22, t25, t0, t24, t26);
    xsi_set_current_line(419, ng0);
    t2 = ((char*)((ng2)));
    t3 = ((char*)((ng53)));
    t8 = (t0 + 12404);
    t9 = (t0 + 3112);
    t10 = xsi_create_subprogram_invocation(t8, 0, t0, t9, 0, 0);
    xsi_vlog_subprogram_pushinvocation(t9, t10);
    t12 = (t0 + 11536);
    xsi_vlogvar_assign_value(t12, t2, 0, 0, 8);
    t13 = (t0 + 11628);
    xsi_vlogvar_assign_value(t13, t3, 0, 0, 64);

LAB82:    t14 = (t0 + 12452);
    t15 = *((char **)t14);
    t16 = (t15 + 40U);
    t17 = *((char **)t16);
    t18 = (t17 + 132U);
    t19 = *((char **)t18);
    t20 = (t19 + 0U);
    t21 = *((char **)t20);
    t7 = ((int  (*)(char *, char *))t21)(t0, t15);
    if (t7 != 0)
        goto LAB84;

LAB83:    t15 = (t0 + 3112);
    xsi_vlog_subprogram_popinvocation(t15);

LAB81:    t22 = (t0 + 12452);
    t23 = *((char **)t22);
    t22 = (t0 + 3112);
    t24 = (t0 + 12452);
    t25 = *((char **)t24);
    t24 = (t0 + 12404);
    t26 = 0;
    xsi_delete_subprogram_invocation(t22, t25, t0, t24, t26);
    xsi_set_current_line(420, ng0);
    t2 = ((char*)((ng3)));
    t3 = ((char*)((ng54)));
    t8 = (t0 + 12404);
    t9 = (t0 + 3112);
    t10 = xsi_create_subprogram_invocation(t8, 0, t0, t9, 0, 0);
    xsi_vlog_subprogram_pushinvocation(t9, t10);
    t12 = (t0 + 11536);
    xsi_vlogvar_assign_value(t12, t2, 0, 0, 8);
    t13 = (t0 + 11628);
    xsi_vlogvar_assign_value(t13, t3, 0, 0, 64);

LAB86:    t14 = (t0 + 12452);
    t15 = *((char **)t14);
    t16 = (t15 + 40U);
    t17 = *((char **)t16);
    t18 = (t17 + 132U);
    t19 = *((char **)t18);
    t20 = (t19 + 0U);
    t21 = *((char **)t20);
    t7 = ((int  (*)(char *, char *))t21)(t0, t15);
    if (t7 != 0)
        goto LAB88;

LAB87:    t15 = (t0 + 3112);
    xsi_vlog_subprogram_popinvocation(t15);

LAB85:    t22 = (t0 + 12452);
    t23 = *((char **)t22);
    t22 = (t0 + 3112);
    t24 = (t0 + 12452);
    t25 = *((char **)t24);
    t24 = (t0 + 12404);
    t26 = 0;
    xsi_delete_subprogram_invocation(t22, t25, t0, t24, t26);
    xsi_set_current_line(423, ng0);
    t2 = ((char*)((ng55)));
    t3 = (t2 + 4U);
    t4 = *((unsigned int *)t3);
    t5 = (~(t4));
    t6 = *((unsigned int *)t2);
    t7 = (t6 & t5);
    t8 = (t0 + 17996);
    *((int *)t8) = t7;

LAB89:    t9 = (t0 + 17996);
    if (*((int *)t9) > 0)
        goto LAB90;

LAB91:    xsi_set_current_line(424, ng0);
    xsi_vlogfile_write(1, 0, ng56, 1, t0);
    xsi_set_current_line(425, ng0);
    t2 = (t0 + 12404);
    t3 = (t0 + 2632);
    t8 = xsi_create_subprogram_invocation(t2, 0, t0, t3, 0, 0);
    xsi_vlog_subprogram_pushinvocation(t3, t8);

LAB94:    t9 = (t0 + 12452);
    t10 = *((char **)t9);
    t12 = (t10 + 40U);
    t13 = *((char **)t12);
    t14 = (t13 + 132U);
    t15 = *((char **)t14);
    t16 = (t15 + 0U);
    t17 = *((char **)t16);
    t7 = ((int  (*)(char *, char *))t17)(t0, t10);
    if (t7 != 0)
        goto LAB96;

LAB95:    t10 = (t0 + 2632);
    xsi_vlog_subprogram_popinvocation(t10);

LAB93:    t18 = (t0 + 12452);
    t19 = *((char **)t18);
    t18 = (t0 + 2632);
    t20 = (t0 + 12452);
    t21 = *((char **)t20);
    t20 = (t0 + 12404);
    t22 = 0;
    xsi_delete_subprogram_invocation(t18, t21, t0, t20, t22);
    xsi_set_current_line(427, ng0);
    t2 = ((char*)((ng57)));
    t3 = (t2 + 4U);
    t4 = *((unsigned int *)t3);
    t5 = (~(t4));
    t6 = *((unsigned int *)t2);
    t7 = (t6 & t5);
    t8 = (t0 + 18000);
    *((int *)t8) = t7;

LAB97:    t9 = (t0 + 18000);
    if (*((int *)t9) > 0)
        goto LAB98;

LAB99:    xsi_set_current_line(428, ng0);
    t2 = xsi_vlog_time(t11, 1000000.000000000, 1000.000000000000);
    xsi_vlogfile_write(1, 0, ng58, 2, t0, (char)118, t11, 64);
    xsi_set_current_line(429, ng0);
    xsi_vlog_finish(1);

LAB1:    return;
LAB6:    xsi_set_current_line(389, ng0);
    t10 = (t0 + 12852);
    *((int *)t10) = 1;
    *((char **)t1) = &&LAB8;
    goto LAB1;

LAB8:    t2 = (t0 + 17992);
    t7 = *((int *)t2);
    *((int *)t2) = (t7 - 1);
    goto LAB5;

LAB12:    t14 = (t0 + 12488U);
    *((char **)t14) = &&LAB10;
    goto LAB1;

LAB16:    t14 = (t0 + 12488U);
    *((char **)t14) = &&LAB14;
    goto LAB1;

LAB20:    t9 = (t0 + 12488U);
    *((char **)t9) = &&LAB18;
    goto LAB1;

LAB24:    t14 = (t0 + 12488U);
    *((char **)t14) = &&LAB22;
    goto LAB1;

LAB28:    t14 = (t0 + 12488U);
    *((char **)t14) = &&LAB26;
    goto LAB1;

LAB32:    t14 = (t0 + 12488U);
    *((char **)t14) = &&LAB30;
    goto LAB1;

LAB36:    t14 = (t0 + 12488U);
    *((char **)t14) = &&LAB34;
    goto LAB1;

LAB40:    t14 = (t0 + 12488U);
    *((char **)t14) = &&LAB38;
    goto LAB1;

LAB44:    t14 = (t0 + 12488U);
    *((char **)t14) = &&LAB42;
    goto LAB1;

LAB48:    t14 = (t0 + 12488U);
    *((char **)t14) = &&LAB46;
    goto LAB1;

LAB52:    t14 = (t0 + 12488U);
    *((char **)t14) = &&LAB50;
    goto LAB1;

LAB56:    t14 = (t0 + 12488U);
    *((char **)t14) = &&LAB54;
    goto LAB1;

LAB60:    t14 = (t0 + 12488U);
    *((char **)t14) = &&LAB58;
    goto LAB1;

LAB64:    t14 = (t0 + 12488U);
    *((char **)t14) = &&LAB62;
    goto LAB1;

LAB68:    t14 = (t0 + 12488U);
    *((char **)t14) = &&LAB66;
    goto LAB1;

LAB72:    t14 = (t0 + 12488U);
    *((char **)t14) = &&LAB70;
    goto LAB1;

LAB76:    t14 = (t0 + 12488U);
    *((char **)t14) = &&LAB74;
    goto LAB1;

LAB80:    t14 = (t0 + 12488U);
    *((char **)t14) = &&LAB78;
    goto LAB1;

LAB84:    t14 = (t0 + 12488U);
    *((char **)t14) = &&LAB82;
    goto LAB1;

LAB88:    t14 = (t0 + 12488U);
    *((char **)t14) = &&LAB86;
    goto LAB1;

LAB90:    xsi_set_current_line(423, ng0);
    t10 = (t0 + 12860);
    *((int *)t10) = 1;
    *((char **)t1) = &&LAB92;
    goto LAB1;

LAB92:    t2 = (t0 + 17996);
    t7 = *((int *)t2);
    *((int *)t2) = (t7 - 1);
    goto LAB89;

LAB96:    t9 = (t0 + 12488U);
    *((char **)t9) = &&LAB94;
    goto LAB1;

LAB98:    xsi_set_current_line(427, ng0);
    t10 = (t0 + 12868);
    *((int *)t10) = 1;
    *((char **)t1) = &&LAB100;
    goto LAB1;

LAB100:    t2 = (t0 + 18000);
    t7 = *((int *)t2);
    *((int *)t2) = (t7 - 1);
    goto LAB97;

}

static void I432_4(char *t0)
{
    char t3[16];
    char *t1;
    char *t2;

LAB0:    t1 = (t0 + 12616U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(432, ng0);

LAB4:    xsi_set_current_line(433, ng0);
    t2 = (t0 + 12532);
    xsi_process_wait(t2, 400000000000LL);
    *((char **)t1) = &&LAB5;

LAB1:    return;
LAB5:    xsi_set_current_line(434, ng0);
    t2 = xsi_vlog_time(t3, 1000000.000000000, 1000.000000000000);
    xsi_vlogfile_write(1, 0, ng59, 2, t0, (char)118, t3, 64);
    xsi_set_current_line(435, ng0);
    xsi_vlog_finish(1);
    goto LAB1;

}


extern void work_m_00000000000408929016_4096408752_init()
{
	static char *pe[] = {(void *)I277_0,(void *)A278_1,(void *)A357_2,(void *)I380_3,(void *)I432_4};
	static char *se[] = {(void *)sp_reg_write,(void *)sp_pulse_input_type,(void *)sp_write_gpu_imem,(void *)sp_arm_imem_write_udp,(void *)sp_pulse_cpu_start_udp,(void *)sp_pulse_gpu_start_udp,(void *)sp_send_word_in0};
	xsi_register_didat("work_m_00000000000408929016_4096408752", "isim/_tmp/work/m_00000000000408929016_4096408752.didat");
	xsi_register_executes(pe);
	xsi_register_subprogram_executes(se);
}
