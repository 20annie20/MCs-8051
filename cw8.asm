;307393 Anna Semrau
;==============================================================================
;operacje wielobajtowe na liczbach ze znakiem
;===============================================================================

ORG 40h
DB 	0FFh, 023h
ORG 48h
DB	0FEh, 044h

ORG 0000
	ljmp	loop

ORG 0100h

loop: 	lcall wczytaj_dane
	lcall dodawanieU2
	lcall odejmowanieU2
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
dodawanieU2:
	mov	50h, 	#0h
	mov	51h,	#0h
	mov	52h,	#0h
	mov	A,	R0
	add	A,	R2
	mov	52h,	A
	mov	A,	R1
	addc	A,	R3
	mov	51h,	A
	jb	OV,	przepelnienie
	mov	A,	R1
	jb	A.7,	ujemna
	RET
przepelnienie:
	jc	ujemna
	mov	50h,	#01h
	RET
ujemna:
	mov	50h,	#0FFh
	RET


odejmowanieU2:
	mov	58h, 	#0h
	mov	59h,	#0h
	mov	5Ah,	#0h
	clr C
	clr OV
	mov	A,	R0
	subb	A,	R2
	mov	5Ah,	A
	mov	A,	R1
	subb	A,	R3
	mov	59h,	A
	jb	C,	przepel
	mov	A,	59h
	RET
przepel:
	jnb	OV,	ujem
	mov	58h,	#00h
	RET
ujem:
	mov	58h,	#0FFh
	RET
RET
END