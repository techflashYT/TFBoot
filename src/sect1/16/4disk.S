.code16
.global loadMoreBytes
.type loadMoreBytes, @function
loadMoreBytes:
	// reset the disk
	xor %ax, %ax
	// bios disk interrupt
	int $0x13

	// read the data into the memory at 0000:1000
	mov 0x0000, %ax
	mov 0x1000, %bx

	mov $0x02, %ah // read sector
	mov $0x02, %al // read 2 sectors
	mov $0x00, %ch // cylinder 0
	mov $0x06, %cl // local to write
	mov $0x00, %dh // head 0
	// call the bios again
	int $0x13
	jmp $0x0000,$0x1000