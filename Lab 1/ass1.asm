.data 
	txt1: .asciiz "Input first number: "
	txt2: .asciiz "Input second number: "
	txt3: .asciiz "Choose a number for integer operation from the dropdown list: \n 1. Addition\n 2.Subtraction\n 3.Multiplication\n 4.Division\n "
	endl: .asciiz "\n"
	txt4: .asciiz "Result:"
	txt5: .asciiz "Choose an operation: "
.text

	main: 

		li $v0, 4
		la $a0, txt1
		syscall
		
		li $v0, 5
		syscall
		add $t0, $v0, $zero
		
		li $v0, 4
		la $a0, endl
		syscall
		
		li $v0, 4
		la $a0, txt2
		syscall
		
		li $v0, 5
		syscall
		add $t1, $v0, $zero
		
		li $v0, 4
		la $a0, txt3
		syscall 
		
		li $v0, 4
		la $a0, txt5
		syscall 
		li $v0, 5
		syscall
		add $t3, $v0, $zero
		

		beq $t3, 1, addition
		beq $t3, 2, subtraction
		beq $t3, 3, multiply
		beq $t3, 4, division
		
	terminate:
		li $v0, 10
		syscall
		
	addition: 
		la $a0, txt4
		li $v0, 4
		syscall 
		
		li $v0, 1
		add $a0, $t0, $t1
		syscall
		j terminate
		
	subtraction:
		la $a0, txt4
		li $v0, 4
		syscall 
		
		li $v0, 1
		sub $a0, $t0, $t1
		syscall
		j terminate
	multiply:
		la $a0, txt4
		li $v0, 4
		syscall 
		
		li $v0, 1
		mul $a0, $t0, $t1
		syscall
		j terminate
	division:
		la $a0, txt4
		li $v0, 4
		syscall 
		
		li $v0, 1
		div $a0, $t0, $t1
		syscall
		j terminate