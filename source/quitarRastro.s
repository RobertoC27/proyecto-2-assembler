.globl QuitarRastro
QuitarRastro:
	
	// Guardo todos los parametros en la pila para realizar calculos preliminares
	ldr r4,=imagencueva
	push {r4}
	ldr r3,=1024 @alto
	ldr r2,=768 @ancho
	@ldrh r3,[r3] @alto 
	ldr r1, =posBrendany
	ldr r0, =posBrendanx
	push {r3} // alto
	push {r2} // ancho
	push {r1} // y 
	push {r0} // x

	// **************************************************************
	// Reviso que la posicion x,y esten dentro de la pantalla

	fbInfoAddr .req r0
	px .req r1
	py .req r2
	
	// Obtengo la direccion de la tabla FrameBufferInfo
	ldr fbInfoAddr,=FrameBufferInfo

	pop {r1}
	pop {r2}

	// Reviso la posicion y
	height .req r3
	ldr height,[fbInfoAddr,#4]
	sub height,#1
	cmp py,height
	movhi pc,lr
	.unreq height
	
	// Reviso la posicion x
	width .req r3
	ldr width,[fbInfoAddr,#0]
	sub width,#1
	cmp px,width
	movhi pc,lr
	.unreq width
	// **************************************************************
	
	// **************************************************************
	// Obtengo la direccion del frame buffer y la modifico 
	// para la posicion (x,y) que quiero dibujar
	// fbAddr = fbAddr + (x + y * anchoPantalla) * 2

	.unreq fbInfoAddr
	fbAddr .req r0 
	ldr fbAddr,[fbAddr,#32]

	ldr r3, =1024
	mla r3,py,r3,px
	lsl r3,#1
	add fbAddr,r3
	// **************************************************************

	// ***********************************************************************
	// Obtengo las variables de la pila: ancho, alto y direccion de la imagen
	// Almaceno en la pila los demas registros para poder utilizarlos
	// Inicializo las variables para dibujar las imagenes

	.unreq px
	.unreq py 
	width .req r1
	height .req r2
	image .req r3

	pop {r1}
	pop {r2}
	pop {r3}

	push {r4-r12}
	
	colour .req r4
	y .req r5
	x .req r6
	matrizAux .req r8
	mov y,height
	
	desplazamiento .req r7
	
	mov desplazamiento,#0
	mov matrizAux,fbAddr
	ldrh r10,[image,fbAddr]
	// **************************************************************
	
	// *****************************************************************
	// Ciclo que recorre la matriz de la imagen y la dibuja en pantalla
	push {r9}
	ldr r9,=65535
	drawRow$:
		
		mov x,width
		
		drawPixel$:
			
			ldrh colour,[r10,desplazamiento]
			@cmp colour,r9
			@beq continuar
			
			strh colour,[matrizAux,desplazamiento]
			
			continuar:
			add desplazamiento,#2
			@add countPix,#2
			sub x,#1
	
			teq x,#0
			bne drawPixel$
		
		
		//(1024-image width)*2 para dibujar el cuadrado
		ldr r8,=1024
		sub r8,width
		lsl r8,#1
		
		add desplazamiento,r8
		
		sub y,#1

		teq y,#0
		bne drawRow$
	pop {r9}
	// *****************************************************************

	.unreq width
	.unreq height
	.unreq image
	.unreq fbAddr
	.unreq colour
	.unreq x
	.unreq y
	.unreq desplazamiento
	
	pop {r4-r12}
	mov pc,lr
