.global start16
.type start16, @function
.global loadingStr

.code16
.section .rodata
loadingStr:
.asciz "TFBoot loading..."

.section .text
start16:
	cli # Disable interrupts
	mov loadingStr, %si
	call printStr
	1:
		cli
		hlt
		jmp 1b

