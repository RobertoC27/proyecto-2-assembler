/*
Roberto Chiroy -13027
Angel Morales - 13332
archivo fuente para el proyecto #2 de assembler 
subrutinas para dibujar personajes y fondos en pantalla
*/
.macro guardarX x
	ldr r0,=posBrendanx
	mov r1,\x
	str r1,[r0]
.endm
.macro guardarY y
	ldr r0,=posBrendany
	str \y,[r0]
.endm
/*
subrutina que dibuja el fondo completo en la pantalla
parametros:
r0-> numero de la imagen de fondo a dibujar
1 es la cueva
2 es el mewtwo
*/
.globl DibujarFondo
DibujarFondo:
	caracter .req r7
	posicionFondo .req r8
	dimensionesFondo .req r9
	fondo .req r10
	push {lr}
	push {r4-r12}
	mov caracter, r0
	cmp caracter,#'1'
	bne mewtwo
	ldr posicionFondo, =posFondox
	ldr dimensionesFondo, =altocueva
	ldr fondo, =imagencueva
	ldr r0,[posicionFondo] // Posicion en x
	ldr r1,[posicionFondo,#4] // Posicion en y
	ldrh r2,[dimensionesFondo,#2] // Ancho 
	ldrh r3,[dimensionesFondo] // Alto
	push {fondo}
	bl drawImage
	b finDib
	mewtwo:
	cmp caracter,#'2'
	bne finDib
	ldr posicionFondo, =posFondox
	ldr dimensionesFondo, =altostartscreen_uvg
	ldr fondo, =imagenstartscreen_uvg
	ldr r0,[posicionFondo] // Posicion en x
	ldr r1,[posicionFondo,#4] // Posicion en y
	ldrh r2,[dimensionesFondo,#2] // Ancho 
	ldrh r3,[dimensionesFondo] // Alto
	push {fondo}
	bl drawImage
	finDib:
	pop {r4-r12}
	pop {pc}
	.unreq posicionFondo
	.unreq dimensionesFondo
	.unreq fondo
	.unreq caracter
/*
subrutina que dibuja al personaje de frente (viendo hacia afuera de la pantalla)
parámetros:
posicion x inicial @cargado de la etiqueta posBrendanx
posicion y inicial @cargado de la etiqueta posBrendanx
r0->direccion de la imagen a cargar
r1-->direccion del alto de la imagen
*/	
.globl DibujarPersonaje
DibujarPersonaje:
	posx .req r4
	posy .req r5
	dimensionesBrendan .req r6
	iBrendan .req r7
	push {lr}
	push {r4-r12}
	ldr posx,=posBrendanx
	ldr posx,[posx]
	ldr posy,=posBrendany
	ldr posy,[posy]
	mov iBrendan,r0 @cargar la direccion de la imagen
	mov dimensionesBrendan,r1 @cargar el alto de la imagen
	
	// Dibuja Brendan
	mov r0, posx // Posicion en x
	mov r1, posy // Posicion en y
	ldrh r2, [dimensionesBrendan,#2] // Ancho 
	ldrh r3, [dimensionesBrendan] // Alto
	push {iBrendan}
	bl drawImage
	
	add posx,#5
	guardarX posx
	
	pop {r4-r12}
	pop {pc}
	.unreq posx
	.unreq posy
	.unreq dimensionesBrendan
	.unreq iBrendan


.macro coordenadas x,y
	mov r0,\x
	mov r1,\y
.endm
.macro pausa
	ldr r0,=100000
	bl Wait
.endm
.macro rectangulo x0,y0,ancho,alto
	mov r0,\x0
	mov r1,\y0
	mov r2,\ancho
	mov r3,\alto
	bl dibujarRectangulo
.endm
/*
subrutina que hace la animacion de caminar del personaje
parametros:
en las etiquetas
posBrendanx
posBrendany
las coordenadas para dibujar el personaje
*/
.global CaminarDerecha
	CaminarDerecha:
	push {lr}
	push {r4-r12}
	posx .req r4
	posy .req r5
	dimensionesBrendan .req r6
	iBrendan .req r7
	@ posx final -> 503
	
	@cargar las posiciones iniciales de donde dibujar
	ldr posx,=posBrendanx
	ldr posx,[posx]
	ldr posy,=posBrendany
	ldr posy,[posy]
	
	dibujos:
		pausa
		paso1:
		ldr dimensionesBrendan, =altoderecha
		ldr iBrendan, =imagenderecha
		coordenadas posx,posy
		ldrh r2, [dimensionesBrendan,#2] // Ancho 
		ldrh r3, [dimensionesBrendan] // Alto
		push {iBrendan}
		bl drawImage
		@rectangulo posx,posy,#5,#24
		add posx,#5
		
		
		pausa
		paso2:
		ldr dimensionesBrendan, =altoderecha1
		ldr iBrendan, =imagenderecha1
		coordenadas posx,posy
		ldrh r2, [dimensionesBrendan,#2] // Ancho 
		ldrh r3, [dimensionesBrendan] // Alto
		push {iBrendan}
		bl drawImage
		@rectangulo posx,posy,#5,#24
		add posx,#5
		
		
		pausa
		paso3:
		ldr dimensionesBrendan, =altoderecha2
		ldr iBrendan, =imagenderecha2
		coordenadas posx,posy
		ldrh r2, [dimensionesBrendan,#2] // Ancho 
		ldrh r3, [dimensionesBrendan] // Alto
		push {iBrendan}
		bl drawImage
		@rectangulo posx,posy,#5,#24
		
		add posx,#5
		ldr r0,=posBrendanx
		str posx,[r0]
		
	pop {r4-r12}
	pop {pc}
	.unreq posx
	.unreq posy
	.unreq dimensionesBrendan
	.unreq iBrendan
/*
subrutina que se encarga de hacer acciones segun la tecla presionada
parámetros:
r0->caracter ingresado
*/
.globl leerTeclas
leerTeclas:
	caracter .req r6
	push {lr}
	push {r4-r12}
	mov caracter,r0
	enter:
		cmp caracter,#'\n'
		bne derecha
		mov r0,#'1'
		bl DibujarFondo
		b leerteclasfin
		
	derecha:
		cmp caracter,#200
		bne izq
		ldr r0,=imagenderecha @direccion de la imagen
		ldr r1,=altoderecha @alto de la imagen
		bl DibujarPersonaje
		b leerteclasfin
	izq:
		cmp caracter,#201
		bne arri
		ldr r0,=imagenizquierda @direccion de la imagen
		ldr r1,=altoizquierda @alto de la imagen
		bl DibujarPersonaje
		b leerteclasfin
		
	arri:
		cmp caracter,#202
		bne abaj
		ldr r0,=imagenfrente @direccion de la imagen
		ldr r1,=altofrente @alto de la imagen
		bl DibujarPersonaje
		b leerteclasfin
	abaj:
		cmp caracter,#203
		bne leerteclasfin
		ldr r0,=imagenatras @direccion de la imagen
		ldr r1,=altoatras @alto de la imagen
		bl DibujarPersonaje
		
	leerteclasfin:
	pop {r4-r12}
	pop {pc}
.section .data
.align 2
posFondox:	.int 0
posFondoy:	.int 0
@variable que contiene la posicion x donde dibujar la esquina superior izq de la image
.globl posBrendanx
	posBrendanx:	.int	700
@variable que contiene la posicion y donde dibujar la esquina superior izq de la image
.globl posBrendany
	posBrendany:	.int	467
