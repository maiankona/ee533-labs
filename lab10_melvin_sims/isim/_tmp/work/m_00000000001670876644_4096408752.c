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
static unsigned int ng1[] = {0U, 0U};
static unsigned int ng2[] = {1U, 0U};
static unsigned int ng3[] = {132U, 0U};
static unsigned int ng4[] = {131U, 0U};
static unsigned int ng5[] = {130U, 0U};
static unsigned int ng6[] = {64U, 0U};
static unsigned int ng7[] = {32U, 0U};
static unsigned int ng8[] = {0U, 0U, 0U, 0U};
static const char *ng9 = "[TB] RX word into ids: ctrl=%02h data=%016h t=%0t";
static int ng10[] = {71, 0};
static int ng11[] = {64, 0};
static const char *ng12 = "[TB] TX word from user_data_path: out_wr=%b%b%b%b%b%b%b%b ctrl0=%02h data0=%016h t=%0t";
static int ng13[] = {0, 0, 0, 0};
static int ng14[] = {0, 0};
static int ng15[] = {1, 0};
static unsigned int ng16[] = {0U, 0U, 0U, 0U, 0U, 0U};
static int ng17[] = {5, 0};
static const char *ng18 = "\n=== tb_udp_packet_user_data_path: reset released @ %0t ===";
static const char *ng19 = "[TB] Loading minimal GPU program (HALT) and pulsing GPU start...";
static unsigned int ng20[] = {738197504U, 0U};
static unsigned int ng21[] = {256U, 0U};
static unsigned int ng22[] = {8U, 0U};
static const char *ng23 = "[TB] Loading ARM IMEM via UDP (input_type[6] arm_write_to_imem)...";
static unsigned int ng24[] = {3818926080U, 0U};
static unsigned int ng25[] = {3800248384U, 0U};
static unsigned int ng26[] = {2U, 0U};
static unsigned int ng27[] = {3U, 0U};
static unsigned int ng28[] = {4U, 0U};
static unsigned int ng29[] = {5U, 0U};
static unsigned int ng30[] = {3818917889U, 0U};
static unsigned int ng31[] = {6U, 0U};
static unsigned int ng32[] = {3785359360U, 0U};
static unsigned int ng33[] = {7U, 0U};
static unsigned int ng34[] = {9U, 0U};
static unsigned int ng35[] = {10U, 0U};
static unsigned int ng36[] = {3851616260U, 0U};
static unsigned int ng37[] = {11U, 0U};
static unsigned int ng38[] = {12U, 0U};
static unsigned int ng39[] = {3850571784U, 0U};
static unsigned int ng40[] = {13U, 0U};
static unsigned int ng41[] = {3942645758U, 0U};
static const char *ng42 = "[TB] Injecting single packet on in_0...";
static unsigned int ng43[] = {255U, 0U};
static unsigned int ng44[] = {1432778632U, 0U, 287454020U, 0U};
static unsigned int ng45[] = {3405691582U, 0U, 3735928559U, 0U};
static unsigned int ng46[] = {1515870810U, 0U, 2779096485U, 0U};
static int ng47[] = {40, 0};
static const char *ng48 = "[TB] Pulsing ARM cpu_start (UDP input_type[5])...";
static int ng49[] = {120, 0};
static const char *ng50 = "=== tb_udp_packet_user_data_path done @ %0t ===\n";
static const char *ng51 = "[TB] TIMEOUT @ %0t";



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

LAB2:    t4 = (t1 + 1672);
    xsi_vlog_subprogram_setdisablestate(t4, &&LAB4);
    xsi_set_current_line(283, ng0);

LAB5:    xsi_set_current_line(284, ng0);
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

LAB6:    xsi_set_current_line(285, ng0);
    t4 = (t1 + 10652);
    t5 = (t4 + 32U);
    t6 = *((char **)t5);
    t7 = (t1 + 10468);
    xsi_vlogvar_assign_value(t7, t6, 0, 0, 23);
    xsi_set_current_line(286, ng0);
    t4 = (t1 + 10744);
    t5 = (t4 + 32U);
    t6 = *((char **)t5);
    t7 = (t1 + 10560);
    xsi_vlogvar_assign_value(t7, t6, 0, 0, 32);
    xsi_set_current_line(287, ng0);
    t4 = ((char*)((ng1)));
    t5 = (t1 + 10376);
    xsi_vlogvar_assign_value(t5, t4, 0, 0, 1);
    xsi_set_current_line(288, ng0);
    t4 = ((char*)((ng2)));
    t5 = (t1 + 10284);
    xsi_vlogvar_assign_value(t5, t4, 0, 0, 1);
    xsi_set_current_line(289, ng0);
    t4 = (t2 + 44U);
    t5 = *((char **)t4);
    t6 = (t5 + 8U);
    xsi_wp_set_status(t6, 1);
    *((char **)t3) = &&LAB7;
    goto LAB1;

LAB7:    xsi_set_current_line(290, ng0);
    t4 = (t2 + 44U);
    t5 = *((char **)t4);
    t6 = (t5 + 16U);
    xsi_wp_set_status(t6, 1);
    *((char **)t3) = &&LAB8;
    goto LAB1;

LAB8:    xsi_set_current_line(291, ng0);
    t4 = ((char*)((ng1)));
    t5 = (t1 + 10284);
    xsi_vlogvar_assign_value(t5, t4, 0, 0, 1);
    xsi_set_current_line(292, ng0);
    t4 = ((char*)((ng2)));
    t5 = (t1 + 10376);
    xsi_vlogvar_assign_value(t5, t4, 0, 0, 1);
    goto LAB4;

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
    xsi_set_current_line(298, ng0);

LAB5:    xsi_set_current_line(299, ng0);
    t5 = ((char*)((ng3)));
    t6 = (t1 + 10836);
    t7 = (t6 + 32U);
    t8 = *((char **)t7);
    t9 = (t2 + 28U);
    t10 = *((char **)t9);
    t11 = (t1 + 1672);
    t12 = xsi_create_subprogram_invocation(t10, 0, t1, t11, 0, t2);
    xsi_vlog_subprogram_pushinvocation(t11, t12);
    t13 = (t1 + 10652);
    xsi_vlogvar_assign_value(t13, t5, 0, 0, 23);
    t14 = (t1 + 10744);
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
    xsi_set_current_line(300, ng0);
    t4 = ((char*)((ng3)));
    t5 = ((char*)((ng1)));
    t6 = (t2 + 28U);
    t7 = *((char **)t6);
    t8 = (t1 + 1672);
    t9 = xsi_create_subprogram_invocation(t7, 0, t1, t8, 0, t2);
    xsi_vlog_subprogram_pushinvocation(t8, t9);
    t10 = (t1 + 10652);
    xsi_vlogvar_assign_value(t10, t4, 0, 0, 23);
    t11 = (t1 + 10744);
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

LAB12:    t13 = (t1 + 1672);
    xsi_vlog_subprogram_popinvocation(t13);

LAB10:    t20 = (t2 + 32U);
    t21 = *((char **)t20);
    t20 = (t1 + 1672);
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
    xsi_set_current_line(307, ng0);

LAB5:    xsi_set_current_line(308, ng0);
    t5 = ((char*)((ng4)));
    t7 = (t1 + 10928);
    t8 = (t7 + 32U);
    t9 = *((char **)t8);
    t10 = ((char*)((ng1)));
    xsi_vlogtype_concat(t6, 32, 32, 2U, t10, 23, t9, 9);
    t11 = (t2 + 28U);
    t12 = *((char **)t11);
    t13 = (t1 + 1672);
    t14 = xsi_create_subprogram_invocation(t12, 0, t1, t13, 0, t2);
    xsi_vlog_subprogram_pushinvocation(t13, t14);
    t15 = (t1 + 10652);
    xsi_vlogvar_assign_value(t15, t5, 0, 0, 23);
    t16 = (t1 + 10744);
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
    xsi_set_current_line(309, ng0);
    t4 = ((char*)((ng5)));
    t5 = (t1 + 11020);
    t7 = (t5 + 32U);
    t8 = *((char **)t7);
    t9 = (t2 + 28U);
    t10 = *((char **)t9);
    t11 = (t1 + 1672);
    t12 = xsi_create_subprogram_invocation(t10, 0, t1, t11, 0, t2);
    xsi_vlog_subprogram_pushinvocation(t11, t12);
    t13 = (t1 + 10652);
    xsi_vlogvar_assign_value(t13, t4, 0, 0, 23);
    t14 = (t1 + 10744);
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
    xsi_set_current_line(310, ng0);
    t4 = ((char*)((ng2)));
    t5 = (t2 + 28U);
    t7 = *((char **)t5);
    t8 = (t1 + 1912);
    t9 = xsi_create_subprogram_invocation(t7, 0, t1, t8, 0, t2);
    xsi_vlog_subprogram_pushinvocation(t8, t9);
    t10 = (t1 + 10836);
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
    xsi_set_current_line(317, ng0);

LAB5:    xsi_set_current_line(318, ng0);
    t5 = ((char*)((ng4)));
    t7 = (t1 + 11112);
    t8 = (t7 + 32U);
    t9 = *((char **)t8);
    t10 = ((char*)((ng1)));
    xsi_vlogtype_concat(t6, 32, 32, 2U, t10, 23, t9, 9);
    t11 = (t2 + 28U);
    t12 = *((char **)t11);
    t13 = (t1 + 1672);
    t14 = xsi_create_subprogram_invocation(t12, 0, t1, t13, 0, t2);
    xsi_vlog_subprogram_pushinvocation(t13, t14);
    t15 = (t1 + 10652);
    xsi_vlogvar_assign_value(t15, t5, 0, 0, 23);
    t16 = (t1 + 10744);
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
    xsi_set_current_line(319, ng0);
    t4 = ((char*)((ng5)));
    t5 = (t1 + 11204);
    t7 = (t5 + 32U);
    t8 = *((char **)t7);
    t9 = (t2 + 28U);
    t10 = *((char **)t9);
    t11 = (t1 + 1672);
    t12 = xsi_create_subprogram_invocation(t10, 0, t1, t11, 0, t2);
    xsi_vlog_subprogram_pushinvocation(t11, t12);
    t13 = (t1 + 10652);
    xsi_vlogvar_assign_value(t13, t4, 0, 0, 23);
    t14 = (t1 + 10744);
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
    xsi_set_current_line(320, ng0);
    t4 = ((char*)((ng6)));
    t5 = (t2 + 28U);
    t7 = *((char **)t5);
    t8 = (t1 + 1912);
    t9 = xsi_create_subprogram_invocation(t7, 0, t1, t8, 0, t2);
    xsi_vlog_subprogram_pushinvocation(t8, t9);
    t10 = (t1 + 10836);
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
    xsi_set_current_line(325, ng0);

LAB5:    xsi_set_current_line(326, ng0);
    t5 = ((char*)((ng7)));
    t6 = (t2 + 28U);
    t7 = *((char **)t6);
    t8 = (t1 + 1912);
    t9 = xsi_create_subprogram_invocation(t7, 0, t1, t8, 0, t2);
    xsi_vlog_subprogram_pushinvocation(t8, t9);
    t10 = (t1 + 10836);
    xsi_vlogvar_assign_value(t10, t5, 0, 0, 32);

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

