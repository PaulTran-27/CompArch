.data 
	input_prompt: .asciiz "Choose a number for your desire shape: \n--- 1. Rectangular box\n--- 2. Cube\n--- 3. Cylinder\n--- 4. Rectangular pyramid.\n"
	input_mode:   .asciiz "Choose a number for your desire mode : \n--- 1. Calculate volume\n--- 2. Calculate surface area\n"
	input_field:  .asciiz "-------- Input here: "
	input_again:  .asciiz "\n Invalid input ! Please select 1 to 4\n"
	input_again_mode:  .asciiz "\n Invalid input ! Please select 1 or 2\n"
	chosen_mode:  .asciiz "Chosen mode: "
	vol: .asciiz "Calculate volume\n"
	sur: .asciiz "Calculate surface area\n"
	restate: .asciiz "\n\nChosen shape: "
	rec: .asciiz "Rectangular box\n"
	cub: .asciiz "Cube\n"
	cyl: .asciiz "Cylinder\n"
	rpy: .asciiz "Rectangular pyramid.\n"
	height: .asciiz "------- Input height: "
	width: .asciiz  "------- Input width:  "
	length: .asciiz "------- Input length: "
	result: .asciiz "\n------- Result: "
.text
	main:
		li $v0, 4
		la $a0, input_prompt
		syscall
		
		select:
		la $a0, input_field
		syscall
		li $v0, 5
		syscall
		move $t0, $v0
		
		li $v0, 4
		la $a0, input_mode
		syscall
		
		select_mode:
		la $a0, input_field
		syscall
		li $v0, 5
		syscall
		bgt $v0, 2, mode_except
		blt $v0, 1, mode_except
		
		addi $a0, $v0, 0
		beq $t0, 1, rectangular_box
		beq $t0, 2, cube
		beq $t0, 3, cylinder
		beq $t0, 4, rectangular_pyramid
		
		li $v0, 4
		la $a0, input_again
		syscall 
		j select
		
	exit:
		li $v0, 10
		syscall
	
	mode_except:
		li $v0, 4
		la $a0, input_again_mode
		syscall 
		j select_mode
	
	rectangular_box:
		addi $s0, $a0, 0 ## preserve mode
		li $v0, 4
		la $a0, restate
		syscall 
		la $a0, rec
		syscall
		
		la $a0, chosen_mode
		syscall 
		
		bne $s0, 1, mode_0
		la $a0, vol
		syscall
		j after_0
		
		mode_0:
			la $a0, sur
			syscall
		after_0:
		## input length
		la $a0, length
		li $v0, 4
		syscall
		
		li $v0, 6
		syscall 
		mov.s $f1, $f0
		
		# width
		la $a0, width
		li $v0, 4
		syscall
		
		li $v0, 6
		syscall 
		mov.s $f2, $f0
		
		#length
		la $a0, length
		li $v0, 4
		syscall
		
		li $v0, 6
		syscall 
		mov.s $f3, $f0
		la $v0, 4
		la $a0, result
		syscall
		bne $s0, 1, calc_sur_0
		#calc volume l x w x h
		mul.s $f12, $f0 , $f1 
		mul.s $f12, $f12, $f2
		li $v0, 2
		syscall
		
		calc_sur_0:
		
		end_rec:
			j exit
		
	
	cube:
		
		li $v0, 4
		la $a0, restate
		syscall 
		la $a0, cub
		syscall
		
		j exit
		
	cylinder:
		
		li $v0, 4
		la $a0, restate
		syscall 
		la $a0, cyl
		syscall
		
		j exit
		
	rectangular_pyramid:
		
		li $v0, 4
		la $a0, restate
		syscall 
		la $a0, rpy
		syscall
		
		j exit
		
		
