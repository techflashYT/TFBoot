.code16
.global print
.type print, @function
print:
	push %ax
	mov $0x0E, %ah
	.loop:
		lodsb
		test %al, %al
		jz .end
		int $0x10
		jmp .loop
	.end:
		pop %ax
		ret