LAB2:    t4 = (t1 + 2872);
    xsi_vlog_subprogram_setdisablestate(t4, &&LAB4);
    xsi_set_current_line(333, ng0);

LAB5:    xsi_set_current_line(334, ng0);
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

LAB6:    xsi_set_current_line(335, ng0);

LAB7:    t4 = (t1 + 3220U);
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

LAB13:    xsi_set_current_line(336, ng0);
    t4 = (t1 + 11296);
    t5 = (t4 + 32U);
    t6 = *((char **)t5);
    t7 = (t1 + 7708);
    xsi_vlogvar_assign_value(t7, t6, 0, 0, 8);
    xsi_set_current_line(337, ng0);
    t4 = (t1 + 11388);
    t5 = (t4 + 32U);
    t6 = *((char **)t5);
    t7 = (t1 + 6972);
    xsi_vlogvar_assign_value(t7, t6, 0, 0, 64);
    xsi_set_current_line(338, ng0);
    t4 = ((char*)((ng2)));
    t5 = (t1 + 8444);
    xsi_vlogvar_assign_value(t5, t4, 0, 0, 1);
    xsi_set_current_line(339, ng0);
    t4 = (t2 + 44U);
    t5 = *((char **)t4);
    t6 = (t5 + 16U);
    xsi_wp_set_status(t6, 1);
    *((char **)t3) = &&LAB15;
    goto LAB1;

LAB8:    *((unsigned int *)t8) = 1;
    goto LAB11;

LAB12:    xsi_set_current_line(335, ng0);
    t19 = (t2 + 44U);
    t20 = *((char **)t19);
    t21 = (t20 + 8U);
    xsi_wp_set_status(t21, 1);
    *((char **)t3) = &&LAB14;
    goto LAB1;

LAB14:    goto LAB7;

LAB15:    xsi_set_current_line(340, ng0);
    t4 = ((char*)((ng1)));
    t5 = (t1 + 8444);
    xsi_vlogvar_assign_value(t5, t4, 0, 0, 1);
    xsi_set_current_line(341, ng0);
    t4 = ((char*)((ng1)));
    t5 = (t1 + 7708);
    xsi_vlogvar_assign_value(t5, t4, 0, 0, 8);
    xsi_set_current_line(342, ng0);
    t4 = ((char*)((ng8)));
    t5 = (t1 + 6972);
    xsi_vlogvar_assign_value(t5, t4, 0, 0, 64);
    goto LAB4;

}

