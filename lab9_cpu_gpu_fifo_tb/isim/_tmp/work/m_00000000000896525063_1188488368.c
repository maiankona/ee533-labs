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
static const char *ng0 = "C:/Xilinx/10.1/ISE/ISEexamples/ee533-lab9/ifetch_pseduoARM.v";
static unsigned int ng1[] = {0U, 0U};
static unsigned int ng2[] = {1U, 0U};
static int ng3[] = {0, 0};
static int ng4[] = {1, 0};
static int ng5[] = {2, 0};
static int ng6[] = {3, 0};



static void A27_0(char *t0)
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

LAB0:    t1 = (t0 + 3140U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(27, ng0);
    t2 = (t0 + 4216);
    *((int *)t2) = 1;
    *((char **)t1) = &&LAB4;

LAB1:    return;
LAB4:    xsi_set_current_line(27, ng0);

LAB5:    xsi_set_current_line(28, ng0);
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

LAB7:    xsi_set_current_line(30, ng0);
    t2 = (t0 + 740U);
    t3 = *((char **)t2);
    t2 = (t3 + 4U);
    t5 = *((unsigned int *)t2);
    t6 = (~(t5));
    t7 = *((unsigned int *)t3);
    t8 = (t7 & t6);
    t9 = (t8 != 0);
    if (t9 > 0)
        goto LAB9;

LAB10:
LAB11:
LAB8:    goto LAB2;

LAB6:    xsi_set_current_line(29, ng0);
    t10 = ((char*)((ng1)));
    t11 = (t0 + 2020);
    xsi_vlogvar_generic_wait_assign_value(t11, t10, 2, 0, 0, 1, 0LL);
    goto LAB8;

LAB9:    xsi_set_current_line(31, ng0);
    t4 = ((char*)((ng2)));
    t10 = (t0 + 2020);
    xsi_vlogvar_generic_wait_assign_value(t10, t4, 2, 0, 0, 1, 0LL);
    goto LAB11;

}

static void A39_1(char *t0)
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

LAB0:    t1 = (t0 + 3268U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(39, ng0);
    t2 = (t0 + 4224);
    *((int *)t2) = 1;
    *((char **)t1) = &&LAB4;

LAB1:    return;
LAB4:    xsi_set_current_line(39, ng0);

LAB5:    xsi_set_current_line(40, ng0);
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

LAB7:    xsi_set_current_line(44, ng0);

LAB10:    xsi_set_current_line(45, ng0);
    t2 = (t0 + 1180U);
    t3 = *((char **)t2);
    t2 = (t0 + 2112);
    xsi_vlogvar_generic_wait_assign_value(t2, t3, 2, 0, 0, 1, 0LL);
    xsi_set_current_line(46, ng0);
    t2 = (t0 + 1268U);
    t3 = *((char **)t2);
    t2 = (t0 + 2204);
    xsi_vlogvar_generic_wait_assign_value(t2, t3, 2, 0, 0, 9, 0LL);
    xsi_set_current_line(47, ng0);
    t2 = (t0 + 1356U);
    t3 = *((char **)t2);
    t2 = (t0 + 2296);
    xsi_vlogvar_generic_wait_assign_value(t2, t3, 2, 0, 0, 2, 0LL);

LAB8:    goto LAB2;

LAB6:    xsi_set_current_line(40, ng0);

LAB9:    xsi_set_current_line(41, ng0);
    t10 = ((char*)((ng1)));
    t11 = (t0 + 2112);
    xsi_vlogvar_generic_wait_assign_value(t11, t10, 2, 0, 0, 1, 0LL);
    xsi_set_current_line(42, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 2204);
    xsi_vlogvar_generic_wait_assign_value(t3, t2, 2, 0, 0, 9, 0LL);
    xsi_set_current_line(43, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 2296);
    xsi_vlogvar_generic_wait_assign_value(t3, t2, 2, 0, 0, 2, 0LL);
    goto LAB8;

}

