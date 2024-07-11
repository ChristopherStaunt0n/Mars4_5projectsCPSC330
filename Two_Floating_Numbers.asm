.data
askstr1:	.asciiz "Enter a floating number."
askstr2:	.asciiz "Enter another floating number."
sumstr: 	.asciiz "\nTheir sum is : "
substr: 	.asciiz "\nTheir difference is : "
multstr: 	.asciiz "\nTheir product is : "
divstr: 	.asciiz "\nTheir quotient is : "
anothercalc:	.asciiz "\Another calculation? Press 1 for yes and 2 to exit"
newline:	.asciiz "\n"
.text
	start:				# Runs input and output process for calculation
		li $v0, 4			# Load syscall code for print_string
		la $a0, askstr1			# Load askstr1 string into $a0
		syscall				# Print string in $a0
		la $a0, newline			# Load a new line into $a0
		syscall				# Print string in $a0
		li $v0, 6			# Load syscall code for read_float
		syscall				# Get float (saves in $f0)
		mov.s $f2, $f0			# Save arg1
		li $v0, 4			# Load syscall code for print_string
		la $a0, askstr2			# Load askstr2 string into $a0
		syscall				# Print string in $a0
		la $a0, newline			# Load a new line into $a0
		syscall				# Print string in $a0
		li $v0, 6			# Load syscall code for read_float
		syscall				# Get float (saves in $f0)
		mov.s $f4, $f0			# Save arg2
		li $v0, 4			# Load syscall code for print_string
		la $a0, sumstr			# Load sumstr string into $a0
		syscall				# Print string in $a0
		add.s $f12, $f2, $f4		# Add floats
		li $v0, 2			# Load syscall code for print_float
		syscall				# Print float in $f12
		li $v0, 4			# Load syscall code for print_string
		la $a0, substr			# Load substr string into $a0
		syscall				# Print string in $a0
		sub.s $f12, $f2, $f4		# Add floats
		li $v0, 2			# Load syscall code for print_float
		syscall				# Print float in $f12
		li $v0, 4			# Load syscall code for print_string
		la $a0, multstr			# Load multstr string into $a0
		syscall				# Print string in $a0
		mul.s $f12, $f2, $f4		# Add floats
		li $v0, 2			# Load syscall code for print_float
		syscall				# Print float in $f12
		li $v0, 4			# Load syscall code for print_string
		la $a0, divstr			# Load divstr string into $a0
		syscall				# Print string in $a0
		div.s $f12, $f2, $f4		# Add floats
		li $v0, 2			# Load syscall code for print_float
		syscall				# Print float in $f12
		li $v0, 4			# Load syscall code for print_string
		la $a0, newline			# Load a new line into $a0
		syscall				# Print string in $a0
	again:				# Determines if pogram should be repeated
		li $v0, 4			# Load syscall code for print_string
		la $a0, newline			# Load a new line into $a0
		syscall				# Print string in $a0
		la $a0, anothercalc		# Load anothercalc string into $a0
		syscall				# Print string in $a0
		la $a0, newline			# Load a new line into $a0
		syscall				# Print string in $a0
		li $v0, 5			# Load syscall code for read_int
		syscall				# Get float (saves in $f0)
		beq $v0, 1, start		# If $v0 == 1, then jumps to start
		beq $v0, 2, end			# If $v0 == 2, then jumps to end
		j again				# Jumps to again
	end:				# Ends Program
		li $v0, 10			# Load syscall code for exit
		syscall				# Exits program
