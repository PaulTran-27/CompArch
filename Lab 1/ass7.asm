.data 
	txt1: .asciiz "Input number: "
	txt2: .asciiz "Factorial of input number: "
	
.text
	main: 
		li $v0, 4
		la $a0, txt1
		syscall 
		
		li $v0, 5
		syscall
		addi $t0, $v0, 0 #N
		
		addi $t1, $zero, 1
		
		while:
			beq $t0, 1, print
			mul $t1, $t1, $t0
			addi $t0, $t0, -1
			j while
		
		print:
			li $v0, 4
			la $a0, txt2
			syscall 
			
			li $v0, 1
			addi $a0, $t1, 0
			syscall
			j exit 
	exit:
		li $v0, 10
		syscall
