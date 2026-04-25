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
static const char *ng0 = "C:/Xilinx/10.1/ISE/ISEexamples/lab9_net/alu_64bit_gpu.v";
static unsigned int ng1[] = {1U, 0U};
static unsigned int ng2[] = {2U, 0U};
static unsigned int ng3[] = {8U, 0U};
static unsigned int ng4[] = {9U, 0U};
static unsigned int ng5[] = {0U, 0U};



static void N28_0(char *t0)
{
    char t3[8];
    char *t1;
    char *t2;
    char *t4;
    char *t5;
    unsigned int t6;
    unsigned int t7;
    unsigned int t8;
    unsigned int t9;
    unsigned int t10;
    unsigned int t11;
    char *t12;
    char *t13;
    char *t14;
    char *t15;
    char *t16;
    char *t17;
    unsigned int t18;
    unsigned int t19;
    char *t20;
    unsigned int t21;
    unsigned int t22;
    unsigned int t23;
    unsigned int t24;
    unsigned int t25;
    unsigned int t26;
    char *t27;

LAB0:    t1 = (t0 + 2512U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    t2 = (t0 + 564U);
    t4 = *((char **)t2);
    memset(t3, 0, 8);
    t2 = (t3 + 4U);
    t5 = (t4 + 4U);
    t6 = *((unsigned int *)t4);
    t7 = (t6 >> 0);
    *((unsigned int *)t3) = t7;
    t8 = *((unsigned int *)t5);
    t9 = (t8 >> 0);
    *((unsigned int *)t2) = t9;
    t10 = *((unsigned int *)t3);
    *((unsigned int *)t3) = (t10 & 65535U);
    t11 = *((unsigned int *)t2);
    *((unsigned int *)t2) = (t11 & 65535U);
    t12 = (t0 + 3824);
    t13 = (t12 + 32U);
    t14 = *((char **)t13);
    t15 = (t14 + 40U);
    t16 = *((char **)t15);
    t17 = (t16 + 4U);
    t18 = 65535U;
    t19 = t18;
    t20 = (t3 + 4U);
    t21 = *((unsigned int *)t3);
    t18 = (t18 & t21);
    t22 = *((unsigned int *)t20);
    t19 = (t19 & t22);
    t23 = *((unsigned int *)t16);
    *((unsigned int *)t16) = (t23 & 4294901760U);
    t24 = *((unsigned int *)t16);
    *((unsigned int *)t16) = (t24 | t18);
    t25 = *((unsigned int *)t17);
    *((unsigned int *)t17) = (t25 & 4294901760U);
    t26 = *((unsigned int *)t17);
    *((unsigned int *)t17) = (t26 | t19);
    xsi_driver_vfirst_trans(t12, 0, 15U);
    t27 = (t0 + 3716);
    *((int *)t27) = 1;

LAB1:    return;
}

static void N29_1(char *t0)
{
    char t3[8];
    char *t1;
    char *t2;
    char *t4;
    char *t5;
    unsigned int t6;
    unsigned int t7;
    unsigned int t8;
    unsigned int t9;
    unsigned int t10;
    unsigned int t11;
    char *t12;
    char *t13;
    char *t14;
    char *t15;
    char *t16;
    char *t17;
    unsigned int t18;
    unsigned int t19;
    char *t20;
    unsigned int t21;
    unsigned int t22;
    unsigned int t23;
    unsigned int t24;
    unsigned int t25;
    unsigned int t26;
    char *t27;

LAB0:    t1 = (t0 + 2640U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    t2 = (t0 + 564U);
    t4 = *((char **)t2);
    memset(t3, 0, 8);
    t2 = (t3 + 4U);
    t5 = (t4 + 4U);
    t6 = *((unsigned int *)t4);
    t7 = (t6 >> 16);
    *((unsigned int *)t3) = t7;
    t8 = *((unsigned int *)t5);
    t9 = (t8 >> 16);
    *((unsigned int *)t2) = t9;
    t10 = *((unsigned int *)t3);
    *((unsigned int *)t3) = (t10 & 65535U);
    t11 = *((unsigned int *)t2);
    *((unsigned int *)t2) = (t11 & 65535U);
    t12 = (t0 + 3860);
    t13 = (t12 + 32U);
    t14 = *((char **)t13);
    t15 = (t14 + 40U);
    t16 = *((char **)t15);
    t17 = (t16 + 4U);
    t18 = 65535U;
    t19 = t18;
    t20 = (t3 + 4U);
    t21 = *((unsigned int *)t3);
    t18 = (t18 & t21);
    t22 = *((unsigned int *)t20);
    t19 = (t19 & t22);
    t23 = *((unsigned int *)t16);
    *((unsigned int *)t16) = (t23 & 4294901760U);
    t24 = *((unsigned int *)t16);
    *((unsigned int *)t16) = (t24 | t18);
    t25 = *((unsigned int *)t17);
    *((unsigned int *)t17) = (t25 & 4294901760U);
    t26 = *((unsigned int *)t17);
    *((unsigned int *)t17) = (t26 | t19);
    xsi_driver_vfirst_trans(t12, 0, 15U);
    t27 = (t0 + 3724);
    *((int *)t27) = 1;

LAB1:    return;
}

static void N30_2(char *t0)
{
    char t3[8];
    char *t1;
    char *t2;
    char *t4;
    char *t5;
    char *t6;
    unsigned int t7;
    unsigned int t8;
    unsigned int t9;
    unsigned int t10;
    unsigned int t11;
    unsigned int t12;
    char *t13;
    char *t14;
    char *t15;
    char *t16;
    char *t17;
    char *t18;
    unsigned int t19;
    unsigned int t20;
    char *t21;
    unsigned int t22;
    unsigned int t23;
    unsigned int t24;
    unsigned int t25;
    unsigned int t26;
    unsigned int t27;
    char *t28;

LAB0:    t1 = (t0 + 2768U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    t2 = (t0 + 564U);
    t4 = *((char **)t2);
    memset(t3, 0, 8);
    t2 = (t3 + 4U);
    t5 = (t4 + 8U);
    t6 = (t4 + 12U);
    t7 = *((unsigned int *)t5);
    t8 = (t7 >> 0);
    *((unsigned int *)t3) = t8;
    t9 = *((unsigned int *)t6);
    t10 = (t9 >> 0);
    *((unsigned int *)t2) = t10;
    t11 = *((unsigned int *)t3);
    *((unsigned int *)t3) = (t11 & 65535U);
    t12 = *((unsigned int *)t2);
    *((unsigned int *)t2) = (t12 & 65535U);
    t13 = (t0 + 3896);
    t14 = (t13 + 32U);
    t15 = *((char **)t14);
    t16 = (t15 + 40U);
    t17 = *((char **)t16);
    t18 = (t17 + 4U);
    t19 = 65535U;
    t20 = t19;
    t21 = (t3 + 4U);
    t22 = *((unsigned int *)t3);
    t19 = (t19 & t22);
    t23 = *((unsigned int *)t21);
    t20 = (t20 & t23);
    t24 = *((unsigned int *)t17);
    *((unsigned int *)t17) = (t24 & 4294901760U);
    t25 = *((unsigned int *)t17);
    *((unsigned int *)t17) = (t25 | t19);
    t26 = *((unsigned int *)t18);
    *((unsigned int *)t18) = (t26 & 4294901760U);
    t27 = *((unsigned int *)t18);
    *((unsigned int *)t18) = (t27 | t20);
    xsi_driver_vfirst_trans(t13, 0, 15U);
    t28 = (t0 + 3732);
    *((int *)t28) = 1;

LAB1:    return;
}

static void N31_3(char *t0)
{
    char t3[8];
    char *t1;
    char *t2;
    char *t4;
    char *t5;
    char *t6;
    unsigned int t7;
    unsigned int t8;
    unsigned int t9;
    unsigned int t10;
    unsigned int t11;
    unsigned int t12;
    char *t13;
    char *t14;
    char *t15;
    char *t16;
    char *t17;
    char *t18;
    unsigned int t19;
    unsigned int t20;
    char *t21;
    unsigned int t22;
    unsigned int t23;
    unsigned int t24;
    unsigned int t25;
    unsigned int t26;
    unsigned int t27;
    char *t28;

LAB0:    t1 = (t0 + 2896U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    t2 = (t0 + 564U);
    t4 = *((char **)t2);
    memset(t3, 0, 8);
    t2 = (t3 + 4U);
    t5 = (t4 + 8U);
    t6 = (t4 + 12U);
    t7 = *((unsigned int *)t5);
    t8 = (t7 >> 16);
    *((unsigned int *)t3) = t8;
    t9 = *((unsigned int *)t6);
    t10 = (t9 >> 16);
    *((unsigned int *)t2) = t10;
    t11 = *((unsigned int *)t3);
    *((unsigned int *)t3) = (t11 & 65535U);
    t12 = *((unsigned int *)t2);
    *((unsigned int *)t2) = (t12 & 65535U);
    t13 = (t0 + 3932);
    t14 = (t13 + 32U);
    t15 = *((char **)t14);
    t16 = (t15 + 40U);
    t17 = *((char **)t16);
    t18 = (t17 + 4U);
    t19 = 65535U;
    t20 = t19;
    t21 = (t3 + 4U);
    t22 = *((unsigned int *)t3);
    t19 = (t19 & t22);
    t23 = *((unsigned int *)t21);
    t20 = (t20 & t23);
    t24 = *((unsigned int *)t17);
    *((unsigned int *)t17) = (t24 & 4294901760U);
    t25 = *((unsigned int *)t17);
    *((unsigned int *)t17) = (t25 | t19);
    t26 = *((unsigned int *)t18);
    *((unsigned int *)t18) = (t26 & 4294901760U);
    t27 = *((unsigned int *)t18);
    *((unsigned int *)t18) = (t27 | t20);
    xsi_driver_vfirst_trans(t13, 0, 15U);
    t28 = (t0 + 3740);
    *((int *)t28) = 1;

LAB1:    return;
}

static void N33_4(char *t0)
{
    char t3[8];
    char *t1;
    char *t2;
    char *t4;
    char *t5;
    unsigned int t6;
    unsigned int t7;
    unsigned int t8;
    unsigned int t9;
    unsigned int t10;
    unsigned int t11;
    char *t12;
    char *t13;
    char *t14;
    char *t15;
    char *t16;
    char *t17;
    unsigned int t18;
    unsigned int t19;
    char *t20;
    unsigned int t21;
    unsigned int t22;
    unsigned int t23;
    unsigned int t24;
    unsigned int t25;
    unsigned int t26;
    char *t27;

LAB0:    t1 = (t0 + 3024U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    t2 = (t0 + 652U);
    t4 = *((char **)t2);
    memset(t3, 0, 8);
    t2 = (t3 + 4U);
    t5 = (t4 + 4U);
    t6 = *((unsigned int *)t4);
    t7 = (t6 >> 0);
    *((unsigned int *)t3) = t7;
    t8 = *((unsigned int *)t5);
    t9 = (t8 >> 0);
    *((unsigned int *)t2) = t9;
    t10 = *((unsigned int *)t3);
    *((unsigned int *)t3) = (t10 & 65535U);
    t11 = *((unsigned int *)t2);
    *((unsigned int *)t2) = (t11 & 65535U);
    t12 = (t0 + 3968);
    t13 = (t12 + 32U);
    t14 = *((char **)t13);
    t15 = (t14 + 40U);
    t16 = *((char **)t15);
    t17 = (t16 + 4U);
    t18 = 65535U;
    t19 = t18;
    t20 = (t3 + 4U);
    t21 = *((unsigned int *)t3);
    t18 = (t18 & t21);
    t22 = *((unsigned int *)t20);
    t19 = (t19 & t22);
    t23 = *((unsigned int *)t16);
    *((unsigned int *)t16) = (t23 & 4294901760U);
    t24 = *((unsigned int *)t16);
    *((unsigned int *)t16) = (t24 | t18);
    t25 = *((unsigned int *)t17);
    *((unsigned int *)t17) = (t25 & 4294901760U);
    t26 = *((unsigned int *)t17);
    *((unsigned int *)t17) = (t26 | t19);
    xsi_driver_vfirst_trans(t12, 0, 15U);
    t27 = (t0 + 3748);
    *((int *)t27) = 1;

LAB1:    return;
}

static void N34_5(char *t0)
{
    char t3[8];
    char *t1;
    char *t2;
    char *t4;
    char *t5;
    unsigned int t6;
    unsigned int t7;
    unsigned int t8;
    unsigned int t9;
    unsigned int t10;
    unsigned int t11;
    char *t12;
    char *t13;
    char *t14;
    char *t15;
    char *t16;
    char *t17;
    unsigned int t18;
    unsigned int t19;
    char *t20;
    unsigned int t21;
    unsigned int t22;
    unsigned int t23;
    unsigned int t24;
    unsigned int t25;
    unsigned int t26;
    char *t27;

LAB0:    t1 = (t0 + 3152U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    t2 = (t0 + 652U);
    t4 = *((char **)t2);
    memset(t3, 0, 8);
    t2 = (t3 + 4U);
    t5 = (t4 + 4U);
    t6 = *((unsigned int *)t4);
    t7 = (t6 >> 16);
    *((unsigned int *)t3) = t7;
    t8 = *((unsigned int *)t5);
    t9 = (t8 >> 16);
    *((unsigned int *)t2) = t9;
    t10 = *((unsigned int *)t3);
    *((unsigned int *)t3) = (t10 & 65535U);
    t11 = *((unsigned int *)t2);
    *((unsigned int *)t2) = (t11 & 65535U);
    t12 = (t0 + 4004);
    t13 = (t12 + 32U);
    t14 = *((char **)t13);
    t15 = (t14 + 40U);
    t16 = *((char **)t15);
    t17 = (t16 + 4U);
    t18 = 65535U;
    t19 = t18;
    t20 = (t3 + 4U);
    t21 = *((unsigned int *)t3);
    t18 = (t18 & t21);
    t22 = *((unsigned int *)t20);
    t19 = (t19 & t22);
    t23 = *((unsigned int *)t16);
    *((unsigned int *)t16) = (t23 & 4294901760U);
    t24 = *((unsigned int *)t16);
    *((unsigned int *)t16) = (t24 | t18);
    t25 = *((unsigned int *)t17);
    *((unsigned int *)t17) = (t25 & 4294901760U);
    t26 = *((unsigned int *)t17);
    *((unsigned int *)t17) = (t26 | t19);
    xsi_driver_vfirst_trans(t12, 0, 15U);
    t27 = (t0 + 3756);
    *((int *)t27) = 1;

LAB1:    return;
}

static void N35_6(char *t0)
{
    char t3[8];
    char *t1;
    char *t2;
    char *t4;
    char *t5;
    char *t6;
    unsigned int t7;
    unsigned int t8;
    unsigned int t9;
    unsigned int t10;
    unsigned int t11;
    unsigned int t12;
    char *t13;
    char *t14;
    char *t15;
    char *t16;
    char *t17;
    char *t18;
    unsigned int t19;
    unsigned int t20;
    char *t21;
    unsigned int t22;
    unsigned int t23;
    unsigned int t24;
    unsigned int t25;
    unsigned int t26;
    unsigned int t27;
    char *t28;

LAB0:    t1 = (t0 + 3280U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    t2 = (t0 + 652U);
    t4 = *((char **)t2);
    memset(t3, 0, 8);
    t2 = (t3 + 4U);
    t5 = (t4 + 8U);
    t6 = (t4 + 12U);
    t7 = *((unsigned int *)t5);
    t8 = (t7 >> 0);
    *((unsigned int *)t3) = t8;
    t9 = *((unsigned int *)t6);
    t10 = (t9 >> 0);
    *((unsigned int *)t2) = t10;
    t11 = *((unsigned int *)t3);
    *((unsigned int *)t3) = (t11 & 65535U);
    t12 = *((unsigned int *)t2);
    *((unsigned int *)t2) = (t12 & 65535U);
    t13 = (t0 + 4040);
    t14 = (t13 + 32U);
    t15 = *((char **)t14);
    t16 = (t15 + 40U);
    t17 = *((char **)t16);
    t18 = (t17 + 4U);
    t19 = 65535U;
    t20 = t19;
    t21 = (t3 + 4U);
    t22 = *((unsigned int *)t3);
    t19 = (t19 & t22);
    t23 = *((unsigned int *)t21);
    t20 = (t20 & t23);
    t24 = *((unsigned int *)t17);
    *((unsigned int *)t17) = (t24 & 4294901760U);
    t25 = *((unsigned int *)t17);
    *((unsigned int *)t17) = (t25 | t19);
    t26 = *((unsigned int *)t18);
    *((unsigned int *)t18) = (t26 & 4294901760U);
    t27 = *((unsigned int *)t18);
    *((unsigned int *)t18) = (t27 | t20);
    xsi_driver_vfirst_trans(t13, 0, 15U);
    t28 = (t0 + 3764);
    *((int *)t28) = 1;

LAB1:    return;
}

static void N36_7(char *t0)
{
    char t3[8];
    char *t1;
    char *t2;
    char *t4;
    char *t5;
    char *t6;
    unsigned int t7;
    unsigned int t8;
    unsigned int t9;
    unsigned int t10;
    unsigned int t11;
    unsigned int t12;
    char *t13;
    char *t14;
    char *t15;
    char *t16;
    char *t17;
    char *t18;
    unsigned int t19;
    unsigned int t20;
    char *t21;
    unsigned int t22;
    unsigned int t23;
    unsigned int t24;
    unsigned int t25;
    unsigned int t26;
    unsigned int t27;
    char *t28;

LAB0:    t1 = (t0 + 3408U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    t2 = (t0 + 652U);
    t4 = *((char **)t2);
    memset(t3, 0, 8);
    t2 = (t3 + 4U);
    t5 = (t4 + 8U);
    t6 = (t4 + 12U);
    t7 = *((unsigned int *)t5);
    t8 = (t7 >> 16);
    *((unsigned int *)t3) = t8;
    t9 = *((unsigned int *)t6);
    t10 = (t9 >> 16);
    *((unsigned int *)t2) = t10;
    t11 = *((unsigned int *)t3);
    *((unsigned int *)t3) = (t11 & 65535U);
    t12 = *((unsigned int *)t2);
    *((unsigned int *)t2) = (t12 & 65535U);
    t13 = (t0 + 4076);
    t14 = (t13 + 32U);
    t15 = *((char **)t14);
    t16 = (t15 + 40U);
    t17 = *((char **)t16);
    t18 = (t17 + 4U);
    t19 = 65535U;
    t20 = t19;
    t21 = (t3 + 4U);
    t22 = *((unsigned int *)t3);
    t19 = (t19 & t22);
    t23 = *((unsigned int *)t21);
    t20 = (t20 & t23);
    t24 = *((unsigned int *)t17);
    *((unsigned int *)t17) = (t24 & 4294901760U);
    t25 = *((unsigned int *)t17);
    *((unsigned int *)t17) = (t25 | t19);
    t26 = *((unsigned int *)t18);
    *((unsigned int *)t18) = (t26 & 4294901760U);
    t27 = *((unsigned int *)t18);
    *((unsigned int *)t18) = (t27 | t20);
    xsi_driver_vfirst_trans(t13, 0, 15U);
    t28 = (t0 + 3772);
    *((int *)t28) = 1;

LAB1:    return;
}

static void A41_8(char *t0)
{
    char t9[8];
    char t10[16];
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    int t5;
    char *t6;
    char *t7;
    char *t8;
    char *t11;
    char *t12;
    char *t13;
    char *t14;
    char *t15;
    char *t16;
    char *t17;
    char *t18;

LAB0:    t1 = (t0 + 3536U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(41, ng0);
    t2 = (t0 + 3780);
    *((int *)t2) = 1;
    *((char **)t1) = &&LAB4;

LAB1:    return;
LAB4:    xsi_set_current_line(41, ng0);

LAB5:    xsi_set_current_line(42, ng0);
    t3 = (t0 + 740U);
    t4 = *((char **)t3);

LAB6:    t3 = ((char*)((ng1)));
    t5 = xsi_vlog_unsigned_case_compare(t4, 4, t3, 4);
    if (t5 == 1)
        goto LAB7;

LAB8:    t2 = ((char*)((ng2)));
    t5 = xsi_vlog_unsigned_case_compare(t4, 4, t2, 4);
    if (t5 == 1)
        goto LAB9;

LAB10:    t2 = ((char*)((ng3)));
    t5 = xsi_vlog_unsigned_case_compare(t4, 4, t2, 4);
    if (t5 == 1)
        goto LAB11;

LAB12:    t2 = ((char*)((ng4)));
    t5 = xsi_vlog_unsigned_case_compare(t4, 4, t2, 4);
    if (t5 == 1)
        goto LAB13;

LAB14:
LAB16:
LAB15:    xsi_set_current_line(71, ng0);

LAB22:    xsi_set_current_line(72, ng0);
    t2 = ((char*)((ng5)));
    t3 = (t0 + 1760);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 16);
    xsi_set_current_line(73, ng0);
    t2 = ((char*)((ng5)));
    t3 = (t0 + 1852);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 16);
    xsi_set_current_line(74, ng0);
    t2 = ((char*)((ng5)));
    t3 = (t0 + 1944);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 16);
    xsi_set_current_line(75, ng0);
    t2 = ((char*)((ng5)));
    t3 = (t0 + 2036);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 16);

LAB17:    xsi_set_current_line(79, ng0);
    t2 = (t0 + 1760);
    t3 = (t2 + 32U);
    t6 = *((char **)t3);
    t7 = (t0 + 1852);
    t8 = (t7 + 32U);
    t11 = *((char **)t8);
    t12 = (t0 + 1944);
    t13 = (t12 + 32U);
    t14 = *((char **)t13);
    t15 = (t0 + 2036);
    t16 = (t15 + 32U);
    t17 = *((char **)t16);
    xsi_vlogtype_concat(t10, 64, 64, 4U, t17, 16, t14, 16, t11, 16, t6, 16);
    t18 = (t0 + 1668);
    xsi_vlogvar_assign_value(t18, t10, 0, 0, 64);
    goto LAB2;

LAB7:    xsi_set_current_line(43, ng0);

LAB18:    xsi_set_current_line(44, ng0);
    t6 = (t0 + 828U);
    t7 = *((char **)t6);
    t6 = (t0 + 1180U);
    t8 = *((char **)t6);
    memset(t9, 0, 8);
    xsi_vlog_unsigned_add(t9, 16, t7, 16, t8, 16);
    t6 = (t0 + 1760);
    xsi_vlogvar_assign_value(t6, t9, 0, 0, 16);
    xsi_set_current_line(45, ng0);
    t2 = (t0 + 916U);
    t3 = *((char **)t2);
    t2 = (t0 + 1268U);
    t6 = *((char **)t2);
    memset(t9, 0, 8);
    xsi_vlog_unsigned_add(t9, 16, t3, 16, t6, 16);
    t2 = (t0 + 1852);
    xsi_vlogvar_assign_value(t2, t9, 0, 0, 16);
    xsi_set_current_line(46, ng0);
    t2 = (t0 + 1004U);
    t3 = *((char **)t2);
    t2 = (t0 + 1356U);
    t6 = *((char **)t2);
    memset(t9, 0, 8);
    xsi_vlog_unsigned_add(t9, 16, t3, 16, t6, 16);
    t2 = (t0 + 1944);
    xsi_vlogvar_assign_value(t2, t9, 0, 0, 16);
    xsi_set_current_line(47, ng0);
    t2 = (t0 + 1092U);
    t3 = *((char **)t2);
    t2 = (t0 + 1444U);
    t6 = *((char **)t2);
    memset(t9, 0, 8);
    xsi_vlog_unsigned_add(t9, 16, t3, 16, t6, 16);
    t2 = (t0 + 2036);
    xsi_vlogvar_assign_value(t2, t9, 0, 0, 16);
    goto LAB17;

LAB9:    xsi_set_current_line(50, ng0);

LAB19:    xsi_set_current_line(51, ng0);
    t3 = (t0 + 828U);
    t6 = *((char **)t3);
    t3 = (t0 + 1180U);
    t7 = *((char **)t3);
    memset(t9, 0, 8);
    xsi_vlog_unsigned_minus(t9, 16, t6, 16, t7, 16);
    t3 = (t0 + 1760);
    xsi_vlogvar_assign_value(t3, t9, 0, 0, 16);
    xsi_set_current_line(52, ng0);
    t2 = (t0 + 916U);
    t3 = *((char **)t2);
    t2 = (t0 + 1268U);
    t6 = *((char **)t2);
    memset(t9, 0, 8);
    xsi_vlog_unsigned_minus(t9, 16, t3, 16, t6, 16);
    t2 = (t0 + 1852);
    xsi_vlogvar_assign_value(t2, t9, 0, 0, 16);
    xsi_set_current_line(53, ng0);
    t2 = (t0 + 1004U);
    t3 = *((char **)t2);
    t2 = (t0 + 1356U);
    t6 = *((char **)t2);
    memset(t9, 0, 8);
    xsi_vlog_unsigned_minus(t9, 16, t3, 16, t6, 16);
    t2 = (t0 + 1944);
    xsi_vlogvar_assign_value(t2, t9, 0, 0, 16);
    xsi_set_current_line(54, ng0);
    t2 = (t0 + 1092U);
    t3 = *((char **)t2);
    t2 = (t0 + 1444U);
    t6 = *((char **)t2);
    memset(t9, 0, 8);
    xsi_vlog_unsigned_minus(t9, 16, t3, 16, t6, 16);
    t2 = (t0 + 2036);
    xsi_vlogvar_assign_value(t2, t9, 0, 0, 16);
    goto LAB17;

LAB11:    xsi_set_current_line(57, ng0);

LAB20:    xsi_set_current_line(58, ng0);
    t3 = (t0 + 828U);
    t6 = *((char **)t3);
    t3 = (t0 + 1180U);
    t7 = *((char **)t3);
    memset(t9, 0, 8);
    xsi_vlog_unsigned_multiply(t9, 16, t6, 16, t7, 16);
    t3 = (t0 + 1760);
    xsi_vlogvar_assign_value(t3, t9, 0, 0, 16);
    xsi_set_current_line(59, ng0);
    t2 = (t0 + 916U);
    t3 = *((char **)t2);
    t2 = (t0 + 1268U);
    t6 = *((char **)t2);
    memset(t9, 0, 8);
    xsi_vlog_unsigned_multiply(t9, 16, t3, 16, t6, 16);
    t2 = (t0 + 1852);
    xsi_vlogvar_assign_value(t2, t9, 0, 0, 16);
    xsi_set_current_line(60, ng0);
    t2 = (t0 + 1004U);
    t3 = *((char **)t2);
    t2 = (t0 + 1356U);
    t6 = *((char **)t2);
    memset(t9, 0, 8);
    xsi_vlog_unsigned_multiply(t9, 16, t3, 16, t6, 16);
    t2 = (t0 + 1944);
    xsi_vlogvar_assign_value(t2, t9, 0, 0, 16);
    xsi_set_current_line(61, ng0);
    t2 = (t0 + 1092U);
    t3 = *((char **)t2);
    t2 = (t0 + 1444U);
    t6 = *((char **)t2);
    memset(t9, 0, 8);
    xsi_vlog_unsigned_multiply(t9, 16, t3, 16, t6, 16);
    t2 = (t0 + 2036);
    xsi_vlogvar_assign_value(t2, t9, 0, 0, 16);
    goto LAB17;

LAB13:    xsi_set_current_line(64, ng0);

LAB21:    xsi_set_current_line(65, ng0);
    t3 = (t0 + 1180U);
    t6 = *((char **)t3);
    t3 = (t0 + 1760);
    xsi_vlogvar_assign_value(t3, t6, 0, 0, 16);
    xsi_set_current_line(66, ng0);
    t2 = (t0 + 1268U);
    t3 = *((char **)t2);
    t2 = (t0 + 1852);
    xsi_vlogvar_assign_value(t2, t3, 0, 0, 16);
    xsi_set_current_line(67, ng0);
    t2 = (t0 + 1356U);
    t3 = *((char **)t2);
    t2 = (t0 + 1944);
    xsi_vlogvar_assign_value(t2, t3, 0, 0, 16);
    xsi_set_current_line(68, ng0);
    t2 = (t0 + 1444U);
    t3 = *((char **)t2);
    t2 = (t0 + 2036);
    xsi_vlogvar_assign_value(t2, t3, 0, 0, 16);
    goto LAB17;

}


extern void work_m_00000000002082985114_3663432627_init()
{
	static char *pe[] = {(void *)N28_0,(void *)N29_1,(void *)N30_2,(void *)N31_3,(void *)N33_4,(void *)N34_5,(void *)N35_6,(void *)N36_7,(void *)A41_8};
	xsi_register_didat("work_m_00000000002082985114_3663432627", "isim/_tmp/work/m_00000000002082985114_3663432627.didat");
	xsi_register_executes(pe);
}
