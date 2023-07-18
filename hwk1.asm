# Eric Grunblatt
# egrunblatt
# 112613770

.data
# Command-line arguments
num_args: .word 0
addr_arg0: .word 0
addr_arg1: .word 0
addr_arg2: .word 0
addr_arg3: .word 0
addr_arg4: .word 0
addr_arg5: .word 0
addr_arg6: .word 0
addr_arg7: .word 0
no_args: .asciiz "You must provide at least one command-line argument.\n"

# Output messages
big_bobtail_str: .asciiz "BIG_BOBTAIL\n"
full_house_str: .asciiz "FULL_HOUSE\n"
five_and_dime_str: .asciiz "FIVE_AND_DIME\n"
skeet_str: .asciiz "SKEET\n"
blaze_str: .asciiz "BLAZE\n"
high_card_str: .asciiz "HIGH_CARD\n"

# Error messages
invalid_operation_error: .asciiz "INVALID_OPERATION\n"
invalid_args_error: .asciiz "INVALID_ARGS\n"

# Put your additional .data declarations here, if any.
new_line: .asciiz "\n"
point: .word '.'
zero: .word '0'
one: .word '1'
two: .word '2'
three: .word '3'
four: .word '4'
five: .word '5'
six: .word '6'
eight: .word '8'
nine: .word '9'
sign: .word 'S'
fix: .word 'F'
type_r: .word 'R'
poker_game: .word 'P'
f_letter: .asciiz "F"
min_starter: .word 'o'

# Main program starts here
.text
.globl main
main:
    # Do not modify any of the code before the label named "start_coding_here"
    # Begin: save command-line arguments to main memory
    sw $a0, num_args
    beqz $a0, zero_args
    li $t0, 1
    beq $a0, $t0, one_arg
    li $t0, 2
    beq $a0, $t0, two_args
    li $t0, 3
    beq $a0, $t0, three_args
    li $t0, 4
    beq $a0, $t0, four_args
    li $t0, 4
    beq $a0, $t0, five_args
    li $t0, 4
    beq $a0, $t0, six_args
seven_args:
    lw $t0, 24($a1)
    sw $t0, addr_arg6
six_args:
    lw $t0, 20($a1)
    sw $t0, addr_arg5
five_args:
    lw $t0, 16($a1)
    sw $t0, addr_arg4
four_args:
    lw $t0, 12($a1)
    sw $t0, addr_arg3
three_args:
    lw $t0, 8($a1)
    sw $t0, addr_arg2
two_args:
    lw $t0, 4($a1)
    sw $t0, addr_arg1
one_arg:
    lw $t0, 0($a1)
    sw $t0, addr_arg0
    j start_coding_here

zero_args:
    la $a0, no_args
    li $v0, 4
    syscall
    j exit
    # End: save command-line arguments to main memory

start_coding_here:
# Start the assignment by writing your code here
###### Part 1: Validate the First Command-Line Argument ######

		lw $s0, addr_arg0	#loads contents of first command line to $t0
		add $t1, $0, $0		# $t1 = counter for number of characters
		
	# Loop that checks the number of characters in the first command line		
	char_loop:
		lbu $t2, 0($s0)			# checks to see if there is a character in the current position
		beq $t2, $0, end_char_loop	# ends loop if there is nothing found in the current spot
		addi $s0, $s0, 1		# adds 1 to $s0, which will change the position to the next available spot
		addi $t1, $t1, 1		# adds 1 to the counter
		j char_loop			# jumps back to the top of the loop
	end_char_loop:

		addi $t2, $0, 1			# $t2 is equal to 1, which is the number of characters required for command line 1
		bne $t1, $t2, operation_error 	# if counter ($t1) and $t2 are not equal, go straight to error message
		lw $t0, addr_arg0		# gets the address of the first command line and stores it in $t0
		lbu $s1, 0($t0)			# gets the contents of the first command line and stores it in $s1
		j char_check			# jump to char_check
	
	# Check single character to see if it matches any of the required inputs
	char_check:
		lw $t2, one			# temporary register 1
		lw $t3, two			# temporary register 2
		lw $t4, sign			# temporary register S
		lw $t5, fix			# temporary register F
		lw $t6, type_r			# temporary register R
		lw $t7, poker_game		# temporary register P
		beq $s1, $t2, hexadecimal	# jumps to one's complement if command line is 1
		beq $s1, $t3, hexadecimal	# jumps to two's complement if command line is 2
		beq $s1, $t4, hexadecimal	# jumps to signed/magnitude if command line is S
		beq $s1, $t5, fixed		# jumps to fixed-point if command line is F
		beq $s1, $t6, r_type		# jumps to r-type if command line is R
		beq $s1, $t7, poker		# jumps to poker if command line is P
		j operation_error
	
	# Show invalid operation error and end program
	operation_error:
		li $v0, 4			# command for a string to be printed
		la $a0, invalid_operation_error	# invalid operation if command line 1 matches none of the inputs above
		syscall				# system call to print error message
		j exit				# jumps to end of the code
	
	# Show invalid args error and end program
	args_error:
		li $v0, 4			# command for a string to be printed
		la $a0, invalid_args_error	# invalid operation if command line 1 matches none of the inputs above
		syscall				# system call to print error message
		j exit				# jumps to end of the code
	
