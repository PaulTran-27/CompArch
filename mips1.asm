.data
	dash: .asciiz "--------------"
	greet: .asciiz "Hello player(s)"
	turn_count_prompt: .asciiz "Turn number: "
	turn_count: .word 0
	p1: .asciiz "Player one's turn: "
	p2: .asciiz "Player two's turn: "
	input: .asciiz "Please setup your battleship strategy: \n"
	grid_player_1: .byte 0:49 
	grid_player_2: .byte 0:49 # create 7 by 7 grid for each player
	seven: .word 7
	endl: .asciiz "\n"
	txt: .asciiz "ENDING PROGRAM\n"
	txt_1: .asciiz "Confirm placement ? \n"
	input_buffer: .space 100 # buffer for input
	exception_input: .asciiz "Invalid input: "
	setup_except: .asciiz "Valid character for setup are 0, 1 and whitespace only \n"
	try_again: .asciiz "Please try again: "
	remaining: .asciiz "\nRemaining ship(s): \n"
	s_21: .asciiz "		2 by 1 ship(s): "
	s_31: .asciiz "		3 by 1 ship(s): "
	s_41: .asciiz "		4 by 1 ship(s): "
	choose_type_prompt: .asciiz "Choose your ship type (2 for 2x1, 3 for 3x1, 4 for 4x1): "
	wrong_type_prompt: .asciiz "Please choose 2, 3 or 4 \n"
	player_1_ships: .word 3, 2, 1 # 2x1, 3x1 4x1
	player_2_ships: .word 3, 2, 1 # 2x1, 3x1 4x1
