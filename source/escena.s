/*
ROBERTO CHIROY - 13027
ANGEL MORALES - 13332
proyecto #2 
taller de assembler
*/
/*
subrutina que dibuja un circulo en pantalla centrado en las cordenadas (x0,y0)
parametros:
r0 -> x0
r1 -> y0
r2 -> diametro
*/
.globl DrawCircle
DrawCircle:

	push {lr}
	push {r4-r12}
	
	
	x .req r4
 	y .req r5
 	radio .req r6
    x0 .req r7
    y0 .req r8
    rE .req r9
	
	mov x0,r0
	mov y0,r1
 	mov radio,r2

    mov x, #0
    mov y, radio
    add rE,radio,radio
    rsb rE,rE,#3

    ciclo:

        mov r0,#0
        mov r1,#0
        add r0, x,x0
        add r1, y,y0
        bl DrawPixel

        mov r0,#0
        mov r1,#0
        sub r0, x0,x
        add r1, y,y0
        bl DrawPixel

        mov r0,#0
        mov r1,#0
        add r0, x0,x
        sub r1, y0,y
        bl DrawPixel

        mov r0,#0
        mov r1,#0
        sub r0, x0,x
        sub r1, y0,y
        bl DrawPixel

        mov r0,#0
        mov r1,#0
        add r0, x0,y
        add r1, y0,x
        bl DrawPixel

        mov r0,#0
        mov r1,#0
        sub r0, x0,y
        add r1, y0,x
        bl DrawPixel

        mov r0,#0
        mov r1,#0
        add r0, y,x0
        sub r1, y0,x
        bl DrawPixel
        
        mov r0,#0
        mov r1,#0
        sub r0, x0,y
        sub r1, y0,x
        bl DrawPixel

        add x,#1
        cmp rE,#0
        blt menor
        b mayor
        menor:
            
            add r10,x,x
            add r10,x
            add r10,x
            add r10,#6
            add rE,r10
            b seguir
        mayor:
            sub y,#1
            sub r10, x,y
            add r10,r10
            add r10,r10
            add r10,r10
            add r10,#10
            add rE,r10
        seguir:


        mov r0,#0
        mov r1,#0
        add r0, x,x0
        add r1, y,y0
        bl DrawPixel

        mov r0,#0
        mov r1,#0
        sub r0, x0,x
        add r1, y,y0
        bl DrawPixel

        mov r0,#0
        mov r1,#0
        add r0, x0,x
        sub r1, y0,y
        bl DrawPixel

        mov r0,#0
        mov r1,#0
        sub r0, x0,x
        sub r1, y0,y
        bl DrawPixel

        mov r0,#0
        mov r1,#0
        add r0, x0,y
        add r1, y0,x
        bl DrawPixel

        mov r0,#0
        mov r1,#0
        sub r0, x0,y
        add r1, y0,x
        bl DrawPixel

        mov r0,#0
        mov r1,#0
        add r0, y,x0
        sub r1, y0,x
        bl DrawPixel
        
        mov r0,#0
        mov r1,#0
        sub r0, x0,y
        sub r1, y0,x
        bl DrawPixel

        cmp x,y
        blt ciclo

	pop {r4-r12}
	pop {pc}
 	
	
	.unreq x
 	.unreq y
 	.unreq radio
    .unreq x0
    .unreq y0
    .unreq rE



/*
r0,x0
r1,y0
r2,ancho
r3,alto
*/	
.globl dibujarRectanguloSinRellenar
dibujarRectanguloSinRellenar:
	push {lr}
	mov r4, r0
	mov r5, r1
	mov r6, r2
	mov r7, r3
	mov r0, r4
	mov r1, r5
	add r2, r0, r6
	mov r3, r1
	bl DrawLine
	mov r0, r2
	mov r1, r3
	add r3, r1, r7
	bl DrawLine
	
	mov r0, r4
	mov r1, r3
	add r2, r2, r6
	bl DrawLine
	
	mov r0, r4
	mov r1, r5
	mov r2, r4
	add r3, r1, r7
	pop {pc}
/*
r0,x0 @cargado desde la etiqueta posBrendanx
r1,y0 @cargado desde la etiqueta posBrendany
r2,ancho
r3,alto
*/
.globl dibujarRectangulo
dibujarRectangulo:
	push {lr}
	push {r4-r12}
	x0 .req r4
	y0 .req r5
	alto .req r6
	ancho .req r7
	xf .req r8
	yf .req r9
	/*
	@cargar los valores iniciales
	ldr r0,=posBrendanx
	ldr r0,[r0]
	ldr r1,=posBrendany
	ldr r1,[r1]
	*/
	
	mov x0,r0
	mov y0,r1
	mov yf,y0
	mov ancho,r2
	mov alto,r3
	@mov xf,x0
	
	add xf,x0,ancho
	mov r10,#0
	ldr r0,=34657
	bl SetForeColour
	dibujo:
		cmp r10,alto
		bge final
		mov r0,x0
		mov r1,y0
		mov r2,xf
		mov r3,yf
		bl DrawLine @dibujar primer linea horizontal del rectangulo ->
		add y0,y0,#1
		add yf,yf,#1
		add r10,#1
	b dibujo
	
	final:
	pop {r4-r12}
	pop {pc}
.globl alto
alto:
	push {lr}
	
	ldr r0, =0xFFFF
		bl SetForeColour
		
		ldr r0,=412@/
		mov r1,#234
		ldr r2,=432
		ldr r3,=194
		bl DrawLine
		
		ldr r0, =432@\
		ldr r1, =194
		ldr r2, =452
		mov r3, #234
		bl DrawLine
		
		ldr r0, =422@_
		ldr r1, =214
		ldr r2, =442
		ldr r3, =214
		bl DrawLine
		
		ldr r0, =457@|
		ldr r1, =194
		ldr r2, =457
		ldr r3, =234
		bl DrawLine
		
		ldr r0, =457@_
		ldr r1, =234
		ldr r2, =497
		ldr r3, =234
		bl DrawLine
		
		ldr r0, =502@-
		ldr r1, =194
		ldr r2, =542
		ldr r3, =194
		bl DrawLine
		
		ldr r0, =522@|
		ldr r1, =194
		ldr r2, =522
		ldr r3, =234
		bl DrawLine
		
		ldr r0,=562@O
		ldr r1,=214
		ldr r2,=20
		bl DrawCircle
		pop {pc}
	