static void I277_0(char *t0)
{
    char *t1;
    char *t2;

LAB0:    xsi_set_current_line(277, ng0);
    t1 = ((char*)((ng1)));
    t2 = (t0 + 6788);
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

LAB0:    t1 = (t0 + 11992U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(278, ng0);
    t2 = (t0 + 11908);
    xsi_process_wait(t2, 4000000LL);
    *((char **)t1) = &&LAB4;

LAB1:    return;
LAB4:    xsi_set_current_line(278, ng0);
    t4 = (t0 + 6788);
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
    t17 = (t0 + 6788);
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

static void A346_2(char *t0)
{
    char t3[8];
    char t14[8];
    char t30[8];
    char t37[8];
    char t75[8];
    char t85[16];
    char t90[16];
    char t91[8];
    char t101[8];
    char t107[8];
    char t130[8];
    char t143[8];
    char t150[8];
    char t178[8];
    char t193[8];
    char t200[8];
    char t228[8];
    char t243[8];
    char t250[8];
    char t278[8];
    char t293[8];
    char t300[8];
    char t328[8];
    char t343[8];
    char t350[8];
    char t378[8];
    char t386[8];
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
    char *t15;
    char *t16;
    unsigned int t17;
    unsigned int t18;
    unsigned int t19;
    unsigned int t20;
    unsigned int t21;
    char *t22;
    unsigned int t23;
    unsigned int t24;
    unsigned int t25;
    char *t26;
    char *t27;
    char *t28;
    char *t29;
    char *t31;
    unsigned int t32;
    unsigned int t33;
    unsigned int t34;
    unsigned int t35;
    unsigned int t36;
    unsigned int t38;
    unsigned int t39;
    unsigned int t40;
    char *t41;
    char *t42;
    char *t43;
    unsigned int t44;
    unsigned int t45;
    unsigned int t46;
    unsigned int t47;
    unsigned int t48;
    unsigned int t49;
    unsigned int t50;
    char *t51;
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
    char *t86;
    char *t87;
    char *t88;
    char *t89;
    unsigned int t92;
    unsigned int t93;
    unsigned int t94;
    unsigned int t95;
    unsigned int t96;
    unsigned int t97;
    unsigned int t98;
    unsigned int t99;
    unsigned int t100;
    unsigned int t102;
    unsigned int t103;
    unsigned int t104;
    unsigned int t105;
    unsigned int t106;
    unsigned int t108;
    unsigned int t109;
    unsigned int t110;
    unsigned int t111;
    unsigned int t112;
    unsigned int t113;
    unsigned int t114;
    unsigned int t115;
    unsigned int t116;
    unsigned int t117;
    unsigned int t118;
    unsigned int t119;
    unsigned int t120;
    int t121;
    unsigned int t122;
    unsigned int t123;
    unsigned int t124;
    int t125;
    unsigned int t126;
    unsigned int t127;
    unsigned int t128;
    unsigned int t129;
    unsigned int t131;
    unsigned int t132;
    unsigned int t133;
    unsigned int t134;
    unsigned int t135;
    char *t136;
    unsigned int t137;
    unsigned int t138;
    unsigned int t139;
    unsigned int t140;
    char *t141;
    char *t142;
    char *t144;
    unsigned int t145;
    unsigned int t146;
    unsigned int t147;
    unsigned int t148;
    unsigned int t149;
    unsigned int t151;
    unsigned int t152;
    unsigned int t153;
    char *t154;
    char *t155;
    char *t156;
    unsigned int t157;
    unsigned int t158;
    unsigned int t159;
    unsigned int t160;
    unsigned int t161;
    unsigned int t162;
    unsigned int t163;
    char *t164;
    char *t165;
    unsigned int t166;
    unsigned int t167;
    unsigned int t168;
    int t169;
    unsigned int t170;
    unsigned int t171;
    unsigned int t172;
    int t173;
    unsigned int t174;
    unsigned int t175;
    unsigned int t176;
    unsigned int t177;
    char *t179;
    char *t180;
    unsigned int t181;
    unsigned int t182;
    unsigned int t183;
    unsigned int t184;
    unsigned int t185;
    char *t186;
    unsigned int t187;
    unsigned int t188;
    unsigned int t189;
    unsigned int t190;
    char *t191;
    char *t192;
    char *t194;
    unsigned int t195;
    unsigned int t196;
    unsigned int t197;
    unsigned int t198;
    unsigned int t199;
    unsigned int t201;
    unsigned int t202;
    unsigned int t203;
    char *t204;
    char *t205;
    char *t206;
    unsigned int t207;
    unsigned int t208;
    unsigned int t209;
    unsigned int t210;
    unsigned int t211;
    unsigned int t212;
    unsigned int t213;
    char *t214;
    char *t215;
    unsigned int t216;
    unsigned int t217;
    unsigned int t218;
    int t219;
    unsigned int t220;
    unsigned int t221;
    unsigned int t222;
    int t223;
    unsigned int t224;
    unsigned int t225;
    unsigned int t226;
    unsigned int t227;
    char *t229;
    char *t230;
    unsigned int t231;
    unsigned int t232;
    unsigned int t233;
    unsigned int t234;
    unsigned int t235;
    char *t236;
    unsigned int t237;
    unsigned int t238;
    unsigned int t239;
    unsigned int t240;
    char *t241;
    char *t242;
    char *t244;
    unsigned int t245;
    unsigned int t246;
    unsigned int t247;
    unsigned int t248;
    unsigned int t249;
    unsigned int t251;
    unsigned int t252;
    unsigned int t253;
    char *t254;
    char *t255;
    char *t256;
    unsigned int t257;
    unsigned int t258;
    unsigned int t259;
    unsigned int t260;
    unsigned int t261;
    unsigned int t262;
    unsigned int t263;
    char *t264;
    char *t265;
    unsigned int t266;
    unsigned int t267;
    unsigned int t268;
    int t269;
    unsigned int t270;
    unsigned int t271;
    unsigned int t272;
    int t273;
    unsigned int t274;
    unsigned int t275;
    unsigned int t276;
    unsigned int t277;
    char *t279;
    char *t280;
    unsigned int t281;
    unsigned int t282;
    unsigned int t283;
    unsigned int t284;
    unsigned int t285;
    char *t286;
    unsigned int t287;
    unsigned int t288;
    unsigned int t289;
    unsigned int t290;
    char *t291;
    char *t292;
    char *t294;
    unsigned int t295;
    unsigned int t296;
    unsigned int t297;
    unsigned int t298;
    unsigned int t299;
    unsigned int t301;
    unsigned int t302;
    unsigned int t303;
    char *t304;
    char *t305;
    char *t306;
    unsigned int t307;
    unsigned int t308;
    unsigned int t309;
    unsigned int t310;
    unsigned int t311;
    unsigned int t312;
    unsigned int t313;
    char *t314;
    char *t315;
    unsigned int t316;
    unsigned int t317;
    unsigned int t318;
    int t319;
    unsigned int t320;
    unsigned int t321;
    unsigned int t322;
    int t323;
    unsigned int t324;
    unsigned int t325;
    unsigned int t326;
    unsigned int t327;
    char *t329;
    char *t330;
    unsigned int t331;
    unsigned int t332;
    unsigned int t333;
    unsigned int t334;
    unsigned int t335;
    char *t336;
    unsigned int t337;
    unsigned int t338;
    unsigned int t339;
    unsigned int t340;
    char *t341;
    char *t342;
    char *t344;
    unsigned int t345;
    unsigned int t346;
    unsigned int t347;
    unsigned int t348;
    unsigned int t349;
    unsigned int t351;
    unsigned int t352;
    unsigned int t353;
    char *t354;
    char *t355;
    char *t356;
    unsigned int t357;
    unsigned int t358;
    unsigned int t359;
    unsigned int t360;
    unsigned int t361;
    unsigned int t362;
    unsigned int t363;
    char *t364;
    char *t365;
    unsigned int t366;
    unsigned int t367;
    unsigned int t368;
    int t369;
    unsigned int t370;
    unsigned int t371;
    unsigned int t372;
    int t373;
    unsigned int t374;
    unsigned int t375;
    unsigned int t376;
    unsigned int t377;
    char *t379;
    char *t380;
    unsigned int t381;
    unsigned int t382;
    unsigned int t383;
    unsigned int t384;
    unsigned int t385;
    unsigned int t387;
    unsigned int t388;
    unsigned int t389;
    char *t390;
    char *t391;
    char *t392;
    unsigned int t393;
    unsigned int t394;
    unsigned int t395;
    unsigned int t396;
    unsigned int t397;
    unsigned int t398;
    unsigned int t399;
    char *t400;
    char *t401;
    unsigned int t402;
    unsigned int t403;
    unsigned int t404;
    unsigned int t405;
    unsigned int t406;
    unsigned int t407;
    unsigned int t408;
    unsigned int t409;
    int t410;
    int t411;
    unsigned int t412;
    unsigned int t413;
    unsigned int t414;
    unsigned int t415;
    unsigned int t416;
    unsigned int t417;
    char *t418;
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

LAB0:    t1 = (t0 + 12120U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(346, ng0);
    t2 = (t0 + 12604);
    *((int *)t2) = 1;
    *((char **)t1) = &&LAB4;

LAB1:    return;
LAB4:    xsi_set_current_line(346, ng0);

LAB5:    xsi_set_current_line(347, ng0);
    t4 = (t0 + 6880);
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

LAB9:    memset(t14, 0, 8);
    t15 = (t14 + 4U);
    t16 = (t3 + 4U);
    t17 = *((unsigned int *)t16);
    t18 = (~(t17));
    t19 = *((unsigned int *)t3);
    t20 = (t19 & t18);
    t21 = (t20 & 1U);
    if (t21 != 0)
        goto LAB10;

LAB11:    if (*((unsigned int *)t16) != 0)
        goto LAB12;

LAB13:    t22 = (t14 + 4U);
    t23 = *((unsigned int *)t14);
    t24 = *((unsigned int *)t22);
    t25 = (t23 || t24);
    if (t25 > 0)
        goto LAB14;

LAB15:    memcpy(t37, t14, 8);

LAB16:    t69 = (t37 + 4U);
    t70 = *((unsigned int *)t69);
    t71 = (~(t70));
    t72 = *((unsigned int *)t37);
    t73 = (t72 & t71);
    t74 = (t73 != 0);
    if (t74 > 0)
        goto LAB24;

LAB25:
LAB26:    xsi_set_current_line(351, ng0);
    t2 = (t0 + 6880);
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
        goto LAB30;

LAB28:    if (*((unsigned int *)t7) == 0)
        goto LAB27;

LAB29:    *((unsigned int *)t3) = 1;
    *((unsigned int *)t6) = 1;

LAB30:    memset(t14, 0, 8);
    t8 = (t14 + 4U);
    t15 = (t3 + 4U);
    t17 = *((unsigned int *)t15);
    t18 = (~(t17));
    t19 = *((unsigned int *)t3);
    t20 = (t19 & t18);
    t21 = (t20 & 1U);
    if (t21 != 0)
        goto LAB31;

LAB32:    if (*((unsigned int *)t15) != 0)
        goto LAB33;

LAB34:    t16 = (t14 + 4U);
    t23 = *((unsigned int *)t14);
    t24 = *((unsigned int *)t16);
    t25 = (t23 || t24);
    if (t25 > 0)
        goto LAB35;

LAB36:    memcpy(t386, t14, 8);

LAB37:    t418 = (t386 + 4U);
    t419 = *((unsigned int *)t418);
    t420 = (~(t419));
    t421 = *((unsigned int *)t386);
    t422 = (t421 & t420);
    t423 = (t422 != 0);
    if (t423 > 0)
        goto LAB143;

LAB144:
LAB145:    goto LAB2;

LAB6:    *((unsigned int *)t3) = 1;
    goto LAB9;

LAB10:    *((unsigned int *)t14) = 1;
    goto LAB13;

LAB12:    *((unsigned int *)t14) = 1;
    *((unsigned int *)t15) = 1;
    goto LAB13;

LAB14:    t26 = (t0 + 17116);
    t27 = *((char **)t26);
    t28 = ((((char*)(t27))) + 20U);
    t29 = *((char **)t28);
    memset(t30, 0, 8);
    t28 = (t30 + 4U);
    t31 = (t29 + 4U);
    t32 = *((unsigned int *)t31);
    t33 = (~(t32));
    t34 = *((unsigned int *)t29);
    t35 = (t34 & t33);
    t36 = (t35 & 1U);
    if (t36 != 0)
        goto LAB17;

LAB18:    if (*((unsigned int *)t31) != 0)
        goto LAB19;

LAB20:    t38 = *((unsigned int *)t14);
    t39 = *((unsigned int *)t30);
    t40 = (t38 & t39);
    *((unsigned int *)t37) = t40;
    t41 = (t14 + 4U);
    t42 = (t30 + 4U);
    t43 = (t37 + 4U);
    t44 = *((unsigned int *)t41);
    t45 = *((unsigned int *)t42);
    t46 = (t44 | t45);
    *((unsigned int *)t43) = t46;
    t47 = *((unsigned int *)t43);
    t48 = (t47 != 0);
    if (t48 == 1)
        goto LAB21;

LAB22:
LAB23:    goto LAB16;

LAB17:    *((unsigned int *)t30) = 1;
    goto LAB20;

LAB19:    *((unsigned int *)t30) = 1;
    *((unsigned int *)t28) = 1;
    goto LAB20;

LAB21:    t49 = *((unsigned int *)t37);
    t50 = *((unsigned int *)t43);
    *((unsigned int *)t37) = (t49 | t50);
    t51 = (t14 + 4U);
    t52 = (t30 + 4U);
    t53 = *((unsigned int *)t14);
    t54 = (~(t53));
    t55 = *((unsigned int *)t51);
    t56 = (~(t55));
    t57 = *((unsigned int *)t30);
    t58 = (~(t57));
    t59 = *((unsigned int *)t52);
    t60 = (~(t59));
    t61 = (t54 & t56);
    t62 = (t58 & t60);
    t63 = (~(t61));
    t64 = (~(t62));
    t65 = *((unsigned int *)t43);
    *((unsigned int *)t43) = (t65 & t63);
    t66 = *((unsigned int *)t43);
    *((unsigned int *)t43) = (t66 & t64);
    t67 = *((unsigned int *)t37);
    *((unsigned int *)t37) = (t67 & t63);
    t68 = *((unsigned int *)t37);
    *((unsigned int *)t37) = (t68 & t64);
    goto LAB23;

LAB24:    xsi_set_current_line(348, ng0);
    t76 = (t0 + 17140);
    t77 = *((char **)t76);
    t78 = ((((char*)(t77))) + 20U);
    t79 = *((char **)t78);
    t78 = (t0 + 17164);
    t80 = *((char **)t78);
    t81 = ((((char*)(t80))) + 40U);
    t82 = *((char **)t81);
    t83 = ((char*)((ng10)));
    t84 = ((char*)((ng11)));
    xsi_vlog_generic_get_part_select_value(t75, 8, t79, t82, 2, t83, 32U, 1, t84, 32U, 1);
    t86 = (t0 + 17188);
    t87 = *((char **)t86);
    t88 = ((((char*)(t87))) + 20U);
    t89 = *((char **)t88);
    xsi_vlog_get_part_select_value(t85, 64, t89, 63, 0);
    t88 = xsi_vlog_time(t90, 1000000.000000000, 1000.000000000000);
    xsi_vlogfile_write(1, 0, ng9, 4, t0, (char)118, t75, 8, (char)118, t85, 64, (char)118, t90, 64);
    goto LAB26;

LAB27:    *((unsigned int *)t3) = 1;
    goto LAB30;

LAB31:    *((unsigned int *)t14) = 1;
    goto LAB34;

LAB33:    *((unsigned int *)t14) = 1;
    *((unsigned int *)t8) = 1;
    goto LAB34;

LAB35:    t22 = (t0 + 5332U);
    t26 = *((char **)t22);
    memset(t30, 0, 8);
    t22 = (t30 + 4U);
    t27 = (t26 + 4U);
    t32 = *((unsigned int *)t27);
    t33 = (~(t32));
    t34 = *((unsigned int *)t26);
    t35 = (t34 & t33);
    t36 = (t35 & 1U);
    if (t36 != 0)
        goto LAB38;

LAB39:    if (*((unsigned int *)t27) != 0)
        goto LAB40;

LAB41:    t28 = (t30 + 4U);
    t38 = *((unsigned int *)t30);
    t39 = (!(t38));
    t40 = *((unsigned int *)t28);
    t44 = (t39 || t40);
    if (t44 > 0)
        goto LAB42;

LAB43:    memcpy(t75, t30, 8);

LAB44:    memset(t91, 0, 8);
    t76 = (t91 + 4U);
    t77 = (t75 + 4U);
    t92 = *((unsigned int *)t77);
    t93 = (~(t92));
    t94 = *((unsigned int *)t75);
    t95 = (t94 & t93);
    t96 = (t95 & 1U);
    if (t96 != 0)
        goto LAB52;

LAB53:    if (*((unsigned int *)t77) != 0)
        goto LAB54;

LAB55:    t78 = (t91 + 4U);
    t97 = *((unsigned int *)t91);
    t98 = (!(t97));
    t99 = *((unsigned int *)t78);
    t100 = (t98 || t99);
    if (t100 > 0)
        goto LAB56;

LAB57:    memcpy(t107, t91, 8);

LAB58:    memset(t130, 0, 8);
    t88 = (t130 + 4U);
    t89 = (t107 + 4U);
    t131 = *((unsigned int *)t89);
    t132 = (~(t131));
    t133 = *((unsigned int *)t107);
    t134 = (t133 & t132);
    t135 = (t134 & 1U);
    if (t135 != 0)
        goto LAB66;

LAB67:    if (*((unsigned int *)t89) != 0)
        goto LAB68;

LAB69:    t136 = (t130 + 4U);
    t137 = *((unsigned int *)t130);
    t138 = (!(t137));
    t139 = *((unsigned int *)t136);
    t140 = (t138 || t139);
    if (t140 > 0)
        goto LAB70;

LAB71:    memcpy(t150, t130, 8);

LAB72:    memset(t178, 0, 8);
    t179 = (t178 + 4U);
    t180 = (t150 + 4U);
    t181 = *((unsigned int *)t180);
    t182 = (~(t181));
    t183 = *((unsigned int *)t150);
    t184 = (t183 & t182);
    t185 = (t184 & 1U);
    if (t185 != 0)
        goto LAB80;

LAB81:    if (*((unsigned int *)t180) != 0)
        goto LAB82;

LAB83:    t186 = (t178 + 4U);
    t187 = *((unsigned int *)t178);
    t188 = (!(t187));
    t189 = *((unsigned int *)t186);
    t190 = (t188 || t189);
    if (t190 > 0)
        goto LAB84;

LAB85:    memcpy(t200, t178, 8);

LAB86:    memset(t228, 0, 8);
    t229 = (t228 + 4U);
    t230 = (t200 + 4U);
    t231 = *((unsigned int *)t230);
    t232 = (~(t231));
    t233 = *((unsigned int *)t200);
    t234 = (t233 & t232);
    t235 = (t234 & 1U);
    if (t235 != 0)
        goto LAB94;

LAB95:    if (*((unsigned int *)t230) != 0)
        goto LAB96;

LAB97:    t236 = (t228 + 4U);
    t237 = *((unsigned int *)t228);
    t238 = (!(t237));
    t239 = *((unsigned int *)t236);
    t240 = (t238 || t239);
    if (t240 > 0)
        goto LAB98;

LAB99:    memcpy(t250, t228, 8);

LAB100:    memset(t278, 0, 8);
    t279 = (t278 + 4U);
    t280 = (t250 + 4U);
    t281 = *((unsigned int *)t280);
    t282 = (~(t281));
    t283 = *((unsigned int *)t250);
    t284 = (t283 & t282);
    t285 = (t284 & 1U);
    if (t285 != 0)
        goto LAB108;

LAB109:    if (*((unsigned int *)t280) != 0)
        goto LAB110;

LAB111:    t286 = (t278 + 4U);
    t287 = *((unsigned int *)t278);
    t288 = (!(t287));
    t289 = *((unsigned int *)t286);
    t290 = (t288 || t289);
    if (t290 > 0)
        goto LAB112;

LAB113:    memcpy(t300, t278, 8);

LAB114:    memset(t328, 0, 8);
    t329 = (t328 + 4U);
    t330 = (t300 + 4U);
    t331 = *((unsigned int *)t330);
    t332 = (~(t331));
    t333 = *((unsigned int *)t300);
    t334 = (t333 & t332);
    t335 = (t334 & 1U);
    if (t335 != 0)
        goto LAB122;

LAB123:    if (*((unsigned int *)t330) != 0)
        goto LAB124;

LAB125:    t336 = (t328 + 4U);
    t337 = *((unsigned int *)t328);
    t338 = (!(t337));
    t339 = *((unsigned int *)t336);
    t340 = (t338 || t339);
    if (t340 > 0)
        goto LAB126;

LAB127:    memcpy(t350, t328, 8);

LAB128:    memset(t378, 0, 8);
    t379 = (t378 + 4U);
    t380 = (t350 + 4U);
    t381 = *((unsigned int *)t380);
    t382 = (~(t381));
    t383 = *((unsigned int *)t350);
    t384 = (t383 & t382);
    t385 = (t384 & 1U);
    if (t385 != 0)
        goto LAB136;

LAB137:    if (*((unsigned int *)t380) != 0)
        goto LAB138;

LAB139:    t387 = *((unsigned int *)t14);
    t388 = *((unsigned int *)t378);
    t389 = (t387 & t388);
    *((unsigned int *)t386) = t389;
    t390 = (t14 + 4U);
    t391 = (t378 + 4U);
    t392 = (t386 + 4U);
    t393 = *((unsigned int *)t390);
    t394 = *((unsigned int *)t391);
    t395 = (t393 | t394);
    *((unsigned int *)t392) = t395;
    t396 = *((unsigned int *)t392);
    t397 = (t396 != 0);
    if (t397 == 1)
        goto LAB140;

LAB141:
LAB142:    goto LAB37;

LAB38:    *((unsigned int *)t30) = 1;
    goto LAB41;

LAB40:    *((unsigned int *)t30) = 1;
    *((unsigned int *)t22) = 1;
    goto LAB41;

LAB42:    t29 = (t0 + 5420U);
    t31 = *((char **)t29);
    memset(t37, 0, 8);
    t29 = (t37 + 4U);
    t41 = (t31 + 4U);
    t45 = *((unsigned int *)t41);
    t46 = (~(t45));
    t47 = *((unsigned int *)t31);
    t48 = (t47 & t46);
    t49 = (t48 & 1U);
    if (t49 != 0)
        goto LAB45;

LAB46:    if (*((unsigned int *)t41) != 0)
        goto LAB47;

LAB48:    t50 = *((unsigned int *)t30);
    t53 = *((unsigned int *)t37);
    t54 = (t50 | t53);
    *((unsigned int *)t75) = t54;
    t42 = (t30 + 4U);
    t43 = (t37 + 4U);
    t51 = (t75 + 4U);
    t55 = *((unsigned int *)t42);
    t56 = *((unsigned int *)t43);
    t57 = (t55 | t56);
    *((unsigned int *)t51) = t57;
    t58 = *((unsigned int *)t51);
    t59 = (t58 != 0);
    if (t59 == 1)
        goto LAB49;

LAB50:
LAB51:    goto LAB44;

LAB45:    *((unsigned int *)t37) = 1;
    goto LAB48;

LAB47:    *((unsigned int *)t37) = 1;
    *((unsigned int *)t29) = 1;
    goto LAB48;

LAB49:    t60 = *((unsigned int *)t75);
    t63 = *((unsigned int *)t51);
    *((unsigned int *)t75) = (t60 | t63);
    t52 = (t30 + 4U);
    t69 = (t37 + 4U);
    t64 = *((unsigned int *)t52);
    t65 = (~(t64));
    t66 = *((unsigned int *)t30);
    t61 = (t66 & t65);
    t67 = *((unsigned int *)t69);
    t68 = (~(t67));
    t70 = *((unsigned int *)t37);
    t62 = (t70 & t68);
    t71 = (~(t61));
    t72 = (~(t62));
    t73 = *((unsigned int *)t51);
    *((unsigned int *)t51) = (t73 & t71);
    t74 = *((unsigned int *)t51);
    *((unsigned int *)t51) = (t74 & t72);
    goto LAB51;

LAB52:    *((unsigned int *)t91) = 1;
    goto LAB55;

LAB54:    *((unsigned int *)t91) = 1;
    *((unsigned int *)t76) = 1;
    goto LAB55;

LAB56:    t79 = (t0 + 5508U);
    t80 = *((char **)t79);
    memset(t101, 0, 8);
    t79 = (t101 + 4U);
    t81 = (t80 + 4U);
    t102 = *((unsigned int *)t81);
    t103 = (~(t102));
    t104 = *((unsigned int *)t80);
    t105 = (t104 & t103);
    t106 = (t105 & 1U);
    if (t106 != 0)
        goto LAB59;

LAB60:    if (*((unsigned int *)t81) != 0)
        goto LAB61;

LAB62:    t108 = *((unsigned int *)t91);
    t109 = *((unsigned int *)t101);
    t110 = (t108 | t109);
    *((unsigned int *)t107) = t110;
    t82 = (t91 + 4U);
    t83 = (t101 + 4U);
    t84 = (t107 + 4U);
    t111 = *((unsigned int *)t82);
    t112 = *((unsigned int *)t83);
    t113 = (t111 | t112);
    *((unsigned int *)t84) = t113;
    t114 = *((unsigned int *)t84);
    t115 = (t114 != 0);
    if (t115 == 1)
        goto LAB63;

LAB64:
LAB65:    goto LAB58;

LAB59:    *((unsigned int *)t101) = 1;
    goto LAB62;

LAB61:    *((unsigned int *)t101) = 1;
    *((unsigned int *)t79) = 1;
    goto LAB62;

LAB63:    t116 = *((unsigned int *)t107);
    t117 = *((unsigned int *)t84);
    *((unsigned int *)t107) = (t116 | t117);
    t86 = (t91 + 4U);
    t87 = (t101 + 4U);
    t118 = *((unsigned int *)t86);
    t119 = (~(t118));
    t120 = *((unsigned int *)t91);
    t121 = (t120 & t119);
    t122 = *((unsigned int *)t87);
    t123 = (~(t122));
    t124 = *((unsigned int *)t101);
    t125 = (t124 & t123);
    t126 = (~(t121));
    t127 = (~(t125));
    t128 = *((unsigned int *)t84);
    *((unsigned int *)t84) = (t128 & t126);
    t129 = *((unsigned int *)t84);
    *((unsigned int *)t84) = (t129 & t127);
    goto LAB65;

LAB66:    *((unsigned int *)t130) = 1;
    goto LAB69;

LAB68:    *((unsigned int *)t130) = 1;
    *((unsigned int *)t88) = 1;
    goto LAB69;

LAB70:    t141 = (t0 + 5596U);
    t142 = *((char **)t141);
    memset(t143, 0, 8);
    t141 = (t143 + 4U);
    t144 = (t142 + 4U);
    t145 = *((unsigned int *)t144);
    t146 = (~(t145));
    t147 = *((unsigned int *)t142);
    t148 = (t147 & t146);
    t149 = (t148 & 1U);
    if (t149 != 0)
        goto LAB73;

LAB74:    if (*((unsigned int *)t144) != 0)
        goto LAB75;

LAB76:    t151 = *((unsigned int *)t130);
    t152 = *((unsigned int *)t143);
    t153 = (t151 | t152);
    *((unsigned int *)t150) = t153;
    t154 = (t130 + 4U);
    t155 = (t143 + 4U);
    t156 = (t150 + 4U);
    t157 = *((unsigned int *)t154);
    t158 = *((unsigned int *)t155);
    t159 = (t157 | t158);
    *((unsigned int *)t156) = t159;
    t160 = *((unsigned int *)t156);
    t161 = (t160 != 0);
    if (t161 == 1)
        goto LAB77;

LAB78:
LAB79:    goto LAB72;

LAB73:    *((unsigned int *)t143) = 1;
    goto LAB76;

LAB75:    *((unsigned int *)t143) = 1;
    *((unsigned int *)t141) = 1;
    goto LAB76;

LAB77:    t162 = *((unsigned int *)t150);
    t163 = *((unsigned int *)t156);
    *((unsigned int *)t150) = (t162 | t163);
    t164 = (t130 + 4U);
    t165 = (t143 + 4U);
    t166 = *((unsigned int *)t164);
    t167 = (~(t166));
    t168 = *((unsigned int *)t130);
    t169 = (t168 & t167);
    t170 = *((unsigned int *)t165);
    t171 = (~(t170));
    t172 = *((unsigned int *)t143);
    t173 = (t172 & t171);
    t174 = (~(t169));
    t175 = (~(t173));
    t176 = *((unsigned int *)t156);
    *((unsigned int *)t156) = (t176 & t174);
    t177 = *((unsigned int *)t156);
    *((unsigned int *)t156) = (t177 & t175);
    goto LAB79;

LAB80:    *((unsigned int *)t178) = 1;
    goto LAB83;

LAB82:    *((unsigned int *)t178) = 1;
    *((unsigned int *)t179) = 1;
    goto LAB83;

LAB84:    t191 = (t0 + 5684U);
    t192 = *((char **)t191);
    memset(t193, 0, 8);
    t191 = (t193 + 4U);
    t194 = (t192 + 4U);
    t195 = *((unsigned int *)t194);
    t196 = (~(t195));
    t197 = *((unsigned int *)t192);
    t198 = (t197 & t196);
    t199 = (t198 & 1U);
    if (t199 != 0)
        goto LAB87;

LAB88:    if (*((unsigned int *)t194) != 0)
        goto LAB89;

LAB90:    t201 = *((unsigned int *)t178);
    t202 = *((unsigned int *)t193);
    t203 = (t201 | t202);
    *((unsigned int *)t200) = t203;
    t204 = (t178 + 4U);
    t205 = (t193 + 4U);
    t206 = (t200 + 4U);
    t207 = *((unsigned int *)t204);
    t208 = *((unsigned int *)t205);
    t209 = (t207 | t208);
    *((unsigned int *)t206) = t209;
    t210 = *((unsigned int *)t206);
    t211 = (t210 != 0);
    if (t211 == 1)
        goto LAB91;

LAB92:
LAB93:    goto LAB86;

LAB87:    *((unsigned int *)t193) = 1;
    goto LAB90;

LAB89:    *((unsigned int *)t193) = 1;
    *((unsigned int *)t191) = 1;
    goto LAB90;

LAB91:    t212 = *((unsigned int *)t200);
    t213 = *((unsigned int *)t206);
    *((unsigned int *)t200) = (t212 | t213);
    t214 = (t178 + 4U);
    t215 = (t193 + 4U);
    t216 = *((unsigned int *)t214);
    t217 = (~(t216));
    t218 = *((unsigned int *)t178);
    t219 = (t218 & t217);
    t220 = *((unsigned int *)t215);
    t221 = (~(t220));
    t222 = *((unsigned int *)t193);
    t223 = (t222 & t221);
    t224 = (~(t219));
    t225 = (~(t223));
    t226 = *((unsigned int *)t206);
    *((unsigned int *)t206) = (t226 & t224);
    t227 = *((unsigned int *)t206);
    *((unsigned int *)t206) = (t227 & t225);
    goto LAB93;

LAB94:    *((unsigned int *)t228) = 1;
    goto LAB97;

LAB96:    *((unsigned int *)t228) = 1;
    *((unsigned int *)t229) = 1;
    goto LAB97;

LAB98:    t241 = (t0 + 5772U);
    t242 = *((char **)t241);
    memset(t243, 0, 8);
    t241 = (t243 + 4U);
    t244 = (t242 + 4U);
    t245 = *((unsigned int *)t244);
    t246 = (~(t245));
    t247 = *((unsigned int *)t242);
    t248 = (t247 & t246);
    t249 = (t248 & 1U);
    if (t249 != 0)
        goto LAB101;

LAB102:    if (*((unsigned int *)t244) != 0)
        goto LAB103;

LAB104:    t251 = *((unsigned int *)t228);
    t252 = *((unsigned int *)t243);
    t253 = (t251 | t252);
    *((unsigned int *)t250) = t253;
    t254 = (t228 + 4U);
    t255 = (t243 + 4U);
    t256 = (t250 + 4U);
    t257 = *((unsigned int *)t254);
    t258 = *((unsigned int *)t255);
    t259 = (t257 | t258);
    *((unsigned int *)t256) = t259;
    t260 = *((unsigned int *)t256);
    t261 = (t260 != 0);
    if (t261 == 1)
        goto LAB105;

LAB106:
LAB107:    goto LAB100;

LAB101:    *((unsigned int *)t243) = 1;
    goto LAB104;

LAB103:    *((unsigned int *)t243) = 1;
    *((unsigned int *)t241) = 1;
    goto LAB104;

LAB105:    t262 = *((unsigned int *)t250);
    t263 = *((unsigned int *)t256);
    *((unsigned int *)t250) = (t262 | t263);
    t264 = (t228 + 4U);
    t265 = (t243 + 4U);
    t266 = *((unsigned int *)t264);
    t267 = (~(t266));
    t268 = *((unsigned int *)t228);
    t269 = (t268 & t267);
    t270 = *((unsigned int *)t265);
    t271 = (~(t270));
    t272 = *((unsigned int *)t243);
    t273 = (t272 & t271);
    t274 = (~(t269));
    t275 = (~(t273));
    t276 = *((unsigned int *)t256);
    *((unsigned int *)t256) = (t276 & t274);
    t277 = *((unsigned int *)t256);
    *((unsigned int *)t256) = (t277 & t275);
    goto LAB107;

LAB108:    *((unsigned int *)t278) = 1;
    goto LAB111;

LAB110:    *((unsigned int *)t278) = 1;
    *((unsigned int *)t279) = 1;
    goto LAB111;

LAB112:    t291 = (t0 + 5860U);
    t292 = *((char **)t291);
    memset(t293, 0, 8);
    t291 = (t293 + 4U);
    t294 = (t292 + 4U);
    t295 = *((unsigned int *)t294);
    t296 = (~(t295));
    t297 = *((unsigned int *)t292);
    t298 = (t297 & t296);
    t299 = (t298 & 1U);
    if (t299 != 0)
        goto LAB115;

LAB116:    if (*((unsigned int *)t294) != 0)
        goto LAB117;

LAB118:    t301 = *((unsigned int *)t278);
    t302 = *((unsigned int *)t293);
    t303 = (t301 | t302);
    *((unsigned int *)t300) = t303;
    t304 = (t278 + 4U);
    t305 = (t293 + 4U);
    t306 = (t300 + 4U);
    t307 = *((unsigned int *)t304);
    t308 = *((unsigned int *)t305);
    t309 = (t307 | t308);
    *((unsigned int *)t306) = t309;
    t310 = *((unsigned int *)t306);
    t311 = (t310 != 0);
    if (t311 == 1)
        goto LAB119;

LAB120:
LAB121:    goto LAB114;

LAB115:    *((unsigned int *)t293) = 1;
    goto LAB118;

LAB117:    *((unsigned int *)t293) = 1;
    *((unsigned int *)t291) = 1;
    goto LAB118;

LAB119:    t312 = *((unsigned int *)t300);
    t313 = *((unsigned int *)t306);
    *((unsigned int *)t300) = (t312 | t313);
    t314 = (t278 + 4U);
    t315 = (t293 + 4U);
    t316 = *((unsigned int *)t314);
    t317 = (~(t316));
    t318 = *((unsigned int *)t278);
    t319 = (t318 & t317);
    t320 = *((unsigned int *)t315);
    t321 = (~(t320));
    t322 = *((unsigned int *)t293);
    t323 = (t322 & t321);
    t324 = (~(t319));
    t325 = (~(t323));
    t326 = *((unsigned int *)t306);
    *((unsigned int *)t306) = (t326 & t324);
    t327 = *((unsigned int *)t306);
    *((unsigned int *)t306) = (t327 & t325);
    goto LAB121;

LAB122:    *((unsigned int *)t328) = 1;
    goto LAB125;

LAB124:    *((unsigned int *)t328) = 1;
    *((unsigned int *)t329) = 1;
    goto LAB125;

LAB126:    t341 = (t0 + 5948U);
    t342 = *((char **)t341);
    memset(t343, 0, 8);
    t341 = (t343 + 4U);
    t344 = (t342 + 4U);
    t345 = *((unsigned int *)t344);
    t346 = (~(t345));
    t347 = *((unsigned int *)t342);
    t348 = (t347 & t346);
    t349 = (t348 & 1U);
    if (t349 != 0)
        goto LAB129;

LAB130:    if (*((unsigned int *)t344) != 0)
        goto LAB131;

LAB132:    t351 = *((unsigned int *)t328);
    t352 = *((unsigned int *)t343);
    t353 = (t351 | t352);
    *((unsigned int *)t350) = t353;
    t354 = (t328 + 4U);
    t355 = (t343 + 4U);
    t356 = (t350 + 4U);
    t357 = *((unsigned int *)t354);
    t358 = *((unsigned int *)t355);
    t359 = (t357 | t358);
    *((unsigned int *)t356) = t359;
    t360 = *((unsigned int *)t356);
    t361 = (t360 != 0);
    if (t361 == 1)
        goto LAB133;

LAB134:
LAB135:    goto LAB128;

LAB129:    *((unsigned int *)t343) = 1;
    goto LAB132;

LAB131:    *((unsigned int *)t343) = 1;
    *((unsigned int *)t341) = 1;
    goto LAB132;

LAB133:    t362 = *((unsigned int *)t350);
    t363 = *((unsigned int *)t356);
    *((unsigned int *)t350) = (t362 | t363);
    t364 = (t328 + 4U);
    t365 = (t343 + 4U);
    t366 = *((unsigned int *)t364);
    t367 = (~(t366));
    t368 = *((unsigned int *)t328);
    t369 = (t368 & t367);
    t370 = *((unsigned int *)t365);
    t371 = (~(t370));
    t372 = *((unsigned int *)t343);
    t373 = (t372 & t371);
    t374 = (~(t369));
    t375 = (~(t373));
    t376 = *((unsigned int *)t356);
    *((unsigned int *)t356) = (t376 & t374);
    t377 = *((unsigned int *)t356);
    *((unsigned int *)t356) = (t377 & t375);
    goto LAB135;

LAB136:    *((unsigned int *)t378) = 1;
    goto LAB139;

LAB138:    *((unsigned int *)t378) = 1;
    *((unsigned int *)t379) = 1;
    goto LAB139;

LAB140:    t398 = *((unsigned int *)t386);
    t399 = *((unsigned int *)t392);
    *((unsigned int *)t386) = (t398 | t399);
    t400 = (t14 + 4U);
    t401 = (t378 + 4U);
    t402 = *((unsigned int *)t14);
    t403 = (~(t402));
    t404 = *((unsigned int *)t400);
    t405 = (~(t404));
    t406 = *((unsigned int *)t378);
    t407 = (~(t406));
    t408 = *((unsigned int *)t401);
    t409 = (~(t408));
    t410 = (t403 & t405);
    t411 = (t407 & t409);
    t412 = (~(t410));
    t413 = (~(t411));
    t414 = *((unsigned int *)t392);
    *((unsigned int *)t392) = (t414 & t412);
    t415 = *((unsigned int *)t392);
    *((unsigned int *)t392) = (t415 & t413);
    t416 = *((unsigned int *)t386);
    *((unsigned int *)t386) = (t416 & t412);
    t417 = *((unsigned int *)t386);
    *((unsigned int *)t386) = (t417 & t413);
    goto LAB142;

LAB143:    xsi_set_current_line(352, ng0);
    t424 = (t0 + 5948U);
    t425 = *((char **)t424);
    t424 = (t0 + 5860U);
    t426 = *((char **)t424);
    t424 = (t0 + 5772U);
    t427 = *((char **)t424);
    t424 = (t0 + 5684U);
    t428 = *((char **)t424);
    t424 = (t0 + 5596U);
    t429 = *((char **)t424);
    t424 = (t0 + 5508U);
    t430 = *((char **)t424);
    t424 = (t0 + 5420U);
    t431 = *((char **)t424);
    t424 = (t0 + 5332U);
    t432 = *((char **)t424);
    t424 = (t0 + 4628U);
    t433 = *((char **)t424);
    t424 = (t0 + 3924U);
    t434 = *((char **)t424);
    t424 = xsi_vlog_time(t85, 1000000.000000000, 1000.000000000000);
    xsi_vlogfile_write(1, 0, ng12, 12, t0, (char)118, t425, 1, (char)118, t426, 1, (char)118, t427, 1, (char)118, t428, 1, (char)118, t429, 1, (char)118, t430, 1, (char)118, t431, 1, (char)118, t432, 1, (char)118, t433, 8, (char)118, t434, 64, (char)118, t85, 64);
    goto LAB145;

}

static void I357_3(char *t0)
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

LAB0:    t1 = (t0 + 12248U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(357, ng0);

LAB4:    xsi_set_current_line(358, ng0);
    t2 = ((char*)((ng13)));
    t3 = (t0 + 6972);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 64);
    xsi_set_current_line(358, ng0);
    t2 = ((char*)((ng13)));
    t3 = (t0 + 7064);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 64);
    xsi_set_current_line(358, ng0);
    t2 = ((char*)((ng13)));
    t3 = (t0 + 7156);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 64);
    xsi_set_current_line(358, ng0);
    t2 = ((char*)((ng13)));
    t3 = (t0 + 7248);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 64);
    xsi_set_current_line(358, ng0);
    t2 = ((char*)((ng13)));
    t3 = (t0 + 7340);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 64);
    xsi_set_current_line(358, ng0);
    t2 = ((char*)((ng13)));
    t3 = (t0 + 7432);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 64);
    xsi_set_current_line(358, ng0);
    t2 = ((char*)((ng13)));
    t3 = (t0 + 7524);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 64);
    xsi_set_current_line(358, ng0);
    t2 = ((char*)((ng13)));
    t3 = (t0 + 7616);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 64);
    xsi_set_current_line(359, ng0);
    t2 = ((char*)((ng14)));
    t3 = (t0 + 7708);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 8);
    xsi_set_current_line(359, ng0);
    t2 = ((char*)((ng14)));
    t3 = (t0 + 7800);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 8);
    xsi_set_current_line(359, ng0);
    t2 = ((char*)((ng14)));
    t3 = (t0 + 7892);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 8);
    xsi_set_current_line(359, ng0);
    t2 = ((char*)((ng14)));
    t3 = (t0 + 7984);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 8);
    xsi_set_current_line(359, ng0);
    t2 = ((char*)((ng14)));
    t3 = (t0 + 8076);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 8);
    xsi_set_current_line(359, ng0);
    t2 = ((char*)((ng14)));
    t3 = (t0 + 8168);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 8);
    xsi_set_current_line(359, ng0);
    t2 = ((char*)((ng14)));
    t3 = (t0 + 8260);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 8);
    xsi_set_current_line(359, ng0);
    t2 = ((char*)((ng14)));
    t3 = (t0 + 8352);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 8);
    xsi_set_current_line(360, ng0);
    t2 = ((char*)((ng14)));
    t3 = (t0 + 8444);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(360, ng0);
    t2 = ((char*)((ng14)));
    t3 = (t0 + 8536);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(360, ng0);
    t2 = ((char*)((ng14)));
    t3 = (t0 + 8628);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(360, ng0);
    t2 = ((char*)((ng14)));
    t3 = (t0 + 8720);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(360, ng0);
    t2 = ((char*)((ng14)));
    t3 = (t0 + 8812);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(360, ng0);
    t2 = ((char*)((ng14)));
    t3 = (t0 + 8904);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(360, ng0);
    t2 = ((char*)((ng14)));
    t3 = (t0 + 8996);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(360, ng0);
    t2 = ((char*)((ng14)));
    t3 = (t0 + 9088);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(361, ng0);
    t2 = ((char*)((ng15)));
    t3 = (t0 + 9180);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(361, ng0);
    t2 = ((char*)((ng15)));
    t3 = (t0 + 9272);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(361, ng0);
    t2 = ((char*)((ng15)));
    t3 = (t0 + 9364);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(361, ng0);
    t2 = ((char*)((ng15)));
    t3 = (t0 + 9456);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(361, ng0);
    t2 = ((char*)((ng15)));
    t3 = (t0 + 9548);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(361, ng0);
    t2 = ((char*)((ng15)));
    t3 = (t0 + 9640);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(361, ng0);
    t2 = ((char*)((ng15)));
    t3 = (t0 + 9732);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(361, ng0);
    t2 = ((char*)((ng15)));
    t3 = (t0 + 9824);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(362, ng0);
    t2 = ((char*)((ng15)));
    t3 = (t0 + 9916);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(362, ng0);
    t2 = ((char*)((ng15)));
    t3 = (t0 + 10008);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(362, ng0);
    t2 = ((char*)((ng16)));
    t3 = (t0 + 10100);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 72);
    xsi_set_current_line(362, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 10192);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(363, ng0);
    t2 = ((char*)((ng14)));
    t3 = (t0 + 10284);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(363, ng0);
    t2 = ((char*)((ng2)));
    t3 = (t0 + 10376);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(363, ng0);
    t2 = ((char*)((ng14)));
    t3 = (t0 + 10468);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 23);
    xsi_set_current_line(363, ng0);
    t2 = ((char*)((ng14)));
    t3 = (t0 + 10560);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 32);
    xsi_set_current_line(365, ng0);
    t2 = ((char*)((ng2)));
    t3 = (t0 + 6880);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(366, ng0);
    t2 = ((char*)((ng17)));
    t3 = (t2 + 4U);
    t4 = *((unsigned int *)t3);
    t5 = (~(t4));
    t6 = *((unsigned int *)t2);
    t7 = (t6 & t5);
    t8 = (t0 + 17192);
    *((int *)t8) = t7;

