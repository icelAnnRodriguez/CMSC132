##############################################################################
#
#  KURS: 1DT016 2014.  Computer Architecture
#	
# DATUM:
#
#  NAMN:			
#
#  NAMN:
#	by: Lovely Grace Arsolon & Icel Ann Rodriguez
#	date: 03.26.2018
##############################################################################

	.data
	
ARRAY_SIZE:
	.word	0	# Change here to try other values (less than 10)
FIBONACCI_ARRAY:
	.word	1, 1, 2, 3, 5, 8, 13, 21, 34, 55
STR_str:
	.asciiz "?@ AB YZ [\\ _` ab yz {|"
	.globl DBG
	.text

##############################################################################
#
# DESCRIPTION:  For an array of integers, returns the total sum of all
#		elements in the array.
#
# INPUT:        $a0 - address to first integer in array.
#		$a1 - size of array, i.e., numbers of integers in the array.
#
# OUTPUT:       $v0 - the total sum of all integers in the array.
#
##############################################################################
integer_array_sum:  

DBG:	##### DEBUGG BREAKPOINT ######

        addi    $v0, $zero, 0           # Initialize Sum to zero.
	add	$s0, $zero, $zero	# Initialize array index i to zero.
	
for_all_in_array:

	#### Append a MIPS-instruktion before each of these comments
	
	beq 	$s0, $a1 , end_for_all 	# Done if i == N
	sll 	$s4, $s0, 2 		# offset = 4*i, shift the index stored in $t0 by two bits to the left.
	add 	$s3, $a0, $s4 		# address = ARRAY + 4*i
	lw 	$s5, 0($s3)		# n = A[i]
       	add 	$v0, $v0, $s5 		# Sum = Sum + n
        addi 	$s0, $s0, 1		# i++ 
  	j 	for_all_in_array	# next element
	
end_for_all:
	
	jr	$ra			# Return to caller.
	
##############################################################################
#
# DESCRIPTION: Gives the length of a string.
#
#       INPUT: $a0 - address to a NUL terminated string.
#
#      OUTPUT: $v0 - length of the string (NUL excluded).
#
#    EXAMPLE:  string_length("abcdef") == 6.
#
##############################################################################	
string_length:

	#### Write your solution here ####
	addi $s5, $zero, 0 		#store null (or 0) to $s5
	addi $v0, $zero, 0		#initialize $v0 to 0

loop:
	lb $s1, 0($a0)		# load the next character into t1
	beq 	$s1, $s5, exit 	# check for the null character
	addi 	$a0, $a0, 1 	# increment the string pointer
	addi 	$v0, $v0, 1 	# increment the count
	j 	loop 		# return to the top of the loop
exit:
	jr	$ra
	
##############################################################################
#
#  DESCRIPTION: For each of the characters in a string (from left to right),
#		call a callback subroutine.
#
#		The callback suboutine will be called with the address of
#	        the character as the input parameter ($a0).
#	
#        INPUT: $a0 - address to a NUL terminated string.
#
#		$a1 - address to a callback subroutine.
#
##############################################################################	
string_for_each:
	addi $s5, $zero, 0 		# store null (0) to $s5
loop2:
	lb 	$s6, 0($a0)		# load the next character into $s6
	beq 	$s6, $s5, exit2 	# check for the null character
	
	addi 	$sp, $sp, -4
	sw	$a0, 0($sp)	# save value of $a0
	addi 	$sp, $sp, -4
	sw	$ra, 0($sp)	# save return address before each subroutine call
	
	jalr 	$a1		# call callback subroutine
	
	lw	$ra, 0($sp)	# restore return address after each subroutine call
	addi 	$sp, $sp, 4
	lw	$a0, 0($sp)	# load old value of $a0
	addi 	$sp, $sp, 4
	addi 	$a0, $a0, 1 	# increment the string pointer
	j 	loop2 		# loop again
exit2:
	jr $ra			# return to caller

##############################################################################
#
#  DESCRIPTION: Transforms a lower case character [a-z] to upper case [A-Z].
#	
#        INPUT: $a0 - address of a character 
#
##############################################################################		
to_upper:

	#### Write your solution here ####

	addi 	$s6, $zero, 0
	addi	$s5, $zero, 0
	addi	$s4, $zero, 0
	
	lb 	$s4, 0($a0)
	addi	$s6, $zero, 1			# store 1 to $s6, for comparison of $s5
	slti	$s5, $s4, 123			# set $s5 to 1 if char lesser than '{ = 123', 'z = 122'
	bne	$s6, $s5, return_to_caller	# if $s5 is 0, don't need to change special char
	addi	$s4, $s4, -32			# lower the case of a char
   	slti 	$s5, $s4, 65			# set $s5 to 1 if char - 32 is lesser than 65('A')
   	bne 	$s5, $s6, store_cap		# if $s5 is 0, meaning greater than = 65, store and return capitalized char
   	j	return_to_caller
   store_cap:
   	sb	$s4, 0($a0)			# store byte ro $a0
   return_to_caller:
	jr	$ra				# return to caller
