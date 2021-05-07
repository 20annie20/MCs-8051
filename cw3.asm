;307393 Anna Semrau
;==============================================================================
;wyświetlanie liczb ze stopera na dwóch wyświetlaczach 7-segm.
;wyświetlacze na portach P1 i P2
;czas w postaci X.Y [ms]
; stoper podłączony do wyjść P3.2 - start/stop i P3.3 - reset
;===============================================================================

ORG 0000h			
	ljmp	start		

ORG 0003h
	ljmp 	start_stop

ORG 000Bh
	ljmp 	inc_count

ORG 0013h
	lcall	reset_timer
	RETI

ORG 0100h
start:	
	mov 	TMOD, 	#01h 
	setb 	EX0
	setb 	ET0
	setb 	EX1
	setb 	EA
	setb 	IT0
	mov 	TL0, 	#0A3h
	mov 	TH0, 	#0FFh
	mov 	b, 	#10d	
	mov	DPH,	#03h 
loop:	ljmp 	loop

ORG 200h
start_stop:
	cpl 	TR0
	lcall 	wyswietl
	RETI
	
reset_timer:
	mov 	TL0, 	#0A3h
	mov 	TH0, 	#0FFh
	mov 	a,	#0h
	mov	b, 	#10d
RET	
	
inc_count:
	inc 	a
	mov 	TL0, 	#0A3h
	mov 	TH0, 	#0FFh
	lcall 	wyswietl
	RETI

wyswietl:
	mov	R0,	a
	div	ab	
	cjne	a,#10d,poprawny_X
	lcall	reset_timer
	RET
poprawny_X:
	mov	R1,b
	cjne	R1,#10d,poprawny_Y
	lcall	reset_timer
	RET
poprawny_Y:
	mov 	DPL, 	a
	clr	a
	movc 	a,	@a+dptr
	mov	P2,	a
	mov 	DPL, 	b
	clr a
	movc 	a, 	@a+dptr
	mov	P1, 	a
	mov	b, 	#10d
	mov	a,	R0
RET

ORG 300h

db 01000000b ;0
db 01111001b ;1
db 00100010b ;2
db 00110000b ;3
db 00011001b ;4
db 00010100b ;5
db 00000100b ;6
db 01010001b ;7
db 00000000b ;8
db 00010000b ;9
END