LAB5:    t9 = (t0 + 17192);
    if (*((int *)t9) > 0)
        goto LAB6;

LAB7:    xsi_set_current_line(367, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 6880);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(368, ng0);
    t2 = xsi_vlog_time(t11, 1000000.000000000, 1000.000000000000);
    xsi_vlogfile_write(1, 0, ng18, 2, t0, (char)118, t11, 64);
    xsi_set_current_line(371, ng0);
    xsi_vlogfile_write(1, 0, ng19, 1, t0);
    xsi_set_current_line(372, ng0);
    t2 = ((char*)((ng1)));
    t3 = ((char*)((ng20)));
    t8 = (t0 + 12164);
    t9 = (t0 + 2152);
    t10 = xsi_create_subprogram_invocation(t8, 0, t0, t9, 0, 0);
    xsi_vlog_subprogram_pushinvocation(t9, t10);
    t12 = (t0 + 10928);
    xsi_vlogvar_assign_value(t12, t2, 0, 0, 9);
    t13 = (t0 + 11020);
    xsi_vlogvar_assign_value(t13, t3, 0, 0, 32);

LAB10:    t14 = (t0 + 12212);
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

LAB9:    t22 = (t0 + 12212);
    t23 = *((char **)t22);
    t22 = (t0 + 2152);
    t24 = (t0 + 12212);
    t25 = *((char **)t24);
    t24 = (t0 + 12164);
    t26 = 0;
    xsi_delete_subprogram_invocation(t22, t25, t0, t24, t26);
    xsi_set_current_line(373, ng0);
    t2 = ((char*)((ng4)));
    t3 = ((char*)((ng21)));
    t8 = (t0 + 12164);
    t9 = (t0 + 1672);
    t10 = xsi_create_subprogram_invocation(t8, 0, t0, t9, 0, 0);
    xsi_vlog_subprogram_pushinvocation(t9, t10);
    t12 = (t0 + 10652);
    xsi_vlogvar_assign_value(t12, t2, 0, 0, 23);
    t13 = (t0 + 10744);
    xsi_vlogvar_assign_value(t13, t3, 0, 0, 32);