##############################################################################
#
#  DESCRIPTION: Reverse a string
#	
#        INPUT: $a0 - address to a NULL terminated string 
#	 LENGTH: $v0
#	 TIMES: (length / 2) = $s1
#	 CNTR_START: $s2
#	 CNTR_END: (length - 1) $s3
#
##############################################################################		
reverse_string:
	addi 	$sp, $sp, -4
	sw	$a0, 0($sp)	# save value of $a0
	addi 	$sp, $sp, -4
	sw	$ra, 0($sp)	# save return address before each subroutine call
	
	jal	string_length	# call string length function and store length to $v0
	
	lw	$ra, 0($sp)	# restore return address after each subroutine call
	addi 	$sp, $sp, 4
	
	lw	$a0, 0($sp)	# load old value of $a0
	addi 	$sp, $sp, 4	
	
	addi 	$s0, $zero, 2	# store divisor (2) to register $s1
	div 	$s1, $v0, $s0 	# divide length by two
	
	addi	$s2, $zero, 0	# cntr or i
	addi	$s3, $v0, -1	# length - 1
	
	addi 	$s6, $a0, 0	# copy first char address
	
loop_in_revs:
	beq	$s2, $s1, return_exit
	lb 	$s4, 0($a0)	# load left-side char to $t4
	add	$a0, $a0, $s3	# add address of string, $a0, by the remaining char (length of str)
	lb 	$s5, 0($a0)	# load right-side char to $t5
	sb	$s4, 0($a0)	# store value from $t4 to other side (kaswap niya)
	sub	$a0, $a0, $s3	# restore the pointer to $a0 original address
	sb	$s5, 0($a0)	# store value from $t5 to left part side
	addi	$a0, $a0, 1	# increment string pointer from the left
	addi	$s3, $s3, -2	# decrement string pointer from the right
	addi	$s2, $s2, 1	#increment cntr for times
	
	j 	loop_in_revs

return_exit:
	jr 	$ra	
##############################################################################
##############################################################################
##
##	  You don't have to change anyghing below this line.
##	
##############################################################################
##############################################################################

	
##############################################################################
#
# Strings used by main:
#
##############################################################################

	.data

NLNL:	.asciiz "\n\n"
	
STR_sum_of_fibonacci_a:	
	.asciiz "The sum of the " 
STR_sum_of_fibonacci_b:
	.asciiz " first Fibonacci numbers is " 

STR_string_length:
	.asciiz	"\n\nstring_length(str) = "

STR_for_each_ascii:	
	.asciiz "\n\nstring_for_each(str, ascii)\n"

STR_for_each_to_upper:
	.asciiz "\n\nstring_for_each(str, to_upper)\n\n"	

	.text
	.globl main

##############################################################################
#
# MAIN: Main calls various subroutines and print out results.
#
##############################################################################	
main:
	addi	$sp, $sp, -4	# PUSH return address
	sw	$ra, 0($sp)

	##
	### integer_array_sum
	##
	
	li	$v0, 4
	la	$a0, STR_sum_of_fibonacci_a
	syscall

	lw 	$a0, ARRAY_SIZE
	li	$v0, 1
	syscall

	li	$v0, 4
	la	$a0, STR_sum_of_fibonacci_b
	syscall
	
	la	$a0, FIBONACCI_ARRAY
	lw	$a1, ARRAY_SIZE
	jal 	integer_array_sum

	# Print sum
	add	$a0, $v0, $zero
	li	$v0, 1
	syscall

	li	$v0, 4
	la	$a0, NLNL
	syscall
	
	la	$a0, STR_str
	jal	print_test_string

	##
	### string_length 
	##
	
	li	$v0, 4
	la	$a0, STR_string_length
	syscall

	la	$a0, STR_str
	jal 	string_length

	# Print result
	add	$a0, $v0, $zero
	li	$v0, 1
	syscall

	##
	## string_for_each(string, ascii)
	##
	
	li	$v0, 4
	la	$a0, STR_for_each_ascii
	syscall
	
	la	$a0, STR_str
	la	$a1, ascii
	jal	string_for_each

	##
	### string_for_each(string, to_upper)
	##
	
	li	$v0, 4
	la	$a0, STR_for_each_to_upper
	syscall

	la	$a0, STR_str
	la	$a1, to_upper
	jal	string_for_each
	
	la	$a0, STR_str
	jal	print_test_string

	##
	### reverse_string
	##
	la	$a0, STR_str
	jal	reverse_string
	
	li	$v0, 4
	la	$a0, NLNL
	syscall
	
	la	$a0, STR_str
	jal	print_test_string
	
	
	lw	$ra, 0($sp)	# POP return address
	addi	$sp, $sp, 4	
	
	jr	$ra

##############################################################################
#
#  DESCRIPTION : Prints out 'str = ' followed by the input string surronded
#		 by double quotes to the console. 
#
#        INPUT: $a0 - address to a NUL terminated string.
#
##############################################################################
print_test_string:	

	.data
STR_str_is:
	.asciiz "str = \""
STR_quote:
	.asciiz "\""	

	.text

	add	$t0, $a0, $zero
	
	li	$v0, 4
	la	$a0, STR_str_is
	syscall

	add	$a0, $t0, $zero
	syscall

	li	$v0, 4	
	la	$a0, STR_quote
	syscall
	
	jr	$ra
	

##############################################################################
#
#  DESCRIPTION: Prints out the Ascii value of a character.
#	
#        INPUT: $a0 - address of a character 
#
##############################################################################
ascii:	
	.data
STR_the_ascii_value_is:
	.asciiz "\nAscii('X') = "

	.text
	
	la	$t0, STR_the_ascii_value_is

	# Replace X with the input character
	
	add	$t1, $t0, 8	# Position of X
	lb	$t2, 0($a0)	# Get the Ascii value
	sb	$t2, 0($t1)

	# Print "The Ascii value of..."
	
	add	$a0, $t0, $zero 
	li	$v0, 4
	syscall

	# Append the Ascii value
	
	add	$a0, $t2, $zero
	li	$v0, 1
	syscall


	jr	$ra
	
