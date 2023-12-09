.data 
	txt1: .asciiz "Input a,b,c,d: \n"
	txt_a: .asciiz "a: "
	txt_b: .asciiz "b: "
	txt_c: .asciiz "c: "
	txt_d: .asciiz "d: "
	txt_F: .asciiz "F = "
	txt_G: .asciiz "G = "
	endl: .asciiz "\n"
	a: .word 0
	b_: .word 0
	c: .word 0
	d: .word 0
	F: .word 0
	G: .word 0
.text
	li $v0, 4
	la $a0, txt1
	syscall
	la $a0, txt_a
	syscall	
	li $v0, 5
	syscall
	la $t0, a
	addi $t1, $v0, 0
	sw $t1, 0($t0)
	
	li $v0, 4
	la $a0, txt_b
	syscall	
	li $v0, 5
	syscall
	la $t0, b_
	addi $t1, $v0, 0
	sw $t1, 0($t0)
	
	li $v0, 4
	la $a0, txt_c
	syscall	
	li $v0, 5
	syscall
	la $t0, c
	addi $t1, $v0, 0
	sw $t1, 0($t0)
	
	li $v0, 4
	la $a0, txt_d
	syscall	
	li $v0, 5
	syscall
	la $t0, d
	addi $t1, $v0, 0
	sw $t1, 0($t0)
	
	la $s0, F
	# a+b
	lw $t0, a
	mul $t7, $t0, $t0 # a^2
	lw $t1, b_
	add $t0, $t0, $t1
	
	# c-d
	lw $t1, c
	lw $t2, d 
	sub $t1, $t1, $t2
	
	# (a+b)(c-d)
	mul $t0, $t0, $t1
	# F
	beq $t7, 0, exit
	div $t0, $t0, $t7
	sw $t0, 0($s0)
	
	la $s1, G
	#  c - a
	lw $t0, a
	lw $t1, c
	li $t7, 0
	sub $t7, $t1, $t0
	# a = a + 1
	addi $t0, $t0, 1
	# b = b+2
	lw $t2, b_
	addi $t2, $t2, 2
	# c = c - 3
	addi $t1, $t1, -3
	
	#multiply all
	mul $t0, $t0, $t1
	mul $t0, $t0, $t2
	
	#G 
	beq $t7, $zero, exit
	div $t0, $t0, $t7
	sw $t0, 0($s1)
	
	
	la $a0, txt_F
	li $v0, 4
	syscall
	lw $t0, 0($s0)
	addi $a0, $t0, 0
	li $v0, 1
	syscall
	la $a0, endl
	li $v0, 4
	syscall
	la $a0, txt_G
	li $v0, 4
	syscall
	lw $t0, 0($s1)
	addi $a0, $t0, 0
	li $v0, 1
	syscall
	exit: 
		li $v0, 10
		syscall
