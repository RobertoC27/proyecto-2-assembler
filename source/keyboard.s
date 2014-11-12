/******************************************************************************
*	keyboard.s
*	 by Alex Chadwick
*
*	A sample assembly code implementation of the input01 operating system.
*	See main.s for details.
*
*	keyboard.s contains code to do with the keyboard.
******************************************************************************/

.section .data
/* NEW
* The address of the keyboard we're reading from.
* C++ Signautre: u32 KeyboardAddress;
*/
.align 2
KeyboardAddress:
	.int 0
	
/* NEW
* The scan codes that were down before the current set on the keyboard.
* C++ Signautre: u16* KeyboardOldDown;
*/
KeyboardOldDown:
	.rept 6
	.hword 0
	.endr
	
/* NEW
* KeysNoShift contains the ascii representations of the first 104 scan codes
* when the shift key is up. Special keys are ignored.
* C++ Signature: char* KeysNoShift;
*/
.align 3
KeysNormal:
	.byte 0x0, 0x0, 0x0, 0x0, 'a', 'b', 'c', 'd'
	.byte 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l'
	.byte 'm', 'n', 'o', 'p', 'q', 'r', 's', 't'
	.byte 'u', 'v', 'w', 'x', 'y', 'z', '1', '2'
	.byte '3', '4', '5', '6', '7', '8', '9', '0'
	.byte '\n', 204, '\b', '\t', ' ', '-', '=', '['
	.byte ']', '\\', '#', ';', '\'', '`', ',', '.'
	.byte '/', 0x0, 160, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 255, 0x0, 0x0, 200
	.byte 201, 202, 203, 0x0, '/', '*', '-', '+'
	.byte '\n', '1', '2', '3', '4', '5', '6', '7'
	.byte '8', '9', '0', '.', '\\', 0x0, 0x0, '='
	
/* NEW
* KeysShift contains the ascii representations of the first 104 scan codes
* when the shift key is held. Special keys are ignored.
* C++ Signature: char* KeysShift;
*/
.align 3
KeysShift:
	.byte 0x0, 0x0, 0x0, 0x0, 'A', 'B', 'C', 'D'
	.byte 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L'
	.byte 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T'
	.byte 'U', 'V', 'W', 'X', 'Y', 'Z', '!', '"'
	.byte '£', '$', '%', '^', '&', '*', '(', ')'
	.byte '\n', 0x0, '\b', '\t', ' ', '_', '+', '{'
	.byte '}', '|', '~', ':', '@', '¬', '<', '>'
	.byte '?', 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, '/', '*', '-', '+'
	.byte '\n', '1', '2', '3', '4', '5', '6', '7'
	.byte '8', '9', '0', '.', '|', 0x0, 0x0, '='

.section .text
/* NEW
* Updates the keyboard pressed and released data.
* C++ Signature: void KeyboardUpdate();
*/
.globl KeyboardUpdate
KeyboardUpdate:
	push {r4,r5,lr}

	kbd .req r4
	ldr r0,=KeyboardAddress
	ldr kbd,[r0]
	
	teq kbd,#0
	bne haveKeyboard$

getKeyboard$:
	bl UsbCheckForChange
	bl KeyboardCount
	teq r0,#0	
	ldreq r1,=KeyboardAddress
	streq r0,[r1]
	beq return$

	mov r0,#0
	bl KeyboardGetAddress
	ldr r1,=KeyboardAddress
	str r0,[r1]
	teq r0,#0
	beq return$
	mov kbd,r0

haveKeyboard$:
	mov r5,#0

	saveKeys$:
		mov r0,kbd
		mov r1,r5
		bl KeyboardGetKeyDown

		ldr r1,=KeyboardOldDown
		add r1,r5,lsl #1
		strh r0,[r1]
		add r5,#1
		cmp r5,#6
		blt saveKeys$

	mov r0,kbd
	bl KeyboardPoll
	teq r0,#0
	bne getKeyboard$

return$:
	pop {r4,r5,pc} 
	.unreq kbd
	
/* NEW
* Returns r0=0 if a in r1 key was not pressed before the current scan, and r0
* not 0 otherwise.
* C++ Signature bool KeyWasDown(u16 scanCode)
*/
.globl KeyWasDown
KeyWasDown:
	ldr r1,=KeyboardOldDown
	mov r2,#0

	keySearch$:
		ldrh r3,[r1]
		teq r3,r0
		moveq r0,#1
		moveq pc,lr

		add r1,#2
		add r2,#1
		cmp r2,#6
		blt keySearch$

	mov r0,#0
	mov pc,lr
	
