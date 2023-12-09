.data
	array: .word 0:8 # array 8 elements 
	input_prompt: .asciiz "Please input elements of the array in 1 line separated by white space (If more than 8 elements were input, only take first 8 element): \n"
	input_except: .asciiz "Only integers and whitespace allowed !! Please try again !! \n"
	input_here: .asciiz "------>	Input here: "	
	input_buffer: .space 100
	input_incom: .asciiz "Please input at least 8 elements !! Please try again !! \n"
	res: .asciiz "Resulting array: "
.text
	main:
		la $a0, input_prompt
		li $v0, 4
		syscall
		input_block:
		li $v0, 4
		la $a0, input_here
		syscall
		
		la $a0, input_buffer
		li $a1, 100
		li $v0, 8
		syscall
		
		jal parse_input
		
		jal check_divisible
		
		jal print_array
	exit:
		li $v0, 10
		syscall
	
	parse_input:

		li $t0, 0 # current element
		la $s1, input_buffer
		while_parse:
			li $t9, 0 #bool: is_changed ?
			beq $t0, 8, exit_parse
			la $s0, array
			li $t7, 0 # cur_value
			while_not_space:
				lb $t1, 0($s1)
				beq $t1, 10, end_while
				addi $t1, $t1, -48 # char - 48 = number
				
				bltz $t1, exception
				bgt  $t1, 9, exception
				
				li $t9, 1
				mul $t7, $t7, 10
				add $t7, $t7, $t1
				addi $s1, $s1, 1
				j while_not_space
			
			is_space:
				beqz $t9, no_update # If no number before space -> do not increase input element
				sll $t2, $t0, 2
				add $s0, $s0, $t2
				sw $t7, 0($s0)
				addi $t0, $t0, 1
				no_update:
				addi $s1, $s1, 1
				j while_parse
					
		end_while:
			
			sll $t2, $t0, 2
			add $s0, $s0, $t2
			sw $t7, 0($s0)
			addi $t0, $t0, 1
			
		if_not_8_element_throw_error:
			bne $t0, 8, throw_incomplete
		exit_parse:
			jr $ra
		throw_incomplete:
			li $v0, 4
			la $a0, input_incom
			syscall
			j input_block
	exception:
		beq $t1, -16, is_space#space after - 48	
		li $v0, 4
		la $a0, input_except
		syscall
		j input_block
		
		
	check_divisible:

		li $t0, 0 #cur element
		li $t9, 3 # divisor
		while_array:
			beq $t0, 8, end_while_array 
			la $s0, array
			sll $t1, $t0, 2
			add $s0, $t1, $s0
			lw $t2, 0($s0)
			div  $t2, $t9
			mfhi $t3 # take remainder
			bnez $t3, not_divisible
			#if divisible
			mflo $t2
			addi $t2, $t2, 1
			sw $t2, 0($s0)
			j end_if
			not_divisible:
				beq $t3, 1, decre
				addi $t2, $t2, 1
				sw $t2, 0($s0)
				j end_if
				
			decre:
				addi $t2, $t2, -1
				sw $t2, 0($s0)
			end_if:
			
			addi $t0, $t0, 1
			j while_array
		end_while_array:
			jr $ra
	print_array:
		la $a0, res
		li $v0, 4
		syscall
		
		li $t0, 0
		print_while:
			beq $t0, 8, end_while_print
			la $s0, array
			sll $t2, $t0, 2
			add $s0, $s0, $t2		
			lw $t1, 0($s0)
			addi $a0, $t1, 0
			li $v0, 1
			syscall
			
			li $a0, 32 # sapce
			li $v0, 11
			syscall
			
			addi $t0, $t0, 1
			j print_while
		end_while_print:
			jr $ra
			
			