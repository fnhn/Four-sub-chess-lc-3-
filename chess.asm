.ORIG x3000



;init

		LD R0, table
		AND R1, R1, #0
		LD R2, empty
AGAIN1		ADD R3, R0, R1
		STR R2, R3, #0
		LD R3, negnum36
		ADD R1, R1, #1
		ADD R3, R3, R1
		BRnz AGAIN1
		
;print
GLOBAL_LOOP	JSR PRINT

;output a message
		
INPUT_AGAIN	LEA R0, message
		TRAP x22


;get a character from keyboard and display it on the screen, the character is saved in R1

		TRAP x20
		ADD R1, R0, #0
		TRAP x21
		AND R0, R0, #0
		ADD R0, R0, #10
		TRAP x21

;change the character to num, save in R6
		
		LD R0, negnum48
		ADD R6, R1, R0
		ADD R0, R6, #-6
		BRnz END700
		LEA R0, win_message4
		TRAP x22
		BRnzp INPUT_AGAIN
	END700	ADD R0, R6, #0
		BRp END800
		LEA R0, win_message4
		TRAP x22
		BRnzp INPUT_AGAIN

END800		NOP
		
;change the table content according to the col number(R6)
		
		LD R1, table
		LD R2, num29
		ADD R2, R2, R6

AGAIN3		ADD R2, R2, #0
		BRn END2
		ADD R0, R1, R2
		LDR R0, R0, #0
		ADD R2, R2, #-6
		LD R3, negempty
		ADD R3, R3, R0
		BRnp AGAIN3
		ADD R2, R2, #6
		ADD R0, R1, R2

		ST R2, SAVE_INDEX			;save the index in SAVE_INDEX

		LD R4, player
		BRp SYM2
		LD R3, X
		STR R3, R0, #0
		BRnzp END900
SYM2		LD R3, O
		STR R3, R0, #0	
		BRnzp END900
		
END2		LEA R0, win_message4
		TRAP x22
		JSR INPUT_AGAIN

END900 		NOP

;check

	JSR CHECK

		
;change the player
		
		LD R0, player
		BRz SYM3
		AND R0, R0, #0
		ST R0, player
		BRnzp END3
SYM3		ADD R0, R0, #1
		ST R0, player
END3		NOP
		

BRnzp GLOBAL_LOOP

GLOBAL_END1 	JSR PRINT
		LEA R0, win_message1
		BRnzp GLOBAL_END

GLOBAL_END2	JSR PRINT
		LEA R0, win_message2
		BRnzp GLOBAL_END

GLOBAL_END_TIE	JSR PRINT
		LEA R0, win_message3

GLOBAL_END 	TRAP x22
		HALT




table 		.FILL 		x4200
empty 		.FILL 		#45		; ascii '-' 
negnum36 	.FILL		#-36
space 		.FILL 		#32
message 	.STRINGZ 	"Input a col number:"
negnum48 	.FILL 		#-48
num29 		.FILL 		#29
negempty 	.FILL 		#-45
player 		.FILL 		#0
X 		.FILL 		#88
O 		.FILL 		#79
negX 		.FILL		#-88
negO 		.FILL 		#-79

SAVE_INDEX 	.FILL 		#0
win_message1 	.STRINGZ 	"Player X win.\n"
win_message2 	.STRINGZ 	"Player O win.\n"
win_message3	.STRINGZ	"Tie Game.\n"
win_message4	.STRINGZ	"Invalid input.\n"
count		.FILL		#-36


;print
PRINT		ST R7, SAVE_R7
		LD R1, table
		AND R6, R6, #0
		AND R5, R5, #0
		ADD R5, R5, #1
		ADD R6, R6, #6
		AND R4, R4, #0
		
AGAIN2		ADD R0, R1, R4
		LDR R0, R0, #0
		TRAP x21
		AND R0, R0, #0
		LD R0, space
		TRAP x21
		ADD R0, R5, #-6
		BRn SYM1
		AND R0, R0, #0
		ADD R0, R0, #10
		TRAP x21
		AND R5, R5, #0
		ADD R6, R6, #-1
		BRnz END1
SYM1		ADD R4, R4, #1
		ADD R5, R5, #1
		BR AGAIN2

END1 		LD R7, SAVE_R7
		RET



	
GLOBAL_END1_T 		BRnzp GLOBAL_END1
GLOBAL_END2_T		BRnzp GLOBAL_END2
GLOBAL_END_TIE_T 	BRnzp GLOBAL_END_TIE

;R6 count X
;R7 count O
;R5 index
;R4 col
;R3 row
;R1 current index
CHECK		ST R7, SAVE_R7
		AND R6, R6, #0
		AND R7, R7, #0
		

	
;first check the row
		LD R5, SAVE_INDEX
		ADD R0, R5, #0

		
	LOOP1	ADD R0, R0, #-6
		BRzp LOOP1
		ADD R0, R0, #6
		ADD R4, R0, #0

	LOOP3	ADD R0, R4, #-5
		BRz END100
		ADD R4, R4, #1
		ADD R5, R5, #1
		BRnzp LOOP3		;move col to the right

	END100 NOP
		
		LD R0, table
		ADD R5, R5, R0
		ADD R1, R5, #0
		
	LOOP2	LD R0, negX
		LDR R2, R1, #0
		ADD R0, R0, R2
		BRnp SYM4
		ADD R6, R6, #1
		BRnzp END4
	SYM4	AND R6, R6, #0
		BRnzp SYM5


	END4	ADD R0, R6, #-4
		BRz GLOBAL_END1
		
	SYM5	LD R0, negO
		LDR R2, R1, #0
		ADD R0, R0, R2
		BRnp SYM8
		ADD R7, R7, #1
		BRnzp END6
	SYM8	AND R7, R7, #0
		BRnzp SYM11

	END6	ADD R0, R7, #-4
		BRz GLOBAL_END2


	SYM11	ADD R1, R1, #-1
		ADD R4, R4, #-1
		BRzp LOOP2


