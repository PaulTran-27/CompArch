.data
 	txt1: .asciiz "Input N, M and X:\n"
 	txt2: .asciiz "Input number: "
 	txt3: .asciiz "Printing: "
 	space: .asciiz " "
.text
	main:
		li $v0, 4
		la $a0, txt1
		syscall
		
		li $v0, 4
		la $a0, txt2
		syscall
		li $v0, 5
		syscall
		addi $t0, $v0, 0 # N
		
		li $v0, 4
		la $a0, txt2
		syscall
		li $v0, 5
		syscall
		addi $t1, $v0, 0 #M
		
		li $v0, 4
		la $a0, txt2
		syscall
		li $v0, 5
		syscall
		addi $t2, $v0, 0 # X
		
		li $v0, 4
		la $a0, txt3
		syscall
		addi $t7, $zero, 0
		while: 
			beq $t7, $t2, exit
			blt $t2, $zero, exit
			li $v0, 1
			addi $a0, $t0, 0
			syscall 
			li $v0, 4
			la $a0, space
			syscall
			
			mul $t0, $t0, $t1
			addi $t7, $t7, 1
			j while
	exit:
		li $v0, 10
		syscall
		
