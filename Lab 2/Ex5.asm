.data
	array: .word 0:10 # array 8 elements
	key: .word 0:10  #key of array
	val: .word 0:10  # val of key 
	dict_size: .word 0
	input_prompt: .asciiz "Please input elements of the array in 1 line separated by white space (If more than 10 elements were input, only take first 10 element): \n"
	input_except: .asciiz "Only integers and whitespace allowed !! Please try again !! \n"
	input_here: .asciiz "------>	Input here: "	
	input_buffer: .space 100
	input_incom: .asciiz "Please input at least 10 elements !! Please try again !! \n"
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
		
		jal to_dict

	exit:
		li $v0, 10
		syscall
	parse_input:

		li $t0, 0 # current element
		la $s1, input_buffer
		while_parse:
			li $t9, 0 #bool: is_changed ?
			beq $t0, 10, exit_parse
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
			
		if_not_10_element_throw_error:
			bne $t0, 10, throw_incomplete
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
		
	
	to_dict:
		addi $sp, $sp, -4
		sw   $ra, 0($sp)
		li $t0, 0 # cur _value

		print_while:
			beq $t0, 10, end_while_print
			la $s0, array
			sll $t2, $t0, 2
			add $s0, $s0, $t2		
			lw $t1, 0($s0)
			addi $a0, $t1, 0 
			jal add_to_dict
			addi $t0, $t0, 1
			j print_while
		end_while_print:
			li $a0, 10 # endl
			li $v0, 11
			syscall
			lw $ra, 0($sp)
			addi $sp, $sp, 4
			jr $ra
	 
	add_to_dict:
	# a0 -> val to add
		addi $sp, $sp, -12
		sw $t0, 0($sp)
		sw $s0, 4($sp)
		sw $t1, 8($sp)
		la $t0, dict_size
		li $t1, 0
		lw $t0, 0($t0)
		beqz $t0, add__
		check_key_exist:
			beq $t1, $t0, add__
			la $s0, key
			sll $t1, $t1, 2
			add $s0, $s0, $t1
			lw $t9, 0($s0)
			beq $t9, $a0, add__
			srl $t1, $t1, 2
			addi $t1, $t1, 1
			j check_key_exist
		add__: 
			beqz $t1, up
			beq $t0, $t1, no_up_dict_size
			up:
			addi $t0, $t0, 1
			sw $t0, dict_size
			no_up_dict_size:
			srl $t1, $t1, 2
			addi $t0, $t1, 0

		add_:
			
			sll $t0, $t0, 2
			la $s0, key
			add $s0, $s0, $t0
			sw $a0, 0($s0)
			la $s0, val
			add $s0, $s0, $t0
			lw $t0, 0($s0)
			addi $t0, $t0, 1
			sw $t0, 0($s0)
			

		lw $t0, 0($sp)
		lw $s0, 4($sp)	
		lw $t1, 8($sp)
		addi $sp, $sp, 12
		jr $ra	