/* NEW
* Returns the ascii character last typed on the keyboard, with r0=0 if no 
* character was typed.
* C++ Signature char KeyboardGetChar()
*/
.globl KeyboardGetChar
KeyboardGetChar:	
	ldr r0,=KeyboardAddress
	ldr r1,[r0]
	teq r1,#0
	moveq r0,#0
	moveq pc,lr

	push {r4,r5,r6,lr}
	
	kbd .req r4
	key .req r6

	mov r4,r1	
	mov r5,#0

	keyLoop$:
		mov r0,kbd
		mov r1,r5
		bl KeyboardGetKeyDown

		teq r0,#0
		beq keyLoopBreak$
		
		mov key,r0
		bl KeyWasDown
		teq r0,#0
		bne keyLoopContinue$

		cmp key,#104
		bge keyLoopContinue$

		mov r0,kbd
		bl KeyboardGetModifiers

		tst r0,#0b00100010
		ldreq r0,=KeysNormal
		ldrne r0,=KeysShift

		ldrb r0,[r0,key]
		teq r0,#0
		bne keyboardGetCharReturn$

	keyLoopContinue$:
		add r5,#1
		cmp r5,#6
		blt keyLoop$
		
	keyLoopBreak$:
	mov r0,#0		
keyboardGetCharReturn$:
	pop {r4,r5,r6,pc}
	.unreq kbd
	.unreq key

/*
subrutina que se encarga de distinguir si alguna de las teclas asignadas 
por el usuario está presionada
RECIBE COMO PARAMETROS:
r0-> caracter que se se lee del teclado
DEVUELVE:
r0 -> el caracter leído
r4-> posicion x del cursor
r5-> posicion y del cursor
*/
.globl teclas_personalizadas
teclas_personalizadas:
	push {lr}
	push {r6-r10}
	caracter .req r6
	mov caracter,r0
	
	
	@en la tabla de keyboard.s reemplaze el caracter de f1 por el #160 que no es utilizado
	@en la tabla ascii y devuelve ese numero para hacer la comparacion
	F1:
	cmp caracter,#160
	bne ENTER
	addeq r8,r8,#768
	moveq r0,r8
	bleq SetForeColour
	b salida
	
	ENTER:
	cmp caracter,#'\n'
	bne SUPR
	moveq r4,#0
	addeq r5,#16
	b salida
	
	SUPR:
	@en la tabla de keyboar.s reemplaze el caracter de supr por el #255 que no es utilizado
	@en la tabla ascii y devuelve ese numero para hacer la comparacion
	cmp caracter,#255
	bne TAB
	moveq r9,#1 @bandera 
	ldreq r0,=0
	bleq SetForeColour	@cambiar el color de escritura a negro para repintar la pantalla
	cmp r9,#1
	moveq r0,#0
	moveq r1,#0
	moveq r2,#1024
	moveq r3,#768 
	bleq dibujarRectangulo @dibujar un rectangulo con las dimensiones totales de la pantalla
	cmp r9,#1
	moveq r4,#0
	moveq r5,#0
	moveq r9,#0
	ldreq r0,=65535
	bleq SetForeColour @regresar el color a blanco para imprimir las letras
	b salida
	
	TAB:
	cmp caracter,#'\t'
	bne salida
	moveq r9,#1
	moveq r4,r0
	ldreq r0,=0
	bleq SetForeColour @escoger negro para pintar la franja de la pantalla
	cmp r9,#1
	moveq r0,#0
	moveq r1,r5
	ldreq r2,=1024
	add r7,r5,#16 @sumar la altura de los carateres caracter a la linea actual
	moveq r3,r7
	bleq dibujarRectangulo @dibujar un rectangulo con las dimensiones de el espacio que se escribe en ese momento
	cmp r9,#1
	moveq r4,#0
	moveq r9,#0
	ldreq r0,=65535
	bleq SetForeColour @regresar el color a blanco para imprimir las letras
	
	salida:
	mov r0,caracter
	pop {r6-r10}
	pop {pc}
	.unreq caracter
	