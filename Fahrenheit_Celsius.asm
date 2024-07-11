.data				# Data variables
introStrA:	.asciiz "\na. Convert Fahrenheit to Celsius\nb. Convert Celsius to Fahrenheit\nEnter a or b\n"	# String for starting program
introA:		.asciiz "a"											# String fot condition A
introB:		.asciiz "b"											# String for condition B
introStrB:	.asciiz "\nEnter a floating temperature\n"							# String entering float
end:		.asciiz "\nDo you like to do another conversion? Enter Y for yes or N for no.\n"		# String for another calculation
endY:		.asciiz "Y"											# String for Yes
endN:		.asciiz "N"											# String for No
cold:		.asciiz "\nThat is COLD!!!\n"									# String fot Cold cutoff
hot:		.asciiz "\nThat is HOT!!!\n"									# String for Hot cutoff
c1:		.float 32											# Conversion factor 1
c2:		.float 1.8											# Conversion factor 2
c3AC:		.float -17.78											# Cutoff for "cold" temperature A
c3AH:		.float 48.89											# Cutoff for "hot" temperature A
c3BC:		.float 0.0											# Cutoff for "cold" temperature B
c3BH:		.float 120.0											# Cutoff for "hot" temperature B
buffer:		.space 20											# Space buffer for string input
.text				# Main code
	main:				# Prepares program
		la $s2, introA			# Loads introA string into $s2
		la $s3, introB			# Loads introB string into $s3
		move $t2, $s2			# Moves $s2 into $t2
		move $t3, $s3			# Moves $s3 into $t3
		lb $t2, ($s2)			# Gets first character in $t2
		lb $t3, ($s3)			# Gets first character in $t3
	start:				# Run introduction
		li $v0, 4			# Load 4 = print_string into $v0
		la $a0, introStrA		# Loads introStrA string into $a0
		syscall				# Prints string in $a0
		li $v0, 8			# Load 8 = read_string into $v0
		la $a0, buffer			# Loads buffer into $a0
		li $a1, 20			# Loads 20 into $a1
		move $t0, $a0			# Moves $a0 into $t0
		syscall				# $a0 contains a string
		la $a0, buffer			# Loads buffer into $a0
		move $a0, $t0			# Moves $t0 into $a0
		lb $t0, ($a0)			# Gets first character in $t0
		beq $t0, $t2, setupA		# If $t0 == $t2, then branch to setupA
		beq $t0, $t3, setupB		# If $t0 == $t3, then branch to setupB
		j start				# Jump to start
	setupA:				# Setup for condition A
		li $v0, 4			# Load 4 = print_string into $v0
		la $a0, introStrB		# Loads introStrB string into $a0
		syscall				# Prints string in $a0
		li $t1, 1			# Loads 1 int into $t1
		j getTemperature		# Jumps to getTemperature
	setupB:				# Setup for condition B
		li $v0, 4			# Load 4 = print_string into $v0
		la $a0, introStrB		# Loads introStrB string into $a0
		syscall				# Prints string in $a0
		li $t1, 2			# Loads 2 int into $t1
		j getTemperature		# Jump to getTemperature
	getTemperature:			# Handles float input
		li $v0, 6			# Load 6 = read_float into $v0
		syscall				# $f0 contains a float
		l.s $f1, c1			# Load Floating Point Single conversion factor 1
		l.s $f2, c2			# Load Floating Point Single conversion factor 2
		beq $t1, 1, convertA		# If $t1 == 1, then branch to convertA
		beq $t1, 2, convertB		# If $t1 == 2, then branch to convertB
	convertA:			# Convert for condition A
		sub.s $f3, $f0, $f1		# Stores $f0-$f1 into $f3
		div.s $f3, $f3, $f2		# Stores $f3/$f2 into $f3
		j finalize			# Jump to finalize
	convertB:			# Convert for condition B
		mul.s $f3, $f0, $f2		# Stores $f0*$f2 into $f3
		add.s $f3, $f3, $f1		# Stores $f3+$f1 into $f3
		j finalize			# Jump to finalize
	finalize:			# Begins process for output
		li $v0, 2			# Load 2 = print_float into $v0
		mov.s $f12, $f3			# Moves $f3 into $f12
		syscall				# Prints float in $f12
		beq $t1, 1, cutOffAC		# If $t1 == 1, then branch to cutOffA
		beq $t1, 2, cutOffBC		# If $t1 == 2, then branch to cutOffB
		j checkAgain			# Jump to checkAgain
	cutOffAC:			# Cuttoff for condition A Cold
		l.s $f1, c3AC			# $f1 = constant -17.78
		c.lt.s $f3, $f1			# Compare temp and -17.78
		bc1f cutOffAH			# If false, jump to checkAgain
		li $v0, 4			# Load 4 = print_string into $v0
		la $a0, cold			# Loads cold string into $a0
		syscall				# Prints string in $a0
		j checkAgain			# Jump to checkAgain
	cutOffAH:			# Cuttoff for condition A Hot
		l.s $f1, c3AH			# $f1 = constant 48.89
		c.lt.s $f1, $f3			# Compare temp and 48.89
		bc1f checkAgain			# If false, jump to checkAgain
		li $v0, 4			# Load 4 = print_string into $v0
		la $a0, hot			# Loads hot string into $a0
		syscall				# Prints string in $a0
		j checkAgain			# Jump to checkAgain
	cutOffBC:			# Cuttoff for condition B Cold
		l.s $f1, c3BC			# $f1 = constant 0.0
		c.lt.s $f3, $f1			# Compare temp and 0.0
		bc1f cutOffBH			# If false, jump to checkAgain
		li $v0, 4			# Load 4 = print_string into $v0
		la $a0, cold			# Loads cold string into $a0
		syscall				# Prints string in $a0
		j checkAgain			# Jump to checkAgain
	cutOffBH:			# Cuttoff for condition B Hot
		l.s $f1, c3BH			# $f1 = constant 120.0
		c.lt.s $f1, $f3			# Compare temp and 120.0
		bc1f checkAgain			# If false, jump to checkAgain
		li $v0, 4			# Load 4 = print_string into $v0
		la $a0, hot			# Loads hot into $a0
		syscall				# Prints string in $a0
		j checkAgain			# Jump to checkAgain
	checkAgain:			# Prepares to check for another calculation
		la $s2, endY			# Loads endY string into $s2
		la $s3, endN			# Loads endN string into $s3
		move $t2, $s2			# Moves $t2 into $s2
		move $t3, $s3			# Moves $t3 into $s3
		lb $t2, ($s2)			# Gets first character in $t2
		lb $t3, ($s3)			# Gets first character in $t3
		j checkAgainNext		# Jump to checkAgainNext
	checkAgainNext:			# Ask if another calculation is desired
		li $v0, 4			# Load 4 = print_string into $v0
		la $a0, end			# Loads end string into $a0
		syscall				# Prints string in $a0
		li $v0, 8			# Load 8 = read_string into $v0
		la $a0, buffer			# Loads buffer into $a0
		li $a1, 20			# Loads 20 into $a1
		move $t0, $a0			# Moves $a0 into $t0
		syscall				# $a0 contains a string
		la $a0, buffer			# Loads buffer into $a0
		move $a0, $t0			# Moves $t0 into $a0
		lb $t0, ($a0)			# Gets first character in $t0
		beq $t0, $t2, main		# If $t0 == $t2, then branch to main
		beq $t0, $t3, exit		# If $t0 == $t3, then branch to exit
		j checkAgainNext		# Jump to checkAgainNext
	exit:				# Ends program
		li $v0, 10			# Load 10 = exit into $v0
		syscall				# Exits program
