# Shumba Brown
# A program that computers the sum of 10 and 15.
#
# Registers used:
# 	t0 - used to hold the result.
#		t1 - used to hold the first integer.
# 	t2 - used to hold the second integer.

main:
	li 	$t1, 10
	li 	$t2, 15
	add $t0, $t1, $t2

# end of add.asm