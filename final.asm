########################################
# Shumba Brown -- 11/09/17
# converter.asm - Converts a hexadecimal to a decimal number.
#
# Registers used:
# # Argument Registers
# v0 - syscall.
# a0 - syscall.
# a1 - syscall.
#
# #Temporary Registers
# t0 - stores the address of the input string.
# t1 - used to store the constant 10,000.
# t2 - stores the current char being evaluated.
# t3 - stores the decimal value of the hex char.
# t4 - stores the length of the string.
# t5 - tracks the index in loops.
# t6 - stores the power of the current char.
# t7 - stores the exponent.
# t8 - stores base to convert to.
# t9 - stores the current sum.
#
# # Saved Registers
# s0 - stores the decimal number.
# s1 - first half of decimal number.
# s2 - Second half of decimal number.

.data
    input: .space 9
    input_prompt:  .asciiz "Enter a hexadecimal number: "
    error_string:  .asciiz "\nInvalid hexadecimal number."
    output_string: .asciiz "\nThe decimal number is: "

.text

main:
      addi $t8, $zero, 16 										# Set base to 16.
      addi $t4, $zero, 0                      # Initialize string length to 0.

    
      la $a0, input_prompt        						# Load prompt string in $a0.
      li $v0, 4	        											# Load print string syscall command.
      syscall

      la $a0, input       										# Load byte space into address.
      li $a1, 9           										# Allot the byte space for string.
      li $v0, 8           										# Load print string syscall command.
      syscall	    

      add $t0, $zero, $a0 										# Copy the string address into register $t0.    

loop_length:                                  # Find the length of the input string.
   			
      lb $t2, 0($t0)													# Load the character at t0 in t2.
   
      beq $t2, 10, exit_loop_length 					# If the char is new line exit the loop.
      beq $t2, 0, exit_loop_length  					# If the char is null exit the loop.
    
      addi $t4, $t4, 1												# Increment length.
      addi $t0, $t0, 1												# Increment the starting point of t0 by 1.
      j loop_length  

exit_loop_length:
    
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
      j invalid 														  # If the character is outside the max, it is invalid.

check_lower_min:
      bgt $t2, 96, store_lower_value					# If the character is within the min for lowercase, jump to store the decimal value.
      j check_upper_max											  # If the character is less than the min, check if it is uppercase.
    
store_lower_value:															
      addi $t3, $t2, -87											# Store the decimal value of the character in t3.
      j increment  													  # Move on to the next character.
    

check_upper_max:
      blt $t2, 71, check_upper_min						# If the character is within the max for uppercase, jump to check if it is in the min.
      j invalid 														  # If the character is outside the max, it is invalid.

check_upper_min:
      bgt $t2, 64, store_upper_value					# If the character is within the min for uppercase, jump to store the decimal value.
      j check_num_max												  # If the character is less than the min, check if it is a number.

store_upper_value:
      addi $t3, $t2, -55 											# Store the decimal value of the character in t3.
      j increment            								  # Move on to the next character.
    
check_num_max:
      blt $t2, 58, check_num_min							# If the character is within the max for numbers, jump to check if it in the min.
      j invalid 														  # If the character is outside the max, it is invalid.

check_num_min:
      bgt $t2, 47, store_num_value						# If the character is within the min for numbers, jump to store the decimal value.
      j invalid 														  # If the character is outside the min it is invalid.
    
store_num_value:
      addi $t3, $t2, -48											# Store the decimal value of the character in t3.
      j increment 													  # Move on to the next character.
    

increment:
      addi $t7, $zero, 1											# Initialize the exponent to 1.
    
loop_exponent:																# Calculate the exponent for the character.
      beq $t6, $zero, calculate_current_val 	# If the power is 1, exit the loop.
      mult $t8, $t7														# Multiply the exponent by the base.
      mflo $t7																# Update the exponent.
    
      addi $t6, $t6, -1 											# Decrement the power.
      j loop_exponent    
    
calculate_current_val:
      mult $t3, $t7														# Multiply the decimal value of the char by the exponent.
      mflo $t9 																# Update the current value.
      add $s0, $s0, $t9												# Add the current value to the existing sum.					
      addi $t5, $t5, 1 												# Increment the index.
      addi $t0, $t0, 1 												# Increment the character.
      j loop

end_loop:
      j valid																  # Since all went well, jump to valid.

end_program:
      li $v0, 10      												# End program
      syscall
    

valid:                                        # Print the decimal value of the hex.

      la $a0, output_string        						# Load output string in $a0.
      li $v0, 4	        											# Load print string syscall command.
      syscall    
  
      addi $t1, $zero, 10000      
      divu $s0, $t1
      mflo $s1
      mfhi $s2
		
		
		
      beq $s1, $zero, rem_only

      add $a0, $zero, $s1											# Load sum in syscall arguement.
      li $v0, 1																# Load print interger syscall command.
      syscall

rem_only:
      add $a0, $zero, $s2											# Load sum in syscall arguement.
      li $v0, 1																# Load print interger syscall command.
      syscall
    		
      j end_program													# End program


invalid:                                                                # Print error_string.
      la $a0, error_string
      li $v0, 4 
      syscall
      j end_program													# End program.  
# end of converter.asm
