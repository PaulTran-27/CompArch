.data 
	input_prompt: .asciiz "Input 2 positive number for calculating LCM and GCD: \n"
	input_a: .asciiz "		Number A: "
	input_b: .asciiz "		Number B: "
	request_pos: .asciiz "Value must be positive !!! Please try again !!\n"
	calc_gcd: .asciiz "Calculating GCD: \n"
	calc_lcm: .asciiz "Calculating LCM: \n"
	res: .asciiz "----------Result: "
	
	a: .word 0
	b: .word 0
.text:
	main: 
		la $a0, input_prompt
		li $v0, 4
		syscall
		
		input_A:
			la $a0, input_a 
			syscall
		
			la $v0, 5	
			syscall 
		
			addi $a0, $v0, 0
			la   $a1, input_A #address to return incase error
			jal check_input
			
			la $t0, a
			sw $v0, 0($t0)
			
		input_B:
			li $v0, 4
			la $a0, input_b 
			syscall
		
			la $v0, 5	
			syscall 
		
			addi $a0, $v0, 0
 			la   $a1, input_B #address to return incase error
			jal check_input
			
			la $t0, b
			sw $v0, 0($t0)
		gcd:
			la $a0, calc_gcd
			li $v0, 4
			syscall
			
			la $a0, a
			la $a1, b
			lw $a0, 0($a0)
			lw $a1, 0($a1)
			jal GCD
			
			addi $t0, $v0, 0
			la $a0, res
			li $v0, 4
			syscall
			
			addi $a0, $t0, 0
			li $v0, 1
			syscall
			
			li $a0, 10
			li $v0, 11
			syscall
		lcm:
			la $a0, calc_lcm
			li $v0, 4
			syscall
			
			la $a0, a
			la $a1, b
			lw $a0, 0($a0)
			lw $a1, 0($a1)
			jal LCM
			
			addi $t0, $v0, 0
			la $a0, res
			li $v0, 4
			syscall
			
			addi $a0, $t0, 0
			li $v0, 1
			syscall
	exit:
		la $v0, 10
		syscall
		
	check_input:
		# a0 -> value
		blt $a0, 1, exception
		jr $ra
		
		exception:
			la $a0, request_pos
			li $v0, 4
			syscall
			jr $a1
	GCD:
		#input $a0: a
		#input $a1: b
		#return $v0: result
		addi $sp, $sp, -4
		sw $ra, 0($sp)
		beqz $a1, return_a # b == 0 return a
		
		addi $t0, $a0, 0 # t0 = a
		addi $a0, $a1, 0 # a0 = b
		div  $t0, $a1 # a / b -> remainder in hi
		mfhi $a1 # argument 2 = a % b
		jal GCD
		lw $ra, 0($sp)
		addi $sp, $sp, 4
		jr $ra
		return_a:
			addi $v0, $a0, 0
			jr $ra
	LCM:
		#input $a0: a
		#input $a1: b
		#return $v0: result
		addi $sp, $sp, -4
		sw $ra, 0($sp)
		mul $s0, $a0, $a1 # a * b
		jal GCD
		
		div $v0, $s0, $v0
		lw $ra, 0($sp)
		addi $sp, $sp, 4
		jr $ra