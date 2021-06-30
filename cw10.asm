;307393 Anna Semrau
;==============================================================================
;obsługa czujnika temperatury DS1620
;===============================================================================

	DQ 	equ P0.2
	CLK 	equ P0.1
	RST 	equ P0.0
	INSTR	EQU 40h
	CONF_W	EQU 41h
	CONF_R 	EQU 42h

	THHR	EQU 50h			;stad wysylane wartosci do ds1260
	THLR 	EQU 51h
	TLHR	EQU 52h
	TLLR	EQU 53h

	THHW	EQU 60h			;tu zapisywane wartosci odczytane z ds1260
	THLW 	EQU 61h
	TLHW	EQU 62h
	TLLW	EQU 63h

	TEMPH	EQU 20h
	TEMPL	EQU 21h

org 0000h
	ljmp start

org 100h
start:
	mov 	INSTR,	#0AAh
	mov	CONF_R,	 #0E0h
	mov	THLR,	#0F0h
	mov	TLLR,	#001h
loop:
	mov	INSTR,	#0AAh
	lcall	send_instr
	lcall	read_temp
	lcall	convertASCII
	clr 	F0
	clr	C
	lcall	configure	;procedura odczytuje obecną konfigurację do 41h, a następnie wysyła nową spod 42h
	ljmp 	loop

send_instr:
	CLR 	RST
	SETB 	RST
	mov	B,	#08d;
	mov	A,	INSTR
	setb 	RST
aa:	clr	CLK
	RRC 	A
	mov	DQ, 	C
	setb	CLK	;rising edge - the valid data must be on DQ
	djnz	B,	aa
	RET

read_temp:
	mov	R6,	#00h
	mov	R7,	#00h
	mov	B,	#08d
	clr	A
	clr 	C
bb:
	clr	CLK
	mov	C,	DQ
	RRC 	A
	setb	CLK	;rising edge - the valid data must be on DQ
	djnz	B,	bb
	clr	CLK
	mov	C,	DQ
	setb	CLK
	jnc	dodatnia
ujemna:	mov	R7,	#01h
dodatnia:
	mov	R6, 	A
	CLR	RST
	RET

configure:
	mov	INSTR,	#0ACh	;do INSTR wartość "READ CONFIG"
	lcall 	send_instr
	lcall 	read_data
	clr	RST
	setb	RST
	mov	INSTR,	#0Ch	;do INSTR wartość "WRITE CONFIG"
	lcall 	send_instr
	lcall 	send_data
	RET

read_data:
	mov	41h, #00h
	clr	A
	clr	C
	mov	B,	#08d
cc:
	clr	CLK
	mov	C,	DQ
	RRC 	A
	setb	CLK
	djnz	B,	cc
	mov	R4,	a
	lcall	read_thf
check_tl:
	mov	a,	R4
	lcall	read_tlf
end_read:
	mov	a,	R4
	mov	41h, 	A
	mov	R4,	#0h
	RET

send_data:
	mov	B,	#08d;
	mov	A,	CONF_R
dd:	clr	CLK
	RRC 	A
	mov	DQ, 	C
	setb	CLK	;rising edge - the valid data must be on DQ
	djnz	B,	dd
	mov	A,	CONF_R
	mov	R4,	a
	lcall	write_thf
check_send_tl:
	mov	a,	R4
	lcall write_tlf
end_send:
	mov	R4,	#0h
	RET

read_thf:
	mov	INSTR,	#0A1h	;wysłanie instrukcji odczytania rejestru th
	lcall 	send_instr
	lcall 	read_boundary
	mov	THHW,	TEMPH
	mov	THLW,	TEMPL
	RET

read_tlf:
	mov	INSTR,	#0A2h	;wysłanie instrukcji odczytania rejestru tl
	lcall 	send_instr
	lcall 	read_boundary
	mov	TLHW,	TEMPH
	mov	TLLW,	TEMPL
	RET

write_thf:
	mov	INSTR,	#01h	;wysłanie instrukcji zapisania do rejestru th
	lcall 	send_instr
	mov	TEMPH,	THHR
	mov	TEMPL,	THLR
	lcall 	send_boundary
	RET

write_tlf:
	mov	INSTR,	#02h	;wysłanie instrukcji zapisania do rejestru tl
	lcall send_instr
	mov	TEMPH,	TLHR
	mov	TEMPL,	TLLR
	lcall 	send_boundary
	RET

read_boundary:
	mov	20h,	#00h
	mov	21h,	#00h
	mov	B,	#08d
	clr	A
	clr 	C
hh:
	clr	CLK
	mov	C,	DQ
	RRC 	A
	setb	CLK	;rising edge - the valid data must be on DQ
	djnz	B,	hh
	clr	CLK
	mov	C,	DQ
	setb	CLK
	jnc	dodatnia_r
	mov	TEMPH,	#01h
dodatnia_r:
	mov	TEMPL, 	A
	RET

send_boundary:
	mov	B,	#08d;
	mov	A,	TEMPL
gg:	clr	CLK
	RRC 	A
	mov	DQ, 	C
	setb	CLK	;rising edge - the valid data must be on DQ
	djnz	B,	gg
	mov	A, 	TEMPH
	clr	CLK
	RRC 	A
	mov	DQ, 	C
	setb	CLK
	RET

convertASCII:
	clr F0
	mov	DPH,	#00h	;najpierw czyszczenie zewnetrznej pamieci
	mov 	DPL,	#00h
	clr	a
	movx	@DPTR,	a
	inc	DPTR
	movx	@DPTR,	a
	inc	DPTR
	movx	@DPTR,	a
	inc	DPTR
	movx	@DPTR,	a
	inc	DPTR
	movx	@DPTR,	a
	inc	DPTR
	movx	@DPTR,	a

	mov	DPH,	#00h
	mov 	DPL,	#00h
	mov	a,	R7
	jnb	a.0,	plus
	setb	F0		;liczba ujemna
	mov	a,	#2Dh
	movx	@DPTR,	a
	mov	a,	R6
	cpl 	a
	add	a,	#01h
	ljmp	wartosc

plus:
	mov	a,	#2Bh
	movx	@DPTR,	a
	mov	a,	R6
	ljmp	wartosc

wartosc:
	clr C
	mov	b,	#200d
	div	ab
	add	a,	#30h
	inc	DPTR
	movx	@DPTR,	a
	mov	a,	b
	mov	b,	#20d
	div	ab
	add	a,	#30h
	inc	DPTR
	movx	@DPTR,	a
	mov	a,	b
	mov	b,	#2d
	div 	ab
	add	a,	#30h
	inc	DPTR
	movx	@DPTR,	a
	mov	a,	#2Eh
	inc	DPTR
	movx	@DPTR,	a
	mov	a, b
	jb 	a.0, 	pol
	mov	a,	#30h
	inc	DPTR
	movx	@DPTR,	a
	RET

pol:
	mov	a,	#35h
	inc	DPTR
	movx	@DPTR,	a
	RET
END