LAB14:    t14 = (t0 + 12212);
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

LAB13:    t22 = (t0 + 12212);
    t23 = *((char **)t22);
    t22 = (t0 + 1672);
    t24 = (t0 + 12212);
    t25 = *((char **)t24);
    t24 = (t0 + 12164);
    t26 = 0;
    xsi_delete_subprogram_invocation(t22, t25, t0, t24, t26);
    xsi_set_current_line(374, ng0);
    t2 = ((char*)((ng22)));
    t3 = (t0 + 12164);
    t8 = (t0 + 1912);
    t9 = xsi_create_subprogram_invocation(t3, 0, t0, t8, 0, 0);
    xsi_vlog_subprogram_pushinvocation(t8, t9);
    t10 = (t0 + 10836);
    xsi_vlogvar_assign_value(t10, t2, 0, 0, 32);

LAB18:    t12 = (t0 + 12212);
    t13 = *((char **)t12);
    t14 = (t13 + 40U);
    t15 = *((char **)t14);
    t16 = (t15 + 132U);
    t17 = *((char **)t16);
    t18 = (t17 + 0U);
    t19 = *((char **)t18);
    t7 = ((int  (*)(char *, char *))t19)(t0, t13);
    if (t7 != 0)
        goto LAB20;

LAB19:    t13 = (t0 + 1912);
    xsi_vlog_subprogram_popinvocation(t13);

