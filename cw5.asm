ORG 0000h			
	ljmp	start
ORG 0100h
start:
	mov	DPH,	#03h 	;inicjalizacja DPTR
	mov	R6,	#01h	;pomocniczo do sprawdzania szyfru
	mov 	P3,	#0Fh	;inicjalizacja klawiatury
	mov	a,	P3	;inicjalizacja wyświetlacza
	mov	R0,	#0Fh	;wyświetl początkowo pusty
	lcall	wyswietl
loop:	mov	60h,	R0	
	mov	a,	P3	;jesli wciaz nieodcisniety ten sam, wracaj do loop
	CJNE A, 60h, aa
	jmp	loop
aa:	
	mov	R0,	#0Fh	;wyświetl początkowo pusty
	lcall	wyswietl
aaa:	mov	a,	P3	;jesli odcisniete, czekaj tu na wcisniecie
	jnb	a.0,	bbb
	jnb	a.1,	bbb
	jnb	a.2,	bbb
	jnb	a.3,	bbb
	ljmp	aaa
bbb:				;wcisnieto jakis przycisk
	mov	R0,	a	;tu przechowany kod rzędu
	setb	P3.4
	mov	a,	P3
	lcall	czy_znaleziono
	setb	P3.5
	mov	a,	P3
	lcall	czy_znaleziono
	setb	P3.6
	mov	a,	P3
	lcall	czy_znaleziono
	setb	P3.7
	mov	a,	P3
	lcall	czy_znaleziono

czy_znaleziono:
	;jesli bity 0,1,2,3 akumulatora są równe 1, znaleziono
	jnb	a.0,	wracaj
	jnb	a.1,	wracaj
	jnb	a.2,	wracaj
	jnb	a.3,	wracaj
	clr	c
	subb	a,	#0Fh
	add	a,	R0
	lcall	sprawdz_kod
	lcall 	wyswietl	
	ljmp 	loop
wracaj:
	RET
	
sprawdz_kod:			;kod: 1882
	mov	R7,	a	;zabezpieczenie wyniku
	mov	a,	R6
	jb	a.0,	poz_1	;w R6 przechowywanie info o tym jaka cyfra ma teraz byc weryfikowana
	jb	a.1,	poz_2
	jb	a.2,	poz_3
	jb	a.3,	czy_szyfr
niepoprawne:	
	mov	R6,	#01h	;ustaw z powrotem poszukiwanie pierwszej cyfry
	ljmp 	wroc_ze_sprawdzania
czy_szyfr:			;jesli bit R6.3 to szukam ostatniej poprawnej cyfry
	mov	a,	R7
	CJNE A, #00111110b, niepoprawne
	setb	F0	;sukces!
	ljmp	wroc_ze_sprawdzania
poz_1:
	mov	a,	R7
	CJNE A, #00011110b, niepoprawne
poprawne:
	mov	a,	R6
	rl	a
	mov	R6,	a
	ljmp wroc_ze_sprawdzania
poz_2:
	mov	a,	R7
	CJNE A, #00111011b, niepoprawne
	ljmp	poprawne
poz_3:
	mov	a,	R7
	CJNE A, #00111011b, niepoprawne
	ljmp	poprawne
	
wroc_ze_sprawdzania:
	mov	a,	R7
	RET
		
wyswietl:
	jb	a.7,	kol_4
	jb	a.6,	kol_3
	jb	a.5,	kol_2
	jb	a.4,	kol_1
kol_4: 
	ljmp	pole_4_3	;wystaw pusty znak dla liter

kol_3:	jnb	a.3,	pole_4_3 ;oznaczenie pole_rzad_kolumna
	jnb	a.2,	pole_3_3
	jnb	a.1,	pole_2_3
pole_1_3:			 ;cyfra 3
	mov	DPL,	#03d
	ljmp	wystaw
pole_2_3:			;cyfra 6
	mov	DPL,	#06d
	ljmp	wystaw
pole_3_3:			 ;cyfra 9
	mov	DPL,	#09d
	ljmp	wystaw
pole_4_3:			;pusty - bo hash
	mov	DPL,	#0d
	ljmp	wystaw	

kol_2:	jnb	a.3,	pole_4_2 ;oznaczenie pole_rzad_kolumna
	jnb	a.2,	pole_3_2
	jnb	a.1,	pole_2_2
pole_1_2:			 ;cyfra 2
	mov	DPL,	#02d
	ljmp	wystaw
pole_2_2:			;cyfra 5
	mov	DPL,	#05d
	ljmp	wystaw
pole_3_2:			 ;cyfra 8
	mov	DPL,	#08d
	ljmp	wystaw
pole_4_2:			;cyfra 0
	mov	DPL,	#10d
	ljmp	wystaw		

kol_1:	jnb	a.3,	pole_4_1 ;oznaczenie pole_rzad_kolumna
	jnb	a.2,	pole_3_1
	jnb	a.1,	pole_2_1
pole_1_1:			 ;cyfra 1
	mov	DPL,	#01d
	ljmp	wystaw
pole_2_1:			;cyfra 4
	mov	DPL,	#04d
	ljmp	wystaw
pole_3_1:			 ;cyfra 7
	mov	DPL,	#07d
	ljmp	wystaw
pole_4_1:			;pusty - bo gwiazdka
	mov	DPL,	#0d
	ljmp	wystaw	

wystaw:	clr 	a
	movc 	a,	@a+dptr
	mov	P1,	a
	mov	a,	R0
	mov	P3,	#0Fh
	RET

ORG 300h

db 11111110b ;pusty
db 10011110b ;1
db 01000100b ;2
db 00001100b ;3
db 10011000b ;4
db 00101000b ;5
db 00100000b ;6
db 10001110b ;7
db 00000000b ;8
db 00001000b ;9
db 00000010b ;0

END