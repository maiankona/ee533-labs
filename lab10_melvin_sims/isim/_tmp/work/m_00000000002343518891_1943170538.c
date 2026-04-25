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
static unsigned int ng0[] = {0U, 0U};
static const char *ng1 = "C:/Xilinx/10.1/ISE/ISEexamples/lab9_net/bf16_tensor_2.v";
static unsigned int ng2[] = {0U, 0U, 0U, 0U};
static unsigned int ng3[] = {6U, 0U};
static unsigned int ng4[] = {1065369472U, 0U, 1065369472U, 0U};
static unsigned int ng5[] = {7U, 0U};
static unsigned int ng6[] = {8U, 0U};
static unsigned int ng7[] = {9U, 0U};
static unsigned int ng8[] = {1U, 0U};
static unsigned int ng9[] = {10U, 0U};



static void C50_0(char *t0)
{
    char t3[8];
    char t16[8];
    char t28[8];
    char t42[8];
    char t50[8];
    char *t1;
    char *t2;
    char *t4;
    char *t5;
    char *t6;
    char *t7;
    unsigned int t8;
    unsigned int t9;
    unsigned int t10;
    unsigned int t11;
    unsigned int t12;
    unsigned int t13;
    unsigned int t14;
    unsigned int t15;
    char *t17;
    char *t18;
    unsigned int t19;
    unsigned int t20;
    unsigned int t21;
    unsigned int t22;
    unsigned int t23;
    char *t24;
    unsigned int t25;
    unsigned int t26;
    unsigned int t27;
    char *t29;
    char *t30;
    char *t31;
    char *t32;
    char *t33;
    unsigned int t34;
    unsigned int t35;
    unsigned int t36;
    unsigned int t37;
    unsigned int t38;
    unsigned int t39;
    unsigned int t40;
    unsigned int t41;
    char *t43;
    char *t44;
    unsigned int t45;
    unsigned int t46;
    unsigned int t47;
    unsigned int t48;
    unsigned int t49;
    unsigned int t51;
    unsigned int t52;
    unsigned int t53;
    char *t54;
    char *t55;
    char *t56;
    unsigned int t57;
    unsigned int t58;
    unsigned int t59;
    unsigned int t60;
    unsigned int t61;
    unsigned int t62;
    unsigned int t63;
    char *t64;
    char *t65;
    unsigned int t66;
    unsigned int t67;
    unsigned int t68;
    unsigned int t69;
    unsigned int t70;
    unsigned int t71;
    unsigned int t72;
    unsigned int t73;
    int t74;
    int t75;
    unsigned int t76;
    unsigned int t77;
    unsigned int t78;
    unsigned int t79;
    unsigned int t80;
    unsigned int t81;
    char *t82;
    char *t83;
    char *t84;
    char *t85;
    char *t86;
    char *t87;
    unsigned int t88;
    unsigned int t89;
    char *t90;
    unsigned int t91;
    unsigned int t92;
    unsigned int t93;
    unsigned int t94;
    unsigned int t95;
    unsigned int t96;
    char *t97;

LAB0:    t1 = (t0 + 3512U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    t2 = (t0 + 1932);
    t4 = (t2 + 32U);
    t5 = *((char **)t4);
    memset(t3, 0, 8);
    t6 = (t3 + 4U);
    t7 = (t5 + 4U);
    t8 = *((unsigned int *)t5);
    t9 = (~(t8));
    *((unsigned int *)t3) = t9;
    *((unsigned int *)t6) = 0;
    if (*((unsigned int *)t7) != 0)
        goto LAB5;

LAB4:    t14 = *((unsigned int *)t3);
    *((unsigned int *)t3) = (t14 & 1U);
    t15 = *((unsigned int *)t6);
    *((unsigned int *)t6) = (t15 & 1U);
    memset(t16, 0, 8);
    t17 = (t16 + 4U);
    t18 = (t3 + 4U);
    t19 = *((unsigned int *)t18);
    t20 = (~(t19));
    t21 = *((unsigned int *)t3);
    t22 = (t21 & t20);
    t23 = (t22 & 1U);
    if (t23 != 0)
        goto LAB6;

LAB7:    if (*((unsigned int *)t18) != 0)
        goto LAB8;

LAB9:    t24 = (t16 + 4U);
    t25 = *((unsigned int *)t16);
    t26 = *((unsigned int *)t24);
    t27 = (t25 || t26);
    if (t27 > 0)
        goto LAB10;

LAB11:    memcpy(t50, t16, 8);

LAB12:    t82 = (t0 + 4552);
    t83 = (t82 + 32U);
    t84 = *((char **)t83);
    t85 = (t84 + 40U);
    t86 = *((char **)t85);
    t87 = (t86 + 4U);
    t88 = 1U;
    t89 = t88;
    t90 = (t50 + 4U);
    t91 = *((unsigned int *)t50);
    t88 = (t88 & t91);
    t92 = *((unsigned int *)t90);
    t89 = (t89 & t92);
    t93 = *((unsigned int *)t86);
    *((unsigned int *)t86) = (t93 & 4294967294U);
    t94 = *((unsigned int *)t86);
    *((unsigned int *)t86) = (t94 | t88);
    t95 = *((unsigned int *)t87);
    *((unsigned int *)t87) = (t95 & 4294967294U);
    t96 = *((unsigned int *)t87);
    *((unsigned int *)t87) = (t96 | t89);
    xsi_driver_vfirst_trans(t82, 0, 0);
    t97 = (t0 + 4460);
    *((int *)t97) = 1;

LAB1:    return;
LAB5:    t10 = *((unsigned int *)t3);
    t11 = *((unsigned int *)t7);
    *((unsigned int *)t3) = (t10 | t11);
    t12 = *((unsigned int *)t6);
    t13 = *((unsigned int *)t7);
    *((unsigned int *)t6) = (t12 | t13);
    goto LAB4;

LAB6:    *((unsigned int *)t16) = 1;
    goto LAB9;

LAB8:    *((unsigned int *)t16) = 1;
    *((unsigned int *)t17) = 1;
    goto LAB9;

LAB10:    t29 = (t0 + 2852);
    t30 = (t29 + 32U);
    t31 = *((char **)t30);
    memset(t28, 0, 8);
    t32 = (t28 + 4U);
    t33 = (t31 + 4U);
    t34 = *((unsigned int *)t31);
    t35 = (~(t34));
    *((unsigned int *)t28) = t35;
    *((unsigned int *)t32) = 0;
    if (*((unsigned int *)t33) != 0)
        goto LAB14;

LAB13:    t40 = *((unsigned int *)t28);
    *((unsigned int *)t28) = (t40 & 1U);
    t41 = *((unsigned int *)t32);
    *((unsigned int *)t32) = (t41 & 1U);
    memset(t42, 0, 8);
    t43 = (t42 + 4U);
    t44 = (t28 + 4U);
    t45 = *((unsigned int *)t44);
    t46 = (~(t45));
    t47 = *((unsigned int *)t28);
    t48 = (t47 & t46);
    t49 = (t48 & 1U);
    if (t49 != 0)
        goto LAB15;

LAB16:    if (*((unsigned int *)t44) != 0)
        goto LAB17;

LAB18:    t51 = *((unsigned int *)t16);
    t52 = *((unsigned int *)t42);
    t53 = (t51 & t52);
    *((unsigned int *)t50) = t53;
    t54 = (t16 + 4U);
    t55 = (t42 + 4U);
    t56 = (t50 + 4U);
    t57 = *((unsigned int *)t54);
    t58 = *((unsigned int *)t55);
    t59 = (t57 | t58);
    *((unsigned int *)t56) = t59;
    t60 = *((unsigned int *)t56);
    t61 = (t60 != 0);
    if (t61 == 1)
        goto LAB19;

LAB20:
LAB21:    goto LAB12;

LAB14:    t36 = *((unsigned int *)t28);
    t37 = *((unsigned int *)t33);
    *((unsigned int *)t28) = (t36 | t37);
    t38 = *((unsigned int *)t32);
    t39 = *((unsigned int *)t33);
    *((unsigned int *)t32) = (t38 | t39);
    goto LAB13;

LAB15:    *((unsigned int *)t42) = 1;
    goto LAB18;

LAB17:    *((unsigned int *)t42) = 1;
    *((unsigned int *)t43) = 1;
    goto LAB18;

LAB19:    t62 = *((unsigned int *)t50);
    t63 = *((unsigned int *)t56);
    *((unsigned int *)t50) = (t62 | t63);
    t64 = (t16 + 4U);
    t65 = (t42 + 4U);
    t66 = *((unsigned int *)t16);
    t67 = (~(t66));
    t68 = *((unsigned int *)t64);
    t69 = (~(t68));
    t70 = *((unsigned int *)t42);
    t71 = (~(t70));
    t72 = *((unsigned int *)t65);
    t73 = (~(t72));
    t74 = (t67 & t69);
    t75 = (t71 & t73);
    t76 = (~(t74));
    t77 = (~(t75));
    t78 = *((unsigned int *)t56);
    *((unsigned int *)t56) = (t78 & t76);
    t79 = *((unsigned int *)t56);
    *((unsigned int *)t56) = (t79 & t77);
    t80 = *((unsigned int *)t50);
    *((unsigned int *)t50) = (t80 & t76);
    t81 = *((unsigned int *)t50);
    *((unsigned int *)t50) = (t81 & t77);
    goto LAB21;

}

static void N51_1(char *t0)
{
    char t5[8];
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    unsigned int t6;
    unsigned int t7;
    unsigned int t8;
    char *t9;
    char *t10;
    unsigned int t11;
    unsigned int t12;
    unsigned int t13;
    unsigned int t14;
    unsigned int t15;
    unsigned int t16;
    unsigned int t17;
    char *t18;
    char *t19;
    unsigned int t20;
    unsigned int t21;
    unsigned int t22;
    unsigned int t23;
    unsigned int t24;
    unsigned int t25;
    unsigned int t26;
    unsigned int t27;
    int t28;
    int t29;
    unsigned int t30;
    unsigned int t31;
    unsigned int t32;
    unsigned int t33;
    unsigned int t34;
    unsigned int t35;
    char *t36;
    char *t37;
    char *t38;
    char *t39;
    char *t40;
    char *t41;
    unsigned int t42;
    unsigned int t43;
    char *t44;
    unsigned int t45;
    unsigned int t46;
    unsigned int t47;
    unsigned int t48;
    unsigned int t49;
    unsigned int t50;
    char *t51;

LAB0:    t1 = (t0 + 3640U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    t2 = (t0 + 740U);
    t3 = *((char **)t2);
    t2 = (t0 + 828U);
    t4 = *((char **)t2);
    t6 = *((unsigned int *)t3);
    t7 = *((unsigned int *)t4);
    t8 = (t6 & t7);
    *((unsigned int *)t5) = t8;
    t2 = (t3 + 4U);
    t9 = (t4 + 4U);
    t10 = (t5 + 4U);
    t11 = *((unsigned int *)t2);
    t12 = *((unsigned int *)t9);
    t13 = (t11 | t12);
    *((unsigned int *)t10) = t13;
    t14 = *((unsigned int *)t10);
    t15 = (t14 != 0);
    if (t15 == 1)
        goto LAB4;

LAB5:
LAB6:    t36 = (t0 + 4588);
    t37 = (t36 + 32U);
    t38 = *((char **)t37);
    t39 = (t38 + 40U);
    t40 = *((char **)t39);
    t41 = (t40 + 4U);
    t42 = 1U;
    t43 = t42;
    t44 = (t5 + 4U);
    t45 = *((unsigned int *)t5);
    t42 = (t42 & t45);
    t46 = *((unsigned int *)t44);
    t43 = (t43 & t46);
    t47 = *((unsigned int *)t40);
    *((unsigned int *)t40) = (t47 & 4294967294U);
    t48 = *((unsigned int *)t40);
    *((unsigned int *)t40) = (t48 | t42);
    t49 = *((unsigned int *)t41);
    *((unsigned int *)t41) = (t49 & 4294967294U);
    t50 = *((unsigned int *)t41);
    *((unsigned int *)t41) = (t50 | t43);
    xsi_driver_vfirst_trans(t36, 0, 0U);
    t51 = (t0 + 4468);
    *((int *)t51) = 1;

LAB1:    return;
LAB4:    t16 = *((unsigned int *)t5);
    t17 = *((unsigned int *)t10);
    *((unsigned int *)t5) = (t16 | t17);
    t18 = (t3 + 4U);
    t19 = (t4 + 4U);
    t20 = *((unsigned int *)t3);
    t21 = (~(t20));
    t22 = *((unsigned int *)t18);
    t23 = (~(t22));
    t24 = *((unsigned int *)t4);
    t25 = (~(t24));
    t26 = *((unsigned int *)t19);
    t27 = (~(t26));
    t28 = (t21 & t23);
    t29 = (t25 & t27);
    t30 = (~(t28));
    t31 = (~(t29));
    t32 = *((unsigned int *)t10);
    *((unsigned int *)t10) = (t32 & t30);
    t33 = *((unsigned int *)t10);
    *((unsigned int *)t10) = (t33 & t31);
    t34 = *((unsigned int *)t5);
    *((unsigned int *)t5) = (t34 & t30);
    t35 = *((unsigned int *)t5);
    *((unsigned int *)t5) = (t35 & t31);
    goto LAB6;

}

static void N70_2(char *t0)
{
    char t3[16];
    char t4[8];
    char t5[8];
    char t8[8];
    char t33[8];
    char t45[8];
    char t46[8];
    char t50[8];
    char t75[8];
    char t87[8];
    char t88[8];
    char t92[8];
    char t118[8];
    char t131[8];
    char t132[8];
    char t136[8];
    char t162[8];
    char *t1;
    char *t2;
    char *t6;
    char *t7;
    char *t9;
    char *t10;
    unsigned int t11;
    unsigned int t12;
    unsigned int t13;
    unsigned int t14;
    unsigned int t15;
    unsigned int t16;
    char *t17;
    char *t18;
    unsigned int t19;
    unsigned int t20;
    unsigned int t21;
    unsigned int t22;
    unsigned int t23;
    char *t24;
    unsigned int t25;
    unsigned int t26;
    unsigned int t27;
    char *t28;
    unsigned int t29;
    unsigned int t30;
    unsigned int t31;
    unsigned int t32;
    char *t34;
    char *t35;
    char *t36;
    char *t37;
    char *t38;
    unsigned int t39;
    unsigned int t40;
    unsigned int t41;
    unsigned int t42;
    unsigned int t43;
    unsigned int t44;
    char *t47;
    char *t48;
    char *t49;
    char *t51;
    char *t52;
    unsigned int t53;
    unsigned int t54;
    unsigned int t55;
    unsigned int t56;
    unsigned int t57;
    unsigned int t58;
    char *t59;
    char *t60;
    unsigned int t61;
    unsigned int t62;
    unsigned int t63;
    unsigned int t64;
    unsigned int t65;
    char *t66;
    unsigned int t67;
    unsigned int t68;
    unsigned int t69;
    char *t70;
    unsigned int t71;
    unsigned int t72;
    unsigned int t73;
    unsigned int t74;
    char *t76;
    char *t77;
    char *t78;
    char *t79;
    char *t80;
    unsigned int t81;
    unsigned int t82;
    unsigned int t83;
    unsigned int t84;
    unsigned int t85;
    unsigned int t86;
    char *t89;
    char *t90;
    char *t91;
    char *t93;
    char *t94;
    char *t95;
    unsigned int t96;
    unsigned int t97;
    unsigned int t98;
    unsigned int t99;
    unsigned int t100;
    unsigned int t101;
    char *t102;
    char *t103;
    unsigned int t104;
    unsigned int t105;
    unsigned int t106;
    unsigned int t107;
    unsigned int t108;
    char *t109;
    unsigned int t110;
    unsigned int t111;
    unsigned int t112;
    char *t113;
    unsigned int t114;
    unsigned int t115;
    unsigned int t116;
    unsigned int t117;
    char *t119;
    char *t120;
    char *t121;
    char *t122;
    char *t123;
    char *t124;
    unsigned int t125;
    unsigned int t126;
    unsigned int t127;
    unsigned int t128;
    unsigned int t129;
    unsigned int t130;
    char *t133;
    char *t134;
    char *t135;
    char *t137;
    char *t138;
    char *t139;
    unsigned int t140;
    unsigned int t141;
    unsigned int t142;
    unsigned int t143;
    unsigned int t144;
    unsigned int t145;
    char *t146;
    char *t147;
    unsigned int t148;
    unsigned int t149;
    unsigned int t150;
    unsigned int t151;
    unsigned int t152;
    char *t153;
    unsigned int t154;
    unsigned int t155;
    unsigned int t156;
    char *t157;
    unsigned int t158;
    unsigned int t159;
    unsigned int t160;
    unsigned int t161;
    char *t163;
    char *t164;
    char *t165;
    char *t166;
    char *t167;
    char *t168;
    unsigned int t169;
    unsigned int t170;
    unsigned int t171;
    unsigned int t172;
    unsigned int t173;
    unsigned int t174;
    char *t175;
    char *t176;
    char *t177;
    char *t178;
    char *t179;
    char *t180;

LAB0:    t1 = (t0 + 3768U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    t2 = (t0 + 2116);
    t6 = (t2 + 32U);
    t7 = *((char **)t6);
    memset(t8, 0, 8);
    t9 = (t8 + 4U);
    t10 = (t7 + 4U);
    t11 = *((unsigned int *)t7);
    t12 = (t11 >> 15);
    t13 = (t12 & 1);
    *((unsigned int *)t8) = t13;
    t14 = *((unsigned int *)t10);
    t15 = (t14 >> 15);
    t16 = (t15 & 1);
    *((unsigned int *)t9) = t16;
    memset(t5, 0, 8);
    t17 = (t5 + 4U);
    t18 = (t8 + 4U);
    t19 = *((unsigned int *)t18);
    t20 = (~(t19));
    t21 = *((unsigned int *)t8);
    t22 = (t21 & t20);
    t23 = (t22 & 1U);
    if (t23 != 0)
        goto LAB4;

LAB5:    if (*((unsigned int *)t18) != 0)
        goto LAB6;

LAB7:    t24 = (t5 + 4U);
    t25 = *((unsigned int *)t5);
    t26 = *((unsigned int *)t24);
    t27 = (t25 || t26);
    if (t27 > 0)
        goto LAB8;

LAB9:    t29 = *((unsigned int *)t5);
    t30 = (~(t29));
    t31 = *((unsigned int *)t24);
    t32 = (t30 || t31);
    if (t32 > 0)
        goto LAB10;

LAB11:    if (*((unsigned int *)t24) > 0)
        goto LAB12;

LAB13:    if (*((unsigned int *)t5) > 0)
        goto LAB14;

LAB15:    memcpy(t4, t33, 8);

LAB16:    t47 = (t0 + 2116);
    t48 = (t47 + 32U);
    t49 = *((char **)t48);
    memset(t50, 0, 8);
    t51 = (t50 + 4U);
    t52 = (t49 + 4U);
    t53 = *((unsigned int *)t49);
    t54 = (t53 >> 31);
    t55 = (t54 & 1);
    *((unsigned int *)t50) = t55;
    t56 = *((unsigned int *)t52);
    t57 = (t56 >> 31);
    t58 = (t57 & 1);
    *((unsigned int *)t51) = t58;
    memset(t46, 0, 8);
    t59 = (t46 + 4U);
    t60 = (t50 + 4U);
    t61 = *((unsigned int *)t60);
    t62 = (~(t61));
    t63 = *((unsigned int *)t50);
    t64 = (t63 & t62);
    t65 = (t64 & 1U);
    if (t65 != 0)
        goto LAB17;

LAB18:    if (*((unsigned int *)t60) != 0)
        goto LAB19;

LAB20:    t66 = (t46 + 4U);
    t67 = *((unsigned int *)t46);
    t68 = *((unsigned int *)t66);
    t69 = (t67 || t68);
    if (t69 > 0)
        goto LAB21;

LAB22:    t71 = *((unsigned int *)t46);
    t72 = (~(t71));
    t73 = *((unsigned int *)t66);
    t74 = (t72 || t73);
    if (t74 > 0)
        goto LAB23;

LAB24:    if (*((unsigned int *)t66) > 0)
        goto LAB25;

LAB26:    if (*((unsigned int *)t46) > 0)
        goto LAB27;

LAB28:    memcpy(t45, t75, 8);

LAB29:    t89 = (t0 + 2116);
    t90 = (t89 + 32U);
    t91 = *((char **)t90);
    memset(t92, 0, 8);
    t93 = (t92 + 4U);
    t94 = (t91 + 8U);
    t95 = (t91 + 12U);
    t96 = *((unsigned int *)t94);
    t97 = (t96 >> 15);
    t98 = (t97 & 1);
    *((unsigned int *)t92) = t98;
    t99 = *((unsigned int *)t95);
    t100 = (t99 >> 15);
    t101 = (t100 & 1);
    *((unsigned int *)t93) = t101;
    memset(t88, 0, 8);
    t102 = (t88 + 4U);
    t103 = (t92 + 4U);
    t104 = *((unsigned int *)t103);
    t105 = (~(t104));
    t106 = *((unsigned int *)t92);
    t107 = (t106 & t105);
    t108 = (t107 & 1U);
    if (t108 != 0)
        goto LAB30;

LAB31:    if (*((unsigned int *)t103) != 0)
        goto LAB32;

LAB33:    t109 = (t88 + 4U);
    t110 = *((unsigned int *)t88);
    t111 = *((unsigned int *)t109);
    t112 = (t110 || t111);
    if (t112 > 0)
        goto LAB34;

LAB35:    t114 = *((unsigned int *)t88);
    t115 = (~(t114));
    t116 = *((unsigned int *)t109);
    t117 = (t115 || t116);
    if (t117 > 0)
        goto LAB36;

LAB37:    if (*((unsigned int *)t109) > 0)
        goto LAB38;

LAB39:    if (*((unsigned int *)t88) > 0)
        goto LAB40;

LAB41:    memcpy(t87, t118, 8);

LAB42:    t133 = (t0 + 2116);
    t134 = (t133 + 32U);
    t135 = *((char **)t134);
    memset(t136, 0, 8);
    t137 = (t136 + 4U);
    t138 = (t135 + 8U);
    t139 = (t135 + 12U);
    t140 = *((unsigned int *)t138);
    t141 = (t140 >> 31);
    t142 = (t141 & 1);
    *((unsigned int *)t136) = t142;
    t143 = *((unsigned int *)t139);
    t144 = (t143 >> 31);
    t145 = (t144 & 1);
    *((unsigned int *)t137) = t145;
    memset(t132, 0, 8);
    t146 = (t132 + 4U);
    t147 = (t136 + 4U);
    t148 = *((unsigned int *)t147);
    t149 = (~(t148));
    t150 = *((unsigned int *)t136);
    t151 = (t150 & t149);
    t152 = (t151 & 1U);
    if (t152 != 0)
        goto LAB43;

LAB44:    if (*((unsigned int *)t147) != 0)
        goto LAB45;

LAB46:    t153 = (t132 + 4U);
    t154 = *((unsigned int *)t132);
    t155 = *((unsigned int *)t153);
    t156 = (t154 || t155);
    if (t156 > 0)
        goto LAB47;

LAB48:    t158 = *((unsigned int *)t132);
    t159 = (~(t158));
    t160 = *((unsigned int *)t153);
    t161 = (t159 || t160);
    if (t161 > 0)
        goto LAB49;

LAB50:    if (*((unsigned int *)t153) > 0)
        goto LAB51;

LAB52:    if (*((unsigned int *)t132) > 0)
        goto LAB53;

LAB54:    memcpy(t131, t162, 8);

LAB55:    xsi_vlogtype_concat(t3, 64, 64, 4U, t131, 16, t87, 16, t45, 16, t4, 16);
    t175 = (t0 + 4624);
    t176 = (t175 + 32U);
    t177 = *((char **)t176);
    t178 = (t177 + 40U);
    t179 = *((char **)t178);
    xsi_vlog_bit_copy(t179, 0, t3, 0, 64);
    xsi_driver_vfirst_trans(t175, 0, 63U);
    t180 = (t0 + 4476);
    *((int *)t180) = 1;

LAB1:    return;
LAB4:    *((unsigned int *)t5) = 1;
    goto LAB7;

LAB6:    *((unsigned int *)t5) = 1;
    *((unsigned int *)t17) = 1;
    goto LAB7;

LAB8:    t28 = ((char*)((ng0)));
    goto LAB9;

LAB10:    t34 = (t0 + 2116);
    t35 = (t34 + 32U);
    t36 = *((char **)t35);
    memset(t33, 0, 8);
    t37 = (t33 + 4U);
    t38 = (t36 + 4U);
    t39 = *((unsigned int *)t36);
    t40 = (t39 >> 0);
    *((unsigned int *)t33) = t40;
    t41 = *((unsigned int *)t38);
    t42 = (t41 >> 0);
    *((unsigned int *)t37) = t42;
    t43 = *((unsigned int *)t33);
    *((unsigned int *)t33) = (t43 & 65535U);
    t44 = *((unsigned int *)t37);
    *((unsigned int *)t37) = (t44 & 65535U);
    goto LAB11;

LAB12:    xsi_vlog_unsigned_bit_combine(t4, 16, t28, 16, t33, 16);
    goto LAB16;

LAB14:    memcpy(t4, t28, 8);
    goto LAB16;

LAB17:    *((unsigned int *)t46) = 1;
    goto LAB20;

LAB19:    *((unsigned int *)t46) = 1;
    *((unsigned int *)t59) = 1;
    goto LAB20;

LAB21:    t70 = ((char*)((ng0)));
    goto LAB22;

LAB23:    t76 = (t0 + 2116);
    t77 = (t76 + 32U);
    t78 = *((char **)t77);
    memset(t75, 0, 8);
    t79 = (t75 + 4U);
    t80 = (t78 + 4U);
    t81 = *((unsigned int *)t78);
    t82 = (t81 >> 16);
    *((unsigned int *)t75) = t82;
    t83 = *((unsigned int *)t80);
    t84 = (t83 >> 16);
    *((unsigned int *)t79) = t84;
    t85 = *((unsigned int *)t75);
    *((unsigned int *)t75) = (t85 & 65535U);
    t86 = *((unsigned int *)t79);
    *((unsigned int *)t79) = (t86 & 65535U);
    goto LAB24;

LAB25:    xsi_vlog_unsigned_bit_combine(t45, 16, t70, 16, t75, 16);
    goto LAB29;

LAB27:    memcpy(t45, t70, 8);
    goto LAB29;

LAB30:    *((unsigned int *)t88) = 1;
    goto LAB33;

LAB32:    *((unsigned int *)t88) = 1;
    *((unsigned int *)t102) = 1;
    goto LAB33;

LAB34:    t113 = ((char*)((ng0)));
    goto LAB35;

LAB36:    t119 = (t0 + 2116);
    t120 = (t119 + 32U);
    t121 = *((char **)t120);
    memset(t118, 0, 8);
    t122 = (t118 + 4U);
    t123 = (t121 + 8U);
    t124 = (t121 + 12U);
    t125 = *((unsigned int *)t123);
    t126 = (t125 >> 0);
    *((unsigned int *)t118) = t126;
    t127 = *((unsigned int *)t124);
    t128 = (t127 >> 0);
    *((unsigned int *)t122) = t128;
    t129 = *((unsigned int *)t118);
    *((unsigned int *)t118) = (t129 & 65535U);
    t130 = *((unsigned int *)t122);
    *((unsigned int *)t122) = (t130 & 65535U);
    goto LAB37;

LAB38:    xsi_vlog_unsigned_bit_combine(t87, 16, t113, 16, t118, 16);
    goto LAB42;

LAB40:    memcpy(t87, t113, 8);
    goto LAB42;

LAB43:    *((unsigned int *)t132) = 1;
    goto LAB46;

LAB45:    *((unsigned int *)t132) = 1;
    *((unsigned int *)t146) = 1;
    goto LAB46;

LAB47:    t157 = ((char*)((ng0)));
    goto LAB48;

LAB49:    t163 = (t0 + 2116);
    t164 = (t163 + 32U);
    t165 = *((char **)t164);
    memset(t162, 0, 8);
    t166 = (t162 + 4U);
    t167 = (t165 + 8U);
    t168 = (t165 + 12U);
    t169 = *((unsigned int *)t167);
    t170 = (t169 >> 16);
    *((unsigned int *)t162) = t170;
    t171 = *((unsigned int *)t168);
    t172 = (t171 >> 16);
    *((unsigned int *)t166) = t172;
    t173 = *((unsigned int *)t162);
    *((unsigned int *)t162) = (t173 & 65535U);
    t174 = *((unsigned int *)t166);
    *((unsigned int *)t166) = (t174 & 65535U);
    goto LAB50;

LAB51:    xsi_vlog_unsigned_bit_combine(t131, 16, t157, 16, t162, 16);
    goto LAB55;

LAB53:    memcpy(t131, t157, 8);
    goto LAB55;

}

static void A80_3(char *t0)
{
    char t5[8];
    char t18[8];
    char t29[8];
    char t37[8];
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t6;
    char *t7;
    unsigned int t8;
    unsigned int t9;
    unsigned int t10;
    unsigned int t11;
    unsigned int t12;
    char *t13;
    unsigned int t14;
    unsigned int t15;
    unsigned int t16;
    unsigned int t17;
    char *t19;
    char *t20;
    char *t21;
    char *t22;
    char *t23;
    unsigned int t24;
    unsigned int t25;
    unsigned int t26;
    unsigned int t27;
    unsigned int t28;
    char *t30;
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
    int t56;
    unsigned int t57;
    unsigned int t58;
    unsigned int t59;
    int t60;
    unsigned int t61;
    unsigned int t62;
    unsigned int t63;
    unsigned int t64;
    char *t65;
    unsigned int t66;
    unsigned int t67;
    unsigned int t68;
    unsigned int t69;
    unsigned int t70;
    char *t71;
    char *t72;
    char *t73;
    char *t74;
    int t75;
    char *t76;
    char *t77;

LAB0:    t1 = (t0 + 3896U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(80, ng1);
    t2 = (t0 + 4484);
    *((int *)t2) = 1;
    *((char **)t1) = &&LAB4;

LAB1:    return;
LAB4:    xsi_set_current_line(80, ng1);

LAB5:    xsi_set_current_line(81, ng1);
    t3 = ((char*)((ng2)));
    t4 = (t0 + 2392);
    xsi_vlogvar_assign_value(t4, t3, 0, 0, 64);
    xsi_set_current_line(82, ng1);
    t2 = ((char*)((ng2)));
    t3 = (t0 + 2484);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 64);
    xsi_set_current_line(83, ng1);
    t2 = ((char*)((ng2)));
    t3 = (t0 + 2576);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 64);
    xsi_set_current_line(84, ng1);
    t2 = ((char*)((ng0)));
    t3 = (t0 + 2668);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(86, ng1);
    t2 = (t0 + 1932);
    t3 = (t2 + 32U);
    t4 = *((char **)t3);
    memset(t5, 0, 8);
    t6 = (t5 + 4U);
    t7 = (t4 + 4U);
    t8 = *((unsigned int *)t7);
    t9 = (~(t8));
    t10 = *((unsigned int *)t4);
    t11 = (t10 & t9);
    t12 = (t11 & 1U);
    if (t12 != 0)
        goto LAB6;

LAB7:    if (*((unsigned int *)t7) != 0)
        goto LAB8;

LAB9:    t13 = (t5 + 4U);
    t14 = *((unsigned int *)t5);
    t15 = (!(t14));
    t16 = *((unsigned int *)t13);
    t17 = (t15 || t16);
    if (t17 > 0)
        goto LAB10;

LAB11:    memcpy(t37, t5, 8);

LAB12:    t65 = (t37 + 4U);
    t66 = *((unsigned int *)t65);
    t67 = (~(t66));
    t68 = *((unsigned int *)t37);
    t69 = (t68 & t67);
    t70 = (t69 != 0);
    if (t70 > 0)
        goto LAB24;

LAB25:
LAB26:    goto LAB2;

LAB6:    *((unsigned int *)t5) = 1;
    goto LAB9;

LAB8:    *((unsigned int *)t5) = 1;
    *((unsigned int *)t6) = 1;
    goto LAB9;

LAB10:    t19 = (t0 + 2760);
    t20 = (t19 + 32U);
    t21 = *((char **)t20);
    memset(t18, 0, 8);
    t22 = (t18 + 4U);
    t23 = (t21 + 4U);
    t24 = *((unsigned int *)t23);
    t25 = (~(t24));
    t26 = *((unsigned int *)t21);
    t27 = (t26 & t25);
    t28 = (t27 & 15U);
    if (t28 != 0)
        goto LAB13;

LAB14:    if (*((unsigned int *)t23) != 0)
        goto LAB15;

LAB16:    memset(t29, 0, 8);
    t30 = (t29 + 4U);
    t31 = (t18 + 4U);
    t32 = *((unsigned int *)t31);
    t33 = (~(t32));
    t34 = *((unsigned int *)t18);
    t35 = (t34 & t33);
    t36 = (t35 & 1U);
    if (t36 != 0)
        goto LAB17;

LAB18:    if (*((unsigned int *)t31) != 0)
        goto LAB19;

LAB20:    t38 = *((unsigned int *)t5);
    t39 = *((unsigned int *)t29);
    t40 = (t38 | t39);
    *((unsigned int *)t37) = t40;
    t41 = (t5 + 4U);
    t42 = (t29 + 4U);
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
LAB23:    goto LAB12;

LAB13:    *((unsigned int *)t18) = 1;
    goto LAB16;

LAB15:    *((unsigned int *)t18) = 1;
    *((unsigned int *)t22) = 1;
    goto LAB16;

LAB17:    *((unsigned int *)t29) = 1;
    goto LAB20;

LAB19:    *((unsigned int *)t29) = 1;
    *((unsigned int *)t30) = 1;
    goto LAB20;

LAB21:    t49 = *((unsigned int *)t37);
    t50 = *((unsigned int *)t43);
    *((unsigned int *)t37) = (t49 | t50);
    t51 = (t5 + 4U);
    t52 = (t29 + 4U);
    t53 = *((unsigned int *)t51);
    t54 = (~(t53));
    t55 = *((unsigned int *)t5);
    t56 = (t55 & t54);
    t57 = *((unsigned int *)t52);
    t58 = (~(t57));
    t59 = *((unsigned int *)t29);
    t60 = (t59 & t58);
    t61 = (~(t56));
    t62 = (~(t60));
    t63 = *((unsigned int *)t43);
    *((unsigned int *)t43) = (t63 & t61);
    t64 = *((unsigned int *)t43);
    *((unsigned int *)t43) = (t64 & t62);
    goto LAB23;

LAB24:    xsi_set_current_line(86, ng1);

LAB27:    xsi_set_current_line(87, ng1);
    t71 = (t0 + 2024);
    t72 = (t71 + 32U);
    t73 = *((char **)t72);

LAB28:    t74 = ((char*)((ng3)));
    t75 = xsi_vlog_unsigned_case_compare(t73, 6, t74, 6);
    if (t75 == 1)
        goto LAB29;

LAB30:    t2 = ((char*)((ng5)));
    t56 = xsi_vlog_unsigned_case_compare(t73, 6, t2, 6);
    if (t56 == 1)
        goto LAB31;

LAB32:    t3 = ((char*)((ng6)));
    t60 = xsi_vlog_unsigned_case_compare(t73, 6, t3, 6);
    if (t60 == 1)
        goto LAB33;

LAB34:    t2 = ((char*)((ng7)));
    t56 = xsi_vlog_unsigned_case_compare(t73, 6, t2, 6);
    if (t56 == 1)
        goto LAB35;

LAB36:
LAB38:
LAB37:    xsi_set_current_line(109, ng1);

LAB47:    xsi_set_current_line(110, ng1);
    t2 = ((char*)((ng2)));
    t3 = (t0 + 2392);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 64);
    xsi_set_current_line(111, ng1);
    t2 = ((char*)((ng2)));
    t3 = (t0 + 2484);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 64);
    xsi_set_current_line(112, ng1);
    t2 = ((char*)((ng2)));
    t3 = (t0 + 2576);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 64);
    xsi_set_current_line(113, ng1);
    t2 = ((char*)((ng0)));
    t3 = (t0 + 2668);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);