LAB17:    t20 = (t0 + 12212);
    t21 = *((char **)t20);
    t20 = (t0 + 1912);
    t22 = (t0 + 12212);
    t23 = *((char **)t22);
    t22 = (t0 + 12164);
    t24 = 0;
    xsi_delete_subprogram_invocation(t20, t23, t0, t22, t24);
    xsi_set_current_line(377, ng0);
    xsi_vlogfile_write(1, 0, ng23, 1, t0);
    xsi_set_current_line(378, ng0);
    t2 = ((char*)((ng1)));
    t3 = ((char*)((ng24)));
    t8 = (t0 + 12164);
    t9 = (t0 + 2392);
    t10 = xsi_create_subprogram_invocation(t8, 0, t0, t9, 0, 0);
    xsi_vlog_subprogram_pushinvocation(t9, t10);
    t12 = (t0 + 11112);
    xsi_vlogvar_assign_value(t12, t2, 0, 0, 9);
    t13 = (t0 + 11204);
    xsi_vlogvar_assign_value(t13, t3, 0, 0, 32);

LAB22:    t14 = (t0 + 12212);
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

LAB21:    t22 = (t0 + 12212);
    t23 = *((char **)t22);
    t22 = (t0 + 2392);
    t24 = (t0 + 12212);
    t25 = *((char **)t24);
    t24 = (t0 + 12164);
    t26 = 0;
    xsi_delete_subprogram_invocation(t22, t25, t0, t24, t26);
    xsi_set_current_line(379, ng0);
    t2 = ((char*)((ng2)));
    t3 = ((char*)((ng25)));
    t8 = (t0 + 12164);
    t9 = (t0 + 2392);
    t10 = xsi_create_subprogram_invocation(t8, 0, t0, t9, 0, 0);
    xsi_vlog_subprogram_pushinvocation(t9, t10);
    t12 = (t0 + 11112);
    xsi_vlogvar_assign_value(t12, t2, 0, 0, 9);
    t13 = (t0 + 11204);
    xsi_vlogvar_assign_value(t13, t3, 0, 0, 32);

LAB26:    t14 = (t0 + 12212);
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

LAB25:    t22 = (t0 + 12212);
    t23 = *((char **)t22);
    t22 = (t0 + 2392);
    t24 = (t0 + 12212);
    t25 = *((char **)t24);
    t24 = (t0 + 12164);
    t26 = 0;
    xsi_delete_subprogram_invocation(t22, t25, t0, t24, t26);
    xsi_set_current_line(380, ng0);
    t2 = ((char*)((ng26)));
    t3 = ((char*)((ng25)));
    t8 = (t0 + 12164);
    t9 = (t0 + 2392);
    t10 = xsi_create_subprogram_invocation(t8, 0, t0, t9, 0, 0);
    xsi_vlog_subprogram_pushinvocation(t9, t10);
    t12 = (t0 + 11112);
    xsi_vlogvar_assign_value(t12, t2, 0, 0, 9);
    t13 = (t0 + 11204);
    xsi_vlogvar_assign_value(t13, t3, 0, 0, 32);

