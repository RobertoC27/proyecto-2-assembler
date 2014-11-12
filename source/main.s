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
@macro que asigna el valor indicado en la etiqueta para la posicion x del personaje
.macro asignarx x
	ldr r0,=posBrendanx
	mov r1,\x
	str r1,[r0]
.endm
@macro que asigna el valor indicado en la etiqueta para la posicion y del personaje
.macro asignary y
	ldr r0,=posBrendany
	mov r1,\y
	str r1,[r0]
.endm
@macro que se encarga de leer el caracter presionado por el usuario
.macro leerCaracter
	bl KeyboardUpdate
	bl KeyboardGetChar
.endm
.macro dibujarImagen x,y
	ldr r0,=\x
	ldr r1,=\y
	bl DibujarPersonaje
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
	
	@ el 2 indica que debe pintar la imagen de bienvenida al juego
	
	mov r0,#'2'
	bl DibujarFondo
	bl leerTeclas
	asignarx #100
	asignary #110
	dibujarImagen imagenfrente,altofrente
	
	@DIBUJAR EL FONDO Y EL PERSONAJE EN LA POSICION INICIAL
	dib:
		@ leer el caracter ingresado por el usuario
		
		asignarx #0
		asignary #0
		bl Dificultad
		
		asignarx #400
		asignary #400
		bl Menu
		
		asignarx #900
		asignary #600
		bl leerTeclas
		ldr r0,=1000000
		bl Wait
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