LAB39:    goto LAB26;

LAB29:    xsi_set_current_line(88, ng1);

LAB40:    xsi_set_current_line(89, ng1);
    t76 = ((char*)((ng4)));
    t77 = (t0 + 2392);
    xsi_vlogvar_assign_value(t77, t76, 0, 0, 64);
    xsi_set_current_line(90, ng1);
    t2 = (t0 + 2116);
    t3 = (t2 + 32U);
    t4 = *((char **)t3);
    t6 = (t0 + 2484);
    xsi_vlogvar_assign_value(t6, t4, 0, 0, 64);
    xsi_set_current_line(91, ng1);
    t2 = (t0 + 2208);
    t3 = (t2 + 32U);
    t4 = *((char **)t3);
    t6 = (t0 + 2576);
    xsi_vlogvar_assign_value(t6, t4, 0, 0, 64);
    xsi_set_current_line(92, ng1);
    t2 = (t0 + 2024);
    t3 = (t2 + 32U);
    t4 = *((char **)t3);
    t6 = ((char*)((ng5)));
    memset(t5, 0, 8);
    t7 = (t5 + 4U);
    t13 = (t4 + 4U);
    t19 = (t6 + 4U);
    t8 = *((unsigned int *)t4);
    t9 = *((unsigned int *)t6);
    t10 = (t8 ^ t9);
    t11 = *((unsigned int *)t13);
    t12 = *((unsigned int *)t19);
    t14 = (t11 ^ t12);
    t15 = (t10 | t14);
    t16 = *((unsigned int *)t13);
    t17 = *((unsigned int *)t19);
    t24 = (t16 | t17);
    t25 = (~(t24));
    t26 = (t15 & t25);
    if (t26 != 0)
        goto LAB44;

