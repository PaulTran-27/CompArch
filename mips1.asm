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
	setup_except: .asciiz "Valid characters for setup are number in range 0 to 6 and whitespace only \n"
	try_again: .asciiz "Please try again: "
	remaining: .asciiz "\nRemaining ship(s): \n"
	s_21: .asciiz "		2 by 1 ship(s): "
	s_31: .asciiz "		3 by 1 ship(s): "
	s_41: .asciiz "		4 by 1 ship(s): "
	choose_type_prompt: .asciiz "Choose your ship type (2 for 2x1, 3 for 3x1, 4 for 4x1): "
	wrong_type_prompt: .asciiz "Please choose 2, 3 or 4 \n"
	empty_prompt: .asciiz "The chosen ship is unavailable. "
	player_1_ships: .word 3, 2, 1 # 2x1, 3x1 4x1
	player_2_ships: .word 3, 2, 1 # 2x1, 3x1 4x1
	choose_placement: .asciiz "Input placement by format x_0, y_0, x_1, y_1: "
	input_xy_xy: .word 0:4
	ship_misalign: .asciiz "Ship not in horizontal or vertical alignment.\n"
	ship_size_mismatch: .asciiz "Coordinates does not match the input ship size. \n"
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
			
			addi $sp, $sp, -4
			sw $t0, 0($sp)
			addi $t0, $v0, 0

			li $v0, 4
			la $a0, choose_placement
			syscall
			la $a0, input_buffer
			li $a1, 100
			li $v0, 8
			syscall 
			
			addi $a1, $t0, 0
			lw $t0, 0($sp)
			addi $sp, $sp, 4
			li $a2, 1
			la $a3, p1_setup
			jal parse_input
			
		la $a0, grid_player_1
		jal print_grid

	exit:
		la $a0, txt
		li $v0, 4
		syscall
		li $v0, 10
		syscall
			
	is_type_valid:
        addi $sp, $sp, -4
		sw $s0, 0($sp)
		addi $t0, $v0, -2
		addi $t1, $a1, 0
		
		blt $t0, $zero, throw_invalid_type
		bgt $t0, 2, throw_invalid_type

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
			la $a0, empty_prompt
			la $a1, choose_type
			lw $s0, 0($sp)
			addi $sp, $sp, 4
			blt $t0, 1, throw_invalid_input 
		
		return_valid:
			jr $ra
		throw_invalid_type:
			lw $s0, 0($sp)
			addi $sp, $sp, 4
			la $a0, wrong_type_prompt
			la $a1, choose_type
			j throw_invalid_input
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
		addi $s6, $a1, 0
		# while
		la $s0, input_buffer
		jal load_grid
		li $t7, 0
		li $t6, 100#limiter for no infinite loop
		parse_while:
			beqz $t6, return_grid
			addi $t6, $t6, -1
			beq $t7, 4, init_grid

			lb   $t0, 0($s0)
			beq  $t0, 10, return_grid 
			addi $t0, $t0, -48
			addi $s0, $s0, 1
			
			slt $t1, $t0, $zero
			sne $t2, $t0, -16
			and $t1, $t1, $t2
			
			sgt $t2, $t0,  6
			# check if input is in range [0,6]
			or  $t1, $t1, $t2
			bnez $t1,    throw_invalid_setup
			
			# if not space run update coordinates
			bne $t0, -16,  update_coordinates
	        
	        #li $v0, 11
			#li $a0, 32
			#syscall
	        j parse_while

			update_coordinates:
				addi $sp, $sp, -8
				sw $s0, 0($sp)
				sw $t7, 4($sp)
				la $s0, input_xy_xy
                sll $t7, $t7, 2
				add $s0, $s0, $t7
				sw $t0, 0($s0)
				
				# restore stack
				lw $s0, 0($sp)
				lw $t7, 4($sp)
				addi $sp, $sp, 8

				#increment number of inputed coordinate
				addi $t7, $t7, 1
                j parse_while


			init_grid:
				# sb $t0, 0($a2)
				# li $v0, 1
				# add $a0, $t0, $zero
				# syscall
				# addi $a2, $a2, 1
				# addi $t7, $t7, -1
				# j parse_while

				# 0($s0) x 4($s0) y 8... 12 ... 
				addi $sp, $sp, -36
				sw $s0, 0($sp)
				sw $t0, 4($sp)
				sw $t1, 8($sp)
				sw $t2, 12($sp)
				sw $t3, 16($sp)
				sw $t4, 20($sp)
				sw $t5, 24($sp)
				sw $t6, 28($sp)
				sw $t7, 32($sp)
                la $s0, input_xy_xy
				# check if head and tail coordinates align
				lw $t0,  0($s0) # x1
				lw $t1,  4($s0) # y1
				lw $t2,  8($s0) # x2
				lw $t3, 12($s0) # y2

				seq $t4, $t0, $t2
				seq $t5, $t1, $t3

				or $t4, $t4, $t5
				# if [(x == x) or (y == y)] not true throw exception
				li $v0, 0
				beqz $t4, restore_st

				# if y_1 == y_2 calc length base on x_s else y_s
				beqz $t5, do_else

				sub $t7, $t2, $t0 # length
	
				j end_if
			do_else: 
				sub $t7, $t3, $t1
			end_if:
				slt $t6, $t7, $zero # sign-number
				beqz $t6, positive # if (length < 0) return 1
				mul $t7, $t7, -1
			positive:
				li  $v0, 1
				bne $t7, $s6, restore_st # if length not match with the chosen boat: exception

			restore_st:
				# restore stack
                lw $s0, 0($sp)
				lw $t0, 4($sp)
				lw $t1, 8($sp)
				lw $t2, 12($sp)
				lw $t3, 16($sp)
				lw $t4, 20($sp)
				lw $t5, 24($sp)
				lw $t6, 28($sp)
				lw $t7, 32($sp)
				addi $sp, $sp, 36
				beqz $v0, throw_invalid_ship
				beq  $v0, 1, size_mismatch
		return_grid:
			lw $s0, 0($sp)
			lw $ra, 4($sp)
			addi $sp, $sp, 8
			jr $ra		
		throw_invalid_setup:
			# li $v0, 1
			# add $a0, $t0, $zero
			# syscall 
			la $a0, setup_except
			la $a1, ($a3)
			j throw_invalid_input
		throw_invalid_ship:
			# li $v0, 1
			# add $a0, $t0, $zero
			# syscall 
			la $a0, ship_misalign
			la $a1, ($a3)
			j throw_invalid_input
		size_mismatch:
			la $a0, ship_size_mismatch
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