static void A54_2(char *t0)
{
    char t12[8];
    char t13[8];
    char t33[8];
    char t39[8];
    char t69[8];
    char t81[8];
    char t90[8];
    char t98[8];
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
    char *t14;
    char *t15;
    char *t16;
    char *t17;
    char *t18;
    int t19;
    char *t20;
    int t21;
    int t22;
    int t23;
    int t24;
    unsigned int t25;
    unsigned int t26;
    unsigned int t27;
    unsigned int t28;
    unsigned int t29;
    unsigned int t30;
    unsigned int t31;
    unsigned int t32;
    unsigned int t34;
    unsigned int t35;
    unsigned int t36;
    unsigned int t37;
    unsigned int t38;
    unsigned int t40;
    unsigned int t41;
    unsigned int t42;
    char *t43;
    char *t44;
    char *t45;
    unsigned int t46;
    unsigned int t47;
    unsigned int t48;
    unsigned int t49;
    unsigned int t50;
    unsigned int t51;
    unsigned int t52;
    char *t53;
    char *t54;
    unsigned int t55;
    unsigned int t56;
    unsigned int t57;
    unsigned int t58;
    unsigned int t59;
    unsigned int t60;
    unsigned int t61;
    unsigned int t62;
    unsigned int t63;
    unsigned int t64;
    unsigned int t65;
    unsigned int t66;
    unsigned int t67;
    unsigned int t68;
    char *t70;
    char *t71;
    unsigned int t72;
    unsigned int t73;
    unsigned int t74;
    unsigned int t75;
    unsigned int t76;
    char *t77;
    unsigned int t78;
    unsigned int t79;
    unsigned int t80;
    char *t82;
    char *t83;
    char *t84;
    unsigned int t85;
    unsigned int t86;
    unsigned int t87;
    unsigned int t88;
    unsigned int t89;
    char *t91;
    char *t92;
    unsigned int t93;
    unsigned int t94;
    unsigned int t95;
    unsigned int t96;
    unsigned int t97;
    unsigned int t99;
    unsigned int t100;
    unsigned int t101;
    char *t102;
    char *t103;
    char *t104;
    unsigned int t105;
    unsigned int t106;
    unsigned int t107;
    unsigned int t108;
    unsigned int t109;
    unsigned int t110;
    unsigned int t111;
    char *t112;
    char *t113;
    unsigned int t114;
    unsigned int t115;
    unsigned int t116;
    unsigned int t117;
    unsigned int t118;
    unsigned int t119;
    unsigned int t120;
    unsigned int t121;
    unsigned int t122;
    unsigned int t123;
    unsigned int t124;
    unsigned int t125;
    unsigned int t126;
    unsigned int t127;
    char *t128;
    unsigned int t129;
    unsigned int t130;
    unsigned int t131;
    unsigned int t132;
    unsigned int t133;
    char *t134;
    char *t135;

LAB0:    t1 = (t0 + 3396U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(54, ng0);
    t2 = (t0 + 4232);
    *((int *)t2) = 1;
    *((char **)t1) = &&LAB4;

LAB1:    return;
LAB4:    xsi_set_current_line(54, ng0);

LAB5:    xsi_set_current_line(55, ng0);
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

LAB7:    xsi_set_current_line(61, ng0);
    t2 = (t0 + 916U);
    t3 = *((char **)t2);
    memset(t12, 0, 8);
    t2 = (t12 + 4U);
    t4 = (t3 + 4U);
    t5 = *((unsigned int *)t4);
    t6 = (~(t5));
    t7 = *((unsigned int *)t3);
    t8 = (t7 & t6);
    t9 = (t8 & 1U);
    if (t9 != 0)
        goto LAB21;

LAB19:    if (*((unsigned int *)t4) == 0)
        goto LAB18;

LAB20:    *((unsigned int *)t12) = 1;
    *((unsigned int *)t2) = 1;

LAB21:    memset(t13, 0, 8);
    t10 = (t13 + 4U);
    t11 = (t12 + 4U);
    t25 = *((unsigned int *)t11);
    t26 = (~(t25));
    t27 = *((unsigned int *)t12);
    t28 = (t27 & t26);
    t29 = (t28 & 1U);
    if (t29 != 0)
        goto LAB22;

LAB23:    if (*((unsigned int *)t11) != 0)
        goto LAB24;

LAB25:    t14 = (t13 + 4U);
    t30 = *((unsigned int *)t13);
    t31 = *((unsigned int *)t14);
    t32 = (t30 || t31);
    if (t32 > 0)
        goto LAB26;

LAB27:    memcpy(t39, t13, 8);

LAB28:    memset(t69, 0, 8);
    t70 = (t69 + 4U);
    t71 = (t39 + 4U);
    t72 = *((unsigned int *)t71);
    t73 = (~(t72));
    t74 = *((unsigned int *)t39);
    t75 = (t74 & t73);
    t76 = (t75 & 1U);
    if (t76 != 0)
        goto LAB36;

LAB37:    if (*((unsigned int *)t71) != 0)
        goto LAB38;

LAB39:    t77 = (t69 + 4U);
    t78 = *((unsigned int *)t69);
    t79 = *((unsigned int *)t77);
    t80 = (t78 || t79);
    if (t80 > 0)
        goto LAB40;

LAB41:    memcpy(t98, t69, 8);

LAB42:    t128 = (t98 + 4U);
    t129 = *((unsigned int *)t128);
    t130 = (~(t129));
    t131 = *((unsigned int *)t98);
    t132 = (t131 & t130);
    t133 = (t132 != 0);
    if (t133 > 0)
        goto LAB54;

LAB55:
LAB56:
LAB8:    goto LAB2;

LAB6:    xsi_set_current_line(55, ng0);

LAB9:    xsi_set_current_line(56, ng0);
    t10 = ((char*)((ng1)));
    t11 = (t0 + 2480);
    xsi_vlogvar_generic_wait_assign_value(t11, t10, 2, 0, 0, 2, 0LL);
    xsi_set_current_line(57, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 2388);
    t4 = (t0 + 2388);
    t10 = (t4 + 40U);
    t11 = *((char **)t10);
    t14 = (t0 + 2388);
    t15 = (t14 + 36U);
    t16 = *((char **)t15);
    t17 = ((char*)((ng3)));
    xsi_vlog_generic_convert_array_indices(t12, t13, t11, t16, 2, 1, t17, 32, 1);
    t18 = (t12 + 4U);
    t5 = *((unsigned int *)t18);
    t19 = (!(t5));
    t20 = (t13 + 4U);
    t6 = *((unsigned int *)t20);
    t21 = (!(t6));
    t22 = (t19 && t21);
    if (t22 == 1)
        goto LAB10;

LAB11:    xsi_set_current_line(58, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 2388);
    t4 = (t0 + 2388);
    t10 = (t4 + 40U);
    t11 = *((char **)t10);
    t14 = (t0 + 2388);
    t15 = (t14 + 36U);
    t16 = *((char **)t15);
    t17 = ((char*)((ng4)));
    xsi_vlog_generic_convert_array_indices(t12, t13, t11, t16, 2, 1, t17, 32, 1);
    t18 = (t12 + 4U);
    t5 = *((unsigned int *)t18);
    t19 = (!(t5));
    t20 = (t13 + 4U);
    t6 = *((unsigned int *)t20);
    t21 = (!(t6));
    t22 = (t19 && t21);
    if (t22 == 1)
        goto LAB12;

LAB13:    xsi_set_current_line(59, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 2388);
    t4 = (t0 + 2388);
    t10 = (t4 + 40U);
    t11 = *((char **)t10);
    t14 = (t0 + 2388);
    t15 = (t14 + 36U);
    t16 = *((char **)t15);
    t17 = ((char*)((ng5)));
    xsi_vlog_generic_convert_array_indices(t12, t13, t11, t16, 2, 1, t17, 32, 1);
    t18 = (t12 + 4U);
    t5 = *((unsigned int *)t18);
    t19 = (!(t5));
    t20 = (t13 + 4U);
    t6 = *((unsigned int *)t20);
    t21 = (!(t6));
    t22 = (t19 && t21);
    if (t22 == 1)
        goto LAB14;

LAB15:    xsi_set_current_line(60, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 2388);
    t4 = (t0 + 2388);
    t10 = (t4 + 40U);
    t11 = *((char **)t10);
    t14 = (t0 + 2388);
    t15 = (t14 + 36U);
    t16 = *((char **)t15);
    t17 = ((char*)((ng6)));
    xsi_vlog_generic_convert_array_indices(t12, t13, t11, t16, 2, 1, t17, 32, 1);
    t18 = (t12 + 4U);
    t5 = *((unsigned int *)t18);
    t19 = (!(t5));
    t20 = (t13 + 4U);
    t6 = *((unsigned int *)t20);
    t21 = (!(t6));
    t22 = (t19 && t21);
    if (t22 == 1)
        goto LAB16;

LAB17:    goto LAB8;

LAB10:    t7 = *((unsigned int *)t12);
    t8 = *((unsigned int *)t13);
    t23 = (t7 - t8);
    t24 = (t23 + 1);
    xsi_vlogvar_generic_wait_assign_value(t3, t2, 2, 0, *((unsigned int *)t13), t24, 0LL);
    goto LAB11;

LAB12:    t7 = *((unsigned int *)t12);
    t8 = *((unsigned int *)t13);
    t23 = (t7 - t8);
    t24 = (t23 + 1);
    xsi_vlogvar_generic_wait_assign_value(t3, t2, 2, 0, *((unsigned int *)t13), t24, 0LL);
    goto LAB13;

LAB14:    t7 = *((unsigned int *)t12);
    t8 = *((unsigned int *)t13);
    t23 = (t7 - t8);
    t24 = (t23 + 1);
    xsi_vlogvar_generic_wait_assign_value(t3, t2, 2, 0, *((unsigned int *)t13), t24, 0LL);
    goto LAB15;

LAB16:    t7 = *((unsigned int *)t12);
    t8 = *((unsigned int *)t13);
    t23 = (t7 - t8);
    t24 = (t23 + 1);
    xsi_vlogvar_generic_wait_assign_value(t3, t2, 2, 0, *((unsigned int *)t13), t24, 0LL);
    goto LAB17;

LAB18:    *((unsigned int *)t12) = 1;
    goto LAB21;

LAB22:    *((unsigned int *)t13) = 1;
    goto LAB25;

LAB24:    *((unsigned int *)t13) = 1;
    *((unsigned int *)t10) = 1;
    goto LAB25;

LAB26:    t15 = (t0 + 2020);
    t16 = (t15 + 32U);
    t17 = *((char **)t16);
    memset(t33, 0, 8);
    t18 = (t33 + 4U);
    t20 = (t17 + 4U);
    t34 = *((unsigned int *)t20);
    t35 = (~(t34));
    t36 = *((unsigned int *)t17);
    t37 = (t36 & t35);
    t38 = (t37 & 1U);
    if (t38 != 0)
        goto LAB29;

LAB30:    if (*((unsigned int *)t20) != 0)
        goto LAB31;

LAB32:    t40 = *((unsigned int *)t13);
    t41 = *((unsigned int *)t33);
    t42 = (t40 & t41);
    *((unsigned int *)t39) = t42;
    t43 = (t13 + 4U);
    t44 = (t33 + 4U);
    t45 = (t39 + 4U);
    t46 = *((unsigned int *)t43);
    t47 = *((unsigned int *)t44);
    t48 = (t46 | t47);
    *((unsigned int *)t45) = t48;
    t49 = *((unsigned int *)t45);
    t50 = (t49 != 0);
    if (t50 == 1)
        goto LAB33;

LAB34:
LAB35:    goto LAB28;

LAB29:    *((unsigned int *)t33) = 1;
    goto LAB32;

LAB31:    *((unsigned int *)t33) = 1;
    *((unsigned int *)t18) = 1;
    goto LAB32;

LAB33:    t51 = *((unsigned int *)t39);
    t52 = *((unsigned int *)t45);
    *((unsigned int *)t39) = (t51 | t52);
    t53 = (t13 + 4U);
    t54 = (t33 + 4U);
    t55 = *((unsigned int *)t13);
    t56 = (~(t55));
    t57 = *((unsigned int *)t53);
    t58 = (~(t57));
    t59 = *((unsigned int *)t33);
    t60 = (~(t59));
    t61 = *((unsigned int *)t54);
    t62 = (~(t61));
    t19 = (t56 & t58);
    t21 = (t60 & t62);
    t63 = (~(t19));
    t64 = (~(t21));
    t65 = *((unsigned int *)t45);
    *((unsigned int *)t45) = (t65 & t63);
    t66 = *((unsigned int *)t45);
    *((unsigned int *)t45) = (t66 & t64);
    t67 = *((unsigned int *)t39);
    *((unsigned int *)t39) = (t67 & t63);
    t68 = *((unsigned int *)t39);
    *((unsigned int *)t39) = (t68 & t64);
    goto LAB35;

LAB36:    *((unsigned int *)t69) = 1;
    goto LAB39;

LAB38:    *((unsigned int *)t69) = 1;
    *((unsigned int *)t70) = 1;
    goto LAB39;

LAB40:    t82 = (t0 + 828U);
    t83 = *((char **)t82);
    memset(t81, 0, 8);
    t82 = (t81 + 4U);
    t84 = (t83 + 4U);
    t85 = *((unsigned int *)t84);
    t86 = (~(t85));
    t87 = *((unsigned int *)t83);
    t88 = (t87 & t86);
    t89 = (t88 & 1U);
    if (t89 != 0)
        goto LAB46;

LAB44:    if (*((unsigned int *)t84) == 0)
        goto LAB43;

LAB45:    *((unsigned int *)t81) = 1;
    *((unsigned int *)t82) = 1;

LAB46:    memset(t90, 0, 8);
    t91 = (t90 + 4U);
    t92 = (t81 + 4U);
    t93 = *((unsigned int *)t92);
    t94 = (~(t93));
    t95 = *((unsigned int *)t81);
    t96 = (t95 & t94);
    t97 = (t96 & 1U);
    if (t97 != 0)
        goto LAB47;

LAB48:    if (*((unsigned int *)t92) != 0)
        goto LAB49;

LAB50:    t99 = *((unsigned int *)t69);
    t100 = *((unsigned int *)t90);
    t101 = (t99 & t100);
    *((unsigned int *)t98) = t101;
    t102 = (t69 + 4U);
    t103 = (t90 + 4U);
    t104 = (t98 + 4U);
    t105 = *((unsigned int *)t102);
    t106 = *((unsigned int *)t103);
    t107 = (t105 | t106);
    *((unsigned int *)t104) = t107;
    t108 = *((unsigned int *)t104);
    t109 = (t108 != 0);
    if (t109 == 1)
        goto LAB51;

LAB52:
LAB53:    goto LAB42;

LAB43:    *((unsigned int *)t81) = 1;
    goto LAB46;

LAB47:    *((unsigned int *)t90) = 1;
    goto LAB50;

LAB49:    *((unsigned int *)t90) = 1;
    *((unsigned int *)t91) = 1;
    goto LAB50;

LAB51:    t110 = *((unsigned int *)t98);
    t111 = *((unsigned int *)t104);
    *((unsigned int *)t98) = (t110 | t111);
    t112 = (t69 + 4U);
    t113 = (t90 + 4U);
    t114 = *((unsigned int *)t69);
    t115 = (~(t114));
    t116 = *((unsigned int *)t112);
    t117 = (~(t116));
    t118 = *((unsigned int *)t90);
    t119 = (~(t118));
    t120 = *((unsigned int *)t113);
    t121 = (~(t120));
    t22 = (t115 & t117);
    t23 = (t119 & t121);
    t122 = (~(t22));
    t123 = (~(t23));
    t124 = *((unsigned int *)t104);
    *((unsigned int *)t104) = (t124 & t122);
    t125 = *((unsigned int *)t104);
    *((unsigned int *)t104) = (t125 & t123);
    t126 = *((unsigned int *)t98);
    *((unsigned int *)t98) = (t126 & t122);
    t127 = *((unsigned int *)t98);
    *((unsigned int *)t98) = (t127 & t123);
    goto LAB53;

LAB54:    xsi_set_current_line(61, ng0);

LAB57:    xsi_set_current_line(63, ng0);
    t134 = ((char*)((ng1)));
    t135 = (t0 + 2480);
    xsi_vlogvar_generic_wait_assign_value(t135, t134, 2, 0, 0, 2, 0LL);
    xsi_set_current_line(65, ng0);
    t2 = (t0 + 2388);
    t3 = (t2 + 32U);
    t4 = *((char **)t3);
    t10 = (t0 + 2388);
    t11 = (t10 + 40U);
    t14 = *((char **)t11);
    t15 = (t0 + 2388);
    t16 = (t15 + 36U);
    t17 = *((char **)t16);
    t18 = (t0 + 2480);
    t20 = (t18 + 32U);
    t43 = *((char **)t20);
    xsi_vlog_generic_get_array_select_value(t12, 32, t4, t14, t17, 2, 1, t43, 2, 2);
    t44 = ((char*)((ng4)));
    memset(t13, 0, 8);
    xsi_vlog_unsigned_add(t13, 32, t12, 32, t44, 32);
    t45 = (t0 + 2388);
    t53 = (t0 + 2388);
    t54 = (t53 + 40U);
    t70 = *((char **)t54);
    t71 = (t0 + 2388);
    t77 = (t71 + 36U);
    t82 = *((char **)t77);
    t83 = (t0 + 2480);
    t84 = (t83 + 32U);
    t91 = *((char **)t84);
    xsi_vlog_generic_convert_array_indices(t33, t39, t70, t82, 2, 1, t91, 2, 2);
    t92 = (t33 + 4U);
    t5 = *((unsigned int *)t92);
    t19 = (!(t5));
    t102 = (t39 + 4U);
    t6 = *((unsigned int *)t102);
    t21 = (!(t6));
    t22 = (t19 && t21);
    if (t22 == 1)
        goto LAB58;

LAB59:    xsi_set_current_line(68, ng0);
    t2 = (t0 + 2112);
    t3 = (t2 + 32U);
    t4 = *((char **)t3);
    t10 = (t4 + 4U);
    t5 = *((unsigned int *)t10);
    t6 = (~(t5));
    t7 = *((unsigned int *)t4);
    t8 = (t7 & t6);
    t9 = (t8 != 0);
    if (t9 > 0)
        goto LAB60;

LAB61:
LAB62:    goto LAB56;

LAB58:    t7 = *((unsigned int *)t33);
    t8 = *((unsigned int *)t39);
    t23 = (t7 - t8);
    t24 = (t23 + 1);
    xsi_vlogvar_generic_wait_assign_value(t45, t13, 2, 0, *((unsigned int *)t39), t24, 0LL);
    goto LAB59;

LAB60:    xsi_set_current_line(68, ng0);

LAB63:    xsi_set_current_line(69, ng0);
    t11 = (t0 + 2204);
    t14 = (t11 + 32U);
    t15 = *((char **)t14);
    t16 = (t0 + 2388);
    t17 = (t0 + 2388);
    t18 = (t17 + 40U);
    t20 = *((char **)t18);
    t43 = (t0 + 2388);
    t44 = (t43 + 36U);
    t45 = *((char **)t44);
    t53 = (t0 + 2296);
    t54 = (t53 + 32U);
    t70 = *((char **)t54);
    xsi_vlog_generic_convert_array_indices(t12, t13, t20, t45, 2, 1, t70, 2, 2);
    t71 = (t12 + 4U);
    t25 = *((unsigned int *)t71);
    t19 = (!(t25));
    t77 = (t13 + 4U);
    t26 = *((unsigned int *)t77);
    t21 = (!(t26));
    t22 = (t19 && t21);
    if (t22 == 1)
        goto LAB64;

LAB65:    goto LAB62;

LAB64:    t27 = *((unsigned int *)t12);
    t28 = *((unsigned int *)t13);
    t23 = (t27 - t28);
    t24 = (t23 + 1);
    xsi_vlogvar_generic_wait_assign_value(t16, t15, 2, 0, *((unsigned int *)t13), t24, 0LL);
    goto LAB65;

}

static void N75_3(char *t0)
{
    char t3[8];
    char t4[8];
    char t24[8];
    char *t1;
    char *t2;
    char *t5;
    char *t6;
    unsigned int t7;
    unsigned int t8;
    unsigned int t9;
    unsigned int t10;
    unsigned int t11;
    char *t12;
    unsigned int t13;
    unsigned int t14;
    unsigned int t15;
    char *t16;
    char *t17;
    unsigned int t18;
    unsigned int t19;
    unsigned int t20;
    unsigned int t21;
    char *t22;
    char *t23;
    char *t25;
    char *t26;
    char *t27;
    char *t28;
    char *t29;
    char *t30;
    char *t31;
    char *t32;
    char *t33;
    char *t34;
    char *t35;
    char *t36;
    char *t37;
    char *t38;
    char *t39;
    unsigned int t40;
    unsigned int t41;
    char *t42;
    unsigned int t43;
    unsigned int t44;
    unsigned int t45;
    unsigned int t46;
    unsigned int t47;
    unsigned int t48;
    char *t49;

LAB0:    t1 = (t0 + 3524U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    t2 = (t0 + 916U);
    t5 = *((char **)t2);
    memset(t4, 0, 8);
    t2 = (t4 + 4U);
    t6 = (t5 + 4U);
    t7 = *((unsigned int *)t6);
    t8 = (~(t7));
    t9 = *((unsigned int *)t5);
    t10 = (t9 & t8);
    t11 = (t10 & 1U);
    if (t11 != 0)
        goto LAB4;

LAB5:    if (*((unsigned int *)t6) != 0)
        goto LAB6;

LAB7:    t12 = (t4 + 4U);
    t13 = *((unsigned int *)t4);
    t14 = *((unsigned int *)t12);
    t15 = (t13 || t14);
    if (t15 > 0)
        goto LAB8;

LAB9:    t18 = *((unsigned int *)t4);
    t19 = (~(t18));
    t20 = *((unsigned int *)t12);
    t21 = (t19 || t20);
    if (t21 > 0)
        goto LAB10;

LAB11:    if (*((unsigned int *)t12) > 0)
        goto LAB12;

LAB13:    if (*((unsigned int *)t4) > 0)
        goto LAB14;

LAB15:    memcpy(t3, t24, 8);

LAB16:    t34 = (t0 + 4316);
    t35 = (t34 + 32U);
    t36 = *((char **)t35);
    t37 = (t36 + 40U);
    t38 = *((char **)t37);
    t39 = (t38 + 4U);
    t40 = 511U;
    t41 = t40;
    t42 = (t3 + 4U);
    t43 = *((unsigned int *)t3);
    t40 = (t40 & t43);
    t44 = *((unsigned int *)t42);
    t41 = (t41 & t44);
    t45 = *((unsigned int *)t38);
    *((unsigned int *)t38) = (t45 & 4294966784U);
    t46 = *((unsigned int *)t38);
    *((unsigned int *)t38) = (t46 | t40);
    t47 = *((unsigned int *)t39);
    *((unsigned int *)t39) = (t47 & 4294966784U);
    t48 = *((unsigned int *)t39);
    *((unsigned int *)t39) = (t48 | t41);
    xsi_driver_vfirst_trans(t34, 0, 8U);
    t49 = (t0 + 4240);
    *((int *)t49) = 1;

LAB1:    return;
LAB4:    *((unsigned int *)t4) = 1;
    goto LAB7;

LAB6:    *((unsigned int *)t4) = 1;
    *((unsigned int *)t2) = 1;
    goto LAB7;

LAB8:    t16 = (t0 + 1004U);
    t17 = *((char **)t16);
    goto LAB9;

LAB10:    t16 = (t0 + 2388);
    t22 = (t16 + 32U);
    t23 = *((char **)t22);
    t25 = (t0 + 2388);
    t26 = (t25 + 40U);
    t27 = *((char **)t26);
    t28 = (t0 + 2388);
    t29 = (t28 + 36U);
    t30 = *((char **)t29);
    t31 = (t0 + 2480);
    t32 = (t31 + 32U);
    t33 = *((char **)t32);
    xsi_vlog_generic_get_array_select_value(t24, 9, t23, t27, t30, 2, 1, t33, 2, 2);
    goto LAB11;

LAB12:    xsi_vlog_unsigned_bit_combine(t3, 9, t17, 9, t24, 9);
    goto LAB16;

LAB14:    memcpy(t3, t17, 8);
    goto LAB16;

}

static void A90_4(char *t0)
{
    char t13[8];
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
    char *t14;
    char *t15;
    char *t16;
    char *t17;
    char *t18;
    char *t19;
    char *t20;

LAB0:    t1 = (t0 + 3652U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(90, ng0);
    t2 = (t0 + 4248);
    *((int *)t2) = 1;
    *((char **)t1) = &&LAB4;

LAB1:    return;
LAB4:    xsi_set_current_line(90, ng0);

LAB5:    xsi_set_current_line(91, ng0);
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

LAB7:    xsi_set_current_line(94, ng0);
    t2 = (t0 + 828U);
    t3 = *((char **)t2);
    t2 = (t3 + 4U);
    t5 = *((unsigned int *)t2);
    t6 = (~(t5));
    t7 = *((unsigned int *)t3);
    t8 = (t7 & t6);
    t9 = (t8 != 0);
    if (t9 > 0)
        goto LAB10;

LAB11:    xsi_set_current_line(97, ng0);

LAB14:    xsi_set_current_line(98, ng0);
    t2 = (t0 + 2480);
    t3 = (t2 + 32U);
    t4 = *((char **)t3);
    t10 = (t0 + 2572);
    xsi_vlogvar_generic_wait_assign_value(t10, t4, 2, 0, 0, 2, 0LL);
    xsi_set_current_line(99, ng0);
    t2 = (t0 + 2388);
    t3 = (t2 + 32U);
    t4 = *((char **)t3);
    t10 = (t0 + 2388);
    t11 = (t10 + 40U);
    t12 = *((char **)t11);
    t14 = (t0 + 2388);
    t15 = (t14 + 36U);
    t16 = *((char **)t15);
    t17 = (t0 + 2480);
    t18 = (t17 + 32U);
    t19 = *((char **)t18);
    xsi_vlog_generic_get_array_select_value(t13, 9, t4, t12, t16, 2, 1, t19, 2, 2);
    t20 = (t0 + 2664);
    xsi_vlogvar_generic_wait_assign_value(t20, t13, 2, 0, 0, 9, 0LL);

LAB12:
LAB8:    goto LAB2;

LAB6:    xsi_set_current_line(91, ng0);

LAB9:    xsi_set_current_line(92, ng0);
    t10 = ((char*)((ng1)));
    t11 = (t0 + 2572);
    xsi_vlogvar_generic_wait_assign_value(t11, t10, 2, 0, 0, 2, 0LL);
    xsi_set_current_line(93, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 2664);
    xsi_vlogvar_generic_wait_assign_value(t3, t2, 2, 0, 0, 9, 0LL);
    goto LAB8;

LAB10:    xsi_set_current_line(94, ng0);

LAB13:    xsi_set_current_line(95, ng0);
    t4 = (t0 + 2572);
    t10 = (t4 + 32U);
    t11 = *((char **)t10);
    t12 = (t0 + 2572);
    xsi_vlogvar_generic_wait_assign_value(t12, t11, 2, 0, 0, 2, 0LL);
    xsi_set_current_line(96, ng0);
    t2 = (t0 + 2664);
    t3 = (t2 + 32U);
    t4 = *((char **)t3);
    t10 = (t0 + 2664);
    xsi_vlogvar_generic_wait_assign_value(t10, t4, 2, 0, 0, 9, 0LL);
    goto LAB12;

}

static void C103_5(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;
    char *t8;

LAB0:    t1 = (t0 + 3780U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    t2 = (t0 + 1796U);
    t3 = *((char **)t2);
    t2 = (t0 + 4352);
    t4 = (t2 + 32U);
    t5 = *((char **)t4);
    t6 = (t5 + 40U);
    t7 = *((char **)t6);
    memcpy(t7, t3, 8);
    xsi_driver_vfirst_trans(t2, 0, 31);
    t8 = (t0 + 4256);
    *((int *)t8) = 1;

LAB1:    return;
}

static void C104_6(char *t0)
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

LAB0:    t1 = (t0 + 3908U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    t2 = (t0 + 2664);
    t3 = (t2 + 32U);
    t4 = *((char **)t3);
    t5 = (t0 + 4388);
    t6 = (t5 + 32U);
    t7 = *((char **)t6);
    t8 = (t7 + 40U);
    t9 = *((char **)t8);
    t10 = (t9 + 4U);
    t11 = 511U;
    t12 = t11;
    t13 = (t4 + 4U);
    t14 = *((unsigned int *)t4);
    t11 = (t11 & t14);
    t15 = *((unsigned int *)t13);
    t12 = (t12 & t15);
    t16 = *((unsigned int *)t9);
    *((unsigned int *)t9) = (t16 & 4294966784U);
    t17 = *((unsigned int *)t9);
    *((unsigned int *)t9) = (t17 | t11);
    t18 = *((unsigned int *)t10);
    *((unsigned int *)t10) = (t18 & 4294966784U);
    t19 = *((unsigned int *)t10);
    *((unsigned int *)t10) = (t19 | t12);
    xsi_driver_vfirst_trans(t5, 0, 8);
    t20 = (t0 + 4264);
    *((int *)t20) = 1;

LAB1:    return;
}

static void C105_7(char *t0)
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

LAB0:    t1 = (t0 + 4036U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    t2 = (t0 + 2572);
    t3 = (t2 + 32U);
    t4 = *((char **)t3);
    t5 = (t0 + 4424);
    t6 = (t5 + 32U);
    t7 = *((char **)t6);
    t8 = (t7 + 40U);
    t9 = *((char **)t8);
    t10 = (t9 + 4U);
    t11 = 3U;
    t12 = t11;
    t13 = (t4 + 4U);
    t14 = *((unsigned int *)t4);
    t11 = (t11 & t14);
    t15 = *((unsigned int *)t13);
    t12 = (t12 & t15);
    t16 = *((unsigned int *)t9);
    *((unsigned int *)t9) = (t16 & 4294967292U);
    t17 = *((unsigned int *)t9);
    *((unsigned int *)t9) = (t17 | t11);
    t18 = *((unsigned int *)t10);
    *((unsigned int *)t10) = (t18 & 4294967292U);
    t19 = *((unsigned int *)t10);
    *((unsigned int *)t10) = (t19 | t12);
    xsi_driver_vfirst_trans(t5, 0, 1);
    t20 = (t0 + 4272);
    *((int *)t20) = 1;

LAB1:    return;
}


extern void work_m_00000000000896525063_1188488368_init()
{
	static char *pe[] = {(void *)A27_0,(void *)A39_1,(void *)A54_2,(void *)N75_3,(void *)A90_4,(void *)C103_5,(void *)C104_6,(void *)C105_7};
	xsi_register_didat("work_m_00000000000896525063_1188488368", "isim/_tmp/work/m_00000000000896525063_1188488368.didat");
	xsi_register_executes(pe);
}