LAB41:    if (t24 != 0)
        goto LAB43;

LAB42:    *((unsigned int *)t5) = 1;

LAB44:    t20 = (t0 + 2668);
    xsi_vlogvar_assign_value(t20, t5, 0, 0, 1);
    goto LAB39;

LAB31:    goto LAB29;

LAB33:    xsi_set_current_line(95, ng1);

LAB45:    xsi_set_current_line(96, ng1);
    t4 = (t0 + 2116);
    t6 = (t4 + 32U);
    t7 = *((char **)t6);
    t13 = (t0 + 2392);
    xsi_vlogvar_assign_value(t13, t7, 0, 0, 64);
    xsi_set_current_line(97, ng1);
    t2 = (t0 + 2208);
    t3 = (t2 + 32U);
    t4 = *((char **)t3);
    t6 = (t0 + 2484);
    xsi_vlogvar_assign_value(t6, t4, 0, 0, 64);
    xsi_set_current_line(98, ng1);
    t2 = ((char*)((ng2)));
    t3 = (t0 + 2576);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 64);
    xsi_set_current_line(99, ng1);
    t2 = ((char*)((ng0)));
    t3 = (t0 + 2668);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    goto LAB39;

LAB35:    xsi_set_current_line(102, ng1);

LAB46:    xsi_set_current_line(103, ng1);
    t3 = (t0 + 2116);
    t4 = (t3 + 32U);
    t6 = *((char **)t4);
    t7 = (t0 + 2392);
    xsi_vlogvar_assign_value(t7, t6, 0, 0, 64);
    xsi_set_current_line(104, ng1);
    t2 = (t0 + 2208);
    t3 = (t2 + 32U);
    t4 = *((char **)t3);
    t6 = (t0 + 2484);
    xsi_vlogvar_assign_value(t6, t4, 0, 0, 64);
    xsi_set_current_line(105, ng1);
    t2 = (t0 + 2300);
    t3 = (t2 + 32U);
    t4 = *((char **)t3);
    t6 = (t0 + 2576);
    xsi_vlogvar_assign_value(t6, t4, 0, 0, 64);
    xsi_set_current_line(106, ng1);
    t2 = ((char*)((ng0)));
    t3 = (t0 + 2668);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    goto LAB39;

