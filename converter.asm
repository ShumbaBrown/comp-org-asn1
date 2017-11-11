########################################
# Shumba Brown -- 11/09/17
# converter.asm - Converts a hexadecimal to a decimal number.
#
# Registers used:
# v0 - syscall.
# a0 - syscall.
# a1 - syscall.
# t0 - stores the address of the input string.
# t2 - stores the current char being evaluated.
# t3 - stores the decimal value of the hex char.
# t4 - stores the length of the string.
# t5 - tracks the index in loops.
# t6 - stores the power of the current char.
# t7 - stores the exponent.
# t8 - stores base to convert to.
# t9 - stores the current sum.
# s0 - stores the decimal number.

.data
    input: .space 9
    input_prompt:  .asciiz "Enter a hexadecimal number: "
    error_prompt:  .asciiz "Invalid hexadecimal number."

.text

main:
        addi $t8, $zero, 16 										# Set base to 16.
    
    		la $a0, input_prompt        						# Load prompt string in $a0.
   		  li $v0, 4	        											# Load print string syscall command.
  		  syscall

  		  la $a0, input       										# Load byte space into address.
  		  li $a1, 9           										# Allot the byte space for string.
  		  li $v0, 8           										# Load print string syscall command.
  		  syscall	    

    		add $t0, $zero, $a0 										# Copy the string address into register $t0.
    
    		addi $t4, $zero, 0											# Initialize string length to 0.



loop_length:
   			
   			lb $t2, 0($t0)													# Load the character at t0 in t2.
   
    		beq $t2, 10, end_loop_length 						# If the char is new line.
    		beq $t2, 0, end_loop_length  						# If the char is null.
    
    		addi $t4, $t4, 1												# Increment length.
    		addi $t0, $t0, 1												# Increment the starting point of t0 by 1.
    		jal loop_length  

end_loop_length:
    
    		add $t0, $zero, $a0 										# Copy the string address into register $t0.
    		add $t5, $zero, 0   										# Initialize index tracker.
    
loop:
    		lb $t2, 0($t0)     											# Load the character at t0 in t2.
    
    																						# Power = string_length - index - 1
    		sub $t6, $t4, $t5  											# Power = string length - index
    		addi $t6, $t6, -1												# Power = power - 1
    

    		beq $t2, 10, end_loop 									# If the character is new line, end the loop.
    		beq $t2, 0, end_loop  									# If the chararacter is null, end the loop.
    

check_lower_max: 																
    		blt $t2, 103, check_lower_min						# If the character is within the max for lowercase, jump to check if it is in the min.		
    		jal invalid 														# If the character is outside the max, it is invalid.

check_lower_min:
   		 	bgt $t2, 96, store_lower_value					# If the character is within the min for lowercase, jump to store the decimal value.
    		jal check_upper_max											# If the character is less than the min, check if it is uppercase.
    
store_lower_value:															
    		addi $t3, $t2, -87											# Store the decimal value of the character in t3.
    		jal increment  													# Move on to the next character.
    

check_upper_max:
    		blt $t2, 71, check_upper_min						# If the character is within the max for uppercase, jump to check if it is in the min.
    		jal invalid 														# If the character is outside the max, it is invalid.

check_upper_min:
    		bgt $t2, 64, store_upper_value					# If the character is within the min for uppercase, jump to store the decimal value.
    		jal check_num_max												# If the character is less than the min, check if it is a number.

store_upper_value:
    		addi $t3, $t2, -55 											# Store the decimal value of the character in t3.
    		jal increment            								# Move on to the next character.
    
check_num_max:
    		blt $t2, 58, check_num_min							# If the character is within the max for numbers, jump to check if it in the min.
    		jal invalid 														# If the character is outside the max, it is invalid.

check_num_min:
    		bgt $t2, 47, store_num_value						# If the character is within the min for numbers, jump to store the decimal value.
    		jal invalid 														# If the character is outside the min it is invalid.
    
store_num_value:
    		addi $t3, $t2, -48											# Store the decimal value of the character in t3.
    		jal increment 													# Move on to the next character.
    

increment:
    		addi $t7, $zero, 1											# Initialize the exponent to 1.
    
loop_exponent:																	# Calculate the exponent for the character.
    		beq $t6, $zero, calculate_current_val 	# If the power is 1, exit the loop.
    		mult $t8, $t7														# Multiply the exponent by the base.
    		mflo $t7																# Update the exponent.
    
    		addi $t6, $t6, -1 											# Decrement the power.
    		jal loop_exponent    
    
calculate_current_val:
    		mult $t3, $t7														# Multiply the decimal value of the char by the exponent.
    		mflo $t9 																# Update the current value.
    
    		add $s0, $s0, $t9												# Add the current value to the existing sum.					

    		addi $t5, $t5, 1 												# Increment the index.
    		addi $t0, $t0, 1 												# Increment the character.
    		jal loop

end_loop:
    		jal valid																# Since all went well, jump to valid.

end_program:
   			li $v0, 10      												# End program
    		syscall
    

valid:
    		add $a0, $zero, $s0											# Load sum in syscall arguement.
    		li $v0, 1																# Load print interger syscall command.
    		syscall
    		jal end_program													# End program

invalid:
    		la $a0, error_prompt
    		li $v0, 4       												# Load syscall
    		syscall
    		jal end_program													# End program
    
    
  
# end of converter.asm