.data
	grid_player_1: .byte 0:49 
	grid_player_2: .byte 0:49 # create 7 by 7 grid for each player
	ship_count_p1: .word 16  # 4x1 + 3x2 + 2x3
	ship_count_p2: .word 16   
	dash: .asciiz "--------------------------------------------------"
	greet: .asciiz "Hello player(s)"
	turn_count_prompt: .asciiz "	Turn number: "
	turn_count_log:    .ascii  "\n	Turn number: "
	turn_count: .word 1
	p1: .asciiz "\n	*Current player* -> Player one's turn: \n"
	p2: .asciiz "\n	*Current player* -> Player two's turn: \n"
	input: .asciiz "--------------------------------------------------Please setup your battleship strategy-------------------------------------------------- \n"
	shoot: .asciiz "----------------------------------------------------------------Battle Phase------------------------------------------------------------- \n"
	bomb_input:.asciiz "	Enter bombing coordinates: "
	current_grid: .asciiz "		  				       <Your current grid> \n"
	seven: .word 7
	endl: .asciiz "\n" 
	endl_no_z: .ascii "   \n" 
	txt: .asciiz "ENDING PROGRAM\n"
	txt_1: .asciiz "Confirm placement ? \n"
	input_buffer: .space 100 # buffer for input
	exception_input: .asciiz "		Invalid input: "
	setup_except: .asciiz "Valid characters for setup are single-digit number in range 0 to 6 and whitespace only \n"
	try_again: .asciiz "Please try again: "
	remaining: .asciiz "\n	<-> Remaining ship(s): \n"
	s_21: .asciiz "				<+> 2 by 1 ship(s): "
	s_31: .asciiz "				<+> 3 by 1 ship(s): "
	s_41: .asciiz "				<+> 4 by 1 ship(s): "
	choose_type_prompt: .asciiz "	Choose your ship type (2 for 2x1, 3 for 3x1, 4 for 4x1): "
	wrong_type_prompt: .asciiz "	Please choose 2, 3 or 4 \n"
	empty_prompt: .asciiz "		The chosen ship is unavailable. \n "
	player_1_ships: .word 3, 2, 1 # 2x1, 3x1 4x1
	player_2_ships: .word 3, 2, 1 # 2x1, 3x1 4x1
	choose_placement: .asciiz "	Input placement by format x_0, y_0, x_1, y_1: "
	input_xy_xy: .word 0:4
	bomb_coord: .word 0:2
	ship_misalign: .asciiz "	Ship not in horizontal or vertical alignment.\n"
	ship_size_mismatch: .asciiz "	Coordinates does not match the input ship size. \n"
	clear_screen: .asciiz "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"
	indent_spacing: .asciiz "							" # 8tab
	overlap_prompt: .asciiz "	Input ship overlaps with an already placed ship.\n"
	hit_announce: .asciiz "			HIT!!\n"
	you_missed: .asciiz "			You missed !!\n"
	incomplete_input: .asciiz "Incomplete input (Must be 4 numbers for ship setup or 2 numbers for bombing!!\n"
	p1_win_bool: .word 0 # 0 if lose else win
	player_win: .asciiz "\n__________________________WINNER: PLAYER  "
	log_file_name: .asciiz "/mnt/Workspace/BK_assignment/CompArchitecture/gamelog.txt" # REMEMBER TO CHANGE THIS WHEN CHANGE DEVICE
	log_file_desc: .word   0
	log_start: .ascii "_________________________GAME LOG_________________________"
	p1_log: .ascii    "\n		__Player one's move: "
	p2_log: .ascii    "\n		__Player two's move: "
	p_len:  .word 23
	buff: .asciiz ""
	index_y: .asciiz "o-0-1-2-3-4-5-6-y\n"
	p_w_1: .asciiz "1"
	p_w_2: .asciiz "2"
	player_win_log: .asciiz "\n		__Winner: Player "
	
