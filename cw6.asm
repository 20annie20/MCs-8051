ORG 0000h			
	ljmp	start
ORG 0100h
start:
	
	mov	a,	43h
	mov	b,	#64h
	div	ab
	;mov	57h,	a
	mov	a,	b
	mov	b,	#0Ah
	div 	ab
	;mov	58h,	a
	;mov	59h,	b
	
loop: 	mov	R0,	#0h
	mov	R1,	#0h
	mov	R2,	#0h
	mov	R3,	#0h
	mov	R4,	#0h
	mov	R7,	#0h
	mov	a, 	40h
	clr C
	lcall shift
	lcall shift
	lcall shift
main:	lcall check_ones
	lcall check_ones
	lcall check_ones
	lcall dziesiatki
	lcall dziesiatki
	mov	a,	41h
	lcall dziesiatki
	lcall setki
	lcall setki
	lcall setki
	lcall tysiace
	lcall tysiace
	lcall tysiace
	lcall dzies_tys
	mov	a,	42h
	lcall dzies_tys
	lcall dzies_tys
	lcall sto_tys
	lcall sto_tys
	lcall sto_tys
	lcall mln
	lcall mln
	lcall mln
	mov   	a,	43h
	lcall dzies_mln
	lcall dzies_mln
	lcall dzies_mln
	lcall sto_mln
	lcall sto_mln
	lcall sto_mln
	lcall mld
	lcall mld
	lcall przenies
	lcall loop
dziesiatki:
	lcall check_tens
	lcall check_ones
	RET
setki:
	lcall check_hundreds
	lcall dziesiatki
	RET
tysiace:
	lcall check_thousands
	lcall setki
	RET
dzies_tys:
	lcall ten_thousands
	lcall tysiace
	RET
sto_tys:
	lcall hundred_thousands
	lcall dzies_tys
	RET
mln:
	lcall millions
	lcall sto_tys
	RET
dzies_mln:
	lcall ten_millions
	lcall mln
	RET
sto_mln:
	lcall hundred_millions
	lcall dzies_mln
	RET
mld:
	lcall billions
	lcall sto_mln
	RET

check_ones:
	clr C
	mov	R7,	#0h
	mov	b,	a
	mov	a,	R0
	clr	a.0
	clr	a.1
	clr	a.2
	clr	a.3
	mov	R7,	a	;zapisuję górną połowę a
	mov	a,	R0	;jeszcze raz wczytuję rejestr R0 i czyszczę górną połowę
	clr 	a.7
	clr 	a.6
	clr	a.5
	clr 	a.4
	subb	a,	#05h
	jc	back
	add	a,	#03h
back:	add	a,	#05h
	add	a,	R7
	mov	R0,	a
	mov	a,	b
	lcall shift
	RET

check_tens:
	clr C
	mov	b,	a
	mov	a,	R0
	clr 	a.7
	clr 	a.6
	clr	a.5
	clr 	a.4
	mov	R7,	a
	mov	a,	R0
	clr	a.0
	clr	a.1
	clr	a.2
	clr	a.3
	subb	a,	#50h
	jc	bback
	add	a,	#30h
bback:  clr C
	add	a,	#50h
	add	a,	R7
	mov	R0,	a
	mov	a,	b
	RET

check_hundreds:
	clr C
	mov	R7,	#0h
	mov	b,	a
	mov	a,	R1
	clr	a.0
	clr	a.1
	clr	a.2
	clr	a.3
	mov	R7,	a
	mov	a,	R1	;jeszcze raz wczytuję rejestr R0 i czyszczę górną połowę
	clr 	a.7
	clr 	a.6
	clr	a.5
	clr 	a.4
	subb	a,	#05h
	jc	bbback
	add	a,	#03h
bbback:	add	a,	#05h
	add	a,	R7
	mov	R1,	a
	mov	a,	b
	RET
	
check_thousands:
	clr C
	mov	b,	a
	mov	a,	R1
	clr 	a.7
	clr 	a.6
	clr	a.5
	clr 	a.4
	mov	R7,	a
	mov	a,	R1
	clr	a.0
	clr	a.1
	clr	a.2
	clr	a.3
	subb	a,	#50h
	jc	back_1000
	add	a,	#30h
back_1000:
	add	a,	#50h
	add	a,	R7
	mov	R1,	a
	mov	a,	b
	RET

ten_thousands:
	clr C
	mov	R7,	#0h
	mov	b,	a
	mov	a,	R2
	clr	a.0
	clr	a.1
	clr	a.2
	clr	a.3
	mov	R7,	a	;zapisuję górną połowę a
	mov	a,	R2	;jeszcze raz wczytuję rejestr R0 i czyszczę górną połowę
	clr 	a.7
	clr 	a.6
	clr	a.5
	clr 	a.4
	subb	a,	#05h
	jc	back_10t
	add	a,	#03h
