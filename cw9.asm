;307393 Anna Semrau
;==============================================================================
;obsługa matrycy LED
;===============================================================================
org 0000h
	ljmp 	start
	org 050h
init_db:
	DB 0FFh
	DB 11010001b, 11010101b, 11000101b ;litera S
	DB 0FFh
	DB 11000001b, 11010101b, 11010101b 	;litera E
	DB 0FFh
	DB 11000001b, 11111011b, 11110111b, 11111011b, 11000001b	;litera M
	DB 0FFh

ORG 200h
start:	mov R1,	#0FEh
	mov 	DPTR, #50h
	mov	R2,	#0Fh
	mov	R3,	#50h
loop:
	mov	a,	R3
	mov	DPL,  a
	inc a
	jb a.3, koniec
	mov	R3, a
	mov	R0, #08h	;zalezne od ilosci linijek w init
inner:
	clr a
	movc 	a, @a+dptr
	inc	DPTR
	mov	P0, #0FFh
	mov 	P1, a
	mov	P0, R1
	mov 	a, P0
	rr 	a
	mov	R1, a
	djnz	R0, inner
	ljmp 	loop

koniec:	mov R3, 50h
	mov R0,	#08h
	ljmp inner
END