# TESTED!! EXCEPTION HANDLING
.ktext 0x80000180
	la $k0, syscall_integer_1
	move $k1, $a0
	mfc0 $a0, $14
	beq $a0, $k0, ship_input_integer_except_1
	la $k0, syscall_integer_2
	beq $a0, $k0, ship_input_integer_except_2
	move $k0,$v0   # Save $v0 value
   	move $k1,$a0   # Save $a0 value
   	#la   $a0, msg  # address of string to print
   	#li   $v0, 4    # Print String service
   	#syscall
   	move $v0,$k0   # Restore $v0
   	move $a0,$k1   # Restore $a0
   	mfc0 $k0,$14   # Coprocessor 0 register $14 has address of trapping instruction
   	addi $k0,$k0,4 # Add 4 to point to next instruction
   	mtc0 $k0,$14   # Store new address back into $14
   	eret           # Error return; set PC to value in $14
   	ship_input_integer_except_1:
   	la $k0,choose_type
   	j return_e
	ship_input_integer_except_2:
   	la $k0,choose_type_2 
   	return_e:
	la   $a0, msg  # address of string to print
   	li   $v0, 4    # Print String service
   	syscall
   	mtc0 $k0,$14   # Store new address back into $14
   	eret           # Error return; set PC to value in $14
.kdata	
msg:   
   .asciiz "	\n\n+-------!! Please input only integers (No whitespaces or other characters) !!-------+ \n\n"
