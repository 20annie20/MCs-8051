;program przesyla dane umieszczone pod adresem 70h w pamiecie wewnetrznej danych
;presylanie odbywa sie w trybie 4 bitowym
	RS 	EQU 	P3.7	;0- instrukcje 	1- dane
	RW 	EQU 	P3.6	;0- zapis	1-odczyt
	E 	EQU 	P3.5	;odczyt danych nastepuje na zboczu opadajacym pojawiajacym sie na wejsiu E
	DANE 	EQU 	70h	;adres spod ktorego dane sa przesylane do wyswietlacza
	X	EQU	71h	;adres wspolrzednej w osi X
	Y	EQU	72h	;adres wspolrzednej w osi Y	

	org 0000h
	ljmp 	start

	org 0100h
				;dane inicjalizacyjne wyswietlacz
init_db: DB 01h, 02h, 06h, 0Eh, 02h, 28h, 85h, 00h
;init_db: 	DB 01h, 02h, 06h, 0Eh, 02h, 85h, 00h
	org 0150h
text_to_write: DB 'Podstawy techniki Mikroprocesorowej'

start:	mov 	DPTR, 	#init_db
	clr 	RW
	clr 	RS
	setb 	E
	mov 	P3, 	#01h
	clr 	E
	setb 	E
init:	clr 	A
	movc 	A, 	@A+DPTR
	jz 	next
	inc 	DPTR
	mov 	dane, 	A
	LCALL 	send_data
	jmp 	init
next:
	setb 	RS		;przechodzimy do trybu wysylania danych
	mov 	dane, 	#35h	;liczba odpowiadająca cyfrze 5 w tablicy znakow asci
	LCALL 	send_data
	LCALL 	lcd_clear
	LCALL   lcd_write
	LCALL 	lcd_home
	LCALL 	lcd_clear
	LCALL 	lcd_home

loop:	
	LCALL   lcd_write
	LCALL	lcd_home
	LCALL 	lcd_clear
	ljmp 	loop

				;procedura wysylajaca do wyswietlacz dwa polbajty: najpierw starszy potem mlodszy
send_data:
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

lcd_write:
	mov	DPTR, 	#text_to_write
	ljmp aa
kolejny:
	inc 	DPTR
	mov 	dane, 	A
	LCALL 	send_data
aa:	clr 	A
	movc 	A, 	@A+DPTR
	cjne A, #090h, kolejny
	RET

lcd_clear:
	clr 	RW
	clr 	RS
	mov 	DPTR,  #0300h
hop:	clr 	A
	movc 	A, 	@A+DPTR
	jz 	koniec
	inc 	DPTR
	mov 	dane, 	A
	LCALL 	send_data
	jmp 	hop
koniec:	setb	RS
	RET

lcd_home:
	clr 	RW
	clr 	RS
	mov 	DPTR,  #0400h
	clr 	A
	movc 	A, 	@A+DPTR
	inc 	DPTR
	mov 	dane, 	A
	LCALL 	send_data
	clr 	A
	movc 	A, 	@A+DPTR
	inc 	DPTR
	mov 	dane, 	A
	LCALL 	send_data
	clr 	A
	movc 	A, 	@A+DPTR
	inc 	DPTR
	mov 	dane, 	A
	LCALL 	send_data
	clr 	A
	movc 	A, 	@A+DPTR
	inc 	DPTR
	mov 	dane, 	A
	LCALL 	send_data
	setb	RS
	RET

ORG 300h
DB 01h, 06h, 0Eh, 28h, 80h, 00h
ORG 400h
DB 02Ah, 06h, 0Eh, 80h
END