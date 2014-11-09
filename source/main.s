/*
Roberto Chiroy -13027
Angel Morales - 13332
archivo fuente para el proyecto #2 de assembler 
main encargado interaccion con el usuario
*/
.section .init
.globl _start
_start:

b main
.macro asignarx x
	ldr r0,=posBrendanx
	mov r1,\x
	str r1,[r0]
.endm
.macro asignary y
	ldr r0,=posBrendany
	mov r1,\y
	str r1,[r0]
.endm
.macro leerCaracter
	bl KeyboardUpdate
	bl KeyboardGetChar
.endm
.section .text

main:

	mov sp,#0x8000

	mov r0,#1024
	mov r1,#768
	mov r2,#16
	bl InitialiseFrameBuffer

	teq r0,#0
	bne noError$
	mov r0,#16
	mov r1,#1
	bl SetGpioFunction

	mov r0,#16
	mov r1,#0
	bl SetGpio

	error$:
		b error$

	noError$:

	bl SetGraphicsAddress

	bl UsbInitialise
	
reset$:
	mov sp,#0x8000
	dib:
	mov r0,#'2'
	bl DibujarFondo
	
	@DIBUJAR EL FONDO Y EL PERSONAJE EN LA POSICION INICIAL
		
		lec1:
		leerCaracter
		cmp r0,#0
		beq lec1
		bl leerTeclas
		
		ya:
		ldr r0,=imagenizquierda @direccion de la imagen
		ldr r1,=altoizquierda @alto de la imagen
		bl DibujarPersonaje
		
		mov r0,#200
		mov r1,#200
		mov r2,#18
		mov r3,#24
		bl dibujarRectangulo
		asignarx #300
		asignary #600
		bl CaminarDerecha
		
		asignarx #800
		asignary #200
		mov r5,#0
		cicl:
		bl CaminarDerecha
		cmp r5,#1
		addlt r5,#1
		blt cicl
		
		asignarx #100
		asignary #100
		leerCaracter
		bl leerTeclas
	b dib
	
	end$:
	b end$



.section .data
.align 2
posFondox:	.int 0
posFondoy:	.int 0
posFondoPx: .int 503
posFondoPy: .int 467
posBrendanyFinal:	.int	155