LAB43:    *((unsigned int *)t5) = 1;
    *((unsigned int *)t7) = 1;
    goto LAB44;

}

static void A122_4(char *t0)
{
    char t13[8];
    char t14[8];
    char t30[8];
    char t46[8];
    char t54[8];
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
    char *t12;
    unsigned int t15;
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
    char *t32;
    char *t33;
    unsigned int t34;
    unsigned int t35;
    unsigned int t36;
    unsigned int t37;
    unsigned int t38;
    unsigned int t39;
    unsigned int t40;
    unsigned int t41;
    unsigned int t42;
    unsigned int t43;
    unsigned int t44;
    unsigned int t45;
    char *t47;
    char *t48;
    unsigned int t49;
    unsigned int t50;
    unsigned int t51;
    unsigned int t52;
    unsigned int t53;
    unsigned int t55;
    unsigned int t56;
    unsigned int t57;
    char *t58;
    char *t59;
    char *t60;
    unsigned int t61;
    unsigned int t62;
    unsigned int t63;
    unsigned int t64;
    unsigned int t65;
    unsigned int t66;
    unsigned int t67;
    char *t68;
    char *t69;
    unsigned int t70;
    unsigned int t71;
    unsigned int t72;
    unsigned int t73;
    unsigned int t74;
    unsigned int t75;
    unsigned int t76;
    unsigned int t77;
    int t78;
    int t79;
    unsigned int t80;
    unsigned int t81;
    unsigned int t82;
    unsigned int t83;
    unsigned int t84;
    unsigned int t85;
    char *t86;
    unsigned int t87;
    unsigned int t88;
    unsigned int t89;
    unsigned int t90;
    unsigned int t91;
    char *t92;
    char *t93;

LAB0:    t1 = (t0 + 4024U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(122, ng1);
    t2 = (t0 + 4492);
    *((int *)t2) = 1;
    *((char **)t1) = &&LAB4;

LAB1:    return;
LAB4:    xsi_set_current_line(122, ng1);

LAB5:    xsi_set_current_line(123, ng1);
    t3 = (t0 + 652U);
    t4 = *((char **)t3);
    t3 = (t4 + 4U);
    t5 = *((unsigned int *)t3);
    t6 = (~(t5));
    t7 = *((unsigned int *)t4);
    t8 = (t7 & t6);
    t9 = (t8 != 0);
    if (t9 > 0)
        goto LAB6;

LAB7:    xsi_set_current_line(133, ng1);

LAB10:    xsi_set_current_line(134, ng1);
    t2 = ((char*)((ng0)));
    t3 = (t0 + 3036);
    xsi_vlogvar_generic_wait_assign_value(t3, t2, 2, 0, 0, 1, 0LL);
    xsi_set_current_line(139, ng1);
    t2 = (t0 + 1444U);
    t3 = *((char **)t2);
    t2 = (t3 + 4U);
    t5 = *((unsigned int *)t2);
    t6 = (~(t5));
    t7 = *((unsigned int *)t3);
    t8 = (t7 & t6);
    t9 = (t8 != 0);
    if (t9 > 0)
        goto LAB11;

LAB12:    xsi_set_current_line(145, ng1);
    t2 = (t0 + 1932);
    t3 = (t2 + 32U);
    t4 = *((char **)t3);
    t10 = (t4 + 4U);
    t5 = *((unsigned int *)t10);
    t6 = (~(t5));
    t7 = *((unsigned int *)t4);
    t8 = (t7 & t6);
    t9 = (t8 != 0);
    if (t9 > 0)
        goto LAB15;

LAB16:
LAB17:
LAB13:    xsi_set_current_line(154, ng1);
    t2 = (t0 + 740U);
    t3 = *((char **)t2);
    t2 = (t0 + 2760);
    t4 = (t2 + 32U);
    t10 = *((char **)t4);
    memset(t14, 0, 8);
    t11 = (t14 + 4U);
    t12 = (t10 + 4U);
    t5 = *((unsigned int *)t10);
    t6 = (t5 >> 0);
    *((unsigned int *)t14) = t6;
    t7 = *((unsigned int *)t12);
    t8 = (t7 >> 0);
    *((unsigned int *)t11) = t8;
    t9 = *((unsigned int *)t14);
    *((unsigned int *)t14) = (t9 & 7U);
    t15 = *((unsigned int *)t11);
    *((unsigned int *)t11) = (t15 & 7U);
    xsi_vlogtype_concat(t13, 4, 4, 2U, t14, 3, t3, 1);
    t16 = (t0 + 2760);
    xsi_vlogvar_generic_wait_assign_value(t16, t13, 2, 0, 0, 4, 0LL);
    xsi_set_current_line(159, ng1);
    t2 = (t0 + 2760);
    t3 = (t2 + 32U);
    t4 = *((char **)t3);
    memset(t13, 0, 8);
    t10 = (t13 + 4U);
    t11 = (t4 + 4U);
    t5 = *((unsigned int *)t4);
    t6 = (t5 >> 3);
    t7 = (t6 & 1);
    *((unsigned int *)t13) = t7;
    t8 = *((unsigned int *)t11);
    t9 = (t8 >> 3);
    t15 = (t9 & 1);
    *((unsigned int *)t10) = t15;
    memset(t14, 0, 8);
    t12 = (t14 + 4U);
    t16 = (t13 + 4U);
    t17 = *((unsigned int *)t16);
    t18 = (~(t17));
    t19 = *((unsigned int *)t13);
    t20 = (t19 & t18);
    t21 = (t20 & 1U);
    if (t21 != 0)
        goto LAB19;

LAB20:    if (*((unsigned int *)t16) != 0)
        goto LAB21;

LAB22:    t22 = (t14 + 4U);
    t23 = *((unsigned int *)t14);
    t24 = *((unsigned int *)t22);
    t25 = (t23 || t24);
    if (t25 > 0)
        goto LAB23;

LAB24:    memcpy(t54, t14, 8);

LAB25:    t86 = (t54 + 4U);
    t87 = *((unsigned int *)t86);
    t88 = (~(t87));
    t89 = *((unsigned int *)t54);
    t90 = (t89 & t88);
    t91 = (t90 != 0);
    if (t91 > 0)
        goto LAB37;

LAB38:
LAB39:    xsi_set_current_line(169, ng1);
    t2 = (t0 + 2760);
    t3 = (t2 + 32U);
    t4 = *((char **)t3);
    memset(t13, 0, 8);
    t10 = (t13 + 4U);
    t11 = (t4 + 4U);
    t5 = *((unsigned int *)t4);
    t6 = (t5 >> 3);
    t7 = (t6 & 1);
    *((unsigned int *)t13) = t7;
    t8 = *((unsigned int *)t11);
    t9 = (t8 >> 3);
    t15 = (t9 & 1);
    *((unsigned int *)t10) = t15;
    memset(t14, 0, 8);
    t12 = (t14 + 4U);
    t16 = (t13 + 4U);
    t17 = *((unsigned int *)t16);
    t18 = (~(t17));
    t19 = *((unsigned int *)t13);
    t20 = (t19 & t18);
    t21 = (t20 & 1U);
    if (t21 != 0)
        goto LAB41;

LAB42:    if (*((unsigned int *)t16) != 0)
        goto LAB43;

LAB44:    t22 = (t14 + 4U);
    t23 = *((unsigned int *)t14);
    t24 = *((unsigned int *)t22);
    t25 = (t23 || t24);
    if (t25 > 0)
        goto LAB45;

LAB46:    memcpy(t54, t14, 8);

LAB47:    t86 = (t54 + 4U);
    t87 = *((unsigned int *)t86);
    t88 = (~(t87));
    t89 = *((unsigned int *)t54);
    t90 = (t89 & t88);
    t91 = (t90 != 0);
    if (t91 > 0)
        goto LAB59;

LAB60:
LAB61:    xsi_set_current_line(172, ng1);
    t2 = (t0 + 2852);
    t3 = (t2 + 32U);
    t4 = *((char **)t3);
    memset(t13, 0, 8);
    t10 = (t13 + 4U);
    t11 = (t4 + 4U);
    t5 = *((unsigned int *)t11);
    t6 = (~(t5));
    t7 = *((unsigned int *)t4);
    t8 = (t7 & t6);
    t9 = (t8 & 1U);
    if (t9 != 0)
        goto LAB62;

LAB63:    if (*((unsigned int *)t11) != 0)
        goto LAB64;

LAB65:    t12 = (t13 + 4U);
    t15 = *((unsigned int *)t13);
    t17 = *((unsigned int *)t12);
    t18 = (t15 || t17);
    if (t18 > 0)
        goto LAB66;

LAB67:    memcpy(t30, t13, 8);

LAB68:    t33 = (t30 + 4U);
    t64 = *((unsigned int *)t33);
    t65 = (~(t64));
    t66 = *((unsigned int *)t30);
    t67 = (t66 & t65);
    t70 = (t67 != 0);
    if (t70 > 0)
        goto LAB76;

LAB77:
LAB78:
LAB8:    goto LAB2;

LAB6:    xsi_set_current_line(123, ng1);

LAB9:    xsi_set_current_line(124, ng1);
    t10 = ((char*)((ng0)));
    t11 = (t0 + 1932);
    xsi_vlogvar_generic_wait_assign_value(t11, t10, 2, 0, 0, 1, 0LL);
    xsi_set_current_line(125, ng1);
    t2 = ((char*)((ng0)));
    t3 = (t0 + 2024);
    xsi_vlogvar_generic_wait_assign_value(t3, t2, 2, 0, 0, 6, 0LL);
    xsi_set_current_line(126, ng1);
    t2 = ((char*)((ng2)));
    t3 = (t0 + 2116);
    xsi_vlogvar_generic_wait_assign_value(t3, t2, 2, 0, 0, 64, 0LL);
    xsi_set_current_line(127, ng1);
    t2 = ((char*)((ng2)));
    t3 = (t0 + 2208);
    xsi_vlogvar_generic_wait_assign_value(t3, t2, 2, 0, 0, 64, 0LL);
    xsi_set_current_line(128, ng1);
    t2 = ((char*)((ng2)));
    t3 = (t0 + 2300);
    xsi_vlogvar_generic_wait_assign_value(t3, t2, 2, 0, 0, 64, 0LL);
    xsi_set_current_line(129, ng1);
    t2 = ((char*)((ng0)));
    t3 = (t0 + 2760);
    xsi_vlogvar_generic_wait_assign_value(t3, t2, 2, 0, 0, 4, 0LL);
    xsi_set_current_line(130, ng1);
    t2 = ((char*)((ng0)));
    t3 = (t0 + 2852);
    xsi_vlogvar_generic_wait_assign_value(t3, t2, 2, 0, 0, 1, 0LL);
    xsi_set_current_line(131, ng1);
    t2 = ((char*)((ng2)));
    t3 = (t0 + 2944);
    xsi_vlogvar_generic_wait_assign_value(t3, t2, 2, 0, 0, 64, 0LL);
    xsi_set_current_line(132, ng1);
    t2 = ((char*)((ng0)));
    t3 = (t0 + 3036);
    xsi_vlogvar_generic_wait_assign_value(t3, t2, 2, 0, 0, 1, 0LL);
    goto LAB8;

LAB11:    xsi_set_current_line(139, ng1);

LAB14:    xsi_set_current_line(140, ng1);
    t4 = ((char*)((ng8)));
    t10 = (t0 + 1932);
    xsi_vlogvar_generic_wait_assign_value(t10, t4, 2, 0, 0, 1, 0LL);
    xsi_set_current_line(141, ng1);
    t2 = (t0 + 916U);
    t3 = *((char **)t2);
    t2 = (t0 + 2024);
    xsi_vlogvar_generic_wait_assign_value(t2, t3, 2, 0, 0, 6, 0LL);
    xsi_set_current_line(142, ng1);
    t2 = (t0 + 1004U);
    t3 = *((char **)t2);
    t2 = (t0 + 2116);
    xsi_vlogvar_generic_wait_assign_value(t2, t3, 2, 0, 0, 64, 0LL);
    xsi_set_current_line(143, ng1);
    t2 = (t0 + 1092U);
    t3 = *((char **)t2);
    t2 = (t0 + 2208);
    xsi_vlogvar_generic_wait_assign_value(t2, t3, 2, 0, 0, 64, 0LL);
    xsi_set_current_line(144, ng1);
    t2 = (t0 + 1180U);
    t3 = *((char **)t2);
    t2 = (t0 + 2300);
    xsi_vlogvar_generic_wait_assign_value(t2, t3, 2, 0, 0, 64, 0LL);
    goto LAB13;

LAB15:    xsi_set_current_line(145, ng1);

LAB18:    xsi_set_current_line(148, ng1);
    t11 = ((char*)((ng0)));
    t12 = (t0 + 1932);
    xsi_vlogvar_generic_wait_assign_value(t12, t11, 2, 0, 0, 1, 0LL);
    goto LAB17;

LAB19:    *((unsigned int *)t14) = 1;
    goto LAB22;

LAB21:    *((unsigned int *)t14) = 1;
    *((unsigned int *)t12) = 1;
    goto LAB22;

LAB23:    t26 = (t0 + 2024);
    t27 = (t26 + 32U);
    t28 = *((char **)t27);
    t29 = ((char*)((ng9)));
    memset(t30, 0, 8);
    t31 = (t30 + 4U);
    t32 = (t28 + 4U);
    t33 = (t29 + 4U);
    t34 = *((unsigned int *)t28);
    t35 = *((unsigned int *)t29);
    t36 = (t34 ^ t35);
    t37 = *((unsigned int *)t32);
    t38 = *((unsigned int *)t33);
    t39 = (t37 ^ t38);
    t40 = (t36 | t39);
    t41 = *((unsigned int *)t32);
    t42 = *((unsigned int *)t33);
    t43 = (t41 | t42);
    t44 = (~(t43));
    t45 = (t40 & t44);
    if (t45 != 0)
        goto LAB29;

LAB26:    if (t43 != 0)
        goto LAB28;

LAB27:    *((unsigned int *)t30) = 1;

LAB29:    memset(t46, 0, 8);
    t47 = (t46 + 4U);
    t48 = (t30 + 4U);
    t49 = *((unsigned int *)t48);
    t50 = (~(t49));
    t51 = *((unsigned int *)t30);
    t52 = (t51 & t50);
    t53 = (t52 & 1U);
    if (t53 != 0)
        goto LAB30;

LAB31:    if (*((unsigned int *)t48) != 0)
        goto LAB32;

LAB33:    t55 = *((unsigned int *)t14);
    t56 = *((unsigned int *)t46);
    t57 = (t55 & t56);
    *((unsigned int *)t54) = t57;
    t58 = (t14 + 4U);
    t59 = (t46 + 4U);
    t60 = (t54 + 4U);
    t61 = *((unsigned int *)t58);
    t62 = *((unsigned int *)t59);
    t63 = (t61 | t62);
    *((unsigned int *)t60) = t63;
    t64 = *((unsigned int *)t60);
    t65 = (t64 != 0);
    if (t65 == 1)
        goto LAB34;

LAB35:
LAB36:    goto LAB25;

LAB28:    *((unsigned int *)t30) = 1;
    *((unsigned int *)t31) = 1;
    goto LAB29;

LAB30:    *((unsigned int *)t46) = 1;
    goto LAB33;

LAB32:    *((unsigned int *)t46) = 1;
    *((unsigned int *)t47) = 1;
    goto LAB33;

LAB34:    t66 = *((unsigned int *)t54);
    t67 = *((unsigned int *)t60);
    *((unsigned int *)t54) = (t66 | t67);
    t68 = (t14 + 4U);
    t69 = (t46 + 4U);
    t70 = *((unsigned int *)t14);
    t71 = (~(t70));
    t72 = *((unsigned int *)t68);
    t73 = (~(t72));
    t74 = *((unsigned int *)t46);
    t75 = (~(t74));
    t76 = *((unsigned int *)t69);
    t77 = (~(t76));
    t78 = (t71 & t73);
    t79 = (t75 & t77);
    t80 = (~(t78));
    t81 = (~(t79));
    t82 = *((unsigned int *)t60);
    *((unsigned int *)t60) = (t82 & t80);
    t83 = *((unsigned int *)t60);
    *((unsigned int *)t60) = (t83 & t81);
    t84 = *((unsigned int *)t54);
    *((unsigned int *)t54) = (t84 & t80);
    t85 = *((unsigned int *)t54);
    *((unsigned int *)t54) = (t85 & t81);
    goto LAB36;

LAB37:    xsi_set_current_line(159, ng1);

LAB40:    xsi_set_current_line(160, ng1);
    t92 = (t0 + 1708U);
    t93 = *((char **)t92);
    t92 = (t0 + 2944);
    xsi_vlogvar_generic_wait_assign_value(t92, t93, 2, 0, 0, 64, 0LL);
    xsi_set_current_line(161, ng1);
    t2 = ((char*)((ng8)));
    t3 = (t0 + 3036);
    xsi_vlogvar_generic_wait_assign_value(t3, t2, 2, 0, 0, 1, 0LL);
    goto LAB39;

LAB41:    *((unsigned int *)t14) = 1;
    goto LAB44;

LAB43:    *((unsigned int *)t14) = 1;
    *((unsigned int *)t12) = 1;
    goto LAB44;

LAB45:    t26 = (t0 + 2024);
    t27 = (t26 + 32U);
    t28 = *((char **)t27);
    t29 = ((char*)((ng9)));
    memset(t30, 0, 8);
    t31 = (t30 + 4U);
    t32 = (t28 + 4U);
    t33 = (t29 + 4U);
    t34 = *((unsigned int *)t28);
    t35 = *((unsigned int *)t29);
    t36 = (t34 ^ t35);
    t37 = *((unsigned int *)t32);
    t38 = *((unsigned int *)t33);
    t39 = (t37 ^ t38);
    t40 = (t36 | t39);
    t41 = *((unsigned int *)t32);
    t42 = *((unsigned int *)t33);
    t43 = (t41 | t42);
    t44 = (~(t43));
    t45 = (t40 & t44);
    if (t45 != 0)
        goto LAB49;

LAB48:    if (t43 != 0)
        goto LAB50;

LAB51:    memset(t46, 0, 8);
    t47 = (t46 + 4U);
    t48 = (t30 + 4U);
    t49 = *((unsigned int *)t48);
    t50 = (~(t49));
    t51 = *((unsigned int *)t30);
    t52 = (t51 & t50);
    t53 = (t52 & 1U);
    if (t53 != 0)
        goto LAB52;

LAB53:    if (*((unsigned int *)t48) != 0)
        goto LAB54;

LAB55:    t55 = *((unsigned int *)t14);
    t56 = *((unsigned int *)t46);
    t57 = (t55 & t56);
    *((unsigned int *)t54) = t57;
    t58 = (t14 + 4U);
    t59 = (t46 + 4U);
    t60 = (t54 + 4U);
    t61 = *((unsigned int *)t58);
    t62 = *((unsigned int *)t59);
    t63 = (t61 | t62);
    *((unsigned int *)t60) = t63;
    t64 = *((unsigned int *)t60);
    t65 = (t64 != 0);
    if (t65 == 1)
        goto LAB56;

LAB57:
LAB58:    goto LAB47;

LAB49:    *((unsigned int *)t30) = 1;
    goto LAB51;

LAB50:    *((unsigned int *)t30) = 1;
    *((unsigned int *)t31) = 1;
    goto LAB51;

LAB52:    *((unsigned int *)t46) = 1;
    goto LAB55;

LAB54:    *((unsigned int *)t46) = 1;
    *((unsigned int *)t47) = 1;
    goto LAB55;

LAB56:    t66 = *((unsigned int *)t54);
    t67 = *((unsigned int *)t60);
    *((unsigned int *)t54) = (t66 | t67);
    t68 = (t14 + 4U);
    t69 = (t46 + 4U);
    t70 = *((unsigned int *)t14);
    t71 = (~(t70));
    t72 = *((unsigned int *)t68);
    t73 = (~(t72));
    t74 = *((unsigned int *)t46);
    t75 = (~(t74));
    t76 = *((unsigned int *)t69);
    t77 = (~(t76));
    t78 = (t71 & t73);
    t79 = (t75 & t77);
    t80 = (~(t78));
    t81 = (~(t79));
    t82 = *((unsigned int *)t60);
    *((unsigned int *)t60) = (t82 & t80);
    t83 = *((unsigned int *)t60);
    *((unsigned int *)t60) = (t83 & t81);
    t84 = *((unsigned int *)t54);
    *((unsigned int *)t54) = (t84 & t80);
    t85 = *((unsigned int *)t54);
    *((unsigned int *)t54) = (t85 & t81);
    goto LAB58;

LAB59:    xsi_set_current_line(170, ng1);
    t92 = ((char*)((ng8)));
    t93 = (t0 + 2852);
    xsi_vlogvar_generic_wait_assign_value(t93, t92, 2, 0, 0, 1, 0LL);
    goto LAB61;

LAB62:    *((unsigned int *)t13) = 1;
    goto LAB65;

LAB64:    *((unsigned int *)t13) = 1;
    *((unsigned int *)t10) = 1;
    goto LAB65;

LAB66:    t16 = (t0 + 1620U);
    t22 = *((char **)t16);
    memset(t14, 0, 8);
    t16 = (t14 + 4U);
    t26 = (t22 + 4U);
    t19 = *((unsigned int *)t26);
    t20 = (~(t19));
    t21 = *((unsigned int *)t22);
    t23 = (t21 & t20);
    t24 = (t23 & 1U);
    if (t24 != 0)
        goto LAB69;

LAB70:    if (*((unsigned int *)t26) != 0)
        goto LAB71;

LAB72:    t25 = *((unsigned int *)t13);
    t34 = *((unsigned int *)t14);
    t35 = (t25 & t34);
    *((unsigned int *)t30) = t35;
    t27 = (t13 + 4U);
    t28 = (t14 + 4U);
    t29 = (t30 + 4U);
    t36 = *((unsigned int *)t27);
    t37 = *((unsigned int *)t28);
    t38 = (t36 | t37);
    *((unsigned int *)t29) = t38;
    t39 = *((unsigned int *)t29);
    t40 = (t39 != 0);
    if (t40 == 1)
        goto LAB73;

LAB74:
LAB75:    goto LAB68;

LAB69:    *((unsigned int *)t14) = 1;
    goto LAB72;

LAB71:    *((unsigned int *)t14) = 1;
    *((unsigned int *)t16) = 1;
    goto LAB72;

LAB73:    t41 = *((unsigned int *)t30);
    t42 = *((unsigned int *)t29);
    *((unsigned int *)t30) = (t41 | t42);
    t31 = (t13 + 4U);
    t32 = (t14 + 4U);
    t43 = *((unsigned int *)t13);
    t44 = (~(t43));
    t45 = *((unsigned int *)t31);
    t49 = (~(t45));
    t50 = *((unsigned int *)t14);
    t51 = (~(t50));
    t52 = *((unsigned int *)t32);
    t53 = (~(t52));
    t78 = (t44 & t49);
    t79 = (t51 & t53);
    t55 = (~(t78));
    t56 = (~(t79));
    t57 = *((unsigned int *)t29);
    *((unsigned int *)t29) = (t57 & t55);
    t61 = *((unsigned int *)t29);
    *((unsigned int *)t29) = (t61 & t56);
    t62 = *((unsigned int *)t30);
    *((unsigned int *)t30) = (t62 & t55);
    t63 = *((unsigned int *)t30);
    *((unsigned int *)t30) = (t63 & t56);
    goto LAB75;

LAB76:    xsi_set_current_line(172, ng1);

LAB79:    xsi_set_current_line(173, ng1);
    t47 = ((char*)((ng0)));
    t48 = (t0 + 2852);
    xsi_vlogvar_generic_wait_assign_value(t48, t47, 2, 0, 0, 1, 0LL);
    xsi_set_current_line(174, ng1);
    t2 = (t0 + 1532U);
    t3 = *((char **)t2);
    t2 = (t0 + 2944);
    xsi_vlogvar_generic_wait_assign_value(t2, t3, 2, 0, 0, 64, 0LL);
    xsi_set_current_line(175, ng1);
    t2 = ((char*)((ng8)));
    t3 = (t0 + 3036);
    xsi_vlogvar_generic_wait_assign_value(t3, t2, 2, 0, 0, 1, 0LL);
    goto LAB78;

}

static void C180_5(char *t0)
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

LAB0:    t1 = (t0 + 4152U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    t2 = (t0 + 2944);
    t3 = (t2 + 32U);
    t4 = *((char **)t3);
    t5 = (t0 + 4660);
    t6 = (t5 + 32U);
    t7 = *((char **)t6);
    t8 = (t7 + 40U);
    t9 = *((char **)t8);
    xsi_vlog_bit_copy(t9, 0, t4, 0, 64);
    xsi_driver_vfirst_trans(t5, 0, 63);
    t10 = (t0 + 4500);
    *((int *)t10) = 1;

LAB1:    return;
}

static void C181_6(char *t0)
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
    unsigned int t11;
    unsigned int t12;
    char *t13;
    unsigned int t14;
    unsigned int t15;
    unsigned int t16;
    unsigned int t17;
    unsigned int t18;
    unsigned int t19;
    char *t20;

LAB0:    t1 = (t0 + 4280U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    t2 = (t0 + 3036);
    t3 = (t2 + 32U);
    t4 = *((char **)t3);
    t5 = (t0 + 4696);
    t6 = (t5 + 32U);
    t7 = *((char **)t6);
    t8 = (t7 + 40U);
    t9 = *((char **)t8);
    t10 = (t9 + 4U);
    t11 = 1U;
    t12 = t11;
    t13 = (t4 + 4U);
    t14 = *((unsigned int *)t4);
    t11 = (t11 & t14);
    t15 = *((unsigned int *)t13);
    t12 = (t12 & t15);
    t16 = *((unsigned int *)t9);
    *((unsigned int *)t9) = (t16 & 4294967294U);
    t17 = *((unsigned int *)t9);
    *((unsigned int *)t9) = (t17 | t11);
    t18 = *((unsigned int *)t10);
    *((unsigned int *)t10) = (t18 & 4294967294U);
    t19 = *((unsigned int *)t10);
    *((unsigned int *)t10) = (t19 | t12);
    xsi_driver_vfirst_trans(t5, 0, 0);
    t20 = (t0 + 4508);
    *((int *)t20) = 1;

LAB1:    return;
}


extern void work_m_00000000002343518891_1943170538_init()
{
	static char *pe[] = {(void *)C50_0,(void *)N51_1,(void *)N70_2,(void *)A80_3,(void *)A122_4,(void *)C180_5,(void *)C181_6};
	xsi_register_didat("work_m_00000000002343518891_1943170538", "isim/_tmp/work/m_00000000002343518891_1943170538.didat");
	xsi_register_executes(pe);
}