.text
	main:
		# start of the game
		li $v0, 4
		la $a0, dash
		syscall
		la $a0, greet
		syscall
		la $a0, dash
		syscall
		la $a0, endl
		syscall
		
		## Input
		la $a0, input
		syscall
	p1_setup:
		la $a0, p1
		syscall 
		while_remain_ship:
			la $s7, player_1_ships
			lw $t0, 0($s7)
			la $a0, remaining
			syscall
			# print 2x1 ships
			la $a0, s_21
            syscall

			addi $a0, $t0, 0
			addi $s7, $s7, 4
			li $v0, 1 
			syscall

			li $v0, 4
			la $a0, endl
			syscall
			
			# print 3x1 ships

            la $a0, s_31
            syscall

			lw $t0, 0($s7)

			addi $a0, $t0, 0
			addi $s7, $s7, 4
			li $v0, 1 
			syscall

			li $v0, 4
			la $a0, endl
			syscall

            # print 4x1 ships
			la $a0, s_41
            syscall

			lw $t0, 0($s7)

			addi $a0, $t0, 0
			addi $s7, $s7, 4
			li $v0, 1 
			syscall

			li $v0, 4
			la $a0, endl
			syscall
		choose_type:
			la $a0, choose_type_prompt
			syscall
			li $v0, 5
			li $a1, 1
			syscall
			jal is_type_valid

			la $a0, input_buffer
			li $a1, 100  
			li $v0, 8
			syscall 
			
			li $a2, 1
			la $a3, p1_setup
			jal parse_input
			
		la $a0, grid_player_1
		jal print_grid
		
	is_type_valid:
        addi $sp, $sp, -4
		sw $s0, 0($sp)
		addi $t0, $v0, -2
		addi $t1, $a1, 0
		la $a0, wrong_type_prompt
		la $a1, choose_type
		blt $t0, $zero, throw_invalid_input
		bgt $t0, 2, throw_invalid_input

		beq $t1, 2, load_2 
		load_1:
			la $s0, player_1_ships
			j next
		load_2:
			la $s0, player_2_ships
		next:
			sll $t0, $t0, 2
			add $s0, $s0, $t0
			lw  $t0, 0($s0)
		
		jr $ra

	exit:
		la $a0, txt
		li $v0, 4
		syscall
		li $v0, 10
		syscall
	
	load_grid:
		#input a2 -> player id; load grid to a2
		# output $v1: return remaining ship
		beq $a2, 1, return_1
		la $a2, grid_player_2
		la $v1, player_2_ships
		jr $ra
		return_1:
			la $a2, grid_player_1
			la $v1, player_1_ships
            jr $ra
		
		
	parse_input:
		# input: a0 -> input_buffer; a1 -> size; a2 -> player id
		#	  a3 -> address to jump to in case of exception
		addi $sp, $sp, -8
		sw $s0, 0($sp)
		sw $ra, 4($sp)
		
		# while
		la $s0, input_buffer
		jal load_grid
		li $t7, 49
		addi $t6, $a0, 0 #limiter for no infinite loop
		parse_while:
			beqz $t6, return_grid
			addi $t6, $t6, -1
			beqz $t7, return_grid

			lb   $t0, 0($s0)
			beq $t0, 10, return_grid 
			subi $t0, $t0, 48
			addi $s0, $s0, 1
			
			beq $t0, 1, init_grid
	        	beq $t0, 0, init_grid
	        	
	        	bne $t0, -16, throw_invalid_setup
	        	
	        	#li $v0, 11
			#li $a0, 32
			#syscall
	        	j parse_while
		
			init_grid:
				sb $t0, 0($a2)
				li $v0, 1
				add $a0, $t0, $zero
				syscall
				addi $a2, $a2, 1
				addi $t7, $t7, -1
				j parse_while
		
		return_grid:
			lw $s0, 0($sp)
			lw $ra, 4($sp)
			addi $sp, $sp, 8
			jr $ra		
		throw_invalid_setup:
			li $v0, 1
			add $a0, $t0, $zero
			syscall 
			la $a0, setup_except
			la $a1, ($a3)
			j throw_invalid_input
	print_grid:
		#input a0: player grid address
		addi $sp, $sp, -4
		sw $s0, 0($sp)
		la $s0, ($a0)
		li $t1, 0 # cur r
		la $s1, seven
		lw $s1, 0($s1)
		for_print:
			li $t2, 0 # cur c
			for_print_2:
				la $t0, ($s0)
				mul $t3, $t1, $s1
				add $t3, $t3, $t2
			
				add $t0, $t0, $t3
				lb $t4, 0($t0) 
				add $a0, $t4, $zero
				li $v0, 1
				syscall
		
				li $v0, 11
				li $a0, 32   # ASCII code for space
    				syscall
			
				addi $t2, $t2, 1
				#li $v0, 1
				#add $a0, $t2, $zero
    				#syscall
				blt $t2, 7, for_print_2
			
				la $a0, endl
				li $v0, 4
    				syscall
    			
    				addi $t1, $t1, 1
				blt $t1, 7, for_print
		end_print:
			lw $s0, 0($sp)
			addi $sp, $sp, 4
			jr $ra
	throw_invalid_input:
		# input: a0 -> address of exception type,
		#   	 a1 -> address to return after catch exception
		la $t0, ($a0)
		li $v0, 4
		la $a0, exception_input
		syscall
		la $a0, ($t0)
		syscall
		la $a0, try_again
		jr $a1
	update_turn_counter:
		addi $sp, $sp, -4
		sw $s0, 0($sp)
		la $s0, turn_count
		lw $s0, ($s0)
		addi $s0, $s0, 1
		sw $s0, turn_count
		lw $s0, 0($sp)
		addi $sp, $sp, 4
		jr $ra
		
		li $t7, 0 #tmp counter
		while_tmp:
			bgt $t7, 10, exit
			la $t0, turn_count
			lw $t0, ($t0)
			la $a0, turn_count_prompt
			li $v0, 4
			syscall 
			add $a0, $t0, $zero
			li $v0, 1
			syscall
			
			li $a0, 10
			li $v0, 11
			syscall
			
			jal update_turn_counter
			addi $t7, $t7, 1
			j while_tmp
