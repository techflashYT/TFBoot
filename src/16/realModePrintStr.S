.global printStr
.type printStr, @function
.section .text
.code16
printStr:
	mov (%si), %al
	cmp $0x0, %al
	je .done
	mov $0xe, %ah
	int $0x10
	inc %si
	jmp printStr

	.done:
		ret
