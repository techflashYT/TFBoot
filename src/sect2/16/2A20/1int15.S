.global enableA20int15h
.type enableA20int15h, @function
enableA20int15h:
	# Check if it's supported
	mov $0x2403, %ax
	int $0x15
	jb .failed # Not supported
	cmp $0x0, %ah
	jnz .failed # Not supported
	
	# Check status
	mov $0x2402, %ax
	int $0x15
	jb .failed # can't get status
	cmp $0x0, %ah
	jnz .failed # can't get status

	# Activate
	mov $0x2401, %ax
	int $0x15
	jb .failed # failed to activate
	cmp $0x0, %ah
	jnz .failed # failed to activate

	call checkA20Enabled
	jz .enabledWithInt15h
.failed:
	mov $0x1, %ax
	ret

.enabledWithInt15h:
	mov $enabledWithInt15hStr, %si
	call print
	mov $0x00, %ax
	ret
enabledWithInt15hStr:
	.ascii "  - A20 Line enabled with int 15h"
	.byte 0x0D
	.byte 0x0A
	.byte 0x00

