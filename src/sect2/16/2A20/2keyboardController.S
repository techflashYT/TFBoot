.global enableA20KBC
.type enableA20KBC, @function
enableA20KBC:
	# Attempt 1:  8024 Keyboard Controller (KBC) method
	mov $0x64, %dx
	call .waitKBC
	mov $0xAD, %al
	out %al, %dx

	call .waitKBC
	mov $0xD0, %al
	out %al, %dx
	
	call .waitKBC2
	inb $0x60, %al
	push %ax

	call .waitKBC
	mov $0xD1, %al
	out %al, %dx

	call .waitKBC
	pop %ax
	or $2, %al
	out %al, $0x60

	call .waitKBC
	mov $0xAE, %al
	out %al, %dx

	call .waitKBC

	call checkA20Enabled
	jz .enabledWithKBC
	ret # al is already 1, no need to set it

.waitKBC:
	in $0x64, %al
	test $2, %al
	jnz .waitKBC
	ret

.waitKBC2:
	in $0x64, %al
	test $1, %al
	jz .waitKBC2
	ret
.enabledWithKBC:
	mov $enabledWithKBCStr, %si
	call print
	ret
enabledWithKBCStr:
	.ascii "  - A20 Line enabled with KBC"
	.byte 0x0D
	.byte 0x0A
	.byte 0x00