;check the col

		LD R5, SAVE_INDEX
		ADD R0, R5, #0
		AND R3, R3, #0
		AND R6, R6, #0
		AND R7, R7, #0
		
	LOOP4	ADD R3, R3, #1
		ADD R0, R0, #-6
		BRzp LOOP4
		ADD R3, R3, #-1		;R3 is the row

		
	LOOP5	ADD R0, R3, #-5
		BRz END200
		ADD R3, R3, #1
		ADD R5, R5, #6
		BRnzp LOOP5		;move row to the bottom

	END200	 NOP
		
		LD R0, table
		ADD R5, R5, R0
		ADD R1, R5, #0
		
	LOOP6	LD R0, negX
		LDR R2, R1, #0
		ADD R0, R0, R2
		BRnp SYM6
		ADD R6, R6, #1
		BRnzp END5
	SYM6	AND R6, R6, #0
		BRnzp SYM7
	END5	ADD R0, R6, #-4
		BRz GLOBAL_END1
		
	SYM7	LD R0, negO
		LDR R2, R1, #0
		ADD R0, R0, R2
		BRnp SYM12
		ADD R7, R7, #1
		BRnzp END12
	SYM12	AND R7, R7, #0
		BRnzp SYM13

	END12	ADD R0, R7, #-4
		BRz GLOBAL_END2


	SYM13	ADD R1, R1, #-6
		ADD R3, R3, #-1
		BRzp LOOP6


;check \

		LD R5, SAVE_INDEX
		ADD R0, R5, #0
		AND R3, R3, #0
		AND R6, R6, #0
		AND R7, R7, #0
		
	LOOP300	ADD R3, R3, #1
		ADD R0, R0, #-6
		BRzp LOOP300
		ADD R3, R3, #-1		;R3 is the row
		ADD R4, R0, #6		;R4 is the col

		
	LOOP301	ADD R0, R3, #-5
		BRz END300
		ADD R0, R4, #-5
		BRz END300
		ADD R3, R3, #1
		ADD R4, R4, #1
		ADD R5, R5, #7
		BRnzp LOOP301		;move row to the bottom_right

	END300	 NOP
		
		LD R0, table
		ADD R5, R5, R0
		ADD R1, R5, #0
		
	LOOP306	LD R0, negX
		LDR R2, R1, #0
		ADD R0, R0, R2
		BRnp SYM306
		ADD R6, R6, #1
		BRnzp END305
	SYM306	AND R6, R6, #0
		BRnzp SYM307
	END305	ADD R0, R6, #-4
		BRz GLOBAL_END1
		
	SYM307	LD R0, negO
		LDR R2, R1, #0
		ADD R0, R0, R2
		BRnp SYM312
		ADD R7, R7, #1
		BRnzp END312
	SYM312	AND R7, R7, #0
		BRnzp SYM313

	END312	ADD R0, R7, #-4
		BRz GLOBAL_END2


	SYM313	ADD R1, R1, #-7
		ADD R3, R3, #-1
		BRn END320
		ADD R4, R4, #-1
		BRn END320
		BRnzp LOOP306

	END320 	NOP

		
		
;check /

		LD R5, SAVE_INDEX
		ADD R0, R5, #0
		AND R3, R3, #0
		AND R6, R6, #0
		AND R7, R7, #0
		
	LOOP400	ADD R3, R3, #1
		ADD R0, R0, #-6
		BRzp LOOP400
		ADD R3, R3, #-1		;R3 is the row
		ADD R4, R0, #6		;R4 is the col

		
	LOOP401	ADD R0, R3, #-5
		BRz END400
		ADD R0, R4, #0
		BRz END400
		ADD R3, R3, #1
		ADD R4, R4, #-1
		ADD R5, R5, #5
		BRnzp LOOP401		;move row to the bottom_left

	END400	 NOP
		
		LD R0, table1
		ADD R5, R5, R0
		ADD R1, R5, #0
		
	LOOP406	LD R0, negX
		LDR R2, R1, #0
		ADD R0, R0, R2
		BRnp SYM406
		ADD R6, R6, #1
		BRnzp END405
	SYM406	AND R6, R6, #0
		BRnzp SYM407
	END405	ADD R0, R6, #-4
		BRz GLOBAL_END1_T
		
	SYM407	LD R0, negO
		LDR R2, R1, #0
		ADD R0, R0, R2
		BRnp SYM412
		ADD R7, R7, #1
		BRnzp END412
	SYM412	AND R7, R7, #0
		BRnzp SYM413

	END412	ADD R0, R7, #-4
		BRz GLOBAL_END2_T


	SYM413	ADD R1, R1, #-5
		ADD R3, R3, #-1
		BRn END420
		ADD R4, R4, #1
		ADD R0, R4, #-6
		BRz END420
		BRnzp LOOP406

	END420 	NOP


;tie game check
		LD R0, count
		ADD R0, R0, #1
		BRz GLOBAL_END_TIE_T
		ST R0, count
		
;return
		LD R7, SAVE_R7
		RET

SAVE_R7 	.FILL 		#0
table1		.FILL		x4200


.END