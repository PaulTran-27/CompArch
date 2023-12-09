.data 
	alpha_count: .word 0:26 # empty counter for each alphabet letters 

	input_prompt: .asciiz "Input string containing alphabet letters: "
	input_again: .asciiz "INPUT ONLY ALPHABET LETTER(S) PLEASE: "
	again_prompt: .asciiz "ONLY ALPHABET LETTERS !!! \n" 
	input_buffer: .space  1000
	global_max: .word 0
	current_max: .word 0
	max_max: .word 0
	sec_max: .word 0
.text
	main:

	la $a0, input_prompt
	li $v0, 4
	syscall 
	input:
	la $a0, input_buffer
	la $a1, 1000
	li $v0, 8
	syscall
	jal parse_input
	jal find_max
	jal print_max
	exit:
		li $v0, 10
		syscall
	
	parse_input:
		la $s0, input_buffer
		parse_while:
			lb  $t0, 0($s0)
			beq $t0, 10, exit_while
			addi $t0, $t0, -97
			blt  $t0, $zero, exception
			bgt  $t0, 26, exception	
			continue:
			la $s1, alpha_count
			sll $t0, $t0, 2
			add $s1, $s1, $t0
			lw $t2, 0($s1)
			addi $t2, $t2, 1
			sw $t2, 0($s1)
			addi $s0, $s0, 1
			j parse_while
		exit_while:
			jr $ra
	exception:
		blt  $t0, -7, continue_run
		bgt  $t0, -56, continue_run
		j restore_alpha_count
		continue_run:
			addi $t0, $t0,32
			j continue
		restore_alpha_count:
			li $t0, 26
			while_restore:
				beqz $t0, exit_while_r
				la $s0, alpha_count
				sll $t2, $t0, 2
				add $s0, $s0, $t2
				li $t1, 0
				sw $t1, 0($s0)
				addi $t0, $t0, -1
				j while_restore
		exit_while_r:
			la $a0, again_prompt
			li $v0, 4
			syscall
			la $a0, input_again
			syscall 
		j input
	find_max:
		li $t0, 0
		la $s0, alpha_count
		li $s1, -100000
		li $s2, -100000
		
		
		min_while:
			beq $t0, 15, end_while_min
			la $s0, alpha_count
			sll $t2, $t0, 2
			add $s0, $s0, $t2		
			lw $t1, 0($s0)
			
			# if (min < $t1) skip
			# else	sec_min = min; min = t1
			bgt $s1, $t1, no_update_min # if
			beq $s1, $t1, only_min
			addi $s2, $s1, 0
			only_min:
			addi $s1, $t1, 0
			
					
			no_update_min:
				blt $s2, $t1, skip
				beq $s1, $t1, skip
				addi $s2, $t1, 0
			skip:
			addi $t0, $t0, 1
			j min_while
		end_while_min:
			sw $s2, sec_max
			sw $s1, max_max
		

			jr $ra
	print_max:
		li $t0, 25
		la $t3, max_max
		lw $t3, 0($t3)
		print_while:
			beqz $t3, end_while_print
			beq $t0, -1, end_while_print_s
			la $s0, alpha_count
			sll $t2, $t0, 2
			add $s0, $s0, $t2		
			lw $t1, 0($s0)
			beq $t1, $t3, print
			after_print:
			addi $t0, $t0, -1
			j print_while
		end_while_print_s:
			addi $t3, $t3, -1
			li $t0, 25
			j print_while
		end_while_print:
			jr $ra
		print:
			addi $a0, $t0, 97
			li $v0, 11
			syscall
			
			li $a0, 58
			syscall
			li $a0, 32
			syscall
			li $v0, 1
			addi $a0, $t3, 0
			syscall
			li $a0, 59
			li $v0, 11
			syscall
			li $a0, 32
			li $v0, 11
			syscall
			j after_print
			
			
			