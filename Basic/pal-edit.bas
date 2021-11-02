10 LET CX=1: LET CY=1: REM PALETTE CURSOR LOCATION
11 REM R = CURRENT PALETTE COLOUR RED VALUE
12 REM GB = CURRENT PALETTE COLOUR GREEN AND BLUE VALUE
13 REM G = CURRENT PALETTE COLOUR GREEN VALUE
14 REM B = CURRENT PALLETTE COLOUR BLUE VALUE
20 LET PC=0: REM PALETTE COLOUR SELECTION 
30 REM 30000 - LOADING
40 REM 40000 - HELP SCREEN
50 SCREEN$80 :REM 40X30 SCREEN MODE
55 GOSUB 57000: REM DEFAULT PALETTE TO VERA VRAM
60 RECT 0,0,319,199,0: REM BLANK SCREEN
70 GOSUB 40000
80 GOSUB 1000
90 END

1000 REM MAIN LOOP
1010 REM GET STATUS
1020 REM GET CURSOR AND UPDATE
1030 GOSUB 3000: REM PROCESS KEYBOARD 
1040 GOTO 1000

3000 REM GET KEYBOARD AND PROCESS
3010 GET KP$: REM KP$= KEY PRESS
3020 REM PROCESS CURSOR KEYS
3030 IF KP$=CHR$(157) THEN GOSUB 3200: REM LEFT
3040 IF KP$=CHR$(29) THEN GOSUB 3300: REM RIGHT
3050 IF KP$=CHR$(17) THEN GOSUB 3400: REM DOWN
3060 IF KP$=CHR$(145) THEN GOSUB 3500: REM UP
3070 REM PROCESS RGB KEYS
3080 IF KP$=CHR$(82) THEN GOSUB 3600: REM R KEY
3090 IF KP$=CHR$(71) THEN GOSUB 3700: REM G KEY
3100 IF KP$=CHR$(66) THEN GOSUB 3800: REM B KEY
3110 REM CONTROL KEYS
3120 IF KP$=CHR$(81) THEN RESET: REM Q KEY TO QUIT
3130 IF KP$=CHR$(83) THEN: REM S KEY TO SAVE
3140 IF KP$=CHR$(76) THEN: REM L KEY TO LOAD
3150 RETURN

3200 REM MOVE CURSOR LEFT
3210 GOSUB 53000: REM REMOVE PREVIOUS CURSOR
3220 LET CX = CX-1
3230 IF CX < 1 THEN CX = 1
3240 GOSUB 52000: REM DRAW CURSOR
3250 RETURN

3300 REM MOVE CURSOR RIGHT
3310 GOSUB 53000: REM REMOVE PREVIOUS CURSOR
3320 LET CX = CX+1
3330 IF CX > 16 THEN CX = 16
3340 GOSUB 52000: REM DRAW CURSOR
3350 RETURN

3400 REM MOVE CURSOR DOWN
3410 GOSUB 53000: REM REMOVE PREVIOUS CURSOR
3420 LET CY = CY+1
3430 IF CY > 16 THEN CY = 16
3440 GOSUB 52000: REM DRAW CURSOR
3450 RETURN

3500 REM MOVE CURSOR UP
3510 GOSUB 53000: REM REMOVE PREVIOUS CURSOR
3520 LET CY = CY-1
3530 IF CY < 1 THEN CY = 1
3540 GOSUB 52000: REM DRAW CURSOR
3550 RETURN

3600 REM INCREASE R VALUE
3610 R = R+1
3620 IF R > 15 THEN R=0
3630 GOSUB 3900: REM UPDATE VERA
3640 GOSUB 54000: REM DISPLAY CURRENT PALETTE
3650 RETURN

3700 REM INCREASE G VALUE
3710 G = G+1
3720 IF G > 15 THEN G=0
3730 GOSUB 3900: REM UPDATE VERA
3740 GOSUB 54000: REM DISPLAY CURRENT PALETTE
3750 RETURN

3800 REM INCREASE B VALUE
3810 B = B+1
3820 IF B > 15 THEN B=0
3830 GOSUB 3900: REM UPDATE VERA
3840 GOSUB 54000: REM DISPLAY CURRENT PALETTE
3850 RETURN

3900 REM UPDATE PALETTE
3910 REM R IS THE RED BYTE
3920 REM CALCULTE GB BYTE
3930 LET GB = G*16+B
3940 VPOKE 1,$FA00+(2*PC),GB: REM UPDATE GREEN BLUE
3950 VPOKE 1,$FA00+(2*PC)+1,R: REM UPDATE RED
3960 RETURN

4000 REM SWITCH TO HELP SCREEN

4100 REM SWITCH TO EDIT SCREEN

