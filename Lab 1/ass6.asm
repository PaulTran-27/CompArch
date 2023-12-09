.data
	bin: .space 11
	txt_1: .asciiz "Input 10-bit binary: "
	txt_2: .asciiz "Decimal value: "
	endl: .asciiz "\n"
.text
	li $v0, 4
	la $a0, txt_1
	
	syscall
	
	la $a0, bin
	li $a1, 11  
	li $v0, 8
	syscall 
	while:
    		lb $t2, bin($t1)  
    		beqz $t2, print
    		subi $t2, $t2, 48         
    		mul $t0, $t0, 2          
    		add $t0, $t0, $t2        
    		addi $t1, $t1, 1       
    		j while
	print:
	
		la $a0, endl
		li $v0, 4
		syscall
		la $a0, txt_2
		li $v0, 4
		syscall

		addi $a0, $t0, 0
		li $v0, 1
		addi $a0, $t0, 0
		syscall
	exit:
	
		li $v0, 10
		syscall
	
