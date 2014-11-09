.globl leerComando
leerComando:
	push {lr}
	push {r4-r12}
	@lecturaCommand:
	ldr r0,=command
	mov r1,#commandEnd-command
	bl ReadLine
	teq r0,#0
	beq loopContinue$
	mov r4,r0
	
	ldr r5,=command
	ldr r6,=commandTable
	
	ldr r7,[r6,#0]
	ldr r9,[r6,#4]
	commandLoop$:
		ldr r8,[r6,#8]
		sub r1,r8,r7

		cmp r1,r4
		bgt commandLoopContinue$

		mov r0,#0	
		commandName$:
			ldrb r2,[r5,r0]
			ldrb r3,[r7,r0]
			teq r2,r3			
			bne commandLoopContinue$
			add r0,#1
			teq r0,r1
			bne commandName$

		ldrb r2,[r5,r0]
		teq r2,#0
		teqne r2,#' '
		bne commandLoopContinue$

		mov r0,r5
		mov r1,r4
		mov lr,pc
		mov pc,r9
		b loopContinue$

	commandLoopContinue$:
		add r6,#8
		mov r7,r8
		ldr r9,[r6,#4]
		teq r9,#0
		bne commandLoop$	

	ldr r0,=commandUnknown
	mov r1,#commandUnknownEnd-commandUnknown
	ldr r2,=formatBuffer
	ldr r3,=command
	bl FormatString

	mov r1,r0
	ldr r0,=formatBuffer
	bl Print
	
	loopContinue$:
	bl TerminalDisplay
	bl TerminalClear
	b finCommand
	
	juego:
	ldr r0,=pruebajuego
	mov r1,#pruebajuegoEnd-pruebajuego
	bL Print
	b finCommand
	
	instrucciones:
	ldr r0,=pruebainstrucciones
	mov r1,#pruebainstruccionesEnd-pruebainstrucciones
	bL Print
	b finCommand
	
	vocalnumero:
	ldr r0,=pruebainstrucciones
	mov r1,#pruebainstruccionesEnd-pruebainstrucciones
	bL Print
	
	finCommand:
	pop {r4-r12}
	pop {pc}

.section .data
.align 2
welcome:
	.ascii "Bienvenido al juego de Pokémon UVG"
welcomeEnd:
.align 2
pruebainstrucciones:
	.ascii "instrucciones buenas"
pruebainstruccionesEnd:
.align 2
pruebajuego:
	.ascii "juego bueno"
pruebajuegoEnd:
.align 2
prompt:
	.ascii "\n> "
promptEnd:
.align 2
command:
	.rept 128
		.byte 0
	.endr
commandEnd:
.byte 0
.align 2
commandUnknown:
	.ascii "Command `%s' was not recognised.\n"
commandUnknownEnd:
.align 2
formatBuffer:
	.rept 256
	.byte 0
	.endr
formatEnd:
.align 2
commandStringjuego: .ascii "juego"
commandStringvocalnumero: .ascii "vocalnumero"
@commandStringinstrucciones: .ascii "instrucciones"
commandStringEnd:
.align 2
commandTable:
.int commandStringjuego, juego
@.int commandStringintrucciones, instrucciones
.int commandStringvocalnumero, vocalnumero
.int commandStringEnd, 0
