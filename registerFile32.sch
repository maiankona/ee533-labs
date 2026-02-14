VERSION 6
BEGIN SCHEMATIC
    BEGIN ATTR DeviceFamilyName "virtex2p"
        DELETE all:0
        EDITNAME all:0
        EDITTRAIT all:0
    END ATTR
    BEGIN NETLIST
        SIGNAL r0data(31:0)
        SIGNAL r1data(31:0)
        SIGNAL waddr(1:0)
        SIGNAL wdata(31:0)
        SIGNAL waddr(1)
        SIGNAL waddr(0)
        SIGNAL clk
        SIGNAL FDOutput0(31:0)
        SIGNAL FDOut1(31:0)
        SIGNAL FDOut2(31:0)
        SIGNAL FDOut3(31:0)
        SIGNAL clr
        SIGNAL XLXN_46
        SIGNAL XLXN_50
        SIGNAL XLXN_51
        SIGNAL XLXN_52
        SIGNAL XLXN_57
        SIGNAL XLXN_58
        SIGNAL XLXN_59
        SIGNAL XLXN_60
        SIGNAL wena
        SIGNAL r1addr(1:0)
        SIGNAL XLXN_69(1:0)
        SIGNAL XLXN_70
        SIGNAL r0addr(1:0)
        SIGNAL XLXN_72(1:0)
        SIGNAL XLXN_73
        PORT Output r0data(31:0)
        PORT Output r1data(31:0)
        PORT Input waddr(1:0)
        PORT Input wdata(31:0)
        PORT Input clk
        PORT Input clr
        PORT Input wena
        PORT Input r1addr(1:0)
        PORT Input r0addr(1:0)
        BEGIN BLOCKDEF FD32
            TIMESTAMP 2026 2 12 23 17 38
            RECTANGLE N 64 -256 320 0 
            LINE N 64 -224 0 -224 
            LINE N 64 -160 0 -160 
            RECTANGLE N 0 -108 64 -84 
            LINE N 64 -96 0 -96 
            LINE N 64 -32 0 -32 
            RECTANGLE N 320 -236 384 -212 
            LINE N 320 -224 384 -224 
        END BLOCKDEF
        BEGIN BLOCKDEF mux4_32
            TIMESTAMP 2026 2 12 23 40 6
            RECTANGLE N 64 -320 320 0 
            RECTANGLE N 0 -300 64 -276 
            LINE N 64 -288 0 -288 
            RECTANGLE N 0 -236 64 -212 
            LINE N 64 -224 0 -224 
            RECTANGLE N 0 -172 64 -148 
            LINE N 64 -160 0 -160 
            RECTANGLE N 0 -108 64 -84 
            LINE N 64 -96 0 -96 
            RECTANGLE N 0 -44 64 -20 
            LINE N 64 -32 0 -32 
            RECTANGLE N 320 -300 384 -276 
            LINE N 320 -288 384 -288 
        END BLOCKDEF
        BEGIN BLOCKDEF and2
            TIMESTAMP 2000 1 1 10 10 10
            LINE N 0 -64 64 -64 
            LINE N 0 -128 64 -128 
            LINE N 256 -96 192 -96 
            ARC N 96 -144 192 -48 144 -48 144 -144 
            LINE N 144 -48 64 -48 
            LINE N 64 -144 144 -144 
            LINE N 64 -48 64 -144 
        END BLOCKDEF
        BEGIN BLOCKDEF d2_4e
            TIMESTAMP 2000 1 1 10 10 10
            RECTANGLE N 64 -384 320 -64 
            LINE N 0 -128 64 -128 
            LINE N 0 -256 64 -256 
            LINE N 0 -320 64 -320 
            LINE N 384 -128 320 -128 
            LINE N 384 -192 320 -192 
            LINE N 384 -256 320 -256 
            LINE N 384 -320 320 -320 
        END BLOCKDEF
        BEGIN BLOCKDEF fd
            TIMESTAMP 2000 1 1 10 10 10
            RECTANGLE N 64 -320 320 -64 
            LINE N 0 -128 64 -128 
            LINE N 0 -256 64 -256 
            LINE N 384 -256 320 -256 
            LINE N 80 -128 64 -144 
            LINE N 64 -112 80 -128 
        END BLOCKDEF
        BEGIN BLOCK XLXI_2 FD32
            PIN clk clk
            PIN clr clr
            PIN D(31:0) wdata(31:0)
            PIN ce XLXN_51
            PIN Q(31:0) FDOutput0(31:0)
        END BLOCK
        BEGIN BLOCK XLXI_3 FD32
            PIN clk clk
            PIN clr clr
            PIN D(31:0) wdata(31:0)
            PIN ce XLXN_46
            PIN Q(31:0) FDOut1(31:0)
        END BLOCK
        BEGIN BLOCK XLXI_4 FD32
            PIN clk clk
            PIN clr clr
            PIN D(31:0) wdata(31:0)
            PIN ce XLXN_50
            PIN Q(31:0) FDOut2(31:0)
        END BLOCK
        BEGIN BLOCK XLXI_5 FD32
            PIN clk clk
            PIN clr clr
            PIN D(31:0) wdata(31:0)
            PIN ce XLXN_52
            PIN Q(31:0) FDOut3(31:0)
        END BLOCK
        BEGIN BLOCK XLXI_12 mux4_32
            PIN R0(31:0) FDOutput0(31:0)
            PIN R1(31:0) FDOut1(31:0)
            PIN R2(31:0) FDOut2(31:0)
            PIN R3(31:0) FDOut3(31:0)
            PIN sel(1:0) XLXN_72(1:0)
            PIN Y(31:0) r0data(31:0)
        END BLOCK
        BEGIN BLOCK XLXI_13 mux4_32
            PIN R0(31:0) FDOutput0(31:0)
            PIN R1(31:0) FDOut1(31:0)
            PIN R2(31:0) FDOut2(31:0)
            PIN R3(31:0) FDOut3(31:0)
            PIN sel(1:0) XLXN_69(1:0)
            PIN Y(31:0) r1data(31:0)
        END BLOCK
        BEGIN BLOCK XLXI_31 and2
            PIN I0 XLXN_57
            PIN I1 wena
            PIN O XLXN_52
        END BLOCK
        BEGIN BLOCK XLXI_32 and2
            PIN I0 XLXN_58
            PIN I1 wena
            PIN O XLXN_50
        END BLOCK
        BEGIN BLOCK XLXI_34 and2
            PIN I0 XLXN_59
            PIN I1 wena
            PIN O XLXN_46
        END BLOCK
        BEGIN BLOCK XLXI_35 and2
            PIN I0 XLXN_60
            PIN I1 wena
            PIN O XLXN_51
        END BLOCK
        BEGIN BLOCK XLXI_37 d2_4e
            PIN A0 waddr(0)
            PIN A1 waddr(1)
            PIN E wena
            PIN D0 XLXN_60
            PIN D1 XLXN_59
            PIN D2 XLXN_58
            PIN D3 XLXN_57
        END BLOCK
        BEGIN BLOCK XLXI_38 fd
            PIN C clk
            PIN D r0addr(1:0)
            PIN Q XLXN_72(1:0)
        END BLOCK
        BEGIN BLOCK XLXI_39 fd
            PIN C clk
            PIN D r1addr(1:0)
            PIN Q XLXN_69(1:0)
        END BLOCK
    END NETLIST
    BEGIN SHEET 1 5440 3520
        BEGIN BRANCH r0data(31:0)
            WIRE 3968 1184 4656 1184
            WIRE 4656 1184 4656 1424
            WIRE 4656 1424 4816 1424
        END BRANCH
        BEGIN BRANCH r1data(31:0)
            WIRE 3968 2080 4656 2080
            WIRE 4656 1904 4816 1904
            WIRE 4656 1904 4656 2080
        END BRANCH
        IOMARKER 4816 1424 r0data(31:0) R0 28
        IOMARKER 4816 1904 r1data(31:0) R0 28
        BEGIN BRANCH waddr(1:0)
            WIRE 624 1632 672 1632
            WIRE 672 1632 704 1632
            WIRE 704 1632 736 1632
            WIRE 736 1632 784 1632
        END BRANCH
        BEGIN BRANCH wdata(31:0)
            WIRE 624 2352 2144 2352
            WIRE 2144 2352 2144 2896
            WIRE 2144 2896 2256 2896
            WIRE 2112 784 2112 1456
            WIRE 2112 1456 2128 1456
            WIRE 2128 1456 2128 2128
            WIRE 2128 2128 2144 2128
            WIRE 2144 2128 2256 2128
            WIRE 2144 2128 2144 2352
            WIRE 2128 1456 2272 1456
            WIRE 2112 784 2272 784
        END BRANCH
        IOMARKER 624 1632 waddr(1:0) R180 28
        IOMARKER 624 1872 r0addr(1:0) R180 28
        IOMARKER 624 2112 r1addr(1:0) R180 28
        IOMARKER 624 2352 wdata(31:0) R180 28
        BEGIN INSTANCE XLXI_2 2272 880 R0
        END INSTANCE
        BEGIN INSTANCE XLXI_3 2272 1552 R0
        END INSTANCE
        BEGIN INSTANCE XLXI_4 2256 2224 R0
        END INSTANCE
        BEGIN INSTANCE XLXI_5 2256 2992 R0
        END INSTANCE
        BUSTAP 672 1632 672 1728
        BEGIN BRANCH waddr(1)
            WIRE 672 1728 672 1744
            WIRE 672 1744 672 1776
            WIRE 672 1776 704 1776
            WIRE 704 1616 704 1776
            WIRE 704 1616 1248 1616
            BEGIN DISPLAY 672 1752 ATTR Name
                ALIGNMENT SOFT-TVCENTER
            END DISPLAY
        END BRANCH
        BUSTAP 736 1632 736 1728
        BEGIN BRANCH waddr(0)
            WIRE 736 1728 736 1744
            WIRE 736 1744 736 1776
            WIRE 736 1776 960 1776
            WIRE 960 1552 1248 1552
            WIRE 960 1552 960 1776
            BEGIN DISPLAY 736 1752 ATTR Name
                ALIGNMENT SOFT-TVCENTER
            END DISPLAY
        END BRANCH
        IOMARKER 544 2576 clk R180 28
        BEGIN BRANCH FDOutput0(31:0)
            WIRE 2656 656 3120 656
            WIRE 3120 656 3120 1184
            WIRE 3120 1184 3584 1184
            WIRE 3072 1184 3120 1184
            WIRE 3072 1184 3072 2080
            WIRE 3072 2080 3584 2080
        END BRANCH
        BEGIN BRANCH FDOut1(31:0)
            WIRE 2656 1328 3056 1328
            WIRE 3056 1328 3120 1328
            WIRE 3056 1328 3056 2144
            WIRE 3056 2144 3584 2144
            WIRE 3120 1248 3120 1328
            WIRE 3120 1248 3584 1248
        END BRANCH
        BEGIN BRANCH FDOut2(31:0)
            WIRE 2640 2000 3104 2000
            WIRE 3104 2000 3136 2000
            WIRE 3104 2000 3104 2208
            WIRE 3104 2208 3584 2208
            WIRE 3136 1312 3136 2000
            WIRE 3136 1312 3584 1312
        END BRANCH
        BEGIN BRANCH FDOut3(31:0)
            WIRE 2640 2768 3152 2768
            WIRE 3152 2768 3360 2768
            WIRE 3152 1376 3152 2768
            WIRE 3152 1376 3584 1376
            WIRE 3360 2272 3360 2768
            WIRE 3360 2272 3584 2272
        END BRANCH
        BEGIN BRANCH clr
            WIRE 592 1184 2208 1184
            WIRE 2208 1184 2256 1184
            WIRE 2256 1184 2256 1392
            WIRE 2256 1392 2272 1392
            WIRE 2208 720 2208 1184
            WIRE 2208 720 2272 720
            WIRE 2240 1392 2256 1392
            WIRE 2240 1392 2240 2064
            WIRE 2240 2064 2256 2064
            WIRE 2240 2064 2240 2832
            WIRE 2240 2832 2256 2832
        END BRANCH
        IOMARKER 592 1184 clr R180 28
        BEGIN INSTANCE XLXI_12 3584 1472 R0
        END INSTANCE
        BEGIN INSTANCE XLXI_13 3584 2368 R0
        END INSTANCE
        BEGIN BRANCH XLXN_46
            WIRE 2016 1424 2032 1424
            WIRE 2032 1424 2032 1632
            WIRE 2032 1632 2400 1632
            WIRE 2400 1632 2464 1632
            WIRE 2256 1520 2272 1520
            WIRE 2256 1520 2256 1568
            WIRE 2256 1568 2464 1568
            WIRE 2464 1568 2464 1632
        END BRANCH
        BEGIN BRANCH clk
            WIRE 544 2576 704 2576
            WIRE 704 2576 704 2768
            WIRE 704 2768 1088 2768
            WIRE 1088 2768 2080 2768
            WIRE 2080 2768 2256 2768
            WIRE 1024 2080 1072 2080
            WIRE 1024 2080 1024 2592
            WIRE 1024 2592 1088 2592
            WIRE 1024 2592 1024 2720
            WIRE 1024 2720 1088 2720
            WIRE 1088 2720 1088 2768
            WIRE 2080 656 2272 656
            WIRE 2080 656 2080 1328
            WIRE 2080 1328 2272 1328
            WIRE 2080 1328 2080 2000
            WIRE 2080 2000 2256 2000
            WIRE 2080 2000 2080 2080
            WIRE 2080 2080 2080 2768
        END BRANCH
        BEGIN BRANCH XLXN_50
            WIRE 1664 1968 2064 1968
            WIRE 2064 1968 2064 2080
            WIRE 1664 1968 1664 2192
            WIRE 1664 2192 2256 2192
            WIRE 2000 2080 2064 2080
        END BRANCH
        BEGIN BRANCH XLXN_51
            WIRE 1696 624 2064 624
            WIRE 2064 624 2064 752
            WIRE 1696 624 1696 848
            WIRE 1696 848 2272 848
            WIRE 2000 752 2064 752
        END BRANCH
        BEGIN BRANCH XLXN_52
            WIRE 2080 2848 2128 2848
            WIRE 2128 2848 2128 2960
            WIRE 2128 2960 2256 2960
        END BRANCH
        BEGIN BRANCH XLXN_57
            WIRE 1632 1744 1648 1744
            WIRE 1648 1744 1664 1744
            WIRE 1664 1744 2112 1744
            WIRE 2112 1744 2112 2960
            WIRE 1760 2880 1760 2960
            WIRE 1760 2960 2112 2960
            WIRE 1760 2880 1808 2880
            WIRE 1808 2880 1824 2880
        END BRANCH
        BEGIN BRANCH XLXN_58
            WIRE 1632 1680 1648 1680
            WIRE 1648 1680 1664 1680
            WIRE 1664 1680 2048 1680
            WIRE 2048 1680 2048 2208
            WIRE 1680 2112 1680 2208
            WIRE 1680 2208 2048 2208
            WIRE 1680 2112 1728 2112
            WIRE 1728 2112 1744 2112
        END BRANCH
        BEGIN BRANCH XLXN_59
            WIRE 1632 1616 1648 1616
            WIRE 1648 1616 1664 1616
            WIRE 1664 1616 2064 1616
            WIRE 1696 1312 1696 1456
            WIRE 1696 1456 1744 1456
            WIRE 1744 1456 1760 1456
            WIRE 1696 1312 2064 1312
            WIRE 2064 1312 2064 1616
        END BRANCH
        BEGIN BRANCH XLXN_60
            WIRE 1632 1552 2096 1552
            WIRE 1664 784 1664 816
            WIRE 1664 816 2096 816
            WIRE 2096 816 2096 1552
            WIRE 1664 784 1728 784
            WIRE 1728 784 1744 784
        END BRANCH
        IOMARKER 624 1392 wena R180 28
        BEGIN BRANCH wena
            WIRE 624 1392 784 1392
            WIRE 784 1392 784 1472
            WIRE 784 1472 1024 1472
            WIRE 1024 1472 1024 1664
            WIRE 880 1664 880 1808
            WIRE 880 1808 1056 1808
            WIRE 880 1664 1024 1664
            WIRE 1024 1392 1264 1392
            WIRE 1264 1392 1616 1392
            WIRE 1616 1392 1616 2048
            WIRE 1616 2048 1616 2816
            WIRE 1616 2816 1824 2816
            WIRE 1616 2048 1744 2048
            WIRE 1616 1392 1744 1392
            WIRE 1744 1392 1760 1392
            WIRE 1024 1392 1024 1472
            WIRE 1056 1744 1056 1808
            WIRE 1056 1744 1248 1744
            WIRE 1264 720 1264 1392
            WIRE 1264 720 1744 720
        END BRANCH
        INSTANCE XLXI_31 1824 2944 R0
        INSTANCE XLXI_32 1744 2176 R0
        INSTANCE XLXI_34 1760 1520 R0
        INSTANCE XLXI_35 1744 848 R0
        INSTANCE XLXI_37 1248 1872 R0
        INSTANCE XLXI_38 1072 2208 R0
        INSTANCE XLXI_39 1088 2720 R0
        BEGIN BRANCH r1addr(1:0)
            WIRE 624 2112 848 2112
            WIRE 848 2112 848 2464
            WIRE 848 2464 1088 2464
        END BRANCH
        BEGIN BRANCH XLXN_69(1:0)
            WIRE 1472 2464 2528 2464
            WIRE 2528 2336 2528 2464
            WIRE 2528 2336 3584 2336
        END BRANCH
        BEGIN BRANCH r0addr(1:0)
            WIRE 624 1872 848 1872
            WIRE 848 1872 848 1952
            WIRE 848 1952 1072 1952
        END BRANCH
        BEGIN BRANCH XLXN_72(1:0)
            WIRE 1456 1952 2736 1952
            WIRE 2736 1440 2736 1952
            WIRE 2736 1440 3584 1440
        END BRANCH
    END SHEET
END SCHEMATIC
