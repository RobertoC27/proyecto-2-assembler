@r0 = vida actual
.globl CalcularDano @Con random
CalcularDano:
	push {r0,r1}
	bl Random
	mov r2, r0
	pop {r0,r1}
	cmp r0, r2
	movgt r0, #0
	sublt r0, r2