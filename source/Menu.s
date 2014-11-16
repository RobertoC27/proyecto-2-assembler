/*
Roberto Chiroy -13027
Angel Morales - 13332
archivo fuente para el proyecto #2 de assembler 
subrutinas para los diferentes menús que el usuario debe usar
*/
.macro dibujarImagen dir
	ldr r0,=imagen\dir
	ldr r1,=alto\dir
	bl DibujarPersonaje
.endm
.macro inputCar
	bl KeyboardUpdate
	bl KeyboardGetChar
.endm
.macro banderaPosicion num,var
mov r1,\num
ldr r0,=\var
str r1,[r0]
.endm
.macro DibujarBatalla dificultad,fondo
	mov r0,\fondo
	bl DibujarFondo
.endm
/*
subrutina que sirve para escoger una opcion en el menú de batalla
no recibe parámetros 
ni devuelve nada
*/
.globl MenuPelea
MenuPelea:
	push {lr}
	caracter .req r4
	direccion .req r8
	push {r4-r12}
	banderaPosicion #0,opcionMenu
	
	ent:
	inputCar
	cmp r0,#0
	beq ent
	mov caracter,r0
	cmp caracter,#'\n'
	beq salidaMenu @solo sale de la rutina si presiona enter
	
	pelear:
	cmp caracter,#'0'
	bne pokeball
	banderaPosicion #0,opcionMenu @cambiar el valor de la bandera 
	b ent
	
	pokeball:
	cmp caracter,#'1'
	bne huir
	banderaPosicion #1,opcionMenu
	b ent
	
	huir:
	cmp caracter,#'2'
	bne ent
	banderaPosicion #2,opcionMenu
	b ent
	
	salidaMenu:
		ldr r8,=opcionMenu
		ldr r8,[r8]
	@dibujar la accion correspondiente a la tecla presionada
	pelea:	
		cmp r8,#0
		bne atrapar
		dibujarImagen atras2
		b fin
	
	atrapar:
		cmp r8,#1
		bne huida
		dibujarImagen derecha2
		b fin
	
	huida:
		cmp r8,#2
		dibujarImagen izquierda
		b fin
	
	fin:
	pop {r4-r12}
	.unreq caracter
	.unreq direccion
	pop {pc}


/*
subrutina que permite al usuario escoger la dificultad en la que quiere jugar
no recibe parametros
ni devuelve nada
*/
.globl EscogerDificultad
EscogerDificultad:
	push {lr}
	caracter .req r4
	push {r4-r12}
	
	dibujarImagen easy
	banderaPosicion #0,posDific
	
	ingreso:
	inputCar
	cmp r0,#0
	beq ingreso
	mov caracter,r0
	cmp caracter,#'\n'
	bne arribaDif
	b salidaDif @solo sale de la rutina si presiona enter
	
	arribaDif:
	cmp caracter,#203
	bne abajoDif
	dibujarImagen easy
	banderaPosicion #0,posDific
	b ingreso
	
	abajoDif:
	cmp caracter,#202
	bne ingreso
	dibujarImagen hard
	banderaPosicion #1,posDific
	b ingreso
	
	salidaDif:
	ldr r5,=posDific
	ldr r5,[r5]
	cmp r5,#0
	moveq r0,#'3'
	bleq DibujarFondo
	
	ldr r5,=posDific
	ldr r5,[r5]
	cmp r5,#1
	moveq r0,#'4'
	bleq DibujarFondo
	
	pop {r4-r12}
	.unreq caracter
	pop {pc}

.globl Facil	
Facil:
	push {lr}
	push {r4-r12}
	DibujarBatalla facil,#'5'
	bl MenuPelea
	
	pop {r4-r12}
	pop {pc}
	
.globl Dificil
Dificil:
	push {lr}
	push {r4-r12}
	DibujarBatalla dificil,#'6'
	bl MenuPelea
	
	
	pop {r4-r12}
	pop {pc}
	
.section .data
.align 2
@bandera para la dificultad 
@0-> facil
@1-> dificil
.globl posDific
posDific: .int 0
.globl opcionMenu
opcionMenu: .int 0