###### Part 2: Turn Hexadecimal Number into Binary ######
	# Leads to the next argument(s) for one's complement/two's complement/signed
	hexadecimal:
		# Second command line
		lw $s2, num_args		# loads the contents of num_args to $s2
		li $t1, 3			# $t1 = 3, where $t1 is the number of arguments required to move on
		bne $s2, $t1, args_error	# if $s2 != $t1, go to operation error
	
		lw $s0, addr_arg1		# gets the address of the second command line and stores it in $s0
		lw $t1, zero			# $t1 = 0 where $t1 is the counter	
		la $t2, f_letter		# loads the address for f_letter
		lbu $t3, 0($t2)			# $t3 = F
		lw $t4, four			# $t3 = 4
		
		# loops to see if hexadecimal digits are valid
		hexa_digit_check_loop:
			beq $t1, $t4, end_hexa_digit_check_loop	# if counter is equal to 4, exits loop
			lbu $t0, 0($s0)					# checks to see if there is a character in the current position
			addi $t1, $t1, 1				# adds 1 to the counter
			addi $s0, $s0, 1				# move to the next position in the command line 
			bgt  $t0 $t3, args_error			# greater than F, exits loop
			bltz $t0, args_error				# less than 0, exits loop
			j hexa_digit_check_loop					# jumps back to the top of the loop
		end_hexa_digit_check_loop:
		
		j number_of_bits
		
		# Check for the number of bits from the third command line	
		number_of_bits:	
			lw $t0, addr_arg2	# loads the address of the third command line
			move $s4, $t0		# $s4 = $t0
			lbu $t1, 0($t0)		# loads the contents of third command line (first position) and stores it in $t1
			lbu $t2, 1($t0)		# loads the contents of third command line (second position) and stores it in $t2
			lw $t3, one		# $t3 = 1, going to be used to compare first position
			lw $t4, two		# $t4 = 2, going to be used to compare second position
			lw $t5, three		# $t5 = 3, going to be used to compare first position
			lw $t6, six		# $t6 = 6, going to be used to compare second position
		
			bgt $t1, $t5, args_error	# if first position > 3, go to argument error
			blt $t1, $t3, args_error	# if first position < 1, go to argument error
			beq $t1, $t5, three_first_digit	# if first position = 3, check if second position <= 2
			beq $t1, $t3, one_first_digit	# if first position = 1, check second position >= 6
			
			j get_hex_digits
		
			# First digit is 3
			three_first_digit:			
				bgt $t2, $t4, args_error	# if second position > 2, go to argument error
				j get_hex_digits		# jumps to convert
			# First digit is 1
			one_first_digit:
				blt $t2, $t6, args_error	# if second position < 6, go to argument error
				j get_hex_digits		# jumps to convert
		
		
		# Converts the headecimal digits to binary digits
		get_hex_digits:
			lw $s0, four		# load four into $s0
			andi $s0, $s0, 0xF	# $s0 = 4
		
			lw $t0, addr_arg1	# load addr_arg1 into $t0
			lbu $t1, 0($t0)		# load first letter in $t1
			srl $t1, $t1, 4		# shift $t1 4 bits to put at first position
			andi $t1, $t1, 0xF	# $t1 = first letter
			lbu $t2, 1($t0)		# load first letter in $t2
			srl $t2, $t2, 4		# shift $t2 4 bits to put at first position
			andi $t2, $t2, 0xF	# $t2 = second letter
			lbu $t3, 2($t0)		# load first letter in $t3
			srl $t3, $t3, 4		# shift $t3 4 bits to put at first position
			andi $t3, $t3, 0xF	# $t3 = third letter
			lbu $t4, 3($t0)		# load first letter in $t4
			srl $t4, $t4, 4		# shift $t4 4 bits to put at first position
			andi $t4, $t4, 0xF	# $t4 = fourth letter
			
			lbu $t6, 0($t0)		# load first letter value in $t6
			andi $t6, $t6, 0xF	# $t6 = first letter value
			lbu $t7, 1($t0)		# load second letter value in $t7
			andi $t7, $t7, 0xF	# $t7 = second letter value
			lbu $t8, 2($t0)		# load third letter value in $t8
			andi $t8, $t8, 0xF	# $t8 = third letter value
			lbu $t9, 3($t0)		# load fourth letter value in $t9
			andi $t9, $t9, 0xF	# $t9 = fourth letter value
		
			# Check if $t1 is greater than 9
			check_t1:
				beq $t1, $s0, add_9_1		# $t1 = 4, add 9 to $t6
				j check_t2			# jump to check_t2
				add_9_1:
					addi $t6, $t6, 9	# add 9 to $t6
					j check_t2		# jump to check_t2
			# Check if $t2 is greater than 9	
			check_t2:
				beq $t2, $s0, add_9_2		# $t2 = 4, add 9 to $t7
				j check_t3			# jump to check_t3
				add_9_2:
					addi $t7, $t7, 9	# add 9 to $t7
					j check_t3		# jump to check_t3
			# Check if $t3 is greater than 9
			check_t3:
				beq $t3, $s0, add_9_3		# $t3 = 4, add 9 to $t8
				j check_t4			# jump to check_t4
				add_9_3:
					addi $t8, $t8, 9	# add 9 to $t8
					j check_t4		# jump to check_t4
			# Check if $t4 is greater than 9
			check_t4:
				beq $t4, $s0, add_9_4 		# $t4 = 4, add 9 to $t9
				j new_hex_value			# jump to new_hex_value
				add_9_4:
					addi $t9, $t9, 9	# add 9 to $t9
					j new_hex_value		# jump to new_hex_value
	
			new_hex_value:
				add $s1, $0, $t6		# $s1 first position is $t6
				sll $s1, $s1, 4			# shift left 4 bits
				add $s1, $s1, $t7		# $s1 first position is $t7
				sll $s1, $s1, 4			# shift left 4 bits
				add $s1, $s1, $t8		# $s1 first position is $t8
				sll $s1, $s1, 4			# shift left 4 bits
				add $s1, $s1, $t9		# $s1 first position is $t9
	
			# Converts to two's complement
			sign_one_two:
				lw $s2, addr_arg0		# loads addr_arg0 into $s2
				lbu $s2, 0($s2)			# $s2 = .asciiz value
				andi $s2, $s2, 0xF		# $s2 = 1, 2 or S
				
				lw $s6, eight			# loads word eight to $s6
				andi $s6, $s6, 0xF		# $s6 = 8
				li $t1, 1			# $t1 = 1, where $t1 is the position
				sll  $t1, $t1, 15		# start from the left side, which is the 1st bit
				and $s5, $s1, $t1		# isolate the bit
				srl $s5, $s5, 12		# get number to the first position
				
				lw $t0, one			# load one into $t0
				andi $t0, $t0, 0xF		# $t0 = 1
				lw $t1, two			# load two into $t1
				andi $t1, $t1, 0xF		# $t1 = 2

				beq $t0, $s2, one_arg0		# $s2 = 1, jump to one_arg0
				beq $t1, $s2, two_arg0		# $s2 = 2, jump to two_arg0
				j sign_check_arg0		# otherwise, jump to sign_check_arg0
				
				# Check to see if bits need to be flipped or not for S
				sign_check_arg0:
					bge $s5, $s6, sign_arg0	# if $s5 >= 8, the leftmost bit is 1
					j one_arg0
				
				# Flip bits
				sign_arg0:
					flip_digits:
						li $s7, 9		# $s7 = 9
						addi $s7, $s7, 6	# $s7 = 15
						li $t3, 7		# $t3 = 7 
						sub $t6, $t3, $t6	# subtract $t6 from 7
						sub $t7, $s7, $t7	# subtract $t7 from 15
						sub $t8, $s7, $t8	# subtract $t8 from 15
						sub $t9, $s7, $t9	# subtract $t9 from 15
					
						add $s1, $0, $t6	# $s1 = $t6
						sll $s1, $s1, 4		# shift left 4 bits
						add $s1, $s1, $t7	# $s1 = $t6 $t7
						sll $s1, $s1, 4		# shift left 4 bits
						add $s1, $s1, $t8	# $s1 = $t6 $t7 $t8
						sll $s1, $s1, 4		# shift left 4 bits
						add $s1, $s1, $t9	# $s1 = $t6 $t7 $t8 $t9
						j one_arg0_1		# jump to one_arg0_1
				
				# First argument is 1
				one_arg0:
					lw $s6, eight				# loads word eight to $s6
					andi $s6, $s6, 0xF			# $s6 = 8
					bge $s5, $s6, one_arg0_1		# if $s5 >= 8, the leftmost bit is 1
					j add_zeros				# jump to add_zeros
					
					one_arg0_1:
						addi $s1, $s1, 1		# $s1 = $s1 + 1
						j add_ones			# jump to add_ones
					
				# First argument is 2		
				two_arg0:
					lw $s6, eight				# loads word eight to $s6
					andi $s6, $s6, 0xF			# $s6 = 8
					bge $s5, $s6, add_ones			# if $s5 >= 8, the leftmost bit is 1
					j add_zeros				# jump to add_zeros
				
				# Adds certain number of ones to front
				add_ones:
					# $s4 = sum of second argument, # $t9 = third argument
					lw $s3, addr_arg2		# load addr_arg2 into $s3
					li $t6, 10			# $t6 = 10
					lbu $t7, 0($s3)			# $t7 = first number of argument 2
					andi $t7, $t7, 0xF		# $t7 = first number value
					mul $t7, $t7, $t6		# $t7 multiplied by 10 for tens place
					lbu $t8, 1($s3)			# $t8 = second number of argument 2
					andi $t8, $t8, 0xF		# $t8 = second number value
					add $t7, $t7, $t8		# add the two numbers and store in $t7
					
					move $t0, $t7			# move contents from $t9 to $t0
					addi $t0, $t0, -16		# subtract 16, which is the number of remaining bits
					li $v0, 4			# get ready to print
					one_loop:
						ble $t0, $0, end_one_loop	# $t0 <= 0, exit loop
						la $a0, one			# $a0 = address of one
						syscall				# system call
						addi $t0, $t0, -1		# subtract 1 from $t0
						j one_loop			# jump to one_loop
					end_one_loop:
					j hex_to_print_binary			# jump to hex_to_print_binary
				
				# Adds certain number of zeros to front
				add_zeros:
					# $s4 = sum of second argument, # $t9 = third argument
					lw $s3, addr_arg2		# load addr_arg2 into $s3
					li $t6, 10			# $t6 = 10
					lbu $t7, 0($s3)			# $t7 = first number of argument 2
					andi $t7, $t7, 0xF		# $t7 = first number value
					mul $t7, $t7, $t6		# $t7 multiplied by 10 for tens place
					lbu $t8, 1($s3)			# $t8 = second number of argument 2
					andi $t8, $t8, 0xF		# $t8 = second number value
					add $t7, $t7, $t8		# add the two numbers and store in $t7
					
					move $t0, $t7			# move contents from $t9 to $t0
					addi $t0, $t0, -16		# subtract 16, which is the number of remaining bits
					li $v0, 4			# get ready to print
					zero_loop:
						ble $t0, $0, end_zero_loop	# $t0 <= 0, exit loop
						la $a0, zero			# $a0 = address of zero
						syscall				# system call
						addi $t0, $t0, -1		# subtract 1 from $t0
						j zero_loop			# jump to zero_loop
					end_zero_loop:
					j hex_to_print_binary		# jump to hex_to_print_binary
				
			hex_to_print_binary:
			move $s0, $s1				# s0 = addr_arg1, where the hexadecimal value is stored
			addiu $t0, $zero, 15			# $t0 = 31, where $t0 is the counter
			li $t1, 1				# $t1 = 1, where $t1 is the position
			sll  $t1, $t1, 15			# start from the left side, which is the 1st bit
			li $v0, 1
			li $t4, 0	
			loop:
				blt $t0, $t4, end_loop		# if $t0 < 0, exit the loop (loop executed 32 times)
				and $t3, $s0, $t1		# isolate the bit
				beq $t0, $0, after_shift	# shifts only when $t0 > 0
				srlv  $t3, $t3, $t0		# shifts right before it displays the previous binary digit
				after_shift:
					move $a0, $t3		# bit is about to print
					syscall			# prints the bit
			
				addi $t0, $t0, -1		# counter decreases by 1
				srl $t1, $t1, 1			# shift the position to the right 1 unit
				j loop				# jump back to the top of the loop
			end_loop:
	
			j exit		