back_10t:
	add	a,	#05h
	add	a,	R7
	mov	R2,	a
	mov	a,	b
	RET

hundred_thousands:
	clr C
	mov	b,	a
	mov	a,	R2
	clr 	a.7
	clr 	a.6
	clr	a.5
	clr 	a.4
	mov	R7,	a
	mov	a,	R2
	clr	a.0
	clr	a.1
	clr	a.2
	clr	a.3
	subb	a,	#50h
	jc	back_100t
	add	a,	#30h
back_100t:  
	add	a,	#50h
	add	a,	R7
	mov	R2,	a
	mov	a,	b
	RET

millions:
	clr C
	mov	R7,	#0h
	mov	b,	a
	mov	a,	R3
	clr	a.0
	clr	a.1
	clr	a.2
	clr	a.3
	mov	R7,	a	;zapisuję górną połowę a
	mov	a,	R3	;jeszcze raz wczytuję rejestr R0 i czyszczę górną połowę
	clr 	a.7
	clr 	a.6
	clr	a.5
	clr 	a.4
	subb	a,	#05h
	jc	back_mln
	add 	a,	#03h
back_mln:
	add	a,	#05h
	add	a,	R7
	mov	R3,	a
	mov	a,	b
	RET

ten_millions:
	clr C
	mov	b,	a
	mov	a,	R3
	clr 	a.7
	clr 	a.6
	clr	a.5
	clr 	a.4
	mov	R7,	a
	mov	a,	R3
	clr	a.0
	clr	a.1
	clr	a.2
	clr	a.3
	subb	a,	#50h
	jc	back_10mln
	add	a,	#30h
back_10mln:
	add	a,	#50h
	add	a,	R7
	mov	R3,	a
	mov	a,	b
	RET

hundred_millions:
	clr C
	mov	R7,	#0h
	mov	b,	a
	mov	a,	R4
	clr	a.0
	clr	a.1
	clr	a.2
	clr	a.3
	mov	R7,	a	;zapisuję górną połowę a
	mov	a,	R4	;jeszcze raz wczytuję rejestr R0 i czyszczę górną połowę
	clr 	a.7
	clr 	a.6
	clr	a.5
	clr 	a.4
	subb	a,	#05h
	jc	back_100mln
	add	a,	#03h
back_100mln:
	add	a,	#05h
	add	a,	R7
	mov	R4,	a
	mov	a,	b
	RET

billions:
	clr C
	mov	b,	a
	mov	a,	R4
	clr 	a.7
	clr 	a.6
	clr	a.5
	clr 	a.4
	mov	R7,	a
	mov	a,	R4
	clr	a.0
	clr	a.1
	clr	a.2
	clr	a.3
	subb	a,	#50h
	jc	back_bln
	clr C
	add	a,	#30h
back_bln:
	add	a,	#50h
	add	a,	R7
	mov	R4,	a
	mov	a,	b
	RET

shift:	mov	b,	a
	mov	a,	R4
	clr C
	rlc	a
	mov	R4,	a
	mov	a,	R3
	clr C
	rlc	a
	jnc	r_R2
	inc	R4
r_R2:	mov	R3,	a
	mov	a,	R2
	clr C
	rlc	a
	jnc	r_R1
	inc	R3
r_R1:	mov	R2,	a
	mov	a,	R1
	clr C
	rlc	a
	jnc	r_R0
	inc	R2
r_R0:	mov	R1,	a
	mov	a,	R0
	clr C
	rlc	a
	jnc	r_a
	inc	R1
r_a:	mov	R0,	a
	mov	a,	b
	rlc	a
	jnc	bb
	inc	R0
bb:
	RET

przenies:
	mov 	a,	R0
	lcall wyczysc_gore
	mov	59h,	a
	mov 	a,	R0
	lcall wyczysc_dol
	lcall przerotuj
	mov	58h,	a
	mov 	a,	R1
	lcall wyczysc_gore
	mov	57h,	a
	mov 	a,	R1
	lcall wyczysc_dol
	lcall przerotuj
	mov	56h,	a
	mov 	a,	R2
	lcall wyczysc_gore
	mov	55h,	a
	mov 	a,	R2
	lcall wyczysc_dol
	lcall przerotuj
	mov	54h,	a
	mov 	a,	R3
	lcall wyczysc_gore
	mov	53h,	a
	mov 	a,	R3
	lcall wyczysc_dol
	lcall przerotuj
	mov	52h,	a
	mov 	a,	R4
	lcall wyczysc_gore
	mov	51h,	a
	mov 	a,	R4
	lcall wyczysc_dol
	lcall przerotuj
	mov	50h,	a
RET

wyczysc_gore:
	clr	a.7
	clr	a.6
	clr	a.5
	clr	a.4
RET

wyczysc_dol:
	clr 	a.3
	clr	a.2
	clr	a.1
	clr	a.0
RET

przerotuj:
        rr a
	rr a
	rr a
	rr a
	RET
END