LAB30:    t14 = (t0 + 12212);
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

LAB29:    t22 = (t0 + 12212);
    t23 = *((char **)t22);
    t22 = (t0 + 2392);
    t24 = (t0 + 12212);
    t25 = *((char **)t24);
    t24 = (t0 + 12164);
    t26 = 0;
    xsi_delete_subprogram_invocation(t22, t25, t0, t24, t26);
    xsi_set_current_line(381, ng0);
    t2 = ((char*)((ng27)));
    t3 = ((char*)((ng25)));
    t8 = (t0 + 12164);
    t9 = (t0 + 2392);
    t10 = xsi_create_subprogram_invocation(t8, 0, t0, t9, 0, 0);
    xsi_vlog_subprogram_pushinvocation(t9, t10);
    t12 = (t0 + 11112);
    xsi_vlogvar_assign_value(t12, t2, 0, 0, 9);
    t13 = (t0 + 11204);
    xsi_vlogvar_assign_value(t13, t3, 0, 0, 32);

LAB34:    t14 = (t0 + 12212);
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

LAB33:    t22 = (t0 + 12212);
    t23 = *((char **)t22);
    t22 = (t0 + 2392);
    t24 = (t0 + 12212);
    t25 = *((char **)t24);
    t24 = (t0 + 12164);
    t26 = 0;
    xsi_delete_subprogram_invocation(t22, t25, t0, t24, t26);
    xsi_set_current_line(382, ng0);
    t2 = ((char*)((ng28)));
    t3 = ((char*)((ng25)));
    t8 = (t0 + 12164);
    t9 = (t0 + 2392);
    t10 = xsi_create_subprogram_invocation(t8, 0, t0, t9, 0, 0);
    xsi_vlog_subprogram_pushinvocation(t9, t10);
    t12 = (t0 + 11112);
    xsi_vlogvar_assign_value(t12, t2, 0, 0, 9);
    t13 = (t0 + 11204);
    xsi_vlogvar_assign_value(t13, t3, 0, 0, 32);

LAB38:    t14 = (t0 + 12212);
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

LAB37:    t22 = (t0 + 12212);
    t23 = *((char **)t22);
    t22 = (t0 + 2392);
    t24 = (t0 + 12212);
    t25 = *((char **)t24);
    t24 = (t0 + 12164);
    t26 = 0;
    xsi_delete_subprogram_invocation(t22, t25, t0, t24, t26);
    xsi_set_current_line(383, ng0);
    t2 = ((char*)((ng29)));
    t3 = ((char*)((ng30)));
    t8 = (t0 + 12164);
    t9 = (t0 + 2392);
    t10 = xsi_create_subprogram_invocation(t8, 0, t0, t9, 0, 0);
    xsi_vlog_subprogram_pushinvocation(t9, t10);
    t12 = (t0 + 11112);
    xsi_vlogvar_assign_value(t12, t2, 0, 0, 9);
    t13 = (t0 + 11204);
    xsi_vlogvar_assign_value(t13, t3, 0, 0, 32);

LAB42:    t14 = (t0 + 12212);
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

LAB41:    t22 = (t0 + 12212);
    t23 = *((char **)t22);
    t22 = (t0 + 2392);
    t24 = (t0 + 12212);
    t25 = *((char **)t24);
    t24 = (t0 + 12164);
    t26 = 0;
    xsi_delete_subprogram_invocation(t22, t25, t0, t24, t26);
    xsi_set_current_line(384, ng0);
    t2 = ((char*)((ng31)));
    t3 = ((char*)((ng32)));
    t8 = (t0 + 12164);
    t9 = (t0 + 2392);
    t10 = xsi_create_subprogram_invocation(t8, 0, t0, t9, 0, 0);
    xsi_vlog_subprogram_pushinvocation(t9, t10);
    t12 = (t0 + 11112);
    xsi_vlogvar_assign_value(t12, t2, 0, 0, 9);
    t13 = (t0 + 11204);
    xsi_vlogvar_assign_value(t13, t3, 0, 0, 32);

LAB46:    t14 = (t0 + 12212);
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

LAB45:    t22 = (t0 + 12212);
    t23 = *((char **)t22);
    t22 = (t0 + 2392);
    t24 = (t0 + 12212);
    t25 = *((char **)t24);
    t24 = (t0 + 12164);
    t26 = 0;
    xsi_delete_subprogram_invocation(t22, t25, t0, t24, t26);
    xsi_set_current_line(385, ng0);
    t2 = ((char*)((ng33)));
    t3 = ((char*)((ng32)));
    t8 = (t0 + 12164);
    t9 = (t0 + 2392);
    t10 = xsi_create_subprogram_invocation(t8, 0, t0, t9, 0, 0);
    xsi_vlog_subprogram_pushinvocation(t9, t10);
    t12 = (t0 + 11112);
    xsi_vlogvar_assign_value(t12, t2, 0, 0, 9);
    t13 = (t0 + 11204);
    xsi_vlogvar_assign_value(t13, t3, 0, 0, 32);

LAB50:    t14 = (t0 + 12212);
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

LAB49:    t22 = (t0 + 12212);
    t23 = *((char **)t22);
    t22 = (t0 + 2392);
    t24 = (t0 + 12212);
    t25 = *((char **)t24);
    t24 = (t0 + 12164);
    t26 = 0;
    xsi_delete_subprogram_invocation(t22, t25, t0, t24, t26);
    xsi_set_current_line(386, ng0);
    t2 = ((char*)((ng22)));
    t3 = ((char*)((ng32)));
    t8 = (t0 + 12164);
    t9 = (t0 + 2392);
    t10 = xsi_create_subprogram_invocation(t8, 0, t0, t9, 0, 0);
    xsi_vlog_subprogram_pushinvocation(t9, t10);
    t12 = (t0 + 11112);
    xsi_vlogvar_assign_value(t12, t2, 0, 0, 9);
    t13 = (t0 + 11204);
    xsi_vlogvar_assign_value(t13, t3, 0, 0, 32);

LAB54:    t14 = (t0 + 12212);
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

LAB53:    t22 = (t0 + 12212);
    t23 = *((char **)t22);
    t22 = (t0 + 2392);
    t24 = (t0 + 12212);
    t25 = *((char **)t24);
    t24 = (t0 + 12164);
    t26 = 0;
    xsi_delete_subprogram_invocation(t22, t25, t0, t24, t26);
    xsi_set_current_line(387, ng0);
    t2 = ((char*)((ng34)));
    t3 = ((char*)((ng32)));
    t8 = (t0 + 12164);
    t9 = (t0 + 2392);
    t10 = xsi_create_subprogram_invocation(t8, 0, t0, t9, 0, 0);
    xsi_vlog_subprogram_pushinvocation(t9, t10);
    t12 = (t0 + 11112);
    xsi_vlogvar_assign_value(t12, t2, 0, 0, 9);
    t13 = (t0 + 11204);
    xsi_vlogvar_assign_value(t13, t3, 0, 0, 32);

LAB58:    t14 = (t0 + 12212);
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

LAB57:    t22 = (t0 + 12212);
    t23 = *((char **)t22);
    t22 = (t0 + 2392);
    t24 = (t0 + 12212);
    t25 = *((char **)t24);
    t24 = (t0 + 12164);
    t26 = 0;
    xsi_delete_subprogram_invocation(t22, t25, t0, t24, t26);
    xsi_set_current_line(388, ng0);
    t2 = ((char*)((ng35)));
    t3 = ((char*)((ng36)));
    t8 = (t0 + 12164);
    t9 = (t0 + 2392);
    t10 = xsi_create_subprogram_invocation(t8, 0, t0, t9, 0, 0);
    xsi_vlog_subprogram_pushinvocation(t9, t10);
    t12 = (t0 + 11112);
    xsi_vlogvar_assign_value(t12, t2, 0, 0, 9);
    t13 = (t0 + 11204);
    xsi_vlogvar_assign_value(t13, t3, 0, 0, 32);

LAB62:    t14 = (t0 + 12212);
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

LAB61:    t22 = (t0 + 12212);
    t23 = *((char **)t22);
    t22 = (t0 + 2392);
    t24 = (t0 + 12212);
    t25 = *((char **)t24);
    t24 = (t0 + 12164);
    t26 = 0;
    xsi_delete_subprogram_invocation(t22, t25, t0, t24, t26);
    xsi_set_current_line(389, ng0);
    t2 = ((char*)((ng37)));
    t3 = ((char*)((ng32)));
    t8 = (t0 + 12164);
    t9 = (t0 + 2392);
    t10 = xsi_create_subprogram_invocation(t8, 0, t0, t9, 0, 0);
    xsi_vlog_subprogram_pushinvocation(t9, t10);
    t12 = (t0 + 11112);
    xsi_vlogvar_assign_value(t12, t2, 0, 0, 9);
    t13 = (t0 + 11204);
    xsi_vlogvar_assign_value(t13, t3, 0, 0, 32);

LAB66:    t14 = (t0 + 12212);
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

LAB65:    t22 = (t0 + 12212);
    t23 = *((char **)t22);
    t22 = (t0 + 2392);
    t24 = (t0 + 12212);
    t25 = *((char **)t24);
    t24 = (t0 + 12164);
    t26 = 0;
    xsi_delete_subprogram_invocation(t22, t25, t0, t24, t26);
    xsi_set_current_line(390, ng0);
    t2 = ((char*)((ng38)));
    t3 = ((char*)((ng39)));
    t8 = (t0 + 12164);
    t9 = (t0 + 2392);
    t10 = xsi_create_subprogram_invocation(t8, 0, t0, t9, 0, 0);
    xsi_vlog_subprogram_pushinvocation(t9, t10);
    t12 = (t0 + 11112);
    xsi_vlogvar_assign_value(t12, t2, 0, 0, 9);
    t13 = (t0 + 11204);
    xsi_vlogvar_assign_value(t13, t3, 0, 0, 32);

LAB70:    t14 = (t0 + 12212);
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

LAB69:    t22 = (t0 + 12212);
    t23 = *((char **)t22);
    t22 = (t0 + 2392);
    t24 = (t0 + 12212);
    t25 = *((char **)t24);
    t24 = (t0 + 12164);
    t26 = 0;
    xsi_delete_subprogram_invocation(t22, t25, t0, t24, t26);
    xsi_set_current_line(391, ng0);
    t2 = ((char*)((ng40)));
    t3 = ((char*)((ng41)));
    t8 = (t0 + 12164);
    t9 = (t0 + 2392);
    t10 = xsi_create_subprogram_invocation(t8, 0, t0, t9, 0, 0);
    xsi_vlog_subprogram_pushinvocation(t9, t10);
    t12 = (t0 + 11112);
    xsi_vlogvar_assign_value(t12, t2, 0, 0, 9);
    t13 = (t0 + 11204);
    xsi_vlogvar_assign_value(t13, t3, 0, 0, 32);