###### Part 3: Print a Decimal Fixed-Point Number as a Binary Fixed-Point Number ######																																				
	# Leads to the next argument(s) for fixed-point
	fixed:
		# Argument number validation
		lw $s2, num_args		# loads the contents of num_args to $s2
		li $t0, 2			# $t0 = 2, where $t1 is the number of arguments required to move on
		bne $s2, $t0, args_error	# if $s2 != $t0, go to operation error
									
		lw $t0, addr_arg1		# loads addr_arg1 into $t0
		lbu $t1, 0($t0)			# $t1 = hundredth's place
		andi $t1, $t1, 0xF		# $t1 = value of hundredth's place
		lbu $t2, 1($t0)			# $t2 = ten's place
		andi $t2, $t2, 0xF		# $t2 = value of ten's place
		lbu $t3, 2($t0)			# $t3 = one's place
		andi $t3, $t3, 0xF		# $t3 = value of one's place
	
		# Checks if first integer is 0
		li $t6, 0 				# $t6 = 0
		beq $t1, $t6, second_int_check		# $t1 = 0, check second integer
		j hex_int_sum				# jump to hex_int_sum
		
		# Checks if second integer is 0
		second_int_check:
			beq $t2, $t6, third_int_check	# $t2 = 0, check third integer
			j hex_int_sum			# jump to hex_int_sum
			
		# Checks if third integer is 0
		third_int_check:
			beq $t3, $t6, print_zero_point	# $t3 = 0, go to print_zero_point
			j hex_int_sum			# jump to hex_int_sum
		
		# Prints 0. if first three integers are 0
		print_zero_point:
			li $v0, 4			# gets ready to print a string
			la $a0, zero			# loads address of zero to $a0
			syscall				# prints 0
			la $a0, point			# loads address of point to $a0
			syscall				# prints . (this skips a lot of steps so it prints 0.)
			j decimal_setup			# jump to decimal_setup
		
		# Sums up the three digits to get a hexadecimal value
		hex_int_sum:
			li $t4, 100		# $t4 = 100
			li $t5, 10		# $t5 = 10
			mul $t1, $t1, $t4	# $t1 * 100
			mul $t2, $t2, $t5	# $t2 * 10
			add $s0, $t1, $t2	# $s0 = $t1 + $t2
			add $s0, $s0, $t3	# $s0 = $s0 + $t3
		
		# Finds the first one to avoid printing leading zeros
		li $s4, 9				# $s4 = 9, maximum possible of bits, the three digit number can be
		addiu $t0, $zero, 9			# $t0 = 9, where $t0 is the counter
		li $t1, 1				# $t1 = 1, where $t1 is the position
		sll  $t1, $t1, 9			# start from the left side, which is the 1st bit
		li $t4, 0				# $t4 = 0, used for checking where the first one is
			
		num_of_digits_loop:
			and $t4, $s0, $t1			# isolate the bit
			beq $t4, $t1, end_num_of_digits_loop	# $t4 = 1, end loop
			srl $t1, $t1, 1 			# shift right by 1 bit
			addi $s4, $s4, -1			# counter ($s4) decreases by 1
			j num_of_digits_loop			# jump yo num_of_digits_loop
		end_num_of_digits_loop:
	
		print_binary:
		addu $t0, $zero, $s4			# $t0 = $s4, where $t0 is the counter
		li $t1, 1				# $t1 = 1, where $t1 is the position
		sllv  $t1, $t1, $s4			# start from the left side, which is the 1st bit
		li $v0, 1				# load 1 into $v0 to print integers 
		li $t4, 0				# $t4 = 0

		print_fixed_loop:
			blt $t0, $t4, end_print_fixed_loop	# if $t0 < 0, exit the loop (loop executed 32 times)
			and $t3, $s0, $t1			# isolate the bit
			beq $t0, $0, after_shift_fixed		# shifts only when $t0 > 0
			srlv  $t3, $t3, $t0			# shifts right before it displays the previous binary digit
			after_shift_fixed:
				move $a0, $t3			# bit is about to print
				syscall				# prints the bit
			
			addi $t0, $t0, -1			# counter decreases by 1
			srl $t1, $t1, 1				# shift the position to the right 1 unit
			j print_fixed_loop			# jump back to the top of the loop
		end_print_fixed_loop:
		
		li $v0, 4			# gets ready to print string
		la $a0, point			# loads point into $a0
		syscall				# prints .
	
		decimal_setup:
			lw $t0, addr_arg1	# loads addr_arg1 into $t0
			lbu $t1, 4($t0)		# $t1 = first number after the decimal
			andi $t1, $t1, 0xF	# $t1 = value of first number after the decimal
			lbu $t2, 5($t0)		# $t2 = second number after the decimal
			andi $t2, $t2, 0xF	# $t2 = value of second number after the decimal
			lbu $t3, 6($t0)		# $t3 = third number after the decimal
			andi $t3, $t3, 0xF	# $t3 = value of third number after the decimal
			lbu $t4, 7($t0)		# $t4 = fourth number after the decimal
			andi $t4, $t4, 0xF	# $t4 = value of fourth number after the decimal
			lbu $t5, 8($t0)		# $t5 = fifth number after the decimal
			andi $t5, $t5, 0xF	# $t5 = value of fifth number after the decimal
		
			li $t6, 10000			# $t6 = 10000
			li $t7, 1000			# $t7 = 1000
			li $t8, 100			# $t8 = 100
			li $t9, 10			# $t9 = 10
			mul $t1, $t1, $t6		# $t1 * 10000
			mul $t2, $t2, $t7		# $t2 * 1000
			mul $t3, $t3, $t8		# $t3 * 100
			mul $t4, $t4, $t9		# $t4 * 10
			add $s2, $t1, $t2		# $s2 = decimal value without hundred's, ten's and one's place
			add $s2, $s2, $t3		# $s2 = decimal value without ten's and one's place
			add $s2, $s2, $t4		# $s2 = decimal value without one's place
			add $s2, $s2, $t5		# $s2 = decimal value as a whole number
			
		# Converts number after decimal place to binary
		decimal_place:
			li $t0, 50000			# $t0 = 50000 (starting unit representing 2^(-1))
			li $t1, 2			# $t1 = 2 (used to divide 50000 each iteration)
			li $t2, 5			# $t2 = 5, counter for number of bits after decimal
			decimal_place_loop:
				beq $t2, $0, end_decimal_place_loop	# $t2 = 0, end loop
				ble $t0, $s2, subtract_and_print	# $t0 < $s2, jump to subtract_and_print
				li $v0, 4				# get ready to print string
				la $a0, zero				# load zero into $a0
				syscall					# print 0
				no_subtract:
					div $t0, $t1			# $t0/2 for the next bit
					mflo $t0			# $t0 = quotient
					addi $t2, $t2, -1		# $t2 - 1, counter deducts one
					j decimal_place_loop		# jump to decimal_place_loop
				subtract_and_print:
					sub $s2, $s2, $t0		# $s2 - $t0, since $t0 was less
					li $v0, 4			# get ready to print string
					la $a0, one			# load one into $a0
					syscall				# print 1
					j no_subtract			# jump to no_subtract
			end_decimal_place_loop:
			li $v0, 4			# load 4 into $v0 to print string
			la $a0, new_line		# load new_line into $a0
			syscall				# new line is made							
																																	
		j exit
		
