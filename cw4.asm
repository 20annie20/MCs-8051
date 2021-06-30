;307393 Anna Semrau
;==============================================================================
;operacje wielobajtowe
;===============================================================================

ORG 40h
DB 	0FFh, 023h
ORG 48h
DB	0FEh, 044h

ORG 0000h
	ljmp	loop

ORG 0100h

loop: 	lcall wczytaj_dane
	lcall dodaj
	lcall odejmij
	lcall pomnoz
	ljmp loop

wczytaj_dane:
	clr a
	mov	a,	40h
	mov 	R1,	a
	clr a
	mov	a,	41h
	mov 	R0,	a
	clr a
	mov	a,	48h
	mov 	R3,	a
	clr a
	mov	a,	49h
	mov 	R2,	a
	RET

ORG 200h
dodaj:
	mov	A,	R0
	add	A,	R2
	mov	52h,	A
	mov	A,	R1
	addc	A,	R3
	mov	51h,	A
	jc	trzybajtowa
	mov	a, #0h
	mov	50h, a
	RET
trzybajtowa:
	mov	a, #01h
	mov	50h,	a
	RET

odejmij:
	clr	C
	mov	A,	R0
	subb	A,	R2
	mov	59h,	a
	mov	A,	R1
	subb	A,	R3
	mov	58h,	A
	JC	wyzeruj
	RET
wyzeruj:
	clr a
	mov	58h, 	a
	mov 	59h,	a
	RET

pomnoz:
	mov	A,	R0
	mov	B,	R2
	mul	AB
	mov	R4,	A
	mov	R5,	B
	;koniec R0xR2
	mov	A,	R1
	mov	B,	R2
	mul	AB
	mov	R6,	B
	addc	A,	R5
	mov	R5,	A
	;koniec R2xR1
	mov	A,	R0
	mov	B,	R3
	mul  	AB
	addc	A,	R5
	mov	R5,	A
	mov	A,	B
	addc	A,	R6
	mov	R6, 	A
	;koniec R0xR3
	mov	A,	R1
	mov	B,	R3
	mul 	AB
	addc	A,	R6
	mov	R6,	A
	mov	R7,	B
przenies:
 	;60h, 61h, 62h, 63h
	mov	a,	R7
	mov	60h,	a
	mov	a,	R6
	mov	61h,	a
	mov	a,	R5
	mov	62h,	a
	mov	a,	R4
	mov	63h,	a
	clr	a
	RET

END