.text
	main:
		# start of the game
		li $v0, 13
		la   $a0, log_file_name     # output file name
		li   $a1, 1        	    # Open for writing (flags are 0: read, 1: write)
  		li   $a2, 0       	    # mode is ignored
  		syscall            	    # open a file (file descriptor returned in $v0)
  		sw   $v0, log_file_desc	    # store file descriptor
  		
  		li   $v0, 15       	    # system call for write to file
  		lw   $a0, log_file_desc     # file descriptor 
  		la   $a1, log_start  
  		li   $a2, 60      	    # hardcoded buffer length
  		syscall            	    # write to file
  		
  		
		li $v0, 4
		la $a0, clear_screen
		syscall 
		
		la $a0, dash
		syscall
		la $a0, greet
		syscall
		la $a0, dash
		syscall
		la $a0, endl
		syscall
		# j main_game_phase# DEBUGGING ONLY 
		## Input
		la $a0, input
		syscall
	
	li $t7, 6
	j end_p1_setup
	j start_up
	
	p1_setup:
		li $v0, 4
		la $a0, clear_screen
		syscall 
		la $a0, input
		syscall
		start_up:
		la $a0, p1
		syscall 
		la $a0, current_grid
		li $v0,4
		syscall
		la $a0, grid_player_1
		jal print_grid
		while_remain_ship:
			beqz $t7,end_p1_setup
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
			la $a2, choose_type
		syscall_integer_1:
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
			la $a3, choose_type
			jal parse_input
			
			#la $a0, current_grid
			#li $v0,4
			#syscall
			#la $a0, grid_player_1
			#jal print_grid
			addi $t7, $t7, -1
			j p1_setup
	end_p1_setup:	
		la $a0, grid_player_1
		jal log_grid
	
	li $t7, 6
	p2_setup:
		li $v0, 4
		la $a0, clear_screen
		syscall 

		la $a0, input
		syscall
		la $a0, p2
		syscall 
		la $a0, current_grid
		li $v0,4
		syscall
		la $a0, grid_player_2
		jal print_grid
 

		while_remain_ship_2:
			beqz $t7,end_p2_setup
			la $s7, player_2_ships
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
		choose_type_2:
			la $a0, choose_type_prompt
			syscall
			li $v0, 5
			li $a1, 2
			la $a2, choose_type_2 # address for exception calls
			syscall_integer_2:
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
			li $a2, 2
			la $a3, choose_type_2
			jal parse_input
			
			addi $t7, $t7, -1
			j p2_setup
	end_p2_setup:	
		
	main_game_phase:
		# Display: turn -> current turn grid -> input bombing location
		
		game:
			
  			    
			la $a0, clear_screen
			li $v0, 4
			syscall	
			# If p1 ship == 0 or p2 ship == 0 ends 
			la $s0, ship_count_p1
			lw $s0, 0($s0)
			beqz $s0, check_winner
			la $s0, ship_count_p2
			lw $s0, 0($s0)
			beqz $s0, check_winner
			
			li   $v0, 15       	    # system call for write to file
  			lw   $a0, log_file_desc     # file descriptor 
  			la   $a1, turn_count_log
	  		li   $a2, 14      	    # hardcoded buffer length
	  		syscall
  			lw   $a0, turn_count
  			jal recur_write
 
			p1_shoot:
				li $v0, 4
				la $a0, shoot
				syscall
				la $a0, turn_count_prompt
				li $v0, 4
				syscall
				li $v0, 1
				la $s0, turn_count
				lw $s0, 0($s0)
                		addi $a0, $s0, 0
                		syscall
				li $v0, 4
				la $a0, p1
				syscall 
				la $a0, current_grid
				li $v0,4
				syscall
				la $a0, grid_player_1
				jal print_grid
				shoot_p1:
				la $a0, bomb_input
				li $v0, 4
				syscall
				la $a0, input_buffer
				li $a1, 100
				li $v0, 8
				syscall 
				
				la $a2, 2 # player 2 being hit
				la $a3, shoot_p1 # incase invalid
				jal parse_bomb_input
				beqz $v0, missed_1 # if v0 -> reduce remaining ship
				addi $sp, $sp, -4
				sw   $t0, 0($sp)
				lw   $t0, ship_count_p2
				addi $t0, $t0, -1
				sw   $t0, ship_count_p2
				lw   $t0, 0($sp)
				addi $sp, $sp, 4
				missed_1:
				jal print_result
			#update log
			
			li   $v0, 15       	    # system call for write to file
			
  			lw   $a0, log_file_desc     # file descriptor 
  			la   $a1, p1_log
  			lw   $a2, p_len
  			syscall
  			
  			li   $v0, 15       	    # system call for write to file
  			lw   $a0, log_file_desc
	  		la   $a1, input_buffer
	  		li   $a2, 3	    # hardcoded buffer length
	  		syscall
			
			
			la $s0, ship_count_p1
			lw $s0, 0($s0)
			beqz $s0, check_winner
			la $s0, ship_count_p2
			lw $s0, 0($s0)
			beqz $s0, check_winner
			la $a0, clear_screen
			li $v0, 4
			syscall	
			p2_shoot:
				li $v0, 4
				la $a0, shoot
				syscall
				la $a0, turn_count_prompt
				li $v0, 4
				syscall
				li $v0, 1
				lw $s0, turn_count
                		addi $a0, $s0, 0
               			syscall
				li $v0, 4
				la $a0, p2
				syscall 
				la $a0, current_grid
				li $v0,4
				syscall
				la $a0, grid_player_2
				jal print_grid
				shoot_p2:
				la $a0, bomb_input
				li $v0, 4
				syscall
				la $a0, input_buffer
				li $a1, 100
				li $v0, 8
				syscall 
				
				la $a2, 1 # player 1 being hit
				la $a3, shoot_p2
				jal parse_bomb_input
				beqz $v0, missed_2 # if v0 -> reduce remaining ship
				addi $sp, $sp, -4
				sw   $t0, 0($sp)
				lw   $t0, ship_count_p1
				addi $t0, $t0, -1
				sw   $t0, ship_count_p1
				lw   $t0, 0($sp)
				addi $sp, $sp, 4
				missed_2:
				jal print_result
				
			li   $v0, 15       	    # system call for write to file
  			lw   $a0, log_file_desc     # file descriptor 
  			la   $a1, p2_log
  			lw   $a2, p_len
  			syscall
  			
  			li   $v0, 15       	    # system call for write to file
  			lw   $a0, log_file_desc
	  		la   $a1, input_buffer
	  		li   $a2, 3	    # hardcoded buffer length
	  		syscall
			jal update_turn_counter
			# Delay
			j game
	check_winner:
		lw  $s1, p1_win_bool
		lw  $s0, ship_count_p2
		seq $s1, $s0, $zero
		sw  $s1, p1_win_bool
		
		jal announce_winner
		
	exit:	

		li   $v0, 16       		# system call for close file
  		lw   $a0, log_file_desc         # file descriptor to close
  		syscall            		# close file
  		
		li $v0, 10
		syscall
	
	announce_winner:
		lw  $s0, p1_win_bool
		la $a0, player_win
		li $v0, 4
		syscall
		li   $v0, 15       	    # system call for write to file
  		lw   $a0, log_file_desc
	  	la   $a1, player_win
	  	li   $a2, 42
	  	syscall
	  	
		beqz $s0, p2_win
		
		la $a0, p_w_1
		j announce
		
		p2_win:
		la $a0, p_w_2
		announce:
		li $v0, 4
		syscall
		
		li   $v0, 15       	    # system call for write to file
  		la   $a1, ($a0)
  		lw   $a0, log_file_desc
	  	li   $a2, 1
	  	syscall
		jr $ra
			
	print_result:
		addi $sp, $sp, -4
		sw $a0, 0($sp)
		addi $a0, $v0, 0
		li $v0, 4
		beqz $a0, no_hit
		la $a0, hit_announce
		syscall
		j delay
		no_hit:
			la $a0, you_missed
			syscall
		delay:
		addi $sp, $sp, -4
		sw $t0, 0($sp)
		li $t0, 10000 # delay by 10000 loop
		delay_while:
			beqz $t0, exit_delay
			addi $t0, $t0, -1
                	j delay_while
		exit_delay:
			lw $t0, 0($sp)
			addi $sp, $sp, 4
		lw $a0, 0($sp)
		addi $sp, $sp, 4
		jr $ra
		
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
			la $a1, ($a2)
			lw $s0, 0($sp)
			addi $sp, $sp, 4
			blt $t0, 1, throw_invalid_input 
		
		return_valid:
			jr $ra
		throw_invalid_type:
			lw $s0, 0($sp)
			addi $sp, $sp, 4
			la $a0, wrong_type_prompt
			la $a1, ($a2)
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
		
	parse_bomb_input:
		# input: a0 -> input_buffer; a1 -> size; a2 -> player being hit
		#	  a3 -> address to jump to in case of exception
		# output: v0: bool -> hit or not
		addi $sp, $sp, -12
		
		sw $s0, 0($sp)
		sw $ra, 4($sp)
		sw $t7, 8($sp)
		addi $s6, $a1, 0
		# while
		la $s0, input_buffer
		jal load_grid
		la $s5, ($v1)
		li $t7, 0
		li $t6, 100  #limiter for no infinite loop        
		li $t9, 1                                                                                       
		parse_bomb_while:
			beqz $t6, return_grid_bomb
			addi $t6, $t6, -1
			beq $t7, 2, update_grid

			lb   $t0, 0($s0)
			beq  $t0, 10, return_grid_bomb
			addi $t0, $t0, -48
			addi $s0, $s0, 1
			
			slt $t1, $t0, $zero
			sne $t2, $t0, -16
			and $t1, $t1, $t2
			
			sgt $t2, $t0,  6
			# check if input is in range [0,6]
			or  $t1, $t1, $t2
			bnez $t1,    throw_invalid_setup
			# check if not next_to_space and is number -> not a single digit number -> throw error
			sne $t1, $t0, -16 # set if t0 is not space
			beqz $t1, set_1
			and $t1, $t1, $t9
			beqz $t1,    throw_invalid_setup
			# if not space run update coordinates
			set_1:
			bne $t0, -16, unset_1
			li $t9, 1
			j no_set_1
			unset_1:
			li $t9, 0
			no_set_1:
			
			bne $t0, -16,  update_bomb_coordinates

	        	j parse_bomb_while
		update_bomb_coordinates:
				addi $sp, $sp, -8
				sw $s0, 0($sp)
				sw $t7, 4($sp)
				la $s0, bomb_coord
                		sll $t7, $t7, 2
				add $s0, $s0, $t7
				sw $t0, 0($s0)
				
				# restore stack
				lw $s0, 0($sp)
				lw $t7, 4($sp)
				addi $sp, $sp, 8

				#increment number of inputed coordinate
				addi $t7, $t7, 1
                		j parse_bomb_while
		update_grid:
			addi $sp, $sp, -16
			sw $t0, 0($sp)
			sw $t1, 4($sp)
			sw $t2, 8($sp)
			sw $s0, 12($sp)
			
			la $s0, bomb_coord
			lw $t0, 0($s0) # x
			lw $t1, 4($s0) # y
			
			mul $t0, $t0, 7   # row * 7
			add $t0, $t0, $t1 # add col to row
			add $s0, $a2, $t0 # get grid[x][y]
			
			lb $t2, 0($s0)
			sb $zero, 0($s0)
			sne $v0, $zero, $t2 # set if t2 is not zero (is a ship)
			lw $t0, 0($sp)
			lw $t1, 4($sp)
			lw $t2, 8($sp)
			lw $s0, 12($sp)
			addi $sp, $sp, 16
		return_grid_bomb:
			blt $t7, 2, throw_incomplete_input
			lw $s0, 0($sp)
			lw $ra, 4($sp)
			lw $t7, 8($sp)
			addi $sp, $sp, 12
			jr $ra		
		

	
	parse_input:
		# input: a0 -> input_buffer; a1 -> size; a2 -> player id
		#	  a3 -> address to jump to in case of exception
		addi $sp, $sp, -12
		
		sw $s0, 0($sp)
		sw $ra, 4($sp)
		sw $t7, 8($sp)
		addi $s6, $a1, 0
		# while
		la $s0, input_buffer
		jal load_grid
		la $s5, ($v1)
		li $t7, 0
		li $t6, 100#limiter for no infinite loop
		li $t9, 1  #bool next_to_space
		parse_while:
			beqz $t6, return_grid
			addi $t6, $t6, -1
			beq $t7, 4, init_grid

			lb   $t0, 0($s0)
			beq  $t0, 10, return_grid 
			addi $t0, $t0, -48
			addi $s0, $s0, 1
			

			
			slt $t1, $t0, $zero # t0 < 0
			sne $t2, $t0, -16   # t0 != -16 (space)
			and $t1, $t1, $t2

			
			sgt $t2, $t0,  6
			# check if input is in range [0,6]
			or  $t1, $t1, $t2
			


			bnez $t1,    throw_invalid_setup
			# check if not next_to_space and is number -> not a single digit number -> throw error
			sne $t1, $t0, -16 # set if t0 is not space
			beqz $t1, set
			and $t1, $t1, $t9
			beqz $t1,    throw_invalid_setup
			# if not space run update coordinates
			set:
			bne $t0, -16, unset
			li $t9, 1
			j no_set
			unset:
			li $t9, 0
			no_set:
			
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

			check_if_less_than_then_swap:
				# input $t0 first registers
				# input $t1 second registers
				
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
				beq  $t5, 1, set_x	# if y == y
				blt  $t1, $t3, after_set   # if y_1 < y_2 skip
				add  $t4, $t1, $zero  #tmp
				add  $t1, $t3, $zero  # t1 = t3
				add  $t3, $t4, $zero  # t3 = tmp
				j after_set
			set_x: 
				blt  $t0, $t2, after_set   # if x_1 < x_2 skip
				add  $t4, $t0, $zero  #tmp
				add  $t0, $t2, $zero  # t0 = t2
				add  $t2, $t4, $zero  # t2 = tmp
			after_set:
				mul $t7, $t7, -1
			positive:
				li  $v0, 1
				addi $t7, $t7, 1  # ptr - ptr + 1 = size
				bne $t7, $s6, restore_st # if length not match with the chosen boat: exception
				
				# t0 t2 rows 
				# t1 t3 cols 
				addi $sp, $sp, -16
				sw $t0, 0($sp)
				sw $t1, 4($sp)
				sw $t2, 8($sp)
				sw $t3, 12($sp)

				
				li $t9, 0 # NEVER USE $t9 UNLESS BOOL 
				check_if_overlap:
					seq $t4, $t0, $t2
					seq $t5, $t1, $t3
					# since  there will always be x == x or y == y, the case where x != x and y != y will not happen
					beq $t4, $t5, end_overlap_check # if x == x and y == y end
					
					la $s0, ($a2) # load player grid
					mul $t5, $t0, 7 # 7x7 grid
					add $t5, $t5, $t1 # add columns 
					
					add $s0, $s0, $t5 
					lb  $t5, 0($s0)
					bnez $t9, skip_t9_bool
					seq $t9, $t5, 1 # if 1 in placement throw invalid placement
				skip_t9_bool:
					beq $t0, $t2, no_x_increment_check
					addi $t0, $t0, 1				
				no_x_increment_check:
					beq $t1, $t3, check_if_overlap
					addi $t1, $t1, 1
					j check_if_overlap
				end_overlap_check:
					# update last element
					la $s0, ($a2) # load player grid
					mul $t5, $t0, 7 # 7x7 grid 
					add $t5, $t5, $t1 # add columns 
					add $s0, $s0, $t5 
					lb  $t5, 0($s0)
					bnez $t9, already_overlap
					seq $t9, $t5, 1
					already_overlap:
					lw $t0, 0($sp)
					lw $t1, 4($sp)
					lw $t2, 8($sp)
					lw $t3, 12($sp)
					addi $sp, $sp, 16
					beqz $t9, update_loop # if not overlap -> update
					
					li $v0, 2
					j restore_st
					
				
				update_loop:
					seq $t4, $t0, $t2
					seq $t5, $t1, $t3
					# since  there will always be x == x or y == y, the case where x != x and y != y will not happen
					beq $t4, $t5, end_update_loop # if x == x and y == y end
					
					la $s0, ($a2) # load player grid
					mul $t5, $t0, 7 # 7x7 grid
					add $t5, $t5, $t1 # add columns 
					
					add $s0, $s0, $t5 
					li $t5, 1
					sb $t5, 0($s0)
					beq $t0, $t2, no_x_increment
					addi $t0, $t0, 1				
				no_x_increment:
					beq $t1, $t3, update_loop
					addi $t1, $t1, 1
					j update_loop
				end_update_loop:
					# update last element
					la $s0, ($a2) # load player grid
					mul $t5, $t0, 7 # 7x7 grid 
					add $t5, $t5, $t1 # add columns 
					
					add $s0, $s0, $t5 
					li $t5, 1
					sb $t5, 0($s0)
				# Decrease remaining ships
				addi $s6, $s6, -2 # s6: ship_size -> s6 -2: index in ship array (0->2, 1->2,2->4)
				sll  $s6, $s6, 2  # multiply by 4
				add $s5, $s5, $s6
				lw $t0, 0($s5)
				addi $t0, $t0, -1
				sw $t0, 0($s5)
				li $v0, 4  # no error -> restore stack without exception
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
				beq  $v0, 2, throw_overlap_placement
		return_grid:
		
			blt $t7, 4, throw_incomplete_input
			lw $s0, 0($sp)
			lw $ra, 4($sp)
			lw $t7, 8($sp)
			addi $sp, $sp, 12
			jr $ra		
		
		throw_incomplete_input:
		
			lw $s0, 0($sp)
			lw $ra, 4($sp)
			lw $t7, 8($sp)
			addi $sp, $sp, 12
			la $a0, incomplete_input
			la $a1, ($a3)
			j throw_invalid_input		
		throw_invalid_setup:
			# li $v0, 1
			# add $a0, $t0, $zero
			# syscall 
			lw $s0, 0($sp)
			lw $ra, 4($sp)
			lw $t7, 8($sp)
			la $a0, setup_except
			la $a1, ($a3)
			j throw_invalid_input
		throw_invalid_ship:
			# li $v0, 1
			# add $a0, $t0, $zero
			# syscall 
			lw $s0, 0($sp)
			lw $ra, 4($sp)
			lw $t7, 8($sp)
			addi $sp, $sp, 12
			la $a0, ship_misalign
			la $a1, ($a3)
			j throw_invalid_input
		size_mismatch:
			lw $s0, 0($sp)
			lw $ra, 4($sp)
			lw $t7, 8($sp)
			addi $sp, $sp, 12
			la $a0, ship_size_mismatch
			la $a1, ($a3)
            j throw_invalid_input
		throw_overlap_placement:
			lw $s0, 0($sp)
			lw $ra, 4($sp)
			lw $t7, 8($sp)
			addi $sp, $sp, 12
			la $a0, overlap_prompt
			la $a1, ($a3)
            j throw_invalid_input
	print_grid:
		#input a0: player grid address
		addi $sp, $sp, -4
		sw $s0, 0($sp)
		la $s0, ($a0)
		li $t1, -1 # cur r
		la $s1, seven
		lw $s1, 0($s1)
		for_print:
			li $v0, 4
			la $a0, indent_spacing
			syscall
			
			li $t2, -1 # cur c
			beq $t1, 7, print_y_index
			bgez $t1, for_print_2
			print_y_index:
				la $a0, index_y
				li $v0, 4
				syscall
				j end_for_print_2	  
			for_print_2:
				print_num:
				bltz $t2, print_index
				beq  $t2, 7, print_index 
				la $t0, ($s0)
				mul $t3, $t1, $s1
				add $t3, $t3, $t2
			
				add $t0, $t0, $t3
				lb $t4, 0($t0) 
				add $a0, $t4, $zero
				li $v0, 1
				syscall
				j print_space
				print_index:
				add $a0, $t1, $zero
				li $v0, 1
				syscall
				print_space:
				li $v0, 11
				li $a0, 32   # ASCII code for space
    				syscall
			
				addi $t2, $t2, 1
				#li $v0, 1
				#add $a0, $t2, $zero
    				#syscall
				blt $t2, 8, for_print_2
			
				la $a0, endl
				li $v0, 4
    				syscall
    			end_for_print_2:
    				addi $t1, $t1, 1
				blt $t1, 8, for_print
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
		
		# li $t7, 0 #tmp counter
		# while_tmp:
		# 	bgt $t7, 10, exit
		# 	la $t0, turn_count
		# 	lw $t0, ($t0)
		# 	la $a0, turn_count_prompt
		# 	li $v0, 4
		# 	syscall 
		# 	add $a0, $t0, $zero
		# 	li $v0, 1
		# 	syscall
			
		# 	li $a0, 10
		# 	li $v0, 11
		# 	syscall
			
		# 	jal update_turn_counter
		# 	addi $t7, $t7, 1
		# 	j while_tmp
	recur_write:

  		bnez $a0, recur

  	
  		jr $ra 
  	
  		recur:
  		addi $sp, $sp, -8

  		sw $ra, 0($sp)
  	
  		li $t9, 10 
  		div $a0, $t9
  		div $a0, $a0, $t9
  		mfhi $t1
  		sw $t1, 4($sp)
  	
  	
  		jal recur_write
  	
  	


  		lw $ra, 0($sp)
  		lw $t1, 4($sp)
  		addi $sp, $sp, 8
  	

  		add $a1, $t1, 48
  		sb   $a1, buff($zero)
  		la $a1, buff
  		li   $v0, 15       # system call for write to file
  		lw   $a0, log_file_desc      # file descriptor 
  		li   $a2, 1       # hardcoded buffer length
  		syscall            # write to file
  		jr $ra
  		
  	log_grid:
  		addi $sp, $sp, -4
		sw $s0, 0($sp)
		la $s0, ($a0)
		li $t1, -1 # cur r
		la $s1, seven
		lw $s1, 0($s1)
		for_log:

			la $a0, log_file_desc
			la $a1, indent_spacing
			la $a2, 7
			li $v0, 15
			syscall
			
			li $t2, -1 # cur c
			beq $t1, 7, log_y_index
			bgez $t1, for_log_2
			log_y_index:
				la $a0, log_file_desc
				la $a1, index_y
				la $a2, 19
				li $v0, 15
				syscall
				j end_for_log_2	  
			for_log_2:
				log_num:
				bltz $t2, log_index
				beq  $t2, 7, log_index 
				la $t0, ($s0)
				mul $t3, $t1, $s1
				add $t3, $t3, $t2
			
				add $t0, $t0, $t3
				lb $t4, 0($t0) 
				add $a1, $t4, 48
				sb $a1, buff($zero)
				la $a0, log_file_desc
				la $a1, buff
				la $a2, 1
				li $v0, 15
				syscall
				
				j log_space
				log_index:
				add $a1, $t1, 48
				sb $a1, buff($zero)
				la $a0, log_file_desc
				la $a1, buff
				la $a2, 1
				li $v0, 15
				syscall
				log_space:

				li $a1, 32   # ASCII code for space
			
				sb $a1, buff($zero)
				la $a0, log_file_desc
				la $a1, buff
				la $a2, 1
				li $v0, 15
    				syscall
			
				addi $t2, $t2, 1
				#li $v0, 1
				#add $a0, $t2, $zero
    				#syscall
				blt $t2, 8, for_log_2
				
				la $a0, log_file_desc
				la $a1, endl
				la $a2, 1
				li $v0, 15

    			end_for_log_2:
    				addi $t1, $t1, 1
				blt $t1, 8, for_log
		end_log:
			lw $s0, 0($sp)
			addi $sp, $sp, 4
			jr $ra