###### Part 4: Encode Six Numerical Fields as an R-Type MIPS Instruction ######
	# Leads to the next argument(s) for r-type
	r_type:
		# Argument number validation
		lw $s2, num_args		# loads the contents of num_args to $s2
		li $t1, 7			# $t1 = 3, where $t1 is the number of arguments required to move on
		bne $s2, $t1, args_error	# if $s2 != $t1, go to operation error
		
		lw $t3, zero			# $t3 = 0
		lw $t4, one			# $t4 = 1
		lw $t5, three			# $t5 = 3
		lw $t6, six			# $t6 = 6
		j third_command			# jump to third_command
		
		# Input validation
		# Third command line validation (0-31)
		third_command:
		lw $t0, addr_arg2	# loads the address of the third command line
		lbu $t1, 0($t0)		# loads the contents of third command line (first position) and stores it in $t1
		lbu $t2, 1($t0)		# loads the contents of third command line (second position) and stores it in $t2
		blt $t1, $t3, args_error 	# $t1 < 0, jump to argument error
		bgt $t1, $t5, args_error	# $t1 > 3, jump to argument error
		beq $t1, $t3, fourth_command	# $t1 = 0, jump to fourth_command
		beq $t1, $t5, first_digit_3	# $t1 = 3, jump to first_digit_3
		j fourth_command
		first_digit_3:
			bgt $t2, $t4, args_error	# $t2 > 1, jump to argument error
		j fourth_command
		
		
		# Fourth command line validation (0-31)
		fourth_command:
		lw $t0, addr_arg3	# loads the address of the fourth command line
		lbu $t1, 0($t0)		# loads the contents of fourth command line (first position) and stores it in $t1
		lbu $t2, 1($t0)		# loads the contents of fourth command line (second position) and stores it in $t2 
		blt $t1, $t3, args_error 	# $t1 < 0, jump to argument error
		bgt $t1, $t5, args_error	# $t1 > 3, jump to argument error
		beq $t1, $t3, fifth_command	# $t1 = 0, jump to fifth_command
		beq $t1, $t5, first_digit_4	# $t1 = 3, jump to first_digit_4
		j fifth_command
		first_digit_4:
			bgt $t2, $t4, args_error	# $t2 > 1, jump to argument error
		j fifth_command
		
		# Fifth command line validation (0-31)
		fifth_command:
		lw $t0, addr_arg4	# loads the address of the fifth command line
		lbu $t1, 0($t0)		# loads the contents of fifth command line (first position) and stores it in $t1
		lbu $t2, 1($t0)		# loads the contents of fifth command line (second position) and stores it in $t2 
		blt $t1, $t3, args_error 	# $t1 < 0, jump to argument error
		bgt $t1, $t5, args_error	# $t1 > 3, jump to argument error
		beq $t1, $t3, sixth_command	# $t1 = 0, jump to sixth_command
		beq $t1, $t5, first_digit_5	# $t1 = 3, jump to fifth_digit_5
		j sixth_command
		first_digit_5:
			bgt $t2, $t4, args_error	# $t2 > 1, jump to argument error
		j sixth_command
		
		# Sixth command line validation (0-31)
		sixth_command:
		lw $t0, addr_arg5	# loads the address of the sixth command line
		lbu $t1, 0($t0)		# loads the contents of sixth command line (first position) and stores it in $t1
		lbu $t2, 1($t0)		# loads the contents of sixth command line (second position) and stores it in $t2
		blt $t1, $t3, args_error 	# $t1 < 0, jump to argument error
		bgt $t1, $t5, args_error	# $t1 > 3, jump to argument error
		beq $t1, $t3, seventh_command	# $t1 = 0, jump to seventh_command
		beq $t1, $t5, first_digit_6	# $t1 = 3, jump to fifth_digit_6
		j seventh_command
		first_digit_6:
			bgt $t2, $t4, args_error	# $t2 > 1, jump to argument error
		j seventh_command
		
		# Seventh command line validation (0-63)
		seventh_command:
		lw $t0, addr_arg6	# loads the address of the seventh command line
		lbu $t1, 0($t0)		# loads the contents of seventh command line (first position) and stores it in $t1
		lbu $t2, 1($t0)		# loads the contents of seventh command line (second position) and stores it in $t2 
		blt $t1, $t3, args_error 	# $t1 < 0, jump to argument error
		bgt $t1, $t6, args_error	# $t1 > 6, jump to argument error
		beq $t1, $t3, fixed_bin_convert	# $t1 = 0, jump to convert_decimal
		beq $t1, $t6, first_digit_7	# $t1 = 6, jump to first_digit_7
		j fixed_bin_convert
		first_digit_7:
			bgt $t2, $t5, args_error  	# $t2 > 3, jump to argument error
		
		
		fixed_bin_convert:
		li $t6, 1		# number that will be multiplied by 2 every iteration
		li $t7, 2		# used to multiply $t6
		li $t8, 1		# used to compare for the bit
		li $s1, 0		# sum of all of the digits


		# Loading bits for funct
		lw $s0, addr_arg6	# loads addr_arg6 into $s0
		lbu $t0, 0($s0)		# $t0 = first digit
		andi $t0, $t0, 0xF	# $t0 = first digit value
		lbu $t1, 1($s0)		# $t1 = second digit
		andi $t1, $t1, 0xF	# $t1 = second digit value
		li $t2, 10		# $t2 = 10 to multiply first digit
		mul $t0, $t0, $t2	# multiply first digit by 10
		add $s0, $t0, $t1	# add $t0 and $t1 for hex value for addr_arg6
		
		li $t3, 0		# $t3 = 0, where $t3 is the counter
		li $t4, 6		# $t3 < $t4 to run since funct is 6 bits
		li $t5, 1		# position of the bit
		
		funct_loop:
			beq $t3, $t4, end_funct_loop	# counter = 6, end loop
			and $t9, $s0, $t5		# isolate the bit
			beq $t9, $0 funct_zero		# $t9 = 0, skip the addition
			add $s1, $s1, $t6		# increases the sum based on position
			funct_zero:
				mul $t6, $t6, $t7	# $t6 * 2
				sll $t5, $t5, 1		# shift left 1 bit
				addi $t3, $t3, 1	# counter + 1
				j funct_loop		# jump to funct_loop
		end_funct_loop:
		
		
		# Loading bits for shamt
		lw $s0, addr_arg5	# loads addr_arg5 into $s0
		lbu $t0, 0($s0)		# $t0 = first digit
		andi $t0, $t0, 0xF	# $t0 = first digit value
		lbu $t1, 1($s0)		# $t1 = second digit
		andi $t1, $t1, 0xF	# $t1 = second digit value
		li $t2, 10		# $t2 = 10 to multiply first digit
		mul $t0, $t0, $t2	# multiply first digit by 10
		add $s0, $t0, $t1	# add $t0 and $t1 for hex value for addr_arg5
		
		li $t3, 0		# $t3 = 0, where $t3 is the counter
		li $t4, 5		# $t3 < $t4 to run since shamt is 5 bits
		li $t5, 1		# position of the bit
		
		shamt_loop:
			beq $t3, $t4, end_shamt_loop	# counter = 6, end loop
			and $t9, $s0, $t5		# isolate the bit
			beq $t9, $0 shamt_zero		# $t9 = 0, skip the addition
			add $s1, $s1, $t6		# increases the sum by 1
			shamt_zero:
				mul $t6, $t6, $t7	# $t6 * 2
				sll $t5, $t5, 1		# shift left 1 bit
				addi $t3, $t3, 1	# counter + 1
				j shamt_loop		# jump to shamt_loop
		end_shamt_loop:				
		
		
		# Loading bits for rd
		lw $s0, addr_arg4	# loads addr_arg4 into $s0
		lbu $t0, 0($s0)		# $t0 = first digit
		andi $t0, $t0, 0xF	# $t0 = first digit value
		lbu $t1, 1($s0)		# $t1 = second digit
		andi $t1, $t1, 0xF	# $t1 = second digit value
		li $t2, 10		# $t2 = 10 to multiply first digit
		mul $t0, $t0, $t2	# multiply first digit by 10
		add $s0, $t0, $t1	# add $t0 and $t1 for hex value for addr_arg4
		
		li $t3, 0		# $t3 = 0, where $t3 is the counter
		li $t4, 5		# $t3 < $t4 to run since shamt is 5 bits
		li $t5, 1		# position of the bit
		
		rd_loop:
			beq $t3, $t4, end_rd_loop	# counter = 6, end loop
			and $t9, $s0, $t5		# isolate the bit
			beq $t9, $0 rd_zero		# $t9 = 0, skip the addition
			add $s1, $s1, $t6		# increases the sum by 1
			rd_zero:
				mul $t6, $t6, $t7	# $t6 * 2
				sll $t5, $t5, 1		# shift left 1 bit
				addi $t3, $t3, 1	# counter + 1
				j rd_loop		# jump to rd_loop
		end_rd_loop:	
			
			
		# Loading bits for rt
		lw $s0, addr_arg3	# loads addr_arg3 into $s0
		lbu $t0, 0($s0)		# $t0 = first digit
		andi $t0, $t0, 0xF	# $t0 = first digit value
		lbu $t1, 1($s0)		# $t1 = second digit
		andi $t1, $t1, 0xF	# $t1 = second digit value
		li $t2, 10		# $t2 = 10 to multiply first digit
		mul $t0, $t0, $t2	# multiply first digit by 10
		add $s0, $t0, $t1	# add $t0 and $t1 for hex value for addr_arg3
		
		li $t3, 0		# $t3 = 0, where $t3 is the counter
		li $t4, 5		# $t3 < $t4 to run since shamt is 5 bits
		li $t5, 1		# position of the bit
		
		rt_loop:
			beq $t3, $t4, end_rt_loop	# counter = 6, end loop
			and $t9, $s0, $t5		# isolate the bit
			beq $t9, $0 rt_zero		# $t9 = 0, skip the addition
			add $s1, $s1, $t6		# increases the sum by 1
			rt_zero:
				mul $t6, $t6, $t7	# $t6 * 2
				sll $t5, $t5, 1		# shift left 1 bit
				addi $t3, $t3, 1	# counter + 1
				j rt_loop		# jump to rt_loop
		end_rt_loop:
		
		
		# Loading bits for rs
		lw $s0, addr_arg2	# loads addr_arg2 into $s0
		lbu $t0, 0($s0)		# $t0 = first digit
		andi $t0, $t0, 0xF	# $t0 = first digit value
		lbu $t1, 1($s0)		# $t1 = second digit
		andi $t1, $t1, 0xF	# $t1 = second digit value
		li $t2, 10		# $t2 = 10 to multiply first digit
		mul $t0, $t0, $t2	# multiply first digit by 10
		add $s0, $t0, $t1	# add $t0 and $t1 for hex value for addr_arg2
		
		li $t3, 0		# $t3 = 0, where $t3 is the counter
		li $t4, 5		# $t3 < $t4 to run since shamt is 5 bits
		li $t5, 1		# position of the bit
		
		rs_loop:
			beq $t3, $t4, end_rs_loop	# counter = 6, end loop
			and $t9, $s0, $t5		# isolate the bit
			beq $t9, $0 rs_zero		# $t9 = 0, skip the addition
			add $s1, $s1, $t6		# increases the sum by 1
			rs_zero:
				mul $t6, $t6, $t7	# $t6 * 2
				sll $t5, $t5, 1		# shift left 1 bit
				addi $t3, $t3, 1	# counter + 1
				j rs_loop		# jump to rd_loop
		end_rs_loop:
		
		# Print the hexadecimal output
		print_hex_output:
			li $v0, 34		# ready to print hexadecimal
			move $a0, $s1		# moves address of $s1 to $a0
			syscall			# prints hexadecimal value
			li $v0, 4		# ready to print string
			la $a0, new_line	# moves address of new_line to $a0
			syscall			# new line is made
			 
		j exit
	
