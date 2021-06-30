;-----------------------------------------------------------------
;projekt miernika temperatury z obsługą klawiatury i wyświetlaczem LCD

	DQ 	equ P0.2	;połączenia czujnika temperatury
	CLK 	equ P0.1
	RST 	equ P0.0
	INSTR	EQU 40h

	;połączenia LCD
	RS 	EQU 	P3.7	;0- instrukcje 	1- dane
	RW 	EQU 	P3.6	;0- zapis	1-odczyt
	E 	EQU 	P3.5	;odczyt danych nastepuje na zboczu opadajacym pojawiajacym
	DANE 	EQU 	70h	;adres spod ktorego dane sa przesylane do wyswietlacza

org 0000h
	ljmp start

org 100h

init_db: 	DB 01h, 02h, 06h, 0Eh, 28h, 80h, 00h
	org 0150h
text_to_write: DB 'Temp: ', 00h

start:
	mov	INSTR, 	#0EEh		;włączenie konwersji temperatury
	lcall	send_instr_temp
	mov 	INSTR,	#0AAh		;rozkaz odczytu temperatury
	mov 	DPTR, 	#init_db
	clr 	RW
	clr 	RS
	setb 	E
	mov 	P3, 	#00110010b
	clr 	E
	setb 	E
init:	clr 	A
	movc 	A, 	@A+DPTR
	jz 	next
	inc 	DPTR
	mov 	dane, 	A
	LCALL 	send_data_lcd
	jmp 	init
next:
	LCALL 	lcd_clear
	LCALL	lcd_text

loop:	setb	RS
	mov	INSTR,	#0AAh
	clr 	F0
	clr	C
	lcall	send_instr_temp
	lcall	read_temp
	lcall	convertASCII
	lcall	lcd_temp
	ljmp 	loop

lcd_clear:
	clr 	RW
	clr 	RS
	mov 	DPTR,  #0300h
hop:	clr 	A
	movc 	A, 	@A+DPTR
	jz 	koniec
	inc 	DPTR
	mov 	dane, 	A
	LCALL 	send_data_lcd
	jmp 	hop
koniec:	setb	RS
	RET

lcd_shift:
	clr 	RW
	clr 	RS
	mov 	DPTR,  #0310h
hop1:	clr 	A
	movc 	A, 	@A+DPTR
	jz 	koniec1
	inc 	DPTR
	mov 	dane, 	A
	LCALL 	send_data_lcd
	jmp 	hop1
koniec1:	
	setb	RS
	RET


lcd_text:
	mov	DPTR, 	#text_to_write
	ljmp aa
kolejny:
	inc 	DPTR
	mov 	dane, 	A
	LCALL 	send_data_lcd
aa:	clr 	A
	movc 	A, 	@A+DPTR
	jnz	kolejny

RET

lcd_temp:
	lcall	lcd_shift
	mov 	dane, 	10h
	LCALL 	send_data_lcd
	mov 	dane, 	11h
	LCALL 	send_data_lcd
	mov 	dane, 	12h
	LCALL 	send_data_lcd
	mov 	dane, 	13h
	LCALL 	send_data_lcd
	mov 	dane, 	14h
	LCALL 	send_data_lcd
	mov 	dane, 	15h
	LCALL 	send_data_lcd
RET

send_data_lcd:
	push 	ACC
	mov 	A, 	#0F0h
	anl 	P3, 	A
	anl 	A, 	dane
	swap 	A
	setb 	E
	orl 	P3, 	A
	clr 	E
	mov 	A, 	#0F0h
	anl 	P3, 	A
	swap 	A
	anl 	A, 	dane
	setb 	E
	orl 	P3, 	A
	clr 	E
	pop 	ACC
RET

send_instr_temp:
	CLR 	RST
	SETB 	RST
	mov	B,	#08d;
	mov	A,	INSTR
	setb 	RST
cc:	clr	CLK
	RRC 	A
	mov	DQ, 	C
	setb	CLK	;rising edge - the valid data must be on DQ
	djnz	B,	cc
	RET

read_temp:
	mov	R6,	#00h
	mov	R7,	#00h
	mov	B,	#08d
	clr	A
	clr 	C
dd:
	clr	CLK
	mov	C,	DQ
	RRC 	A
	setb	CLK	;rising edge - the valid data must be on DQ
	djnz	B,	dd
	clr	CLK
	mov	C,	DQ
	setb	CLK
	jnc	dodatnia
ujemna:	mov	R7,	#01h
dodatnia:
	mov	R6, 	A
	CLR	RST
	RET

convertASCII:
	clr F0
	mov	10h,	#00h
	mov 	11h,	#00h
	mov 	12h,	#00h
	mov 	13h,	#00h
	mov 	14h,	#00h
	mov 	15h,	#00h
	clr	a

	mov	a,	R7
	jnb	a.0,	plus
	setb	F0		;liczba ujemna
	mov	a,	#2Dh
	mov 	10h,	a
	mov	a,	R6
	cpl 	a
	add	a,	#01h
	ljmp	wartosc

plus:
	mov	a,	#2Bh
	mov 	10h,	a
	mov	a,	R6
	ljmp	wartosc

wartosc:
	clr C
	mov	b,	#200d
	div	ab
	add	a,	#30h
	mov	11h,	a
	mov	a,	b
	mov	b,	#20d
	div	ab
	add	a,	#30h
	mov	12h,	a
	mov	a,	b
	mov	b,	#2d
	div 	ab
	add	a,	#30h
	mov	13h,	a
	mov	a,	#2Eh
	mov	14h,	a
	mov	a, b
	jb 	a.0, 	pol
	mov	a,	#30h
	mov	15h,	a
	RET

pol:
	mov	a,	#35h
	mov	15h,	a
	RET

ORG 300h
DB 80h, 00h
ORG 310h
DB 85h,	00h
END