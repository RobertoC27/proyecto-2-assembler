/*
Roberto Chiroy -13027
Angel Morales - 13332
archivo fuente para el proyecto #2 de assembler 
subrutinas para dibujar personajes y fondos en pantalla
*/
@macro que guarda el valor indicado en la etiqueta para la posicion x del personaje
.macro guardarX x
	ldr r0,=posBrendanx
	mov r1,\x
	str r1,[r0]
.endm
@macro que guarda el valor indicado en la etiqueta para la posicion x del personaje
.macro guardarY y
	ldr r0,=posBrendany
	str \y,[r0]
.endm
@macro que dibuja la imagen con direccion (X) y alto (Y)
.macro dibujarImagen x,y
	ldr r0,=\x
	ldr r1,=\y
	bl DibujarPersonaje
.endm
.macro cargarImagen nombre,registro
	ldr \registro,=nombre
.endm
/*
subrutina que dibuja el fondo completo en la pantalla
parametros:
r0-> numero de la imagen de fondo a dibujar
1 es la cueva
2 es el mewtwo
3 es fondo facil
4 es fondo dificil
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
	
	mewtwo:
	cmp caracter,#'2'
	bne fondoFacil
	ldr posicionFondo, =posFondox
	ldr dimensionesFondo, =altostartscreen_uvg
	ldr fondo, =imagenstartscreen_uvg
	ldr r0,[posicionFondo] // Posicion en x
	ldr r1,[posicionFondo,#4] // Posicion en y
	ldrh r2,[dimensionesFondo,#2] // Ancho 
	ldrh r3,[dimensionesFondo] // Alto
	push {fondo}
	bl drawImage
	b finDib
	
	fondoFacil:
	cmp caracter,#'3'
	bne fondoDificil
	ldr posicionFondo, =posFondox
	ldr dimensionesFondo, =altocampomesprit
	ldr fondo, =imagencampomesprit
	ldr r0,[posicionFondo] // Posicion en x
	ldr r1,[posicionFondo,#4] // Posicion en y
	ldrh r2,[dimensionesFondo,#2] // Ancho 
	ldrh r3,[dimensionesFondo] // Alto
	push {fondo}
	bl drawImage
	b finDib
	
	fondoDificil:
	cmp caracter,#'4'
	bne peleaFacil
	ldr posicionFondo, =posFondox
	ldr dimensionesFondo, =altocampomewtwo
	ldr fondo, =imagencampomewtwo
	ldr r0,[posicionFondo] // Posicion en x
	ldr r1,[posicionFondo,#4] // Posicion en y
	ldrh r2,[dimensionesFondo,#2] // Ancho 
	ldrh r3,[dimensionesFondo] // Alto
	push {fondo}
	bl drawImage
	b finDib
	
	peleaFacil:
	cmp caracter,#'5'
	bne peleaDificil
	ldr posicionFondo, =posFondox
	ldr dimensionesFondo, =altopeleamesprit
	ldr fondo, =imagenpeleamesprit
	ldr r0,[posicionFondo] // Posicion en x
	ldr r1,[posicionFondo,#4] // Posicion en y
	ldrh r2,[dimensionesFondo,#2] // Ancho 
	ldrh r3,[dimensionesFondo] // Alto
	push {fondo}
	bl drawImage
	b finDib
	
	peleaDificil:
	cmp caracter,#'6'
	bne finDib
	ldr posicionFondo, =posFondox
	ldr dimensionesFondo, =altopeleamewtwo
	ldr fondo, =imagenpeleamewtwo
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
	
	guardarX posx
	
	pop {r4-r12}
	pop {pc}
	.unreq posx
	.unreq posy
	.unreq dimensionesBrendan
	.unreq iBrendan

@ macro que mueve coordenadas x,y a r0,r1 para ser utilizadas por drawImage
.macro coordenadas x,y
	mov r0,\x
	mov r1,\y
.endm
@ macro para hacer pausa de 0.1 seg
.macro pausa
	ldr r0,=100000
	bl Wait
.endm
@macro que dibuja rectangulo en las coordenadas indicadas
.macro rectangulo x0,y0,ancho,alto
	mov r0,\x0
	mov r1,\y0
	mov r2,\ancho
	mov r3,\alto
	bl dibujarRectangulo
.endm
.macro dibujarCueva
	mov r0,#'1'
	bl DibujarFondo
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
	
	dibujosD:
		pausa
		paso1D:
		ldr dimensionesBrendan, =altoderecha
		ldr iBrendan, =imagenderecha
		coordenadas posx,posy
		ldrh r2, [dimensionesBrendan,#2] // Ancho 
		ldrh r3, [dimensionesBrendan] // Alto
		push {iBrendan}
		bl drawImage
		pausa
		dibujarCueva
		add posx,#5
		
		
		pausa
		paso2D:
		ldr dimensionesBrendan, =altoderecha1
		ldr iBrendan, =imagenderecha1
		coordenadas posx,posy
		ldrh r2, [dimensionesBrendan,#2] // Ancho 
		ldrh r3, [dimensionesBrendan] // Alto
		push {iBrendan}
		bl drawImage
		pausa
		dibujarCueva
		add posx,#5
		
		
		pausa
		paso3D:
		ldr dimensionesBrendan, =altoderecha2
		ldr iBrendan, =imagenderecha2
		coordenadas posx,posy
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
	
.global CaminarIzquierda
	CaminarIzquierda:
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
	
	dibujosI:
		pausa
		paso1I:
		ldr dimensionesBrendan, =altoizquierda
		ldr iBrendan, =imagenizquierda
		coordenadas posx,posy
		ldrh r2, [dimensionesBrendan,#2] // Ancho 
		ldrh r3, [dimensionesBrendan] // Alto
		push {iBrendan}
		bl drawImage
		pausa
		dibujarCueva
		sub posx,#5
		
		
		pausa
		paso2I:
		ldr dimensionesBrendan, =altoizquierda1
		ldr iBrendan, =imagenizquierda1
		coordenadas posx,posy
		ldrh r2, [dimensionesBrendan,#2] // Ancho 
		ldrh r3, [dimensionesBrendan] // Alto
		push {iBrendan}
		bl drawImage
		pausa
		dibujarCueva
		sub posx,#5
		
		
		pausa
		paso3I:
		ldr dimensionesBrendan, =altoizquierda2
		ldr iBrendan, =imagenizquierda2
		coordenadas posx,posy
		ldrh r2, [dimensionesBrendan,#2] // Ancho 
		ldrh r3, [dimensionesBrendan] // Alto
		push {iBrendan}
		bl drawImage
		sub posx,#5
		guardarX posx
		
	pop {r4-r12}
	pop {pc}
	.unreq posx
	.unreq posy
	.unreq dimensionesBrendan
	.unreq iBrendan		
/*
subrutina que hace la animacion de caminar del personaje
parametros:
en las etiquetas
posBrendanx
posBrendany
las coordenadas para dibujar el personaje
*/
.global CaminarAbajo
	CaminarAbajo:
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
	
	dibujosAb:
		pausa
		paso1Ab:
		ldr dimensionesBrendan, =altoatras
		ldr iBrendan, =imagenatras
		coordenadas posx,posy
		ldrh r2, [dimensionesBrendan,#2] // Ancho 
		ldrh r3, [dimensionesBrendan] // Alto
		push {iBrendan}
		bl drawImage
		pausa
		dibujarCueva
		sub posy,#5
		
		
		pausa
		paso2Ab:
		ldr dimensionesBrendan, =altoatras1
		ldr iBrendan, =imagenatras1
		coordenadas posx,posy
		ldrh r2, [dimensionesBrendan,#2] // Ancho 
		ldrh r3, [dimensionesBrendan] // Alto
		push {iBrendan}
		bl drawImage
		pausa
		dibujarCueva
		sub posy,#5
		
		
		pausa
		paso3Ab:
		ldr dimensionesBrendan, =altoatras2
		ldr iBrendan, =imagenatras2
		coordenadas posx,posy
		ldrh r2, [dimensionesBrendan,#2] // Ancho 
		ldrh r3, [dimensionesBrendan] // Alto
		push {iBrendan}
		bl drawImage
		sub posy,#5
		guardarY posy
		
	pop {r4-r12}
	pop {pc}
	.unreq posx
	.unreq posy
	.unreq dimensionesBrendan
	.unreq iBrendan
/*
subrutina que hace la animacion de caminar del personaje
parametros:
en las etiquetas
posBrendanx
posBrendany
las coordenadas para dibujar el personaje
*/
.global CaminarArriba
	CaminarArriba:
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
	
	dibujosArr:
		pausa
		paso1Arr:
		ldr dimensionesBrendan, =altofrente
		ldr iBrendan, =imagenfrente
		coordenadas posx,posy
		ldrh r2, [dimensionesBrendan,#2] // Ancho 
		ldrh r3, [dimensionesBrendan] // Alto
		push {iBrendan}
		bl drawImage
		pausa
		dibujarCueva
		add posy,#5
		
		
		pausa
		paso2Arr:
		ldr dimensionesBrendan, =altofrente1
		ldr iBrendan, =imagenfrente1
		coordenadas posx,posy
		ldrh r2, [dimensionesBrendan,#2] // Ancho 
		ldrh r3, [dimensionesBrendan] // Alto
		push {iBrendan}
		bl drawImage
		pausa
		dibujarCueva
		add posy,#5
		
		
		pausa
		paso3Arr:
		ldr dimensionesBrendan, =altofrente2
		ldr iBrendan, =imagenfrente2
		coordenadas posx,posy
		ldrh r2, [dimensionesBrendan,#2] // Ancho 
		ldrh r3, [dimensionesBrendan] // Alto
		push {iBrendan}
		bl drawImage
		add posy,#5
		guardarY posy
		
	pop {r4-r12}
	pop {pc}
	.unreq posx
	.unreq posy
	.unreq dimensionesBrendan
	.unreq iBrendan
/*
macro que cambia la bandera de la posicion del personaje
0-> viendo arriba
1-> viendo a la dercha
2->viendo a la izquieda
3->viendo abajo
*/
.macro banderaPosicion num
	ldr r0,=Facing
	mov r1,\num
	str r1,[r0]
.endm
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
	ent:
	bl KeyboardUpdate
	bl KeyboardGetChar
	cmp r0,#0
	beq ent
	
	mov caracter,r0
	
	@ver la badera si ya se paso la pantalla de inicio
	ldr r0,=banderaInicio
	ldr r0,[r0]
	cmp r0,#0
	bne derecha
	enter:
		cmp caracter,#'\n'
		bne derecha
		mov r0,#'1'
		bl DibujarFondo
		ldr r0,=banderaInicio
		mov r1,#194
		str r1,[r0]
		b leerteclasfin
	
	derecha:
		ldr r0,=banderaInicio
		ldr r0,[r0]
		cmp r0,#0
		beq ent
		
		cmp caracter,#200
		bne izq
		bl CaminarDerecha
		banderaPosicion #1
		b leerteclasfin
	izq:
		cmp caracter,#201
		bne arri
		bl CaminarIzquierda
		banderaPosicion #2
		b leerteclasfin
	arri:
		cmp caracter,#202
		bne abaj
		bl CaminarArriba
		banderaPosicion #0
		b leerteclasfin
	abaj:
		cmp caracter,#203
		bne ent @ si no es una tecla valida vuelve a esperar el ingreso de otra tecla
		bl CaminarAbajo
		banderaPosicion #3
	leerteclasfin:
	pop {r4-r12}
	pop {pc}
.section .data
.align 2
.globl posFondox
posFondox:	.int 0
.globl posFondoy
posFondoy:	.int 0
@variable que contiene la posicion x donde dibujar la esquina superior izq de la image
.globl posBrendanx
	posBrendanx:	.int	700
@variable que contiene la posicion y donde dibujar la esquina superior izq de la image
.globl posBrendany
	posBrendany:	.int	200
banderaInicio: .int 0
.globl Facing
Facing: .int 0
