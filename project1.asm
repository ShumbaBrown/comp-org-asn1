########################################
# Shumba Brown -- 11/09/17
# Accepts hex value from user and return the decimal.
# Registers used:





#   t0
# Reads a string of up to 8 characters from user input. If
the string has only the characters from '0' to '9' and from 'a' to 'f' and from 'A' to 'F', the
program prints out the unsigned decimal integer corresponding to the hexadecimal number
in the string. Otherwise, the program prints out the message of "Invalid hexadecimal
number.".
leaf_example # Prompts user for an integer, reads it, returns it. #
# Arg registers used: $a0, $a1, $a2, $a3
# Tmp registers used: $t0, $t1
#
# Pre: none
# Post: $v0 contains the return value
# Returns: the value of ($a0 + $a1) – ($a2 + $a3) #
# Called by: main
# Calls: none
