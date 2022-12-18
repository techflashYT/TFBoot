.code16
.global enableA20
.type enableA20, @function
.global checkA20Enabled
.type checkA20Enabled, @function
checkA20Enabled:
	pushf
	push %ds
	push %es
	push %di
	push %si


	xor %ax, %ax
	mov %ax, %es # zero es

	not %ax # set ax to 0xFFFF
	mov %ax, %ds

	# Set up some addresses
	mov $0x0500, %di
	mov $0x0510, %si

	# Push the original value of 0000:0500
	movb %es:(%di), %al
	push %ax

	# Push the original value of FFFF:0510
	movb %ds:(%si), %al
	push %ax

	# Set 0000:0500 to 00
	movb $0x00, %es:(%di)
	# Set FFFF:0510 to FF
	movb $0xFF, %ds:(%si)

	# check if 0000:0500 is FF
	cmpb $0xFF, %es:(%di)

	# restore the original value of FFFF:0510
	pop %ax
	mov %al, %ds:(%si)

	# restore the original value of 0000:0500
	pop %ax
	mov %al, %es:(%di)

	mov $0x00, %ax # Set the exit status to zero (success)
	jne .exit # did the check above pass?  If so, exit with the above status, if not, continue

	mov $0x01, %ax # Set the exit status to one (failure) and continue blow
.exit:
	pop %si
	pop %di
	pop %es
	pop %ds
	popf

	ret
enableA20:
	call checkA20Enabled
	/*! if (checkA20Enabled() != 0) {
		// enable A20
	}
	*/
	cmpb $0x00, %al
	jz .alreadyEnabled
/*
	call enableA20int15h
	cmpb $0x00, %al
	jnz .done

	call enableA20KBC
	cmpb $0x00, %al
	jnz .done
*/
	call enableA20FastA20
	call checkA20Enabled
	cmpb $0x00, %al
	jnz .done

	mov $welpThisSucks, %si
	call print
	cli
	hlt
.done:
	ret

.alreadyEnabled:
	mov $alreadyEnabledStr, %si
	call print
	ret

alreadyEnabledStr:
	.ascii "  - A20 Line already enabled"
	.byte 0x0D
	.byte 0x0A
	.byte 0x00
welpThisSucks:
	.asciz "PANIC: No way to enable A20!"