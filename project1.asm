########################################
# Shumba Brown -- 11/09/17
# Accepts hex value from user and return the decimal.
# Registers used:
# a0 - 

# Todo: Free up registers.

.data
    input: .space 9
    str1:  .asciiz "Enter a hex: "
    str2:  .asciiz "Invalid hexadecimal number."

.text

main:

    # Accept hex value from user.
    la $a0, str1        # Load prompt string in $a0.
    li $v0, 4	        # Load print string syscall command.
    syscall

    la $a0, input       # Load byte space into address.
    li $a1, 9           # Allot the byte space for string.
    li $v0, 8           # Load print string syscall command.
    syscall	    

    add $t0, $zero, $a0 # Copy the string address into register $t0.
    
    
loop:
    lb $t2, 0($t0)      # Load character in $t2
    
    # Check if the we are at the last character.
    beq $t2, 10, end_loop
    beq $t2, 0, end_loop
    
# Check if the char is a valid lowercase hex. 
check_lower_max: 
    blt $t2, 103, check_lower_min
check_lower_min:
    bgt $t2, 96, increment

# Check if the char is a valid uppercase hex.
check_upper_max:
    blt $t2, 71, check_upper_min
check_upper_min:
    bgt $t2, 64, increment
    
# Check if the char is a number.
check_num_max:
    blt $t2, 58, check_num_min
check_num_min:
    bgt $t2, 47, increment

    jal invalid # If all checks failed, jump to invalid.

increment:
    # Increment the character.
    addi $t0, $t0, 1
    jal loop

end_loop:
    jal end_program

end_program:
    li $v0, 10      # end program
    syscall
    
    
    
    
    
    

valid:
    la $a0, str1    # Load and print string asking for string
    li $v0, 4	    # 
    syscall
    jr  $ra

invalid:
    la $a0, str2
    li $v0, 4       # 
    syscall
    jr $ra
    
    
is_valid:
    li $v0, 10      # end program
    syscall
