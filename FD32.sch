VERSION 6
BEGIN SCHEMATIC
    BEGIN ATTR DeviceFamilyName "virtex2p"
        DELETE all:0
        EDITNAME all:0
        EDITTRAIT all:0
    END ATTR
    BEGIN NETLIST
        SIGNAL clk
        SIGNAL clr
        SIGNAL D(31:0)
        SIGNAL ce
        SIGNAL Q(31:0)
        SIGNAL D(31:16)
        SIGNAL D(15:0)
        SIGNAL Q(31:16)
        SIGNAL Q(15:0)
        SIGNAL XLXN_20(15:0)
        SIGNAL XLXN_21
        SIGNAL XLXN_22
        SIGNAL XLXN_23
        SIGNAL XLXN_24
        SIGNAL XLXN_25
        PORT Input clk
        PORT Input clr
        PORT Input D(31:0)
        PORT Input ce
        PORT Output Q(31:0)
        BEGIN BLOCKDEF fd16ce
            TIMESTAMP 2000 1 1 10 10 10
            LINE N 0 -128 64 -128 
            LINE N 0 -192 64 -192 
            LINE N 0 -32 64 -32 
            LINE N 0 -256 64 -256 
            LINE N 384 -256 320 -256 
            LINE N 80 -128 64 -144 
            LINE N 64 -112 80 -128 
            RECTANGLE N 320 -268 384 -244 
            RECTANGLE N 0 -268 64 -244 
            LINE N 192 -32 64 -32 
            LINE N 192 -64 192 -32 
            RECTANGLE N 64 -320 320 -64 
        END BLOCKDEF
        BEGIN BLOCK XLXI_4 fd16ce
            PIN C clk
            PIN CE ce
            PIN CLR clr
            PIN D(15:0) D(15:0)
            PIN Q(15:0) Q(15:0)
        END BLOCK
        BEGIN BLOCK XLXI_5 fd16ce
            PIN C clk
            PIN CE ce
            PIN CLR clr
            PIN D(15:0) D(31:16)
            PIN Q(15:0) Q(31:16)
        END BLOCK
    END NETLIST
    BEGIN SHEET 1 1760 1360
        BEGIN BRANCH D(31:0)
            WIRE 336 288 416 288
            WIRE 416 288 464 288
            WIRE 464 288 496 288
        END BRANCH
        IOMARKER 336 288 D(31:0) R180 28
        IOMARKER 256 576 clk R180 28
        BEGIN BRANCH clk
            WIRE 256 576 496 576
            WIRE 496 576 496 960
            WIRE 496 960 736 960
            WIRE 496 432 720 432
            WIRE 496 432 496 576
        END BRANCH
        IOMARKER 304 1104 clr R180 28
        BEGIN BRANCH clr
            WIRE 304 1104 496 1104
            WIRE 496 1104 576 1104
            WIRE 576 1104 736 1104
            WIRE 576 528 720 528
            WIRE 576 528 576 1104
            WIRE 736 1056 736 1104
        END BRANCH
        BEGIN BRANCH ce
            WIRE 256 816 320 816
            WIRE 320 816 416 816
            WIRE 416 816 560 816
            WIRE 560 816 560 896
            WIRE 560 896 736 896
            WIRE 560 368 560 816
            WIRE 560 368 720 368
        END BRANCH
        IOMARKER 256 816 ce R180 28
        BEGIN BRANCH Q(31:0)
            WIRE 1344 640 1392 640
            WIRE 1392 640 1440 640
            WIRE 1440 640 1504 640
        END BRANCH
        IOMARKER 1504 640 Q(31:0) R0 28
        INSTANCE XLXI_4 736 1088 R0
        INSTANCE XLXI_5 720 560 R0
        BUSTAP 416 288 416 192
        BEGIN BRANCH D(31:16)
            WIRE 416 112 416 144
            WIRE 416 144 416 192
            WIRE 416 112 560 112
            WIRE 560 112 560 304
            WIRE 560 304 720 304
            BEGIN DISPLAY 416 152 ATTR Name
                ALIGNMENT SOFT-TVCENTER
            END DISPLAY
        END BRANCH
        BUSTAP 464 288 464 384
        BEGIN BRANCH D(15:0)
            WIRE 464 384 464 416
            WIRE 464 416 464 464
            WIRE 464 464 464 832
            WIRE 464 832 736 832
            BEGIN DISPLAY 464 424 ATTR Name
                ALIGNMENT SOFT-TVCENTER
            END DISPLAY
        END BRANCH
        BUSTAP 1440 640 1440 544
        BEGIN BRANCH Q(31:16)
            WIRE 1104 304 1440 304
            WIRE 1440 304 1440 432
            WIRE 1440 432 1440 480
            WIRE 1440 480 1440 544
            BEGIN DISPLAY 1440 488 ATTR Name
                ALIGNMENT SOFT-TVCENTER
            END DISPLAY
        END BRANCH
        BUSTAP 1392 640 1392 736
        BEGIN BRANCH Q(15:0)
            WIRE 1120 832 1392 832
            WIRE 1392 736 1392 768
            WIRE 1392 768 1392 800
            WIRE 1392 800 1392 832
            BEGIN DISPLAY 1392 768 ATTR Name
                ALIGNMENT SOFT-TVCENTER
            END DISPLAY
        END BRANCH
    END SHEET
END SCHEMATIC