LAB74:    t14 = (t0 + 12212);
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

LAB73:    t22 = (t0 + 12212);
    t23 = *((char **)t22);
    t22 = (t0 + 2392);
    t24 = (t0 + 12212);
    t25 = *((char **)t24);
    t24 = (t0 + 12164);
    t26 = 0;
    xsi_delete_subprogram_invocation(t22, t25, t0, t24, t26);
    xsi_set_current_line(394, ng0);
    xsi_vlogfile_write(1, 0, ng42, 1, t0);
    xsi_set_current_line(395, ng0);
    t2 = ((char*)((ng43)));
    t3 = ((char*)((ng44)));
    t8 = (t0 + 12164);
    t9 = (t0 + 2872);
    t10 = xsi_create_subprogram_invocation(t8, 0, t0, t9, 0, 0);
    xsi_vlog_subprogram_pushinvocation(t9, t10);
    t12 = (t0 + 11296);
    xsi_vlogvar_assign_value(t12, t2, 0, 0, 8);
    t13 = (t0 + 11388);
    xsi_vlogvar_assign_value(t13, t3, 0, 0, 64);

LAB78:    t14 = (t0 + 12212);
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

LAB79:    t15 = (t0 + 2872);
    xsi_vlog_subprogram_popinvocation(t15);

LAB77:    t22 = (t0 + 12212);
    t23 = *((char **)t22);
    t22 = (t0 + 2872);
    t24 = (t0 + 12212);
    t25 = *((char **)t24);
    t24 = (t0 + 12164);
    t26 = 0;
    xsi_delete_subprogram_invocation(t22, t25, t0, t24, t26);
    xsi_set_current_line(396, ng0);
    t2 = ((char*)((ng1)));
    t3 = ((char*)((ng45)));
    t8 = (t0 + 12164);
    t9 = (t0 + 2872);
    t10 = xsi_create_subprogram_invocation(t8, 0, t0, t9, 0, 0);
    xsi_vlog_subprogram_pushinvocation(t9, t10);
    t12 = (t0 + 11296);
    xsi_vlogvar_assign_value(t12, t2, 0, 0, 8);
    t13 = (t0 + 11388);
    xsi_vlogvar_assign_value(t13, t3, 0, 0, 64);

LAB82:    t14 = (t0 + 12212);
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

LAB83:    t15 = (t0 + 2872);
    xsi_vlog_subprogram_popinvocation(t15);

LAB81:    t22 = (t0 + 12212);
    t23 = *((char **)t22);
    t22 = (t0 + 2872);
    t24 = (t0 + 12212);
    t25 = *((char **)t24);
    t24 = (t0 + 12164);
    t26 = 0;
    xsi_delete_subprogram_invocation(t22, t25, t0, t24, t26);
    xsi_set_current_line(397, ng0);
    t2 = ((char*)((ng2)));
    t3 = ((char*)((ng46)));
    t8 = (t0 + 12164);
    t9 = (t0 + 2872);
    t10 = xsi_create_subprogram_invocation(t8, 0, t0, t9, 0, 0);
    xsi_vlog_subprogram_pushinvocation(t9, t10);
    t12 = (t0 + 11296);
    xsi_vlogvar_assign_value(t12, t2, 0, 0, 8);
    t13 = (t0 + 11388);
    xsi_vlogvar_assign_value(t13, t3, 0, 0, 64);

LAB86:    t14 = (t0 + 12212);
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

LAB87:    t15 = (t0 + 2872);
    xsi_vlog_subprogram_popinvocation(t15);

LAB85:    t22 = (t0 + 12212);
    t23 = *((char **)t22);
    t22 = (t0 + 2872);
    t24 = (t0 + 12212);
    t25 = *((char **)t24);
    t24 = (t0 + 12164);
    t26 = 0;
    xsi_delete_subprogram_invocation(t22, t25, t0, t24, t26);
    xsi_set_current_line(400, ng0);
    t2 = ((char*)((ng47)));
    t3 = (t2 + 4U);
    t4 = *((unsigned int *)t3);
    t5 = (~(t4));
    t6 = *((unsigned int *)t2);
    t7 = (t6 & t5);
    t8 = (t0 + 17196);
    *((int *)t8) = t7;

LAB89:    t9 = (t0 + 17196);
    if (*((int *)t9) > 0)
        goto LAB90;

LAB91:    xsi_set_current_line(401, ng0);
    xsi_vlogfile_write(1, 0, ng48, 1, t0);
    xsi_set_current_line(402, ng0);
    t2 = (t0 + 12164);
    t3 = (t0 + 2632);
    t8 = xsi_create_subprogram_invocation(t2, 0, t0, t3, 0, 0);
    xsi_vlog_subprogram_pushinvocation(t3, t8);

LAB94:    t9 = (t0 + 12212);
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

LAB93:    t18 = (t0 + 12212);
    t19 = *((char **)t18);
    t18 = (t0 + 2632);
    t20 = (t0 + 12212);
    t21 = *((char **)t20);
    t20 = (t0 + 12164);
    t22 = 0;
    xsi_delete_subprogram_invocation(t18, t21, t0, t20, t22);
    xsi_set_current_line(404, ng0);
    t2 = ((char*)((ng49)));
    t3 = (t2 + 4U);
    t4 = *((unsigned int *)t3);
    t5 = (~(t4));
    t6 = *((unsigned int *)t2);
    t7 = (t6 & t5);
    t8 = (t0 + 17200);
    *((int *)t8) = t7;

LAB97:    t9 = (t0 + 17200);
    if (*((int *)t9) > 0)
        goto LAB98;

LAB99:    xsi_set_current_line(405, ng0);
    t2 = xsi_vlog_time(t11, 1000000.000000000, 1000.000000000000);
    xsi_vlogfile_write(1, 0, ng50, 2, t0, (char)118, t11, 64);
    xsi_set_current_line(406, ng0);
    xsi_vlog_finish(1);

LAB1:    return;
LAB6:    xsi_set_current_line(366, ng0);
    t10 = (t0 + 12612);
    *((int *)t10) = 1;
    *((char **)t1) = &&LAB8;
    goto LAB1;

LAB8:    t2 = (t0 + 17192);
    t7 = *((int *)t2);
    *((int *)t2) = (t7 - 1);
    goto LAB5;

LAB12:    t14 = (t0 + 12248U);
    *((char **)t14) = &&LAB10;
    goto LAB1;

LAB16:    t14 = (t0 + 12248U);
    *((char **)t14) = &&LAB14;
    goto LAB1;

LAB20:    t12 = (t0 + 12248U);
    *((char **)t12) = &&LAB18;
    goto LAB1;

LAB24:    t14 = (t0 + 12248U);
    *((char **)t14) = &&LAB22;
    goto LAB1;

LAB28:    t14 = (t0 + 12248U);
    *((char **)t14) = &&LAB26;
    goto LAB1;

LAB32:    t14 = (t0 + 12248U);
    *((char **)t14) = &&LAB30;
    goto LAB1;

LAB36:    t14 = (t0 + 12248U);
    *((char **)t14) = &&LAB34;
    goto LAB1;

LAB40:    t14 = (t0 + 12248U);
    *((char **)t14) = &&LAB38;
    goto LAB1;

LAB44:    t14 = (t0 + 12248U);
    *((char **)t14) = &&LAB42;
    goto LAB1;

LAB48:    t14 = (t0 + 12248U);
    *((char **)t14) = &&LAB46;
    goto LAB1;

LAB52:    t14 = (t0 + 12248U);
    *((char **)t14) = &&LAB50;
    goto LAB1;

LAB56:    t14 = (t0 + 12248U);
    *((char **)t14) = &&LAB54;
    goto LAB1;

LAB60:    t14 = (t0 + 12248U);
    *((char **)t14) = &&LAB58;
    goto LAB1;

LAB64:    t14 = (t0 + 12248U);
    *((char **)t14) = &&LAB62;
    goto LAB1;

LAB68:    t14 = (t0 + 12248U);
    *((char **)t14) = &&LAB66;
    goto LAB1;

LAB72:    t14 = (t0 + 12248U);
    *((char **)t14) = &&LAB70;
    goto LAB1;

LAB76:    t14 = (t0 + 12248U);
    *((char **)t14) = &&LAB74;
    goto LAB1;

LAB80:    t14 = (t0 + 12248U);
    *((char **)t14) = &&LAB78;
    goto LAB1;

LAB84:    t14 = (t0 + 12248U);
    *((char **)t14) = &&LAB82;
    goto LAB1;

LAB88:    t14 = (t0 + 12248U);
    *((char **)t14) = &&LAB86;
    goto LAB1;

LAB90:    xsi_set_current_line(400, ng0);
    t10 = (t0 + 12620);
    *((int *)t10) = 1;
    *((char **)t1) = &&LAB92;
    goto LAB1;

LAB92:    t2 = (t0 + 17196);
    t7 = *((int *)t2);
    *((int *)t2) = (t7 - 1);
    goto LAB89;

LAB96:    t9 = (t0 + 12248U);
    *((char **)t9) = &&LAB94;
    goto LAB1;

LAB98:    xsi_set_current_line(404, ng0);
    t10 = (t0 + 12628);
    *((int *)t10) = 1;
    *((char **)t1) = &&LAB100;
    goto LAB1;

LAB100:    t2 = (t0 + 17200);
    t7 = *((int *)t2);
    *((int *)t2) = (t7 - 1);
    goto LAB97;

}

static void I409_4(char *t0)
{
    char t3[16];
    char *t1;
    char *t2;

LAB0:    t1 = (t0 + 12376U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(409, ng0);

LAB4:    xsi_set_current_line(410, ng0);
    t2 = (t0 + 12292);
    xsi_process_wait(t2, 400000000000LL);
    *((char **)t1) = &&LAB5;

LAB1:    return;
LAB5:    xsi_set_current_line(411, ng0);
    t2 = xsi_vlog_time(t3, 1000000.000000000, 1000.000000000000);
    xsi_vlogfile_write(1, 0, ng51, 2, t0, (char)118, t3, 64);
    xsi_set_current_line(412, ng0);
    xsi_vlog_finish(1);
    goto LAB1;

}


extern void work_m_00000000001670876644_4096408752_init()
{
	static char *pe[] = {(void *)I277_0,(void *)A278_1,(void *)A346_2,(void *)I357_3,(void *)I409_4};
	static char *se[] = {(void *)sp_reg_write,(void *)sp_pulse_input_type,(void *)sp_write_gpu_imem,(void *)sp_arm_imem_write_udp,(void *)sp_pulse_cpu_start_udp,(void *)sp_send_word_in0};
	xsi_register_didat("work_m_00000000001670876644_4096408752", "isim/_tmp/work/m_00000000001670876644_4096408752.didat");
	xsi_register_executes(pe);
	xsi_register_subprogram_executes(se);
}
