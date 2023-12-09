.data 
	array: .word 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19
	cur_p_start: .word 0
	cur_p_end: .word 76
	space: .asciiz " "
.text
	li $t0, 0
	la $s0, array
	while: 
		beq $t0, 10,print
		lw $t1, cur_p_start
    		lw $t2, cur_p_end

		#sll $t1, $t1, 2
   		#sll $t2, $t2, 2
		la $t3, array
    		la $t4, array
    		add $t3, $t3, $t1
    		add $t4, $t4, $t2
    		

		lw $t5, 0($t3)
    		lw $t6, 0($t4)
    		sw $t6, 0($t3)
    		sw $t5, 0($t4)
    	
		#srl $t1, $t1, 2
		#srl $t2, $t2, 2
		addi $t1, $t1, 4
		subi $t2, $t2, 4
		sw $t1, cur_p_start
		sw $t2, cur_p_end
		addi $t0, $t0, 1
		j while

	print:

		li $t0, 0
		la $s0, array
		
		while_print: 
			beq $t0, 20,exit
			li $v0, 1
			lw $t7, 0($s0)
			addi  $a0, $t7, 0
			syscall
			la $a0, space
			li $v0, 4
			syscall
			
			add $s0, $s0, 4
			addi $t0, $t0, 1
			j while_print
	
	
	exit: 
		li $v0, 10
		syscall