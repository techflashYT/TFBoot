.code16 # tell assembler that it's 16-bit code
.global resetSegments
.type resetSegments, @function
.global resetSegments
.type resetSegments, @function
.global init
.type init, @function

init:
	cli
	# NOTE: The following section disables the non-maskable interrupt (NMI), this could be problematic on some PCs,
	# but it's needed later on when we go to 32-bit protected mode
	#! outb(0x70, inb(0x70) & 0x7F);
	mov $0x70, %dx
	inb %dx, %al
	andb $0x7F, %al
	outb %al, %dx
	#! inb(0x71);
	# NOTE: Clobbers al, but we don't have anything important there anyways
	inb %dx, %al
	
	.intel_syntax
		# Jump to our segment resetting function below
		ljmp 0x0, resetSegments
	.att_syntax

resetSegments:
	# Reset the segments in case of buggy BIOS's (like my main testing machine [Optiplex 755])
	xor %ax, %ax
	mov %ax, %ds
	mov %ax, %es
	mov %ax, %ds
	mov %ax, %fs
	mov %ax, %gs
	mov %ax, %ss

continue:
	# Enable VGA text mode
	mov $0x03, %ax
	int $0x10
	#! print("Starting TFBoot...")
	mov $startingMsg, %si
	call print
	# Read some more sectors from the disk, then jump to it,
	call loadMoreBytes
	# Should never, EVER be hit, if it is, we have a big problem, but we don't have enough space left in this sector to do anything about it.
	cli
	hlt



startingMsg:
	.ascii "Starting TFBoot..."
	.byte 0x0D
	.byte 0x0A
	.byte 0x00
