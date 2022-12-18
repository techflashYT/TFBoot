.code16
.section .text
// .org 0x195
entrySect2:
	# Hello from sector 2!  We're now loaded at hex 0000:1000.
	# Lets do some more initializing, starting with ??? TODO

	# say hi to verify that it works
	mov str, %si
	call print
	cli
	hlt 
.section .data
str:
.asciz "hello from sector 2"