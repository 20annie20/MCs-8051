;307393 Anna Semrau
;==============================================================================
;program realizujący sortowanie tablicy danych
;tablica znajduje się w komórkach pamięci wewnętrznej od adresu 900h
;po posortowaniu tablicę należy umieścić w zewnetrznej pamieci od adresu 3000h
;-przeniesienie danych z pamięci programu do zewnętrznej pamięci danych(3)
;-poprawnie posortowanatablica(+1)
;-szybkość algorytmu sortowania (dwa najszybsze +1; dwakolejne +0.5)
;===============================================================================

adres_tabeli 	EQU 	900h
adres_zewn 	EQU 	3000h

ORG 0000h
	ljmp	start

ORG 100h
start: 
	mov	R7,	#0FFh		;wykorzystane do odliczania 256 razy
	mov	R6,	#0FFh		;wewnetrzna petla, przegladajaca liczby z tablicy
	mov	R5,	#0FFh		;rejestr do porównywania w celu znalezienia najmniejszej
	mov	R4,	#00h		;inkrementacja dla tabeli wewn.	
	mov	R3,	#00h		;dla dptr zewn	
	mov	R1,	#00h		;najwieksza z najmniejszych odnalezionych do tej pory wartości
	mov	DPH,	#09h
	mov	DPL,	R4
	ljmp 	pobierz
main:   				;pętla główna programu
	djnz 	R6,	ext_loop	;jak zero to koniec sortowania
loop: 	jmp 	loop
ext_loop:
	djnz	R7,	int_loop
	call 	zapisz
	mov	R4,	#0h
	mov	R5,	#0FFh
	mov	R7, 	#0FFh
	mov	DPL,	R4
	mov	a,	R1
	cpl	a
	jnz	main
	jmp	loop
	
int_loop:
	clr c				
	mov 	a,	R7		
	jc	ext_loop		;przejrzeliśmy całą tablicę
	
pobierz:				;pobiera kolejną wartość do akumulatora	
	mov	a,	#0h
	mov	DPL,	R4
	movc	a, 	@a+DPTR
	inc 	R4

porownaj: 				;pozostawia w akumulatorze wieksza z dwoch
	jz	next
	subb	a,	R5		;flaga zapali sie gdy a < R5
	jnc	next
	
czy_byla:
	add	a,	R5
	clr 	c
	subb	a,	R1		;porownanie liczby podejrzanej o bycie najmniejsza ze znaleziona wczesniej
	jz	next			; jesli byly rowne -> nie wymieniaj ich		
	jc	next
	add	a,	R1
swap:	
	xch	a,	r5
next:
	ljmp 	ext_loop

zapisz:
	mov 	a,	R5
	mov	R1,	a
	mov	DPH,	#30h
	mov 	DPL,	R3
	movx	@DPTR,	a		;przeniesienie danej z akumulatora do zewn. pamięci
	inc	R3
	mov	DPH,	#09h
	RET

	
;Tabela liczb przypadkowych

ORG 900h

db 0BCh, 09Ch, 078h, 0ACh, 0DBh, 0EBh, 06Fh, 0A8h
db 088h, 03Eh, 018h, 04Fh, 013h, 0EEh, 0C3h, 0CFh
db 036h, 043h, 0DCh, 0DDh, 097h, 077h, 06Dh, 009h
db 086h, 095h, 0A9h, 014h, 065h, 0F8h, 0B2h, 0F3h
db 0C9h, 0FEh, 08Dh, 08Fh, 0E4h, 09Ch, 06Eh, 0AEh
db 034h, 00Eh, 06Ch, 0A4h, 0A0h, 081h, 03Eh, 058h
db 0AEh, 0D4h, 012h, 0DBh, 05Eh, 0E8h, 007h, 09Dh
db 009h, 04Eh, 0D9h, 0F5h, 06Eh, 0A4h, 02Bh, 088h
db 00Eh, 0F7h, 0DCh, 028h, 015h, 055h, 09Eh, 0EAh
db 068h, 07Eh, 09Dh, 01Ah, 016h, 004h, 0B7h, 0E9h
db 033h, 003h, 055h, 080h, 060h, 04Fh, 0C8h, 097h
db 07Ch, 02Bh, 06Bh, 05Fh, 0E7h, 0DDh, 00Fh, 031h
db 007h, 0CFh, 03Ah, 0E4h, 0BCh, 091h, 0A8h, 0FFh
db 0E6h, 01Ah, 0E7h, 0CBh, 0E8h, 039h, 00Fh, 036h
db 006h, 06Bh, 0C6h, 040h, 0EBh, 0EFh, 028h, 076h
db 0F6h, 04Dh, 0E1h, 026h, 085h, 0CEh, 023h, 092h
db 079h, 032h, 07Dh, 080h, 025h, 086h, 08Eh, 0A7h
db 0BFh, 0B8h, 0E6h, 092h, 0ECh, 076h, 027h, 04Bh
db 003h, 038h, 012h, 0C8h, 0F4h, 096h, 0E3h, 0B7h
db 006h, 074h, 0F3h, 05Fh, 024h, 01Eh, 0A2h, 0DBh
db 054h, 0EFh, 0D3h, 07Ah, 071h, 042h, 020h, 0DCh
db 07Dh, 02Bh, 0B7h, 001h, 0FEh, 0DBh, 07Bh, 057h
db 0B8h, 01Ch, 035h, 09Bh, 06Ah, 0D2h, 055h, 078h
db 0E4h, 0F2h, 075h, 0D9h, 032h, 0CAh, 0E5h, 019h
db 093h, 013h, 016h, 078h, 0CFh, 00Eh, 0F3h, 0E2h
db 00Ah, 0F0h, 028h, 09Ch, 0B3h, 035h, 024h, 06Fh
db 00Fh, 065h, 027h, 0DBh, 02Bh, 0A2h, 09Ah, 017h
db 024h, 07Eh, 009h, 084h, 0B8h, 0FAh, 024h, 03Eh
db 0FFh, 0F7h, 080h, 0F8h, 072h, 0CBh, 022h, 081h
db 00Ch, 0AFh, 0EBh, 058h, 026h, 035h, 0E3h, 02Ah
db 0FBh, 0ADh, 024h, 079h, 0FCh, 090h, 01Ch, 011h
db 05Dh, 073h, 0F8h, 0B0h, 0C2h, 02Dh, 00Ch, 059h