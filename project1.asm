########################################
# Shumba Brown -- 11/09/17
# Accepts hex value from user and return the decimal.
# Registers used:

# Todo: Free up registers.

.data
    input: .space 256
    str1:  .asciiz "Enter a hex: "
    str2:  .asciiz "You wrote: "
    str3:  .asciiz "Invalid hexadecimal number."

.text

main:
		
    # Get the hex
    la $a0, str1    # Load and print string asking for string
    li $v0, 4				# 
    syscall

    li $v0, 8       # take in input

    la $a0, input   # load byte space into address
    li $a1, 256      # allot the byte space for string
    syscall

    move $t0, $a0 
    lb $a0, ($t0) # load character in $a0
    li $v0, 11
    syscall

    # Todo: write function to see if the chars are valid
    beq $t7, $zero, invalid 
    bne $t7, $zero, valid

exit:
    li $v0, 10      # end program
    syscall

valid:
		# Todo: print the decimal of the hex
		la $a0, str1    # Load and print string asking for string
    li $v0, 4				
    syscall
		jr  $ra

invalid:
		la $a0, str3
		li $v0, 4				# 
    syscall
    jal


# function that checks if it is valid

	# loop through the 8 values
	# check if 
	the characters from '0' to '9' and from 'a' to 'f' and from 'A' to 'F',



    move $t0, $a0   # save string to t0
    
    
    la $a0, str2    # load and print "you wrote" string
    li $v0, 4
    syscall

    la $a0, buffer  # reload byte space to primary address
    move $a0, $t0   # primary address = t0 address (load pointer)
    li $v0, 4       # print string
    syscall

    li $v0, 10      # end program
    syscall

	# Print the string.





#   t0
# Reads a string of up to 8 characters from user input. If
# the string has only the characters from '0' to '9' and from 'a' to 'f' and from 'A' to 'F', the
# program prints out the unsigned decimal integer corresponding to the hexadecimal number
# in the string. Otherwise, the program prints out the message of "Invalid hexadecimal
# number.".
# leaf_example # Prompts user for an integer, reads it, returns it. #
# Arg registers used: $a0, $a1, $a2, $a3
# Tmp registers used: $t0, $t1
#
# Pre: none
# Post: $v0 contains the return value
# Returns: the value of ($a0 + $a1) – ($a2 + $a3) #
# Called by: main
# Calls: none
