.data
	array: .word 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15
	max_index: .word 60
	txt1: .asciiz "Choose a mode: \n 1. Print array at input index\n 2. Print sequence from input index n to input index k\n Your selection: "
	txt2: .asciiz "Choose an index: "
	txt3: .asciiz "Result: "
	txt4: .asciiz "Choose first index: "
	txt5: .asciiz "Choose second index: "
	endl: .asciiz "\n"
	space: .asciiz " "
.text
	main:
		la $a0, txt1
		li $v0, 4
		syscall
		
		li $v0, 5
		syscall 
		
		beq $v0, 1, print_index
		beq $v0, 2, print_sequence
		
	print_index:
		la $a0, txt2
		li $v0, 4
		syscall
		
		li $v0, 5
		syscall 
		sll $t0, $v0, 2
		la $s0, array
		add $s0, $s0, $t0
		
		la $a0, txt3
		li $v0, 4
		syscall
		lw $t0, 0($s0)
		add $a0, $t0, $zero
		li $v0, 1
		syscall 
		j exit
	print_sequence:
		la $a0, txt4
		li $v0, 4
		syscall
		li $v0, 5
		syscall
		
		sll $t0, $v0, 2
		
		la $a0, txt5
		li $v0, 4
		syscall
		li $v0, 5
		syscall
		sll $t2, $v0, 2
		addi $t3, $t2,4
		la $s0, array
		add $s0, $s0, $t0
		la $a0, txt3
		li $v0, 4
		syscall
		while:
			blt $t0, $zero, exit
			beq $t0, $t3, exit
			lw $t7, max_index
			beq $t7, $t0, exit
			li $v0, 1
			lw $t7, 0($s0)
			addi  $a0, $t7, 0
			syscall
			la $a0, space
			li $v0, 4
			syscall
			addi $t0, $t0, 4
			addi $s0, $s0, 4
			j while
	exit: 
		li $v0, 10
		syscall