###### Part 5: Identify Non-Standard Five-Card Poker Hands ######
	# Leads to the next argument(s) for poker
	poker:
			lw $s2, num_args		# loads the contents of num_args to $s2
			li $t1, 2			# $t1 = 3, where $t1 is the number of arguments required to move on
			bne $s2, $t1, args_error	# if $s2 != $t1, go to operation error
			j configure_value
			
			# Configures the values of each card
			configure_value:
				lw $s3, addr_arg1	# load the addr_arg1 into $t0
				lbu $t1, 0($s3)		# get the first hexadecimal digit for $t1
				andi $t1, $t1, 0xF	# convert the hexadecimal digit to the value of the card of $t1
				lbu $t2, 1($s3)		# get the first hexadecimal digit for $t2
				andi $t2, $t2, 0xF	# convert the hexadecimal digit to the value of the card of $t2
				lbu $t3, 2($s3)		# get the first hexadecimal digit for $t3
				andi $t3, $t3, 0xF	# convert the hexadecimal digit to the value of the card of $t3
				lbu $t4, 3($s3)		# get the first hexadecimal digit for $t4
				andi $t4, $t4, 0xF	# convert the hexadecimal digit to the value of the card of $t4
				lbu $t5, 4($s3)		# get the first hexadecimal digit for $t5
				andi $t5, $t5, 0xF	# convert the hexadecimal digit to the value of the card of $t5
				j big_bobtail		# jump to big_bobtail
				
			# Checks if hand is big bobtail
			big_bobtail:
				li $s4, 1		# $s4 = 1, counter 1
				lw $s6, four		# $s6 = 4, used to compare
				andi $s6, $s6, 0xF	# $s6 gets the 4 by itself
				
				lbu $t6, 0($s3)		# get the first hexadecimal digit for $t6
				srl $t6, $t6, 4		# shift $t6 4 bits to get the tens place digit
				andi $t6, $t6, 0xF	# convert the hexadecimal digit to the suit of the card of $t6
				lbu $t7, 1($s3)		# get the first hexadecimal digit for $t7
				srl $t7, $t7, 4		# shift $t7 4 bits to get the tens place digit
				andi $t7, $t7, 0xF	# convert the hexadecimal digit to the value of the card of $t7
				lbu $t8, 2($s3)		# get the first hexadecimal digit for $t8
				srl $t8, $t8, 4		# shift $t8 4 bits to get the tens place digit
				andi $t8, $t8, 0xF	# convert the hexadecimal digit to the value of the card of $t8
				lbu $t9, 3($s3)		# get the first hexadecimal digit for $t9
				srl $t9, $t9, 4		# shift $t9 4 bits to get the tens place digit
				andi $t9, $t9, 0xF	# convert the hexadecimal digit to the value of the card of $t9
				lbu $t0, 4($s3)		# get the first hexadecimal digit for $t0
				srl $t0, $t0, 4		# shift $t0 4 bits to get the tens place digit
				andi $t0, $t0, 0xF	# convert the hexadecimal digit to the value of the card of $t0
				
				bne $t6, $t7, suit_7	# $t6 != $t7, jump to suit_7
				bne $t6, $t8, suit_8	# $t6 != $t7, jump to suit_8
				bne $t6, $t9, suit_9	# $t6 != $t7, jump to suit_9
				bne $t6, $t0, suit_0	# $t6 != $t7, jump to suit_0
				move $s7, $t6		# stores suit in $s7 if all cards are the same suit
				j bobtail_min		# jump to bobtail_min
				
				# Checks cards with same suit as $t7
				suit_7:
					move $s7, $t7			# $s7 = $t7, stores the suit
					bne $t7, $t8, suit_6_7		# $t7 != $t8, jump to suit_6
					bne $t7, $t9, full_house	# $t7 != $t9, no chance of four of same suit, jump to full_house
					bne $t7, $t0, full_house	# $t7 != $t0, no chance of four of same suit, jump to full_house
					j bobtail_min			# hump to bobtail_min
				# Checks cards with same suit as $t8
				suit_8:
					move $s7, $t8			# $s7 = $t7, stores the suit
					bne $t8, $t7, suit_6_7		# $t8 != $t7, jump to suit_6
					bne $t8, $t9, full_house	# $t8 != $t9, no chance of four of same suit, jump to full_house
					bne $t8, $t0, full_house	# $t8 != $t0, no chance of four of same suit, jump to full_house
					j bobtail_min			# jump to bobtail_min
				# Checks cards with same suit as $t9
				suit_9:
					move $s7, $t9			# $s7 = $t7, stores the suit
					bne $t9, $t7, suit_6_7		# $t9 != $t7, jump to suit_6
					bne $t9, $t8, full_house	# $t9 != $t8, no chance of four of same suit, jump to full_house
					bne $t9, $t0, full_house	# $t9 != $t0, no chance of four of same suit, jump to full_house
					j bobtail_min			# jump to bobtail_min
				# Checks cards with same suit as $t0
				suit_0:
					move $s7, $t0			# $s7 = $t7, stores the suit
					bne $t0, $t7, suit_6_7		# $t0 != $t7, jump to suit_6
					bne $t0, $t8, full_house	# $t0 != $t8, no chance of four of same suit, jump to full_house
					bne $t0, $t9, full_house	# $t0 != $t9, no chance of four of same suit, jump to full_house
					j bobtail_min			# jump to bobtail_min
				# Checks cards with same suit as $t6
				suit_6_7:
					move $s7, $t6			# $s7 = $t7, stores the suit
					addi $s4, $s4, 1		# $s4 = $s4 + 1 automatically
					beq $t6, $t7, suit_6_8		# $t6 = $t7, jump to suit_6_8
					addi $s4, $s4, -1		# $s4 = $s4 - 1 if $t6 != $t7
					j suit_6_8			# jump to suit_6_8
				suit_6_8:
					addi $s4, $s4, 1		# $s4 = $s4 + 1 automatically
					beq $t6, $t8, suit_6_9		# $t6 = $t8, jump to suit_6_9
					addi $s4, $s4, -1		# $s4 = $s4 - 1 if $t6 != $t8
					j suit_6_9			# jump to suit_6_9
				suit_6_9:
					addi $s4, $s4, 1		# $s4 = $s4 + 1 automatically
					beq $t6, $t9, suit_6_0		# $t6 = $t9, jump to suit_6_0
					addi $s4, $s4, -1		# $s4 = $s4 - 1 if $t6 != $t9
					j suit_6_0			# jump to suit_6_0
				suit_6_0:
					addi $s4, $s4, 1		# $s4 = $s4 + 1 automatically
					beq $t6, $t0, bobtail_counter	# $t6 = $t0, jump to bobtail_counter
					addi $s4, $s4, -1		# $s4 = $s4 - 1 if $t6 != $t0
					j bobtail_counter		# jump to bobtail_counter
				bobtail_counter:
					bge $s4, $s6, bobtail_min	# $s4 >= 4, jump to bobtail_message
					j full_house			# jump to full_house
				
				bobtail_min:	
					lw $s5, min_starter 		
					andi $s5, $s5, 0xF
					blt $t1, $t2, t1_min		# $t1 < $t2, jump to t2_min
					j t2_min			# jump to t2_min
					
					# Checks all other numbers if $t1 is min
					t1_min:
						bne $t6, $s7, t1_3_check	# not min unless, suits match
						move $s5, $t1			# move $t1 to $s5
						
						t1_3_check:
						bgt $s5, $t3, t1_3_min	# $s5 < $t3, jump to t1_3_min
						j t1_4_check		# jump to t1_4_min
						
						# Sets $s5 (min) to $t3
						t1_3_min:
							bne $t8, $s7, t1_4_check	# not min unless, suits match
							move $s5, $t3			# $s5 = $s3, new min
						
						# Checks if $t1 < $t4	
						t1_4_check:
						bgt $s5, $t4, t1_4_min	# $s5 < $t4, jump to t1_4_min
						j t1_5_check		# jump to t1_5_min
						
						# Sets $s5 (min) to $t4
						t1_4_min:
							bne $t9, $s7, t1_5_check	# not min unless, suits match
							move $s5, $t4			# $s5 = $s4, new min
							
						# Checks if $t1 < $t5	
						t1_5_check:
						bgt $s5, $t5, t1_5_min		# $s5 < $t5, jump to t1_5_min
						j bobtail_set_up		# jump to bobtail_set_up
						
						# Sets $s5 (min) to $t5
						t1_5_min:
							bne $t0, $s7, bobtail_set_up	# not min unless, suits match
							move $s5, $t5			# $s5 = $t5, new min
							j bobtail_set_up		# jump to bobtail_set_up
									
					# Checks all other numbers if $t2 is min
					t2_min:
						bne $t7, $s7, t2_3_check	# not min unless, suits match
						move $s5, $t2			# move $t2 to $s5
						
						t2_3_check:
						bgt $s5, $t3, t2_3_min	# $s5 < $t3, jump to t2_3_min
						j t2_4_check		# jump to t2_4_min
						# Sets $s5 (min) to $t3
						t2_3_min:
							bne $t8, $s7, t2_4_check	# not min unless, suits match
							move $s5, $t3			# $s5 = $s3, new min
						
						# Checks if $t1 < $t4	
						t2_4_check:
						bgt $s5, $t4, t2_4_min	# $s5 < $t4, jump to t2_4_min
						j t2_5_check		# jump to t1_5_min
						# Sets $s5 (min) to $t4
						t2_4_min:
							bne $t9, $s7, t2_5_check	# not min unless, suits match
							move $s5, $t4			# $s5 = $s4, new min
							
						# Checks if $t1 < $t5	
						t2_5_check:
						bgt $s5, $t5, t2_5_min		# $s5 < $t5, jump to t2_5_min
						j bobtail_set_up		# jump to bobtail_set_up
						# Sets $s5 (min) to $t5
						t2_5_min:
							bne $t0, $s7, bobtail_set_up	# not min unless, suits match
							move $s5, $t5			# $s5 = $t5, new min
							j bobtail_set_up		# jump to bobtail_set_up
							
						
				# Sets up the min and max of the four card sequence
				bobtail_set_up:	
					move $s3, $s5		# $s3 = $s5, used for tracking numbers
					addi $s3, $s3, 4	# this is the max number
					li $s4, 0		# $s4 = 0, counter
						
				# Loops to check if numbers of the same suit are in sequential order
				bobtail_loop:
					bgt $s5, $s3, bobtail_end_loop	# $s5 > $s3, jump to bobtail_end_loop
					beq $t1, $s5, check_suit_1	# $t1 = $s5, jump to check_suit_1
					beq $t2, $s5, check_suit_2	# $t2 = $s5, jump to check_suit_2
					beq $t3, $s5, check_suit_3	# $t3 = $s5, jump to check_suit_3
					beq $t4, $s5, check_suit_4	# $t4 = $s5, jump to check_suit_4
					beq $t5, $s5, check_suit_5	# $t5 = $s5, jump to check_suit_5
					addi $s5, $s5, 1		# add 1 to $s5, being the counter
					j bobtail_loop			# jump to bobtail_loop
					
					check_suit_1:
						addi $s5, $s5, 1		# add 1 to $s5
						addi $s4, $s4, 1		# add 1 to $s4
						beq $t6, $s7, bobtail_loop	# $t6 = $s7, jump to bobtail_loop
						addi $s4, $s4, -1 		# subtract 1 from $s4 if not =
						j bobtail_loop			# jump to bobtail_loop
					check_suit_2:
						addi $s5, $s5, 1		# add 1 to $s5
						addi $s4, $s4, 1		# add 1 to $s4
						beq $t7, $s7, bobtail_loop	# $t7 = $s7, jump to bobtail_loop
						addi $s4, $s4, -1 		# subtract 1 from $s4 if not =
						j bobtail_loop			# jump to bobtail_loop
					check_suit_3:
						addi $s5, $s5, 1		# add 1 to $s5
						addi $s4, $s4, 1		# add 1 to $s4
						beq $t8, $s7, bobtail_loop	# $t8 = $s7, jump to bobtail_loop
						addi $s4, $s4, -1 		# subtract 1 from $s4 if not =
						j bobtail_loop			# jump to bobtail_loop
					check_suit_4:
						addi $s5, $s5, 1		# add 1 to $s5
						addi $s4, $s4, 1		# add 1 to $s4
						beq $t9, $s7, bobtail_loop	# $t9 = $s7, jump to bobtail_loop
						addi $s4, $s4, -1 		# subtract 1 from $s4 if not =
						j bobtail_loop			# jump to bobtail_loop
					check_suit_5:
						addi $s5, $s5, 1		# add 1 to $s5
						addi $s4, $s4, 1		# add 1 to $s4
						beq $t0, $s7, bobtail_loop	# $t0 = $s7, jump to bobtail_loop
						addi $s4, $s4, -1 		# subtract 1 from $s4 if not =
						j bobtail_loop			# jump to bobtail_loop
				bobtail_end_loop:
					bge $s4, $s6, bobtail_message		# $s4 = $s6, jump to bobtail_message
					j full_house				# jump to full_house
				
				bobtail_message:
				li $v0, 4		# gets ready to print
				la $a0, big_bobtail_str # loads address of big_bobtail_str
				syscall			# print message
				j exit			# jump to exit
				
			# Checks if hand is full house
			full_house:
				li $t6, 1			# $t6 = 1, counter 1
				li $t7, 1			# $t6 = 1, counter 2
				lw $t8, two			# get the first hexadecimal digit for $t8
				andi $t8, $t8, 0xF		# convert the hexadecimal digit to the value of the card of $t8
				lw $t9, three			# get the first hexadecimal digit for $t9
				andi $t9, $t9, 0xF		# convert the hexadecimal digit to the value of the card of $t9
				
				bne $t1, $t2, count_2_3		# $t1 != $t2, jump to count_2_3
				bne $t1, $t3, count_3_2		# $t1 != $t3, jump to count_3_2
				bne $t1, $t4, count_4_2		# $t1 != $t4, jump to count_4_2
				bne $t1, $t5, count_5_2		# $t1 != $t5, jump to count_5_2
				
				# $t2 is different from $t1
				count_2_3:
					addi $t6, $t6, 1		# $t6 = $t6 + 1 automatically
					beq $t2, $t3, count_2_4 	# $t2 = $t3, jump to count_2_4
					addi $t6, $t6, -1		# $t6 = $t6 - 1 if $t2 != $t3
				count_2_4:
					addi $t6, $t6, 1		# $t6 = $t6 + 1 automatically
					beq $t2, $t4, count_2_5		# $t2 = $t4, jump to count_2_5
					addi $t6, $t6, -1		# $t6 = $t6 - 1 if $t2 != $t4
				count_2_5:
					addi $t6, $t6, 1		# $t6 = $t6 + 1 automatically
					beq $t2, $t5, count_1_2		# $t2 = $t5, jump to count_1_2
					addi $t6, $t6, -1		# $t6 = $t6 - 1 if $t2 != $t5
					j count_1_2			# jump to count_1_2
					
				# $t3 is different from $t1
				count_3_2:
					addi $t6, $t6, 1		# $t6 = $t6 + 1 automatically
					beq $t3, $t2, count_3_4 	# $t3 = $t2, jump to count_3_4
					addi $t6, $t6, -1		# $t6 = $t6 - 1 if $t3 != $t2
				count_3_4:
					addi $t6, $t6, 1		# $t6 = $t6 + 1 automatically
					beq $t3, $t4, count_3_5 	# $t3 = $t4, jump to count_3_5
					addi $t6, $t6, -1		# $t6 = $t6 - 1 if $t3 != $t4
				count_3_5:
					addi $t6, $t6, 1		# $t6 = $t6 + 1 automatically
					beq $t3, $t5, count_1_2 	# $t3 = $t5, jump to count_1_2
					addi $t6, $t6, -1		# $t6 = $t6 - 1 if $t3 != $t5
					j count_1_2			# jump to count_1_2
				
				# $t4 is different from $t1	
				count_4_2:
					addi $t6, $t6, 1		# $t6 = $t6 + 1 automatically
					beq $t4, $t2, count_4_3		# $t4 = $t2, jump to count_4_3
					addi $t6, $t6, -1		# $t6 = $t6 - 1 if $t4 != $t2
				count_4_3:
					addi $t6, $t6, 1		# $t6 = $t6 + 1 automatically
					beq $t4, $t3, count_4_5		# $t4 = $t3, jump to count_4_5
					addi $t6, $t6, -1		# $t6 = $t6 - 1 if $t4 != $t3
				count_4_5:
					addi $t6, $t6, 1		# $t6 = $t6 + 1 automatically
					beq $t4, $t5, count_1_2		# $t4 = $t5, jump to count_1_2
					addi $t6, $t6, -1		# $t6 = $t6 - 1 if $t4 != $t5
					j count_1_2			# jump to count_1_2
				
				# $t5 is different from $t1
				count_5_2:
					addi $t6, $t6, 1		# $t6 = $t6 + 1 automatically
					beq $t5, $t2, count_5_3		# $t5 = $t2, jump to count_5_3
					addi $t6, $t6, -1		# $t6 = $t6 - 1 if $t5 != $t2
				count_5_3:
					addi $t6, $t6, 1		# $t6 = $t6 + 1 automatically
					beq $t5, $t3, count_5_4		# $t5 = $t3, jump to count_5_4
					addi $t6, $t6, -1		# $t6 = $t6 - 1 if $t5 != $t3
				count_5_4:
					addi $t6, $t6, 1		# $t6 = $t6 + 1 automatically
					beq $t5, $t4, count_1_2		# $t2 = $t3, jump to count_2_4
					addi $t6, $t6, -1		# $t6 = $t6 - 1 if $t5 != $t4
					j count_1_2			# jump to count_1_2
				
				# $t1 count since different from other card
				count_1_2:
					addi $t7, $t7, 1		# $t7 = $t7 + 1 automatically
					beq $t1, $t2, count_1_3		# $t1 = $t2, jump to count_1_3
					addi $t7, $t7, -1		# $t7 = $t7 - 1 if $t1 != $t2
				count_1_3:
					addi $t7, $t7, 1		# $t7 = $t7 + 1 automatically
					beq $t1, $t3, count_1_4		# $t1 = $t3, jump to count_1_4
					addi $t7, $t7, -1		# $t7 = $t7 - 1 if $t1 != $t3
				count_1_4:
					addi $t7, $t7, 1		# $t7 = $t7 + 1 automatically
					beq $t1, $t4, count_1_5		# $t1 = $t4, jump to count_1_5
					addi $t7, $t7, -1		# $t7 = $t7 - 1 if $t1 != $t4
				count_1_5:
					addi $t7, $t7, 1		# $t7 = $t7 + 1 automatically
					beq $t1, $t5, t6_2		# $t1 = $t5, jump to t6_2
					addi $t7, $t7, -1		# $t7 = $t7 - 1 if $t1 != $t5
					j t6_2				# jump to t6_2
				
				# Checks if $t6 has count 2	
				t6_2:
					beq $t6, $t8, t7_3		# $t6 = $t8, jump to t7_3
					j t7_3				# jump to t7_3
				# Checks if $t6 has count 3
				t6_3:
					beq $t6, $t9, t7_2		# $t6 = $t9, jump to t7_2
					j t7_2				# jump to t7_2
				# Checks if $t7 has count 2
				t7_2:
					beq $t7, $t8, full_house_message	# $t7 = $t8, jump to full_house_message
					j five_and_dime				# jump to five_and_dime
				# Checks if $t7 has count 3
				t7_3:
					beq $t7, $t9, full_house_message	# $t7 = $t9, jump to full_house_message
					j five_and_dime				# jump to five_and_dime
				
				# Prints the message for full_house
				full_house_message:
				li $v0, 4			# gets ready to print
				la $a0, full_house_str		# loads address of full_house_str
				syscall				# print message
				j exit				# jump to exit
				
			# Checks if hand is five and dime
			five_and_dime:
				lw $t6, five			# get the first hexadecimal digit for $t6
				andi $t6, $t6, 0xF		# convert the hexadecimal digit to the value of the card of $t6
				lw $t7, nine			# get the first hexadecimal digit for $t7
				addi $t7, $t7, 1		# adds 1 to $t7 to get 10
				andi $t7, $t7, 0xF		# convert the hexadecimal digit to the value of the card of $t7
				
				beq $t1, $t2, skeet		# $t1 = $t2, jump to skeet
				beq $t1, $t3, skeet		# $t1 = $t3, jump to skeet
				beq $t1, $t4, skeet		# $t1 = $t4, jump to skeet
				beq $t1, $t5, skeet		# $t1 = $t5, jump to skeet
				beq $t2, $t3, skeet		# $t2 = $t3, jump to skeet
				beq $t2, $t4, skeet		# $t2 = $t4, jump to skeet
				beq $t2, $t5, skeet		# $t2 = $t5, jump to skeet
				beq $t3, $t4, skeet		# $t3 = $t4, jump to skeet
				beq $t3, $t5, skeet		# $t3 = $t5, jump to skeet
				beq $t4, $t5, skeet		# $t4 = $t5, jump to skeet
				
				blt $t1, $t6, skeet		# $t1 <= 5, jump to skeet
				bgt $t1, $t7, skeet		# $t1 >= 10, jump to skeet
				blt $t2, $t6, skeet		# $t2 <= 5, jump to skeet
				bgt $t2, $t7, skeet		# $t2 >= 10, jump to skeet
				blt $t3, $t6, skeet		# $t3 <= 5, jump to skeet
				bgt $t3, $t7, skeet		# $t3 >= 10, jump to skeet
				blt $t4, $t6, skeet		# $t4 <= 5, jump to skeet
				bgt $t4, $t7, skeet		# $t4 >= 10, jump to skeet
				blt $t5, $t6, skeet		# $t5 <= 5, jump to skeet
				bgt $t5, $t7, skeet		# $t5 >= 10, jump to skeet
				
				li $v0, 4			# gets ready to print
				la $a0, five_and_dime_str	# loads address of five_and_dime_str
				syscall				# print message
				j exit				# jump to exit
			
			# Checks if hand is skeet
			skeet:
				lw $t6, two			# get the first hexadecimal digit for $t6
				andi $t6, $t6, 0xF		# convert the hexadecimal digit to the value of the card of $t6
				lw $t7, five			# get the first hexadecimal digit for $t7
				andi $t7, $t7, 0xF		# convert the hexadecimal digit to the value of the card of $t7
				lw $t8, nine			# get the first hexadecimal digit for $t8
				andi $t8, $t8, 0xF		# convert the hexadecimal digit to the value of the card of $t8
				
				check_2:
					beq $t1, $t6, check_5	# $t1 = 2, jump to check_5
					beq $t2, $t6, check_5	# $t2 = 2, jump to check_5
					beq $t3, $t6, check_5	# $t3 = 2, jump to check_5
					beq $t4, $t6, check_5	# $t4 = 2, jump to check_5
					beq $t5, $t6, check_5	# $t5 = 2, jump to check_5
					j blaze			# jump to blaze
				check_5:
					beq $t1, $t7, check_9	# $t1 = 5, jump to check_9
					beq $t2, $t7, check_9	# $t2 = 5, jump to check_9
					beq $t3, $t7, check_9	# $t3 = 5, jump to check_9
					beq $t4, $t7, check_9	# $t4 = 5, jump to check_9
					beq $t5, $t7, check_9	# $t5 = 5, jump to check_9
					j blaze			# jump to blaze
				check_9:
					beq $t1, $t8, check_rest_1	# $t1 = 9, jump to check_rest_1
					beq $t2, $t8, check_rest_2	# $t2 = 9, jump to check_rest_2
					beq $t3, $t8, check_rest_3	# $t3 = 9, jump to check_rest_3
					beq $t4, $t8, check_rest_4	# $t4 = 9, jump to check_rest_4
					beq $t5, $t8, check_rest_5	# $t5 = 9, jump to check_rest_5
					j blaze				# jump to blaze
				check_rest_1:
					bge $t2, $t8, blaze		# $t2 > 9, jump to blaze
					bge $t3, $t8, blaze		# $t3 > 9, jump to blaze
					bge $t4, $t8, blaze		# $t4 > 9, jump to blaze
					bge $t5, $t8, blaze		# $t5 > 9, jump to blaze
					j skeet_message			# jump to skeet_message
				check_rest_2:
					bge $t1, $t8, blaze		# $t1 > 9, jump to blaze
					bge $t3, $t8, blaze		# $t3 > 9, jump to blaze
					bge $t4, $t8, blaze		# $t4 > 9, jump to blaze
					bge $t5, $t8, blaze		# $t5 > 9, jump to blaze
					j skeet_message			# jump to skeet_message
				check_rest_3:
					bge $t1, $t8, blaze		# $t1 > 9, jump to blaze
					bge $t2, $t8, blaze		# $t2 > 9, jump to blaze
					bge $t4, $t8, blaze		# $t4 > 9, jump to blaze
					bge $t5, $t8, blaze		# $t5 > 9, jump to blaze
					j skeet_message			# jump to skeet_message
				check_rest_4:
					bge $t1, $t8, blaze		# $t1 > 9, jump to blaze
					bge $t2, $t8, blaze		# $t2 > 9, jump to blaze
					bge $t3, $t8, blaze		# $t3 > 9, jump to blaze
					bge $t5, $t8, blaze		# $t5 > 9, jump to blaze
					j skeet_message			# jump to skeet_message
				check_rest_5:	
					bge $t1, $t8, blaze		# $t1 > 9, jump to blaze
					bge $t2, $t8, blaze		# $t2 > 9, jump to blaze
					bge $t3, $t8, blaze		# $t3 > 9, jump to blaze
					bge $t4, $t8, blaze		# $t4 > 9, jump to blaze
					j skeet_message			# jump to skeet_message
				skeet_message:
					li $v0, 4			# gets ready to print
					la $a0, skeet_str		# loads address of skeet_str
					syscall				# print message
					j exit				# jump to exit
				
			# Checks if hand is blaze
			blaze:
				lw $t6, nine				# get the first hexadecimal digit for $t6
				addi $t6, $t6, 1			# adds 1 to $t6 to get 10
				andi $t6, $t6, 0xF			# convert the hexadecimal digit to the value of the card of $t6
				
				ble $t1, $t6, high_card			# $t1 <= 10, jump to high_card
				ble $t2, $t6, high_card			# $t2 <= 10, jump to high_card
				ble $t3, $t6, high_card			# $t3 <= 10, jump to high_card
				ble $t4, $t6, high_card			# $t4 <= 10, jump to high_card
				ble $t5, $t6, high_card			# $t5 <= 10, jump to high_card
				
				li $v0, 4				# gets ready to print
				la $a0, blaze_str			# loads address of blaze_str
				syscall					# print message
				j exit					# jump to exit
			
			# Automatically prints high card if hand fits none of the others
			high_card:
				li $v0, 4				# gets ready to print
				la $a0, high_card_str			# loads address of high_card_str
				syscall					# print message
				j exit					# jump to exit
# End of the program
exit:
	li $v0, 10	# gets ready to end program
   	syscall		# ends program