40000 REM SCREEN
40010 GOSUB 41000: REM DRAW SCREEN
40020 GOSUB 50000: REM DRAW PALETTE
40030 REM 
40040 RETURN

41000 REM DRAW HELP SCREEN
41010 PRINT "DRAW SCREEN"
41020 OPEN 1,8,2,"IFDRAW5,SEQ,R"
41030 GET#1,D$: IF ST=64 THEN RETURN
41040 GET#1,D$: REM FIRST 2 BYTES ARE NOT USEFUL
41050 FOR Y=0 TO 29
41060 FOR X=0 TO 79
41070 GET#1,D$
41080 VPOKE 0,0+((Y*256)+X),ASC(D$)
41090 NEXT X
41100 NEXT Y 
41110 CLOSE 1
41120 RETURN

50000 REM DRAW PALETTE
50010 FOR Y=0 TO 15
50020 FOR X=0 TO 15
50030 REM CS=VPEEK(1,$FA00+((Y*16)+X))
50040 RECT (X*8)+8,(Y*8)+8,(X*8)+14,(Y*8)+14,(Y*16)+X
50060 NEXT X
50070 NEXT Y
50080 RETURN

51000 REM DRAW SAMPLE BOX
51010 RECT 160,8,311,30,PC
51020 RETURN

52000 REM DRAW CURSOR BOX
52010 FRAME (CX*8)-1,(CY*8)-1,(CX*8)+7,(CY*8)+7,7
52020 REM SET PALETTE COLOUR
52030 PC=((CY-1)*16)+(CX-1): REM COLOURS RANGE FROM 0 TO 255
52040 GOSUB 51000: REM UPDATE SAMPLE BOX
52050 GOSUB 54000
52060 RETURN

53000 REM DRAW BLACK CURSOR BOX
53010 FRAME (CX*8)-1,(CY*8)-1,(CX*8)+7,(CY*8)+7,0
53020 RETURN

54000 REM DISPLAY CURRENT PALETTE
54010 RECT 64,158,88,166,0 : REM BLACK OUT PREVIOUS TEXT
54020 CHAR 64,166,1,STR$(PC): REM DISPLAY COLOUR INDEX
54030 GOSUB 58000: REM FIND RGB VALUES
54040 RECT 112,159,128,167,0: REM BLACK OUT PREVIOUS VALUE
54050 CHAR 112,166,1,STR$(R): REM DISPLAY RED VALUE
54060 RECT 160,159,176,167,0: REM BLACK OUT PREVIOUS VALUE
54070 CHAR 160,166,1,STR$(G): REM DISPLAY GREEN VALUE
54080 RECT 208,159,224,167,0: REM BLACK OUT PREVIOUS VALUE
54090 CHAR 208,166,1,STR$(B): REM DISPLAY BLUE VALUE
54095 RETURN

55000 REM RGB OF CURRENT COLOUR
55010 C1=VPEEK(1,$FA00+(PC*2))
55020 C2=VPEEK(1,$FA01+(PC*2))
55030 LET CR=C2
55040 LET CG=100
55050 LET CB=100

56000 REM HX$="0123456789ABCDEF"
56010 REM R$=MID$(HX$, 1+(V% AND 15),1)
56020 REM PRINT R$
56030 REM V%=V%/16: IF V%=0 THEN END
56040 

57000 REM PUSH PALETTE TO VERA
57001 REM READ DEFAULT DATA
57010 FOR I=0 TO 511
57020 READ D
57030 VPOKE 1,$FA00+I,D
57040 NEXT I
57050 RETURN

58000 REM CALCULATE RGB FROM PALETTE
58005 LET R=0: LET GB=0: LET G=0: LET B=0: REM RESET COLOURS VARIABLES
58010 GB = VPEEK(1,$FA00+(PC*2))
58015 R = VPEEK(1,$FA00+(PC*2)+1)
58020 REM GB NEEDS TO BE SPLIT G = FIRST 4-BIT B = LAST 4-BIT
58025 IF (GB AND 128) = 128 THEN G=8
58030 IF (GB AND 64) = 64 THEN G=G+4
58035 IF (GB AND 32) = 32 THEN G=G+2
58040 IF (GB AND 16) = 16 THEN G=G+1
58045 IF (GB AND 8) = 8 THEN B=8
58050 IF (GB AND 4) = 4 THEN B=B+4
58055 IF (GB AND 2) = 2 THEN B=B+2
58060 IF (GB AND 1) = 1 THEN B=B+1
58065 RETURN

