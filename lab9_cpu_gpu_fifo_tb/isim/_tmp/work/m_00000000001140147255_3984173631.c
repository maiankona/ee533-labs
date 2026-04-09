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
static unsigned int ng0[] = {240U, 0U};
static unsigned int ng1[] = {241U, 0U};
static unsigned int ng2[] = {242U, 0U};
static unsigned int ng3[] = {243U, 0U};
static const char *ng4 = "C:/Xilinx/10.1/ISE/ISEexamples/ee533-lab9/gpu_control_interface_2.v";
static unsigned int ng5[] = {80U, 0U};
static unsigned int ng6[] = {0U, 0U};
static unsigned int ng7[] = {1U, 0U};
static unsigned int ng8[] = {2U, 0U};



static void N27_0(char *t0)
{
    char t4[8];
    char t17[8];
    char t33[8];
    char t41[8];
    char *t1;
    char *t2;
    char *t3;
    char *t5;
    unsigned int t6;
    unsigned int t7;
    unsigned int t8;
    unsigned int t9;
    unsigned int t10;
    char *t11;
    unsigned int t12;
    unsigned int t13;
    unsigned int t14;
    char *t15;
    char *t16;
    char *t18;
    char *t19;
    char *t20;
    unsigned int t21;
    unsigned int t22;
    unsigned int t23;
    unsigned int t24;
    unsigned int t25;
    unsigned int t26;
    unsigned int t27;
    unsigned int t28;
    unsigned int t29;
    unsigned int t30;
    unsigned int t31;
    unsigned int t32;
    char *t34;
    char *t35;
    unsigned int t36;
    unsigned int t37;
    unsigned int t38;
    unsigned int t39;
    unsigned int t40;
    unsigned int t42;
    unsigned int t43;
    unsigned int t44;
    char *t45;
    char *t46;
    char *t47;
    unsigned int t48;
    unsigned int t49;
    unsigned int t50;
    unsigned int t51;
    unsigned int t52;
    unsigned int t53;
    unsigned int t54;
    char *t55;
    char *t56;
    unsigned int t57;
    unsigned int t58;
    unsigned int t59;
    unsigned int t60;
    unsigned int t61;
    unsigned int t62;
    unsigned int t63;
    unsigned int t64;
    int t65;
    int t66;
    unsigned int t67;
    unsigned int t68;
    unsigned int t69;
    unsigned int t70;
    unsigned int t71;
    unsigned int t72;
    char *t73;
    char *t74;
    char *t75;
    char *t76;
    char *t77;
    char *t78;
    unsigned int t79;
    unsigned int t80;
    char *t81;
    unsigned int t82;
    unsigned int t83;
    unsigned int t84;
    unsigned int t85;
    unsigned int t86;
    unsigned int t87;
    char *t88;

LAB0:    t1 = (t0 + 3016U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    t2 = (t0 + 1144U);
    t3 = *((char **)t2);
    memset(t4, 0, 8);
    t2 = (t4 + 4U);
    t5 = (t3 + 4U);
    t6 = *((unsigned int *)t5);
    t7 = (~(t6));
    t8 = *((unsigned int *)t3);
    t9 = (t8 & t7);
    t10 = (t9 & 1U);
    if (t10 != 0)
        goto LAB4;

LAB5:    if (*((unsigned int *)t5) != 0)
        goto LAB6;

LAB7:    t11 = (t4 + 4U);
    t12 = *((unsigned int *)t4);
    t13 = *((unsigned int *)t11);
    t14 = (t12 || t13);
    if (t14 > 0)
        goto LAB8;

LAB9:    memcpy(t41, t4, 8);

LAB10:    t73 = (t0 + 4328);
    t74 = (t73 + 32U);
    t75 = *((char **)t74);
    t76 = (t75 + 40U);
    t77 = *((char **)t76);
    t78 = (t77 + 4U);
    t79 = 1U;
    t80 = t79;
    t81 = (t41 + 4U);
    t82 = *((unsigned int *)t41);
    t79 = (t79 & t82);
    t83 = *((unsigned int *)t81);
    t80 = (t80 & t83);
    t84 = *((unsigned int *)t77);
    *((unsigned int *)t77) = (t84 & 4294967294U);
    t85 = *((unsigned int *)t77);
    *((unsigned int *)t77) = (t85 | t79);
    t86 = *((unsigned int *)t78);
    *((unsigned int *)t78) = (t86 & 4294967294U);
    t87 = *((unsigned int *)t78);
    *((unsigned int *)t78) = (t87 | t80);
    xsi_driver_vfirst_trans(t73, 0, 0U);
    t88 = (t0 + 4220);
    *((int *)t88) = 1;

LAB1:    return;
LAB4:    *((unsigned int *)t4) = 1;
    goto LAB7;

LAB6:    *((unsigned int *)t4) = 1;
    *((unsigned int *)t2) = 1;
    goto LAB7;

LAB8:    t15 = (t0 + 968U);
    t16 = *((char **)t15);
    t15 = ((char*)((ng0)));
    memset(t17, 0, 8);
    t18 = (t17 + 4U);
    t19 = (t16 + 4U);
    t20 = (t15 + 4U);
    t21 = *((unsigned int *)t16);
    t22 = *((unsigned int *)t15);
    t23 = (t21 ^ t22);
    t24 = *((unsigned int *)t19);
    t25 = *((unsigned int *)t20);
    t26 = (t24 ^ t25);
    t27 = (t23 | t26);
    t28 = *((unsigned int *)t19);
    t29 = *((unsigned int *)t20);
    t30 = (t28 | t29);
    t31 = (~(t30));
    t32 = (t27 & t31);
    if (t32 != 0)
        goto LAB14;

LAB11:    if (t30 != 0)
        goto LAB13;

LAB12:    *((unsigned int *)t17) = 1;

LAB14:    memset(t33, 0, 8);
    t34 = (t33 + 4U);
    t35 = (t17 + 4U);
    t36 = *((unsigned int *)t35);
    t37 = (~(t36));
    t38 = *((unsigned int *)t17);
    t39 = (t38 & t37);
    t40 = (t39 & 1U);
    if (t40 != 0)
        goto LAB15;

LAB16:    if (*((unsigned int *)t35) != 0)
        goto LAB17;

LAB18:    t42 = *((unsigned int *)t4);
    t43 = *((unsigned int *)t33);
    t44 = (t42 & t43);
    *((unsigned int *)t41) = t44;
    t45 = (t4 + 4U);
    t46 = (t33 + 4U);
    t47 = (t41 + 4U);
    t48 = *((unsigned int *)t45);
    t49 = *((unsigned int *)t46);
    t50 = (t48 | t49);
    *((unsigned int *)t47) = t50;
    t51 = *((unsigned int *)t47);
    t52 = (t51 != 0);
    if (t52 == 1)
        goto LAB19;

LAB20:
LAB21:    goto LAB10;

LAB13:    *((unsigned int *)t17) = 1;
    *((unsigned int *)t18) = 1;
    goto LAB14;

LAB15:    *((unsigned int *)t33) = 1;
    goto LAB18;

LAB17:    *((unsigned int *)t33) = 1;
    *((unsigned int *)t34) = 1;
    goto LAB18;

LAB19:    t53 = *((unsigned int *)t41);
    t54 = *((unsigned int *)t47);
    *((unsigned int *)t41) = (t53 | t54);
    t55 = (t4 + 4U);
    t56 = (t33 + 4U);
    t57 = *((unsigned int *)t4);
    t58 = (~(t57));
    t59 = *((unsigned int *)t55);
    t60 = (~(t59));
    t61 = *((unsigned int *)t33);
    t62 = (~(t61));
    t63 = *((unsigned int *)t56);
    t64 = (~(t63));
    t65 = (t58 & t60);
    t66 = (t62 & t64);
    t67 = (~(t65));
    t68 = (~(t66));
    t69 = *((unsigned int *)t47);
    *((unsigned int *)t47) = (t69 & t67);
    t70 = *((unsigned int *)t47);
    *((unsigned int *)t47) = (t70 & t68);
    t71 = *((unsigned int *)t41);
    *((unsigned int *)t41) = (t71 & t67);
    t72 = *((unsigned int *)t41);
    *((unsigned int *)t41) = (t72 & t68);
    goto LAB21;

}

static void N28_1(char *t0)
{
    char t4[8];
    char t17[8];
    char t33[8];
    char t41[8];
    char *t1;
    char *t2;
    char *t3;
    char *t5;
    unsigned int t6;
    unsigned int t7;
    unsigned int t8;
    unsigned int t9;
    unsigned int t10;
    char *t11;
    unsigned int t12;
    unsigned int t13;
    unsigned int t14;
    char *t15;
    char *t16;
    char *t18;
    char *t19;
    char *t20;
    unsigned int t21;
    unsigned int t22;
    unsigned int t23;
    unsigned int t24;
    unsigned int t25;
    unsigned int t26;
    unsigned int t27;
    unsigned int t28;
    unsigned int t29;
    unsigned int t30;
    unsigned int t31;
    unsigned int t32;
    char *t34;
    char *t35;
    unsigned int t36;
    unsigned int t37;
    unsigned int t38;
    unsigned int t39;
    unsigned int t40;
    unsigned int t42;
    unsigned int t43;
    unsigned int t44;
    char *t45;
    char *t46;
    char *t47;
    unsigned int t48;
    unsigned int t49;
    unsigned int t50;
    unsigned int t51;
    unsigned int t52;
    unsigned int t53;
    unsigned int t54;
    char *t55;
    char *t56;
    unsigned int t57;
    unsigned int t58;
    unsigned int t59;
    unsigned int t60;
    unsigned int t61;
    unsigned int t62;
    unsigned int t63;
    unsigned int t64;
    int t65;
    int t66;
    unsigned int t67;
    unsigned int t68;
    unsigned int t69;
    unsigned int t70;
    unsigned int t71;
    unsigned int t72;
    char *t73;
    char *t74;
    char *t75;
    char *t76;
    char *t77;
    char *t78;
    unsigned int t79;
    unsigned int t80;
    char *t81;
    unsigned int t82;
    unsigned int t83;
    unsigned int t84;
    unsigned int t85;
    unsigned int t86;
    unsigned int t87;
    char *t88;

LAB0:    t1 = (t0 + 3144U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    t2 = (t0 + 1144U);
    t3 = *((char **)t2);
    memset(t4, 0, 8);
    t2 = (t4 + 4U);
    t5 = (t3 + 4U);
    t6 = *((unsigned int *)t5);
    t7 = (~(t6));
    t8 = *((unsigned int *)t3);
    t9 = (t8 & t7);
    t10 = (t9 & 1U);
    if (t10 != 0)
        goto LAB4;

LAB5:    if (*((unsigned int *)t5) != 0)
        goto LAB6;

LAB7:    t11 = (t4 + 4U);
    t12 = *((unsigned int *)t4);
    t13 = *((unsigned int *)t11);
    t14 = (t12 || t13);
    if (t14 > 0)
        goto LAB8;

LAB9:    memcpy(t41, t4, 8);

LAB10:    t73 = (t0 + 4364);
    t74 = (t73 + 32U);
    t75 = *((char **)t74);
    t76 = (t75 + 40U);
    t77 = *((char **)t76);
    t78 = (t77 + 4U);
    t79 = 1U;
    t80 = t79;
    t81 = (t41 + 4U);
    t82 = *((unsigned int *)t41);
    t79 = (t79 & t82);
    t83 = *((unsigned int *)t81);
    t80 = (t80 & t83);
    t84 = *((unsigned int *)t77);
    *((unsigned int *)t77) = (t84 & 4294967294U);
    t85 = *((unsigned int *)t77);
    *((unsigned int *)t77) = (t85 | t79);
    t86 = *((unsigned int *)t78);
    *((unsigned int *)t78) = (t86 & 4294967294U);
    t87 = *((unsigned int *)t78);
    *((unsigned int *)t78) = (t87 | t80);
    xsi_driver_vfirst_trans(t73, 0, 0U);
    t88 = (t0 + 4228);
    *((int *)t88) = 1;

LAB1:    return;
LAB4:    *((unsigned int *)t4) = 1;
    goto LAB7;

LAB6:    *((unsigned int *)t4) = 1;
    *((unsigned int *)t2) = 1;
    goto LAB7;

LAB8:    t15 = (t0 + 968U);
    t16 = *((char **)t15);
    t15 = ((char*)((ng1)));
    memset(t17, 0, 8);
    t18 = (t17 + 4U);
    t19 = (t16 + 4U);
    t20 = (t15 + 4U);
    t21 = *((unsigned int *)t16);
    t22 = *((unsigned int *)t15);
    t23 = (t21 ^ t22);
    t24 = *((unsigned int *)t19);
    t25 = *((unsigned int *)t20);
    t26 = (t24 ^ t25);
    t27 = (t23 | t26);
    t28 = *((unsigned int *)t19);
    t29 = *((unsigned int *)t20);
    t30 = (t28 | t29);
    t31 = (~(t30));
    t32 = (t27 & t31);
    if (t32 != 0)
        goto LAB14;

LAB11:    if (t30 != 0)
        goto LAB13;

LAB12:    *((unsigned int *)t17) = 1;

LAB14:    memset(t33, 0, 8);
    t34 = (t33 + 4U);
    t35 = (t17 + 4U);
    t36 = *((unsigned int *)t35);
    t37 = (~(t36));
    t38 = *((unsigned int *)t17);
    t39 = (t38 & t37);
    t40 = (t39 & 1U);
    if (t40 != 0)
        goto LAB15;

LAB16:    if (*((unsigned int *)t35) != 0)
        goto LAB17;

LAB18:    t42 = *((unsigned int *)t4);
    t43 = *((unsigned int *)t33);
    t44 = (t42 & t43);
    *((unsigned int *)t41) = t44;
    t45 = (t4 + 4U);
    t46 = (t33 + 4U);
    t47 = (t41 + 4U);
    t48 = *((unsigned int *)t45);
    t49 = *((unsigned int *)t46);
    t50 = (t48 | t49);
    *((unsigned int *)t47) = t50;
    t51 = *((unsigned int *)t47);
    t52 = (t51 != 0);
    if (t52 == 1)
        goto LAB19;

LAB20:
LAB21:    goto LAB10;

LAB13:    *((unsigned int *)t17) = 1;
    *((unsigned int *)t18) = 1;
    goto LAB14;

LAB15:    *((unsigned int *)t33) = 1;
    goto LAB18;

LAB17:    *((unsigned int *)t33) = 1;
    *((unsigned int *)t34) = 1;
    goto LAB18;

LAB19:    t53 = *((unsigned int *)t41);
    t54 = *((unsigned int *)t47);
    *((unsigned int *)t41) = (t53 | t54);
    t55 = (t4 + 4U);
    t56 = (t33 + 4U);
    t57 = *((unsigned int *)t4);
    t58 = (~(t57));
    t59 = *((unsigned int *)t55);
    t60 = (~(t59));
    t61 = *((unsigned int *)t33);
    t62 = (~(t61));
    t63 = *((unsigned int *)t56);
    t64 = (~(t63));
    t65 = (t58 & t60);
    t66 = (t62 & t64);
    t67 = (~(t65));
    t68 = (~(t66));
    t69 = *((unsigned int *)t47);
    *((unsigned int *)t47) = (t69 & t67);
    t70 = *((unsigned int *)t47);
    *((unsigned int *)t47) = (t70 & t68);
    t71 = *((unsigned int *)t41);
    *((unsigned int *)t41) = (t71 & t67);
    t72 = *((unsigned int *)t41);
    *((unsigned int *)t41) = (t72 & t68);
    goto LAB21;

}

static void N29_2(char *t0)
{
    char t4[8];
    char t17[8];
    char t33[8];
    char t41[8];
    char *t1;
    char *t2;
    char *t3;
    char *t5;
    unsigned int t6;
    unsigned int t7;
    unsigned int t8;
    unsigned int t9;
    unsigned int t10;
    char *t11;
    unsigned int t12;
    unsigned int t13;
    unsigned int t14;
    char *t15;
    char *t16;
    char *t18;
    char *t19;
    char *t20;
    unsigned int t21;
    unsigned int t22;
    unsigned int t23;
    unsigned int t24;
    unsigned int t25;
    unsigned int t26;
    unsigned int t27;
    unsigned int t28;
    unsigned int t29;
    unsigned int t30;
    unsigned int t31;
    unsigned int t32;
    char *t34;
    char *t35;
    unsigned int t36;
    unsigned int t37;
    unsigned int t38;
    unsigned int t39;
    unsigned int t40;
    unsigned int t42;
    unsigned int t43;
    unsigned int t44;
    char *t45;
    char *t46;
    char *t47;
    unsigned int t48;
    unsigned int t49;
    unsigned int t50;
    unsigned int t51;
    unsigned int t52;
    unsigned int t53;
    unsigned int t54;
    char *t55;
    char *t56;
    unsigned int t57;
    unsigned int t58;
    unsigned int t59;
    unsigned int t60;
    unsigned int t61;
    unsigned int t62;
    unsigned int t63;
    unsigned int t64;
    int t65;
    int t66;
    unsigned int t67;
    unsigned int t68;
    unsigned int t69;
    unsigned int t70;
    unsigned int t71;
    unsigned int t72;
    char *t73;
    char *t74;
    char *t75;
    char *t76;
    char *t77;
    char *t78;
    unsigned int t79;
    unsigned int t80;
    char *t81;
    unsigned int t82;
    unsigned int t83;
    unsigned int t84;
    unsigned int t85;
    unsigned int t86;
    unsigned int t87;
    char *t88;

LAB0:    t1 = (t0 + 3272U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    t2 = (t0 + 1144U);
    t3 = *((char **)t2);
    memset(t4, 0, 8);
    t2 = (t4 + 4U);
    t5 = (t3 + 4U);
    t6 = *((unsigned int *)t5);
    t7 = (~(t6));
    t8 = *((unsigned int *)t3);
    t9 = (t8 & t7);
    t10 = (t9 & 1U);
    if (t10 != 0)
        goto LAB4;

LAB5:    if (*((unsigned int *)t5) != 0)
        goto LAB6;

LAB7:    t11 = (t4 + 4U);
    t12 = *((unsigned int *)t4);
    t13 = *((unsigned int *)t11);
    t14 = (t12 || t13);
    if (t14 > 0)
        goto LAB8;

LAB9:    memcpy(t41, t4, 8);

LAB10:    t73 = (t0 + 4400);
    t74 = (t73 + 32U);
    t75 = *((char **)t74);
    t76 = (t75 + 40U);
    t77 = *((char **)t76);
    t78 = (t77 + 4U);
    t79 = 1U;
    t80 = t79;
    t81 = (t41 + 4U);
    t82 = *((unsigned int *)t41);
    t79 = (t79 & t82);
    t83 = *((unsigned int *)t81);
    t80 = (t80 & t83);
    t84 = *((unsigned int *)t77);
    *((unsigned int *)t77) = (t84 & 4294967294U);
    t85 = *((unsigned int *)t77);
    *((unsigned int *)t77) = (t85 | t79);
    t86 = *((unsigned int *)t78);
    *((unsigned int *)t78) = (t86 & 4294967294U);
    t87 = *((unsigned int *)t78);
    *((unsigned int *)t78) = (t87 | t80);
    xsi_driver_vfirst_trans(t73, 0, 0U);
    t88 = (t0 + 4236);
    *((int *)t88) = 1;

LAB1:    return;
LAB4:    *((unsigned int *)t4) = 1;
    goto LAB7;

LAB6:    *((unsigned int *)t4) = 1;
    *((unsigned int *)t2) = 1;
    goto LAB7;

LAB8:    t15 = (t0 + 968U);
    t16 = *((char **)t15);
    t15 = ((char*)((ng2)));
    memset(t17, 0, 8);
    t18 = (t17 + 4U);
    t19 = (t16 + 4U);
    t20 = (t15 + 4U);
    t21 = *((unsigned int *)t16);
    t22 = *((unsigned int *)t15);
    t23 = (t21 ^ t22);
    t24 = *((unsigned int *)t19);
    t25 = *((unsigned int *)t20);
    t26 = (t24 ^ t25);
    t27 = (t23 | t26);
    t28 = *((unsigned int *)t19);
    t29 = *((unsigned int *)t20);
    t30 = (t28 | t29);
    t31 = (~(t30));
    t32 = (t27 & t31);
    if (t32 != 0)
        goto LAB14;

LAB11:    if (t30 != 0)
        goto LAB13;

LAB12:    *((unsigned int *)t17) = 1;

LAB14:    memset(t33, 0, 8);
    t34 = (t33 + 4U);
    t35 = (t17 + 4U);
    t36 = *((unsigned int *)t35);
    t37 = (~(t36));
    t38 = *((unsigned int *)t17);
    t39 = (t38 & t37);
    t40 = (t39 & 1U);
    if (t40 != 0)
        goto LAB15;

LAB16:    if (*((unsigned int *)t35) != 0)
        goto LAB17;

LAB18:    t42 = *((unsigned int *)t4);
    t43 = *((unsigned int *)t33);
    t44 = (t42 & t43);
    *((unsigned int *)t41) = t44;
    t45 = (t4 + 4U);
    t46 = (t33 + 4U);
    t47 = (t41 + 4U);
    t48 = *((unsigned int *)t45);
    t49 = *((unsigned int *)t46);
    t50 = (t48 | t49);
    *((unsigned int *)t47) = t50;
    t51 = *((unsigned int *)t47);
    t52 = (t51 != 0);
    if (t52 == 1)
        goto LAB19;

LAB20:
LAB21:    goto LAB10;

LAB13:    *((unsigned int *)t17) = 1;
    *((unsigned int *)t18) = 1;
    goto LAB14;

LAB15:    *((unsigned int *)t33) = 1;
    goto LAB18;

LAB17:    *((unsigned int *)t33) = 1;
    *((unsigned int *)t34) = 1;
    goto LAB18;

LAB19:    t53 = *((unsigned int *)t41);
    t54 = *((unsigned int *)t47);
    *((unsigned int *)t41) = (t53 | t54);
    t55 = (t4 + 4U);
    t56 = (t33 + 4U);
    t57 = *((unsigned int *)t4);
    t58 = (~(t57));
    t59 = *((unsigned int *)t55);
    t60 = (~(t59));
    t61 = *((unsigned int *)t33);
    t62 = (~(t61));
    t63 = *((unsigned int *)t56);
    t64 = (~(t63));
    t65 = (t58 & t60);
    t66 = (t62 & t64);
    t67 = (~(t65));
    t68 = (~(t66));
    t69 = *((unsigned int *)t47);
    *((unsigned int *)t47) = (t69 & t67);
    t70 = *((unsigned int *)t47);
    *((unsigned int *)t47) = (t70 & t68);
    t71 = *((unsigned int *)t41);
    *((unsigned int *)t41) = (t71 & t67);
    t72 = *((unsigned int *)t41);
    *((unsigned int *)t41) = (t72 & t68);
    goto LAB21;

}

static void N30_3(char *t0)
{
    char t4[8];
    char t17[8];
    char t33[8];
    char t41[8];
    char *t1;
    char *t2;
    char *t3;
    char *t5;
    unsigned int t6;
    unsigned int t7;
    unsigned int t8;
    unsigned int t9;
    unsigned int t10;
    char *t11;
    unsigned int t12;
    unsigned int t13;
    unsigned int t14;
    char *t15;
    char *t16;
    char *t18;
    char *t19;
    char *t20;
    unsigned int t21;
    unsigned int t22;
    unsigned int t23;
    unsigned int t24;
    unsigned int t25;
    unsigned int t26;
    unsigned int t27;
    unsigned int t28;
    unsigned int t29;
    unsigned int t30;
    unsigned int t31;
    unsigned int t32;
    char *t34;
    char *t35;
    unsigned int t36;
    unsigned int t37;
    unsigned int t38;
    unsigned int t39;
    unsigned int t40;
    unsigned int t42;
    unsigned int t43;
    unsigned int t44;
    char *t45;
    char *t46;
    char *t47;
    unsigned int t48;
    unsigned int t49;
    unsigned int t50;
    unsigned int t51;
    unsigned int t52;
    unsigned int t53;
    unsigned int t54;
    char *t55;
    char *t56;
    unsigned int t57;
    unsigned int t58;
    unsigned int t59;
    unsigned int t60;
    unsigned int t61;
    unsigned int t62;
    unsigned int t63;
    unsigned int t64;
    int t65;
    int t66;
    unsigned int t67;
    unsigned int t68;
    unsigned int t69;
    unsigned int t70;
    unsigned int t71;
    unsigned int t72;
    char *t73;
    char *t74;
    char *t75;
    char *t76;
    char *t77;
    char *t78;
    unsigned int t79;
    unsigned int t80;
    char *t81;
    unsigned int t82;
    unsigned int t83;
    unsigned int t84;
    unsigned int t85;
    unsigned int t86;
    unsigned int t87;
    char *t88;

LAB0:    t1 = (t0 + 3400U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    t2 = (t0 + 1144U);
    t3 = *((char **)t2);
    memset(t4, 0, 8);
    t2 = (t4 + 4U);
    t5 = (t3 + 4U);
    t6 = *((unsigned int *)t5);
    t7 = (~(t6));
    t8 = *((unsigned int *)t3);
    t9 = (t8 & t7);
    t10 = (t9 & 1U);
    if (t10 != 0)
        goto LAB4;

LAB5:    if (*((unsigned int *)t5) != 0)
        goto LAB6;

LAB7:    t11 = (t4 + 4U);
    t12 = *((unsigned int *)t4);
    t13 = *((unsigned int *)t11);
    t14 = (t12 || t13);
    if (t14 > 0)
        goto LAB8;

LAB9:    memcpy(t41, t4, 8);

LAB10:    t73 = (t0 + 4436);
    t74 = (t73 + 32U);
    t75 = *((char **)t74);
    t76 = (t75 + 40U);
    t77 = *((char **)t76);
    t78 = (t77 + 4U);
    t79 = 1U;
    t80 = t79;
    t81 = (t41 + 4U);
    t82 = *((unsigned int *)t41);
    t79 = (t79 & t82);
    t83 = *((unsigned int *)t81);
    t80 = (t80 & t83);
    t84 = *((unsigned int *)t77);
    *((unsigned int *)t77) = (t84 & 4294967294U);
    t85 = *((unsigned int *)t77);
    *((unsigned int *)t77) = (t85 | t79);
    t86 = *((unsigned int *)t78);
    *((unsigned int *)t78) = (t86 & 4294967294U);
    t87 = *((unsigned int *)t78);
    *((unsigned int *)t78) = (t87 | t80);
    xsi_driver_vfirst_trans(t73, 0, 0U);
    t88 = (t0 + 4244);
    *((int *)t88) = 1;

LAB1:    return;
LAB4:    *((unsigned int *)t4) = 1;
    goto LAB7;

LAB6:    *((unsigned int *)t4) = 1;
    *((unsigned int *)t2) = 1;
    goto LAB7;

LAB8:    t15 = (t0 + 968U);
    t16 = *((char **)t15);
    t15 = ((char*)((ng3)));
    memset(t17, 0, 8);
    t18 = (t17 + 4U);
    t19 = (t16 + 4U);
    t20 = (t15 + 4U);
    t21 = *((unsigned int *)t16);
    t22 = *((unsigned int *)t15);
    t23 = (t21 ^ t22);
    t24 = *((unsigned int *)t19);
    t25 = *((unsigned int *)t20);
    t26 = (t24 ^ t25);
    t27 = (t23 | t26);
    t28 = *((unsigned int *)t19);
    t29 = *((unsigned int *)t20);
    t30 = (t28 | t29);
    t31 = (~(t30));
    t32 = (t27 & t31);
    if (t32 != 0)
        goto LAB14;

LAB11:    if (t30 != 0)
        goto LAB13;

LAB12:    *((unsigned int *)t17) = 1;

LAB14:    memset(t33, 0, 8);
    t34 = (t33 + 4U);
    t35 = (t17 + 4U);
    t36 = *((unsigned int *)t35);
    t37 = (~(t36));
    t38 = *((unsigned int *)t17);
    t39 = (t38 & t37);
    t40 = (t39 & 1U);
    if (t40 != 0)
        goto LAB15;

LAB16:    if (*((unsigned int *)t35) != 0)
        goto LAB17;

LAB18:    t42 = *((unsigned int *)t4);
    t43 = *((unsigned int *)t33);
    t44 = (t42 & t43);
    *((unsigned int *)t41) = t44;
    t45 = (t4 + 4U);
    t46 = (t33 + 4U);
    t47 = (t41 + 4U);
    t48 = *((unsigned int *)t45);
    t49 = *((unsigned int *)t46);
    t50 = (t48 | t49);
    *((unsigned int *)t47) = t50;
    t51 = *((unsigned int *)t47);
    t52 = (t51 != 0);
    if (t52 == 1)
        goto LAB19;

LAB20:
LAB21:    goto LAB10;

LAB13:    *((unsigned int *)t17) = 1;
    *((unsigned int *)t18) = 1;
    goto LAB14;

LAB15:    *((unsigned int *)t33) = 1;
    goto LAB18;

LAB17:    *((unsigned int *)t33) = 1;
    *((unsigned int *)t34) = 1;
    goto LAB18;

LAB19:    t53 = *((unsigned int *)t41);
    t54 = *((unsigned int *)t47);
    *((unsigned int *)t41) = (t53 | t54);
    t55 = (t4 + 4U);
    t56 = (t33 + 4U);
    t57 = *((unsigned int *)t4);
    t58 = (~(t57));
    t59 = *((unsigned int *)t55);
    t60 = (~(t59));
    t61 = *((unsigned int *)t33);
    t62 = (~(t61));
    t63 = *((unsigned int *)t56);
    t64 = (~(t63));
    t65 = (t58 & t60);
    t66 = (t62 & t64);
    t67 = (~(t65));
    t68 = (~(t66));
    t69 = *((unsigned int *)t47);
    *((unsigned int *)t47) = (t69 & t67);
    t70 = *((unsigned int *)t47);
    *((unsigned int *)t47) = (t70 & t68);
    t71 = *((unsigned int *)t41);
    *((unsigned int *)t41) = (t71 & t67);
    t72 = *((unsigned int *)t41);
    *((unsigned int *)t41) = (t72 & t68);
    goto LAB21;

}

static void A36_4(char *t0)
{
    char t12[8];
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    unsigned int t5;
    unsigned int t6;
    unsigned int t7;
    unsigned int t8;
    unsigned int t9;
    char *t10;
    char *t11;
    unsigned int t13;
    unsigned int t14;
    unsigned int t15;
    unsigned int t16;
    unsigned int t17;
    unsigned int t18;
    char *t19;

LAB0:    t1 = (t0 + 3528U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(36, ng4);
    t2 = (t0 + 4252);
    *((int *)t2) = 1;
    *((char **)t1) = &&LAB4;

LAB1:    return;
LAB4:    xsi_set_current_line(36, ng4);

LAB5:    xsi_set_current_line(37, ng4);
    t3 = (t0 + 880U);
    t4 = *((char **)t3);
    t3 = (t4 + 4U);
    t5 = *((unsigned int *)t3);
    t6 = (~(t5));
    t7 = *((unsigned int *)t4);
    t8 = (t7 & t6);
    t9 = (t8 != 0);
    if (t9 > 0)
        goto LAB6;

LAB7:    xsi_set_current_line(40, ng4);

LAB10:    xsi_set_current_line(41, ng4);
    t2 = (t0 + 1408U);
    t3 = *((char **)t2);
    t2 = (t3 + 4U);
    t5 = *((unsigned int *)t2);
    t6 = (~(t5));
    t7 = *((unsigned int *)t3);
    t8 = (t7 & t6);
    t9 = (t8 != 0);
    if (t9 > 0)
        goto LAB11;

LAB12:
LAB13:    xsi_set_current_line(42, ng4);
    t2 = (t0 + 1496U);
    t3 = *((char **)t2);
    t2 = (t3 + 4U);
    t5 = *((unsigned int *)t2);
    t6 = (~(t5));
    t7 = *((unsigned int *)t3);
    t8 = (t7 & t6);
    t9 = (t8 != 0);
    if (t9 > 0)
        goto LAB14;

LAB15:
LAB16:
LAB8:    goto LAB2;

LAB6:    xsi_set_current_line(37, ng4);

LAB9:    xsi_set_current_line(38, ng4);
    t10 = ((char*)((ng5)));
    t11 = (t0 + 2264);
    xsi_vlogvar_generic_wait_assign_value(t11, t10, 2, 0, 0, 8, 0LL);
    xsi_set_current_line(39, ng4);
    t2 = ((char*)((ng6)));
    t3 = (t0 + 2356);
    xsi_vlogvar_generic_wait_assign_value(t3, t2, 2, 0, 0, 8, 0LL);
    goto LAB8;

LAB11:    xsi_set_current_line(41, ng4);
    t4 = (t0 + 1056U);
    t10 = *((char **)t4);
    memset(t12, 0, 8);
    t4 = (t12 + 4U);
    t11 = (t10 + 4U);
    t13 = *((unsigned int *)t10);
    t14 = (t13 >> 0);
    *((unsigned int *)t12) = t14;
    t15 = *((unsigned int *)t11);
    t16 = (t15 >> 0);
    *((unsigned int *)t4) = t16;
    t17 = *((unsigned int *)t12);
    *((unsigned int *)t12) = (t17 & 255U);
    t18 = *((unsigned int *)t4);
    *((unsigned int *)t4) = (t18 & 255U);
    t19 = (t0 + 2264);
    xsi_vlogvar_generic_wait_assign_value(t19, t12, 2, 0, 0, 8, 0LL);
    goto LAB13;

LAB14:    xsi_set_current_line(42, ng4);
    t4 = (t0 + 1056U);
    t10 = *((char **)t4);
    memset(t12, 0, 8);
    t4 = (t12 + 4U);
    t11 = (t10 + 4U);
    t13 = *((unsigned int *)t10);
    t14 = (t13 >> 0);
    *((unsigned int *)t12) = t14;
    t15 = *((unsigned int *)t11);
    t16 = (t15 >> 0);
    *((unsigned int *)t4) = t16;
    t17 = *((unsigned int *)t12);
    *((unsigned int *)t12) = (t17 & 255U);
    t18 = *((unsigned int *)t4);
    *((unsigned int *)t4) = (t18 & 255U);
    t19 = (t0 + 2356);
    xsi_vlogvar_generic_wait_assign_value(t19, t12, 2, 0, 0, 8, 0LL);
    goto LAB16;

}

static void C49_5(char *t0)
{
    char t4[8];
    char t19[8];
    char t23[8];
    char t31[8];
    char t63[8];
    char t82[8];
    char t83[8];
    char t87[8];
    char t95[8];
    char *t1;
    char *t2;
    char *t3;
    char *t5;
    unsigned int t6;
    unsigned int t7;
    unsigned int t8;
    unsigned int t9;
    unsigned int t10;
    char *t11;
    unsigned int t12;
    unsigned int t13;
    unsigned int t14;
    char *t15;
    char *t16;
    char *t17;
    char *t18;
    char *t20;
    char *t21;
    char *t22;
    char *t24;
    char *t25;
    unsigned int t26;
    unsigned int t27;
    unsigned int t28;
    unsigned int t29;
    unsigned int t30;
    unsigned int t32;
    unsigned int t33;
    unsigned int t34;
    char *t35;
    char *t36;
    char *t37;
    unsigned int t38;
    unsigned int t39;
    unsigned int t40;
    unsigned int t41;
    unsigned int t42;
    unsigned int t43;
    unsigned int t44;
    char *t45;
    char *t46;
    unsigned int t47;
    unsigned int t48;
    unsigned int t49;
    unsigned int t50;
    unsigned int t51;
    unsigned int t52;
    unsigned int t53;
    unsigned int t54;
    int t55;
    int t56;
    unsigned int t57;
    unsigned int t58;
    unsigned int t59;
    unsigned int t60;
    unsigned int t61;
    unsigned int t62;
    char *t64;
    char *t65;
    unsigned int t66;
    unsigned int t67;
    unsigned int t68;
    unsigned int t69;
    unsigned int t70;
    char *t71;
    unsigned int t72;
    unsigned int t73;
    unsigned int t74;
    char *t75;
    char *t76;
    char *t77;
    char *t78;
    char *t79;
    char *t80;
    char *t81;
    char *t84;
    char *t85;
    char *t86;
    char *t88;
    char *t89;
    unsigned int t90;
    unsigned int t91;
    unsigned int t92;
    unsigned int t93;
    unsigned int t94;
    unsigned int t96;
    unsigned int t97;
    unsigned int t98;
    char *t99;
    char *t100;
    char *t101;
    unsigned int t102;
    unsigned int t103;
    unsigned int t104;
    unsigned int t105;
    unsigned int t106;
    unsigned int t107;
    unsigned int t108;
    char *t109;
    char *t110;
    unsigned int t111;
    unsigned int t112;
    unsigned int t113;
    unsigned int t114;
    unsigned int t115;
    unsigned int t116;
    unsigned int t117;
    unsigned int t118;
    int t119;
    int t120;
    unsigned int t121;
    unsigned int t122;
    unsigned int t123;
    unsigned int t124;
    unsigned int t125;
    unsigned int t126;
    char *t127;
    char *t128;
    char *t129;
    char *t130;
    char *t131;
    char *t132;
    unsigned int t133;
    unsigned int t134;
    char *t135;
    unsigned int t136;
    unsigned int t137;
    unsigned int t138;
    unsigned int t139;
    unsigned int t140;
    unsigned int t141;
    char *t142;

LAB0:    t1 = (t0 + 3656U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    t2 = (t0 + 1144U);
    t3 = *((char **)t2);
    memset(t4, 0, 8);
    t2 = (t4 + 4U);
    t5 = (t3 + 4U);
    t6 = *((unsigned int *)t5);
    t7 = (~(t6));
    t8 = *((unsigned int *)t3);
    t9 = (t8 & t7);
    t10 = (t9 & 1U);
    if (t10 != 0)
        goto LAB4;

LAB5:    if (*((unsigned int *)t5) != 0)
        goto LAB6;

LAB7:    t11 = (t4 + 4U);
    t12 = *((unsigned int *)t4);
    t13 = *((unsigned int *)t11);
    t14 = (t12 || t13);
    if (t14 > 0)
        goto LAB8;

LAB9:    memcpy(t31, t4, 8);

LAB10:    memset(t63, 0, 8);
    t64 = (t63 + 4U);
    t65 = (t31 + 4U);
    t66 = *((unsigned int *)t65);
    t67 = (~(t66));
    t68 = *((unsigned int *)t31);
    t69 = (t68 & t67);
    t70 = (t69 & 1U);
    if (t70 != 0)
        goto LAB23;

LAB24:    if (*((unsigned int *)t65) != 0)
        goto LAB25;

LAB26:    t71 = (t63 + 4U);
    t72 = *((unsigned int *)t63);
    t73 = *((unsigned int *)t71);
    t74 = (t72 || t73);
    if (t74 > 0)
        goto LAB27;

LAB28:    memcpy(t95, t63, 8);

LAB29:    t127 = (t0 + 4472);
    t128 = (t127 + 32U);
    t129 = *((char **)t128);
    t130 = (t129 + 40U);
    t131 = *((char **)t130);
    t132 = (t131 + 4U);
    t133 = 1U;
    t134 = t133;
    t135 = (t95 + 4U);
    t136 = *((unsigned int *)t95);
    t133 = (t133 & t136);
    t137 = *((unsigned int *)t135);
    t134 = (t134 & t137);
    t138 = *((unsigned int *)t131);
    *((unsigned int *)t131) = (t138 & 4294967294U);
    t139 = *((unsigned int *)t131);
    *((unsigned int *)t131) = (t139 | t133);
    t140 = *((unsigned int *)t132);
    *((unsigned int *)t132) = (t140 & 4294967294U);
    t141 = *((unsigned int *)t132);
    *((unsigned int *)t132) = (t141 | t134);
    xsi_driver_vfirst_trans(t127, 0, 0);
    t142 = (t0 + 4260);
    *((int *)t142) = 1;

LAB1:    return;
LAB4:    *((unsigned int *)t4) = 1;
    goto LAB7;

LAB6:    *((unsigned int *)t4) = 1;
    *((unsigned int *)t2) = 1;
    goto LAB7;

LAB8:    t15 = (t0 + 968U);
    t16 = *((char **)t15);
    t15 = (t0 + 2264);
    t17 = (t15 + 32U);
    t18 = *((char **)t17);
    memset(t19, 0, 8);
    t20 = (t19 + 4U);
    t21 = (t16 + 4U);
    t22 = (t18 + 4U);
    if (*((unsigned int *)t21) != 0)
        goto LAB12;

LAB11:    if (*((unsigned int *)t22) != 0)
        goto LAB12;

LAB15:    if (*((unsigned int *)t16) < *((unsigned int *)t18))
        goto LAB14;

LAB13:    *((unsigned int *)t19) = 1;

LAB14:    memset(t23, 0, 8);
    t24 = (t23 + 4U);
    t25 = (t19 + 4U);
    t26 = *((unsigned int *)t25);
    t27 = (~(t26));
    t28 = *((unsigned int *)t19);
    t29 = (t28 & t27);
    t30 = (t29 & 1U);
    if (t30 != 0)
        goto LAB16;

LAB17:    if (*((unsigned int *)t25) != 0)
        goto LAB18;

LAB19:    t32 = *((unsigned int *)t4);
    t33 = *((unsigned int *)t23);
    t34 = (t32 & t33);
    *((unsigned int *)t31) = t34;
    t35 = (t4 + 4U);
    t36 = (t23 + 4U);
    t37 = (t31 + 4U);
    t38 = *((unsigned int *)t35);
    t39 = *((unsigned int *)t36);
    t40 = (t38 | t39);
    *((unsigned int *)t37) = t40;
    t41 = *((unsigned int *)t37);
    t42 = (t41 != 0);
    if (t42 == 1)
        goto LAB20;

LAB21:
LAB22:    goto LAB10;

LAB12:    *((unsigned int *)t19) = 1;
    *((unsigned int *)t20) = 1;
    goto LAB14;

LAB16:    *((unsigned int *)t23) = 1;
    goto LAB19;

LAB18:    *((unsigned int *)t23) = 1;
    *((unsigned int *)t24) = 1;
    goto LAB19;

LAB20:    t43 = *((unsigned int *)t31);
    t44 = *((unsigned int *)t37);
    *((unsigned int *)t31) = (t43 | t44);
    t45 = (t4 + 4U);
    t46 = (t23 + 4U);
    t47 = *((unsigned int *)t4);
    t48 = (~(t47));
    t49 = *((unsigned int *)t45);
    t50 = (~(t49));
    t51 = *((unsigned int *)t23);
    t52 = (~(t51));
    t53 = *((unsigned int *)t46);
    t54 = (~(t53));
    t55 = (t48 & t50);
    t56 = (t52 & t54);
    t57 = (~(t55));
    t58 = (~(t56));
    t59 = *((unsigned int *)t37);
    *((unsigned int *)t37) = (t59 & t57);
    t60 = *((unsigned int *)t37);
    *((unsigned int *)t37) = (t60 & t58);
    t61 = *((unsigned int *)t31);
    *((unsigned int *)t31) = (t61 & t57);
    t62 = *((unsigned int *)t31);
    *((unsigned int *)t31) = (t62 & t58);
    goto LAB22;

LAB23:    *((unsigned int *)t63) = 1;
    goto LAB26;

LAB25:    *((unsigned int *)t63) = 1;
    *((unsigned int *)t64) = 1;
    goto LAB26;

LAB27:    t75 = (t0 + 968U);
    t76 = *((char **)t75);
    t75 = (t0 + 2264);
    t77 = (t75 + 32U);
    t78 = *((char **)t77);
    t79 = (t0 + 2356);
    t80 = (t79 + 32U);
    t81 = *((char **)t80);
    memset(t82, 0, 8);
    xsi_vlog_unsigned_add(t82, 8, t78, 8, t81, 8);
    memset(t83, 0, 8);
    t84 = (t83 + 4U);
    t85 = (t76 + 4U);
    t86 = (t82 + 4U);
    if (*((unsigned int *)t85) != 0)
        goto LAB31;

LAB30:    if (*((unsigned int *)t86) != 0)
        goto LAB31;

LAB34:    if (*((unsigned int *)t76) < *((unsigned int *)t82))
        goto LAB32;

LAB33:    memset(t87, 0, 8);
    t88 = (t87 + 4U);
    t89 = (t83 + 4U);
    t90 = *((unsigned int *)t89);
    t91 = (~(t90));
    t92 = *((unsigned int *)t83);
    t93 = (t92 & t91);
    t94 = (t93 & 1U);
    if (t94 != 0)
        goto LAB35;

LAB36:    if (*((unsigned int *)t89) != 0)
        goto LAB37;

LAB38:    t96 = *((unsigned int *)t63);
    t97 = *((unsigned int *)t87);
    t98 = (t96 & t97);
    *((unsigned int *)t95) = t98;
    t99 = (t63 + 4U);
    t100 = (t87 + 4U);
    t101 = (t95 + 4U);
    t102 = *((unsigned int *)t99);
    t103 = *((unsigned int *)t100);
    t104 = (t102 | t103);
    *((unsigned int *)t101) = t104;
    t105 = *((unsigned int *)t101);
    t106 = (t105 != 0);
    if (t106 == 1)
        goto LAB39;

LAB40:
LAB41:    goto LAB29;

LAB31:    *((unsigned int *)t83) = 1;
    *((unsigned int *)t84) = 1;
    goto LAB33;

LAB32:    *((unsigned int *)t83) = 1;
    goto LAB33;

LAB35:    *((unsigned int *)t87) = 1;
    goto LAB38;

LAB37:    *((unsigned int *)t87) = 1;
    *((unsigned int *)t88) = 1;
    goto LAB38;

LAB39:    t107 = *((unsigned int *)t95);
    t108 = *((unsigned int *)t101);
    *((unsigned int *)t95) = (t107 | t108);
    t109 = (t63 + 4U);
    t110 = (t87 + 4U);
    t111 = *((unsigned int *)t63);
    t112 = (~(t111));
    t113 = *((unsigned int *)t109);
    t114 = (~(t113));
    t115 = *((unsigned int *)t87);
    t116 = (~(t115));
    t117 = *((unsigned int *)t110);
    t118 = (~(t117));
    t119 = (t112 & t114);
    t120 = (t116 & t118);
    t121 = (~(t119));
    t122 = (~(t120));
    t123 = *((unsigned int *)t101);
    *((unsigned int *)t101) = (t123 & t121);
    t124 = *((unsigned int *)t101);
    *((unsigned int *)t101) = (t124 & t122);
    t125 = *((unsigned int *)t95);
    *((unsigned int *)t95) = (t125 & t121);
    t126 = *((unsigned int *)t95);
    *((unsigned int *)t95) = (t126 & t122);
    goto LAB41;

}

static void A60_6(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    unsigned int t5;
    unsigned int t6;
    unsigned int t7;
    unsigned int t8;
    unsigned int t9;
    char *t10;
    char *t11;

LAB0:    t1 = (t0 + 3784U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(60, ng4);
    t2 = (t0 + 4268);
    *((int *)t2) = 1;
    *((char **)t1) = &&LAB4;

LAB1:    return;
LAB4:    xsi_set_current_line(60, ng4);

LAB5:    xsi_set_current_line(61, ng4);
    t3 = (t0 + 880U);
    t4 = *((char **)t3);
    t3 = (t4 + 4U);
    t5 = *((unsigned int *)t3);
    t6 = (~(t5));
    t7 = *((unsigned int *)t4);
    t8 = (t7 & t6);
    t9 = (t8 != 0);
    if (t9 > 0)
        goto LAB6;

LAB7:    xsi_set_current_line(62, ng4);
    t2 = (t0 + 2540);
    t3 = (t2 + 32U);
    t4 = *((char **)t3);
    t10 = (t0 + 2448);
    xsi_vlogvar_generic_wait_assign_value(t10, t4, 2, 0, 0, 2, 0LL);

LAB8:    goto LAB2;

LAB6:    xsi_set_current_line(61, ng4);
    t10 = ((char*)((ng6)));
    t11 = (t0 + 2448);
    xsi_vlogvar_generic_wait_assign_value(t11, t10, 2, 0, 0, 2, 0LL);
    goto LAB8;

}

static void A66_7(char *t0)
{
    char t8[8];
    char t9[8];
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    int t7;
    char *t10;
    char *t11;
    unsigned int t12;
    unsigned int t13;
    unsigned int t14;
    unsigned int t15;
    unsigned int t16;
    char *t17;
    unsigned int t18;
    unsigned int t19;
    unsigned int t20;
    char *t21;
    unsigned int t22;
    unsigned int t23;
    unsigned int t24;
    unsigned int t25;
    char *t26;
    char *t27;

LAB0:    t1 = (t0 + 3912U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(66, ng4);
    t2 = (t0 + 4276);
    *((int *)t2) = 1;
    *((char **)t1) = &&LAB4;

LAB1:    return;
LAB4:    xsi_set_current_line(66, ng4);

LAB5:    xsi_set_current_line(67, ng4);
    t3 = (t0 + 2448);
    t4 = (t3 + 32U);
    t5 = *((char **)t4);
    t6 = (t0 + 2540);
    xsi_vlogvar_assign_value(t6, t5, 0, 0, 2);
    xsi_set_current_line(68, ng4);
    t2 = (t0 + 2448);
    t3 = (t2 + 32U);
    t4 = *((char **)t3);

LAB6:    t5 = ((char*)((ng6)));
    t7 = xsi_vlog_unsigned_case_compare(t4, 2, t5, 2);
    if (t7 == 1)
        goto LAB7;

LAB8:    t2 = ((char*)((ng7)));
    t7 = xsi_vlog_unsigned_case_compare(t4, 2, t2, 2);
    if (t7 == 1)
        goto LAB9;

LAB10:    t2 = ((char*)((ng8)));
    t7 = xsi_vlog_unsigned_case_compare(t4, 2, t2, 2);
    if (t7 == 1)
        goto LAB11;

LAB12:
LAB14:
LAB13:    xsi_set_current_line(72, ng4);
    t2 = ((char*)((ng6)));
    t3 = (t0 + 2540);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 2);

LAB15:    goto LAB2;

LAB7:    xsi_set_current_line(69, ng4);
    t6 = (t0 + 1584U);
    t10 = *((char **)t6);
    memset(t9, 0, 8);
    t6 = (t9 + 4U);
    t11 = (t10 + 4U);
    t12 = *((unsigned int *)t11);
    t13 = (~(t12));
    t14 = *((unsigned int *)t10);
    t15 = (t14 & t13);
    t16 = (t15 & 1U);
    if (t16 != 0)
        goto LAB16;

LAB17:    if (*((unsigned int *)t11) != 0)
        goto LAB18;

LAB19:    t17 = (t9 + 4U);
    t18 = *((unsigned int *)t9);
    t19 = *((unsigned int *)t17);
    t20 = (t18 || t19);
    if (t20 > 0)
        goto LAB20;

LAB21:    t22 = *((unsigned int *)t9);
    t23 = (~(t22));
    t24 = *((unsigned int *)t17);
    t25 = (t23 || t24);
    if (t25 > 0)
        goto LAB22;

LAB23:    if (*((unsigned int *)t17) > 0)
        goto LAB24;

LAB25:    if (*((unsigned int *)t9) > 0)
        goto LAB26;

LAB27:    memcpy(t8, t26, 8);

LAB28:    t27 = (t0 + 2540);
    xsi_vlogvar_assign_value(t27, t8, 0, 0, 2);
    goto LAB15;

LAB9:    xsi_set_current_line(70, ng4);
    t3 = (t0 + 1232U);
    t5 = *((char **)t3);
    memset(t9, 0, 8);
    t3 = (t9 + 4U);
    t6 = (t5 + 4U);
    t12 = *((unsigned int *)t6);
    t13 = (~(t12));
    t14 = *((unsigned int *)t5);
    t15 = (t14 & t13);
    t16 = (t15 & 1U);
    if (t16 != 0)
        goto LAB29;

LAB30:    if (*((unsigned int *)t6) != 0)
        goto LAB31;

LAB32:    t10 = (t9 + 4U);
    t18 = *((unsigned int *)t9);
    t19 = *((unsigned int *)t10);
    t20 = (t18 || t19);
    if (t20 > 0)
        goto LAB33;

LAB34:    t22 = *((unsigned int *)t9);
    t23 = (~(t22));
    t24 = *((unsigned int *)t10);
    t25 = (t23 || t24);
    if (t25 > 0)
        goto LAB35;

LAB36:    if (*((unsigned int *)t10) > 0)
        goto LAB37;

LAB38:    if (*((unsigned int *)t9) > 0)
        goto LAB39;

LAB40:    memcpy(t8, t17, 8);

LAB41:    t21 = (t0 + 2540);
    xsi_vlogvar_assign_value(t21, t8, 0, 0, 2);
    goto LAB15;

LAB11:    xsi_set_current_line(71, ng4);
    t3 = (t0 + 1672U);
    t5 = *((char **)t3);
    memset(t9, 0, 8);
    t3 = (t9 + 4U);
    t6 = (t5 + 4U);
    t12 = *((unsigned int *)t6);
    t13 = (~(t12));
    t14 = *((unsigned int *)t5);
    t15 = (t14 & t13);
    t16 = (t15 & 1U);
    if (t16 != 0)
        goto LAB42;

LAB43:    if (*((unsigned int *)t6) != 0)
        goto LAB44;

LAB45:    t10 = (t9 + 4U);
    t18 = *((unsigned int *)t9);
    t19 = *((unsigned int *)t10);
    t20 = (t18 || t19);
    if (t20 > 0)
        goto LAB46;

LAB47:    t22 = *((unsigned int *)t9);
    t23 = (~(t22));
    t24 = *((unsigned int *)t10);
    t25 = (t23 || t24);
    if (t25 > 0)
        goto LAB48;

LAB49:    if (*((unsigned int *)t10) > 0)
        goto LAB50;

LAB51:    if (*((unsigned int *)t9) > 0)
        goto LAB52;

LAB53:    memcpy(t8, t17, 8);

LAB54:    t21 = (t0 + 2540);
    xsi_vlogvar_assign_value(t21, t8, 0, 0, 2);
    goto LAB15;

LAB16:    *((unsigned int *)t9) = 1;
    goto LAB19;

LAB18:    *((unsigned int *)t9) = 1;
    *((unsigned int *)t6) = 1;
    goto LAB19;

LAB20:    t21 = ((char*)((ng7)));
    goto LAB21;

LAB22:    t26 = ((char*)((ng6)));
    goto LAB23;

LAB24:    xsi_vlog_unsigned_bit_combine(t8, 2, t21, 2, t26, 2);
    goto LAB28;

LAB26:    memcpy(t8, t21, 8);
    goto LAB28;

LAB29:    *((unsigned int *)t9) = 1;
    goto LAB32;

LAB31:    *((unsigned int *)t9) = 1;
    *((unsigned int *)t3) = 1;
    goto LAB32;

LAB33:    t11 = ((char*)((ng8)));
    goto LAB34;

LAB35:    t17 = ((char*)((ng7)));
    goto LAB36;

LAB37:    xsi_vlog_unsigned_bit_combine(t8, 2, t11, 2, t17, 2);
    goto LAB41;

LAB39:    memcpy(t8, t11, 8);
    goto LAB41;

LAB42:    *((unsigned int *)t9) = 1;
    goto LAB45;

LAB44:    *((unsigned int *)t9) = 1;
    *((unsigned int *)t3) = 1;
    goto LAB45;

LAB46:    t11 = ((char*)((ng6)));
    goto LAB47;

LAB48:    t17 = ((char*)((ng8)));
    goto LAB49;

LAB50:    xsi_vlog_unsigned_bit_combine(t8, 2, t11, 2, t17, 2);
    goto LAB54;

LAB52:    memcpy(t8, t11, 8);
    goto LAB54;

}

static void A77_8(char *t0)
{
    char t15[8];
    char t16[8];
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    unsigned int t5;
    unsigned int t6;
    unsigned int t7;
    unsigned int t8;
    unsigned int t9;
    char *t10;
    char *t11;
    int t12;
    char *t13;
    char *t14;
    unsigned int t17;
    unsigned int t18;
    unsigned int t19;
    unsigned int t20;
    unsigned int t21;
    unsigned int t22;
    unsigned int t23;
    char *t24;
    char *t25;

LAB0:    t1 = (t0 + 4040U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(77, ng4);
    t2 = (t0 + 4284);
    *((int *)t2) = 1;
    *((char **)t1) = &&LAB4;

LAB1:    return;
LAB4:    xsi_set_current_line(77, ng4);

LAB5:    xsi_set_current_line(78, ng4);
    t3 = (t0 + 880U);
    t4 = *((char **)t3);
    t3 = (t4 + 4U);
    t5 = *((unsigned int *)t3);
    t6 = (~(t5));
    t7 = *((unsigned int *)t4);
    t8 = (t7 & t6);
    t9 = (t8 != 0);
    if (t9 > 0)
        goto LAB6;

LAB7:    xsi_set_current_line(83, ng4);

LAB10:    xsi_set_current_line(84, ng4);
    t2 = (t0 + 2448);
    t3 = (t2 + 32U);
    t4 = *((char **)t3);

LAB11:    t10 = ((char*)((ng6)));
    t12 = xsi_vlog_unsigned_case_compare(t4, 2, t10, 2);
    if (t12 == 1)
        goto LAB12;

LAB13:    t2 = ((char*)((ng7)));
    t12 = xsi_vlog_unsigned_case_compare(t4, 2, t2, 2);
    if (t12 == 1)
        goto LAB14;

LAB15:    t2 = ((char*)((ng8)));
    t12 = xsi_vlog_unsigned_case_compare(t4, 2, t2, 2);
    if (t12 == 1)
        goto LAB16;

LAB17:
LAB19:
LAB18:    xsi_set_current_line(100, ng4);

LAB41:    xsi_set_current_line(101, ng4);
    t2 = ((char*)((ng6)));
    t3 = (t0 + 1896);
    xsi_vlogvar_generic_wait_assign_value(t3, t2, 2, 0, 0, 1, 0LL);
    xsi_set_current_line(102, ng4);
    t2 = ((char*)((ng6)));
    t3 = (t0 + 1988);
    xsi_vlogvar_generic_wait_assign_value(t3, t2, 2, 0, 0, 1, 0LL);

LAB20:
LAB8:    goto LAB2;

LAB6:    xsi_set_current_line(78, ng4);

LAB9:    xsi_set_current_line(79, ng4);
    t10 = ((char*)((ng6)));
    t11 = (t0 + 1896);
    xsi_vlogvar_generic_wait_assign_value(t11, t10, 2, 0, 0, 1, 0LL);
    xsi_set_current_line(80, ng4);
    t2 = ((char*)((ng6)));
    t3 = (t0 + 1988);
    xsi_vlogvar_generic_wait_assign_value(t3, t2, 2, 0, 0, 1, 0LL);
    xsi_set_current_line(81, ng4);
    t2 = ((char*)((ng5)));
    t3 = (t0 + 2080);
    xsi_vlogvar_generic_wait_assign_value(t3, t2, 2, 0, 0, 8, 0LL);
    xsi_set_current_line(82, ng4);
    t2 = ((char*)((ng6)));
    t3 = (t0 + 2172);
    xsi_vlogvar_generic_wait_assign_value(t3, t2, 2, 0, 0, 8, 0LL);
    goto LAB8;

LAB12:    xsi_set_current_line(85, ng4);

LAB21:    xsi_set_current_line(86, ng4);
    t11 = ((char*)((ng6)));
    t13 = (t0 + 1896);
    xsi_vlogvar_generic_wait_assign_value(t13, t11, 2, 0, 0, 1, 0LL);
    xsi_set_current_line(87, ng4);
    t2 = ((char*)((ng6)));
    t3 = (t0 + 1988);
    xsi_vlogvar_generic_wait_assign_value(t3, t2, 2, 0, 0, 1, 0LL);
    xsi_set_current_line(88, ng4);
    t2 = (t0 + 1584U);
    t3 = *((char **)t2);
    t2 = (t3 + 4U);
    t5 = *((unsigned int *)t2);
    t6 = (~(t5));
    t7 = *((unsigned int *)t3);
    t8 = (t7 & t6);
    t9 = (t8 != 0);
    if (t9 > 0)
        goto LAB22;

LAB23:
LAB24:    goto LAB20;

LAB14:    xsi_set_current_line(94, ng4);

LAB26:    xsi_set_current_line(95, ng4);
    t3 = ((char*)((ng6)));
    t10 = (t0 + 1988);
    xsi_vlogvar_generic_wait_assign_value(t10, t3, 2, 0, 0, 1, 0LL);
    goto LAB20;

LAB16:    xsi_set_current_line(97, ng4);

LAB27:    xsi_set_current_line(98, ng4);
    t3 = (t0 + 1672U);
    t10 = *((char **)t3);
    memset(t16, 0, 8);
    t3 = (t16 + 4U);
    t11 = (t10 + 4U);
    t5 = *((unsigned int *)t11);
    t6 = (~(t5));
    t7 = *((unsigned int *)t10);
    t8 = (t7 & t6);
    t9 = (t8 & 1U);
    if (t9 != 0)
        goto LAB28;

LAB29:    if (*((unsigned int *)t11) != 0)
        goto LAB30;

LAB31:    t13 = (t16 + 4U);
    t17 = *((unsigned int *)t16);
    t18 = *((unsigned int *)t13);
    t19 = (t17 || t18);
    if (t19 > 0)
        goto LAB32;

LAB33:    t20 = *((unsigned int *)t16);
    t21 = (~(t20));
    t22 = *((unsigned int *)t13);
    t23 = (t21 || t22);
    if (t23 > 0)
        goto LAB34;

LAB35:    if (*((unsigned int *)t13) > 0)
        goto LAB36;

LAB37:    if (*((unsigned int *)t16) > 0)
        goto LAB38;

LAB39:    memcpy(t15, t24, 8);

LAB40:    t25 = (t0 + 1896);
    xsi_vlogvar_generic_wait_assign_value(t25, t15, 2, 0, 0, 1, 0LL);
    goto LAB20;

LAB22:    xsi_set_current_line(88, ng4);

LAB25:    xsi_set_current_line(89, ng4);
    t10 = (t0 + 2264);
    t11 = (t10 + 32U);
    t13 = *((char **)t11);
    t14 = (t0 + 2080);
    xsi_vlogvar_generic_wait_assign_value(t14, t13, 2, 0, 0, 8, 0LL);
    xsi_set_current_line(90, ng4);
    t2 = (t0 + 2356);
    t3 = (t2 + 32U);
    t10 = *((char **)t3);
    t11 = (t0 + 2172);
    xsi_vlogvar_generic_wait_assign_value(t11, t10, 2, 0, 0, 8, 0LL);
    xsi_set_current_line(91, ng4);
    t2 = ((char*)((ng7)));
    t3 = (t0 + 1988);
    xsi_vlogvar_generic_wait_assign_value(t3, t2, 2, 0, 0, 1, 0LL);
    goto LAB24;

LAB28:    *((unsigned int *)t16) = 1;
    goto LAB31;

LAB30:    *((unsigned int *)t16) = 1;
    *((unsigned int *)t3) = 1;
    goto LAB31;

LAB32:    t14 = ((char*)((ng6)));
    goto LAB33;

LAB34:    t24 = ((char*)((ng7)));
    goto LAB35;

LAB36:    xsi_vlog_unsigned_bit_combine(t15, 1, t14, 1, t24, 1);
    goto LAB40;

LAB38:    memcpy(t15, t14, 8);
    goto LAB40;

}


extern void work_m_00000000001140147255_3984173631_init()
{
	static char *pe[] = {(void *)N27_0,(void *)N28_1,(void *)N29_2,(void *)N30_3,(void *)A36_4,(void *)C49_5,(void *)A60_6,(void *)A66_7,(void *)A77_8};
	xsi_register_didat("work_m_00000000001140147255_3984173631", "isim/_tmp/work/m_00000000001140147255_3984173631.didat");
	xsi_register_executes(pe);
}
