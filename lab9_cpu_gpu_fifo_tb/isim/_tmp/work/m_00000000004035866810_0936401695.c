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
static const char *ng0 = "C:/Xilinx/10.1/ISE/ISEexamples/ee533-lab9/alu_32bit.v";
static unsigned int ng1[] = {0U, 0U};
static unsigned int ng2[] = {1U, 0U};



static void C12_0(char *t0)
{
    char t4[8];
    char *t1;
    char *t2;
    char *t3;
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

LAB0:    t1 = (t0 + 1704U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    t2 = (t0 + 828U);
    t3 = *((char **)t2);
    memset(t4, 0, 8);
    t2 = (t4 + 4U);
    t5 = (t3 + 4U);
    t6 = *((unsigned int *)t3);
    t7 = (t6 >> 31);
    t8 = (t7 & 1);
    *((unsigned int *)t4) = t8;
    t9 = *((unsigned int *)t5);
    t10 = (t9 >> 31);
    t11 = (t10 & 1);
    *((unsigned int *)t2) = t11;
    t12 = (t0 + 2336);
    t13 = (t12 + 32U);
    t14 = *((char **)t13);
    t15 = (t14 + 40U);
    t16 = *((char **)t15);
    t17 = (t16 + 4U);
    t18 = 1U;
    t19 = t18;
    t20 = (t4 + 4U);
    t21 = *((unsigned int *)t4);
    t18 = (t18 & t21);
    t22 = *((unsigned int *)t20);
    t19 = (t19 & t22);
    t23 = *((unsigned int *)t16);
    *((unsigned int *)t16) = (t23 & 4294967294U);
    t24 = *((unsigned int *)t16);
    *((unsigned int *)t16) = (t24 | t18);
    t25 = *((unsigned int *)t17);
    *((unsigned int *)t17) = (t25 & 4294967294U);
    t26 = *((unsigned int *)t17);
    *((unsigned int *)t17) = (t26 | t19);
    xsi_driver_vfirst_trans(t12, 0, 0);
    t27 = (t0 + 2268);
    *((int *)t27) = 1;

LAB1:    return;
}

static void A18_1(char *t0)
{
    char t8[8];
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    int t5;
    char *t6;
    char *t7;

LAB0:    t1 = (t0 + 1832U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(18, ng0);
    t2 = (t0 + 2276);
    *((int *)t2) = 1;
    *((char **)t1) = &&LAB4;

LAB1:    return;
LAB4:    xsi_set_current_line(18, ng0);

LAB5:    xsi_set_current_line(20, ng0);
    t3 = ((char*)((ng1)));
    t4 = (t0 + 1228);
    xsi_vlogvar_assign_value(t4, t3, 0, 0, 32);
    xsi_set_current_line(24, ng0);
    t2 = (t0 + 740U);
    t3 = *((char **)t2);

LAB6:    t2 = ((char*)((ng1)));
    t5 = xsi_vlog_unsigned_case_compare(t3, 4, t2, 4);
    if (t5 == 1)
        goto LAB7;

LAB8:    t2 = ((char*)((ng2)));
    t5 = xsi_vlog_unsigned_case_compare(t3, 4, t2, 4);
    if (t5 == 1)
        goto LAB9;

LAB10:
LAB12:
LAB11:    xsi_set_current_line(55, ng0);
    t2 = ((char*)((ng1)));
    t4 = (t0 + 1228);
    xsi_vlogvar_assign_value(t4, t2, 0, 0, 32);

LAB13:    goto LAB2;

LAB7:    xsi_set_current_line(25, ng0);

LAB14:    xsi_set_current_line(26, ng0);
    t4 = (t0 + 564U);
    t6 = *((char **)t4);
    t4 = (t0 + 652U);
    t7 = *((char **)t4);
    memset(t8, 0, 8);
    xsi_vlog_unsigned_add(t8, 32, t6, 32, t7, 32);
    t4 = (t0 + 1228);
    xsi_vlogvar_assign_value(t4, t8, 0, 0, 32);
    goto LAB13;

LAB9:    xsi_set_current_line(32, ng0);

LAB15:    xsi_set_current_line(33, ng0);
    t4 = (t0 + 564U);
    t6 = *((char **)t4);
    t4 = (t0 + 652U);
    t7 = *((char **)t4);
    memset(t8, 0, 8);
    xsi_vlog_unsigned_minus(t8, 32, t6, 32, t7, 32);
    t4 = (t0 + 1228);
    xsi_vlogvar_assign_value(t4, t8, 0, 0, 32);
    goto LAB13;

}

static void C61_2(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;
    char *t8;
    char *t9;
    char *t10;

LAB0:    t1 = (t0 + 1960U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    t2 = (t0 + 1228);
    t3 = (t2 + 32U);
    t4 = *((char **)t3);
    t5 = (t0 + 2372);
    t6 = (t5 + 32U);
    t7 = *((char **)t6);
    t8 = (t7 + 40U);
    t9 = *((char **)t8);
    memcpy(t9, t4, 8);
    xsi_driver_vfirst_trans(t5, 0, 31);
    t10 = (t0 + 2284);
    *((int *)t10) = 1;

LAB1:    return;
}

static void C62_3(char *t0)
{
    char t6[8];
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    char *t7;
    char *t8;
    char *t9;
    unsigned int t10;
    unsigned int t11;
    unsigned int t12;
    unsigned int t13;
    unsigned int t14;
    unsigned int t15;
    unsigned int t16;
    unsigned int t17;
    unsigned int t18;
    unsigned int t19;
    unsigned int t20;
    unsigned int t21;
    char *t22;
    char *t23;
    char *t24;
    char *t25;
    char *t26;
    char *t27;
    unsigned int t28;
    unsigned int t29;
    char *t30;
    unsigned int t31;
    unsigned int t32;
    unsigned int t33;
    unsigned int t34;
    unsigned int t35;
    unsigned int t36;
    char *t37;

LAB0:    t1 = (t0 + 2088U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    t2 = (t0 + 1228);
    t3 = (t2 + 32U);
    t4 = *((char **)t3);
    t5 = ((char*)((ng1)));
    memset(t6, 0, 8);
    t7 = (t6 + 4U);
    t8 = (t4 + 4U);
    t9 = (t5 + 4U);
    t10 = *((unsigned int *)t4);
    t11 = *((unsigned int *)t5);
    t12 = (t10 ^ t11);
    t13 = *((unsigned int *)t8);
    t14 = *((unsigned int *)t9);
    t15 = (t13 ^ t14);
    t16 = (t12 | t15);
    t17 = *((unsigned int *)t8);
    t18 = *((unsigned int *)t9);
    t19 = (t17 | t18);
    t20 = (~(t19));
    t21 = (t16 & t20);
    if (t21 != 0)
        goto LAB7;

LAB4:    if (t19 != 0)
        goto LAB6;

LAB5:    *((unsigned int *)t6) = 1;

LAB7:    t22 = (t0 + 2408);
    t23 = (t22 + 32U);
    t24 = *((char **)t23);
    t25 = (t24 + 40U);
    t26 = *((char **)t25);
    t27 = (t26 + 4U);
    t28 = 1U;
    t29 = t28;
    t30 = (t6 + 4U);
    t31 = *((unsigned int *)t6);
    t28 = (t28 & t31);
    t32 = *((unsigned int *)t30);
    t29 = (t29 & t32);
    t33 = *((unsigned int *)t26);
    *((unsigned int *)t26) = (t33 & 4294967294U);
    t34 = *((unsigned int *)t26);
    *((unsigned int *)t26) = (t34 | t28);
    t35 = *((unsigned int *)t27);
    *((unsigned int *)t27) = (t35 & 4294967294U);
    t36 = *((unsigned int *)t27);
    *((unsigned int *)t27) = (t36 | t29);
    xsi_driver_vfirst_trans(t22, 0, 0);
    t37 = (t0 + 2292);
    *((int *)t37) = 1;

LAB1:    return;
LAB6:    *((unsigned int *)t6) = 1;
    *((unsigned int *)t7) = 1;
    goto LAB7;

}


extern void work_m_00000000004035866810_0936401695_init()
{
	static char *pe[] = {(void *)C12_0,(void *)A18_1,(void *)C61_2,(void *)C62_3};
	xsi_register_didat("work_m_00000000004035866810_0936401695", "isim/_tmp/work/m_00000000004035866810_0936401695.didat");
	xsi_register_executes(pe);
}