60000 REM DEFAULT PALETTE
60001 REM EACH COLOUR IS 2 BYTES
60010 DATA $00,$00,$FF,$0F,$00,$08,$FE,$0A,$4C,$0C,$C5,$00,$0A,$00,$E7,$0E
60011 DATA $85,$0D,$40,$06,$77,$0F,$33,$03,$77,$07,$F6,$0A,$8F,$00,$BB,$0B
60012 DATA $00,$00,$11,$01,$22,$02,$33,$03,$44,$04,$55,$05,$66,$06,$77,$07
60013 DATA $88,$08,$99,$09,$AA,$0A,$BB,$0B,$CC,$0C,$DD,$0D,$EE,$0E,$FF,$0F
60014 DATA $11,$02,$33,$04,$44,$06,$66,$08,$88,$0A,$99,$0C,$BB,$0F,$11,$02
60015 DATA $22,$04,$33,$06,$44,$08,$55,$0A,$66,$0C,$77,$0F,$02,$00,$11,$04
60016 DATA $11,$06,$22,$08,$22,$0A,$33,$0C,$33,$0F,$00,$02,$00,$04,$00,$06
60017 DATA $00,$08,$00,$0A,$00,$0C,$00,$0F,$21,$02,$43,$04,$64,$06,$86,$08
60018 DATA $A8,$0A,$C9,$0C,$EB,$0F,$11,$02,$32,$04,$53,$06,$74,$08,$95,$0A
60019 DATA $B6,$0C,$D7,$0F,$10,$02,$31,$04,$51,$06,$62,$08,$82,$0A,$A3,$0C
60020 DATA $C3,$0F,$10,$02,$30,$04,$40,$06,$60,$08,$80,$0A,$90,$C0,$B0,$0F
60021 DATA $21,$01,$43,$03,$64,$05,$86,$07,$A8,$09,$C9,$0B,$FB,$0D,$21,$01
60022 DATA $42,$03,$63,$04,$84,$06,$A5,$08,$C6,$09,$F7,$0B,$20,$01,$41,$02
60023 DATA $61,$04,$82,$05,$A2,$06,$C3,$08,$F3,$09,$20,$01,$40,$02,$60,$03
60024 DATA $80,$04,$A0,$05,$C0,$06,$F0,$07,$21,$01,$43,$03,$65,$04,$86,$06
60025 DATA $A8,$08,$CA,$09,$FC,$0B,$21,$01,$42,$02,$64,$03,$85,$04,$A6,$05
60026 DATA $C8,$06,$F9,$07,$20,$00,$41,$01,$62,$01,$83,$02,$A4,$02,$C5,$03
60027 DATA $F6,$03,$20,$00,$41,$00,$61,$00,$82,$00,$A2,$00,$C3,$00,$F3,$00
60028 DATA $22,$01,$44,$03,$66,$04,$88,$06,$AA,$0A,$CC,$09,$FF,$0B,$22,$01
60029 DATA $44,$02,$66,$03,$88,$04,$AA,$05,$CC,$06,$FF,$07,$22,$00,$44,$01
60030 DATA $66,$01,$88,$02,$AA,$02,$CC,$03,$FF,$03,$22,$00,$44,$00,$66,$00
60031 DATA $88,$00,$AA,$00,$CC,$00,$FF,$00,$12,$01,$34,$03,$56,$04,$68,$06
60032 DATA $8A,$08,$AC,$09,$CF,$0B,$12,$01,$24,$02,$46,$03,$58,$04,$6A,$05
60033 DATA $8C,$06,$9F,$07,$02,$00,$14,$01,$26,$01,$38,$02,$4A,$02,$5C,$03
60034 DATA $8A,$08,$AC,$09,$CF,$0B,$12,$01,$24,$02,$46,$03,$58,$04,$6A,$05
60035 DATA $8C,$06,$9F,$07,$02,$00,$14,$01,$26,$01,$38,$02,$4A,$02,$5C,$03
60036 DATA $24,$03,$36,$04,$48,$06,$5A,$08,$6C,$09,$7F,$0B,$02,$01,$14,$02
60037 DATA $16,$04,$28,$05,$2A,$06,$3C,$08,$3F,$09,$02,$01,$04,$02,$06,$03
60038 DATA $08,$04,$0A,$05,$0C,$06,$0F,$07,$12,$02,$34,$04,$46,$06,$68,$08
60039 DATA $8A,$0A,$9C,$0C,$BE,$0F,$11,$02,$23,$04,$35,$06,$47,$08,$59,$0A
60040 DATA $6B,$0C,$7D,$0F,$01,$02,$13,$04,$15,$06,$26,$08,$28,$0A,$3A,$0C
60041 DATA $3C,$0F,$01,$02,$03,$04,$04,$06,$06,$08,$08,$0A,$09,$0C,$0B,$0F

