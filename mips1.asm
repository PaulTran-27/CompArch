.data
	greet: .asciiz "Hello player(s) \n"
	turn_count_prompt: .asciiz "Turn number: "
	turn_count: .word 0
	p1: .asciiz "Player one's turn: "
	p2: .asciiz "Player two's turn: "
	input: .asciiz "Please setup your battleship strategy:"
	grid_player_1: .byte 0:49 
	grid_player_2: .byte 0:49 # create 7 by 7 grid for each player
	seven: .word 7
	endl: .asciiz "\n"
	txt: .asciiz "ENDING PROGRAM\n"
	txt_1: .asciiz "Confirm placement ? \n"
	input_buffer: .space 100 # buffer for input
.text
	main:
		la $a0, greet
		li $v0, 4
		syscall
	
		
		la $a0, grid_player_2
		jal print_grid
		

				
	exit:
		la $a0, txt
		li $v0, 4
		syscall
		li $v0, 10
		syscall
		
		
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