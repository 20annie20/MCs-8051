ORG 0000h			
	ljmp	start		

ORG 0003h
	ljmp 	ext_int

ORG 000Bh
	ljmp 	inc_count

ORG 0100h
start:	
	mov TMOD, #01h 	;tryb 16b
	setb EX0
	setb EA
	setb IT0
	setb ET0
	mov a, #0h
	mov b, #0h
loop:	ljmp loop

ORG 2000h
ext_int:
	call zmierz_czas
	call wlacz_timer
	clr IE0
	RETI

inc_count:
	inc a
	mov TL0, #017h
	mov TH0, #0FCh
	JNB a.7, wroc
	inc b
	mov a, #0h
wroc:	RETI

zmierz_czas:
	JNB B.0, przenies
	add a, #128d
przenies:
	mov R4, a
	mov a, b
	rr a
	mov R5, a
	RET
	
wlacz_timer:
	setb TR0
	mov TL0, #017h
	mov TH0, #0FCh
	clr a
	RET

;-------------------------------------------------------------------------------

END