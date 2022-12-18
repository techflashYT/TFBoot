.global enableA20FastA20
.type enableA20FastA20, @function
enableA20FastA20:
	in $0x92, %al
	test $2, %al
	jnz .done
	or $2, %al
	and $0xFE, %al
	out %al, $0x92
	.done:
		ret