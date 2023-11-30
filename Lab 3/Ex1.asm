.data 
	input_prompt: .asciiz "Choose a number for your desire shape: \n--- 1. Rectangular box\n--- 2. Cube\n--- 3. Cylinder\n--- 4. Sphere\n"
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
	sph: .asciiz "Sphere\n"
	height: .asciiz "------- Input height: "
	width: .asciiz  "------- Input width:  "
	length: .asciiz "------- Input length: "
	edge: .asciiz "------- Input edge length: "
	radius: .asciiz "------- Input radius: "
	result: .asciiz "\n------- Result: "
	except: .asciiz "\n  Invalid input !! Input must be greater or equal to 0\n"
	pi: .float  3.141592654
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
		blt $t0, 1, shape_except
		bgt $t0, 4, shape_except
		
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
		beq $t0, 4, sphere
		
		shape_except:
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
		li $t0, 0
		mtc1 $t0, $f31
		cvt.s.w $f31, $f31
		# load zero to compare
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
		
		#height
		la $a0, height
		li $v0, 4
		syscall
		
		li $v0, 6
		syscall 
		mov.s $f3, $f0

		c.lt.s $f1, $f31
		bc1t exp_0
		c.lt.s $f2, $f31
		bc1t exp_0
		c.lt.s $f3, $f31
		bc1t exp_0
		
		
		la $v0, 4
		la $a0, result
		syscall
		bne $s0, 1, calc_sur_0
		#calc volume l x w x h
		mul.s $f12, $f1 , $f2 
		mul.s $f12, $f12, $f3
		li $v0, 2
		syscall
		j end_rec
		
		calc_sur_0:
		mul.s $f12, $f1,  $f2  # l * w
		mul.s $f30, $f1,  $f3  # l * h
		add.s $f12, $f12, $f30 # (l*h + l*w)
		mul.s $f30, $f2,  $f3  # w * h
		add.s $f12, $f12, $f30 # (lh + lw + wh)
		add.s $f12, $f12, $f12 # 2(lh + lw + wh)
		li $v0, 2
		syscall

		end_rec:
			j exit
		exp_0:
			la $a0, except
			li $v0, 4
			syscall
			j after_0
	
	cube:
		addi $s0, $a0, 0 ## preserve mode
		li $v0, 4
		la $a0, restate
		syscall 
		la $a0, cub
		syscall
		
		la $a0, chosen_mode
		syscall 
		
		bne $s0, 1, mode_1
		la $a0, vol
		syscall
		j after_1
		
		mode_1:
			la $a0, sur
			syscall
		after_1:
		#edge
		la $a0, edge
		li $v0, 4
		syscall
		
		li $v0, 6
		syscall 
		mov.s $f1, $f0
		
		c.lt.s $f1, $f31
		bc1t exp_1
		
		la $v0, 4
		la $a0, result
		syscall
		bne $s0, 1, calc_sur_1
		#calc volume a ^ 3
		mul.s $f12, $f1 , $f1 # a * a   = a^2 
		mul.s $f12, $f12, $f1 # a^2 * a = a^3
		
		li $v0, 2
		syscall
		j end_cub
		
		calc_sur_1:
		mul.s $f12, $f1,  $f1  # a^2
		# load 6
		li   $t0, 6
		mtc1 $t0, $f30
		cvt.s.w $f30, $f30 # Load 6 to $f30
		mul.s $f12, $f12, $f30 # 6a^2
		
		li $v0, 2
		syscall

		end_cub:
			j exit
		j exit
		exp_1:
			la $a0, except
			li $v0, 4
			syscall
			j after_1
	cylinder:
		
		addi $s0, $a0, 0 ## preserve mode
		li $v0, 4
		la $a0, restate
		syscall 
		la $a0, cyl
		syscall
		
		la $a0, chosen_mode
		syscall 
		
		bne $s0, 1, mode_2
		la $a0, vol
		syscall
		j after_2
		
		mode_2:
			la $a0, sur
			syscall
		after_2:
		#radius
		la $a0, radius
		li $v0, 4
		syscall
		
		li $v0, 6
		syscall 
		mov.s $f1, $f0
		
		#height
		la $a0, height
		li $v0, 4
		syscall
		
		li $v0, 6
		syscall 
		mov.s $f2, $f0
		
		c.lt.s $f1, $f31
		bc1t exp_2
		c.lt.s $f2, $f31
		bc1t exp_2
		
		la $v0, 4
		la $a0, result
		syscall
		bne $s0, 1, calc_sur_2
		#calc volume pi* r^2 * h
		lwc1 $f3, pi # load pi to f3
		mul.s $f12, $f1 , $f1 # r * r   = r^2 
		mul.s $f12, $f12, $f2 # r^2 * h
		mul.s $f12, $f12, $f3 # pi r^2 h
		
		li $v0, 2
		syscall
		j end_cyl
		
		calc_sur_2:
		#  2 pi r h  + 2 pi r ^2 
		lwc1 $f3, pi # load pi to f3
		mul.s $f12, $f1 , $f1 # r * r   = r^2 
		mul.s $f12, $f12, $f3 # r^2 * pi
		add.s $f12, $f12, $f12 # 2 pi r^2 
		
		mul.s $f30, $f1,  $f2 # rh
		mul.s $f30, $f30, $f3 # pi rh
		add.s $f30, $f30, $f30 # 2pi rh
		add.s $f12, $f12, $f30 #  2 pi r h  + 2 pi r ^2 
		li $v0, 2
		syscall

		end_cyl:
			j exit
		j exit
		exp_2:
			la $a0, except
			li $v0, 4
			syscall
			j after_2
	sphere:
		
		addi $s0, $a0, 0 ## preserve mode
		li $v0, 4
		la $a0, restate
		syscall 
		la $a0, sph
		syscall
		
		la $a0, chosen_mode
		syscall 
		
		bne $s0, 1, mode_3
		la $a0, vol
		syscall
		j after_3
		
		mode_3:
			la $a0, sur
			syscall
		after_3:
		#radius
		la $a0, radius
		li $v0, 4
		syscall
		
		li $v0, 6
		syscall 
		mov.s $f1, $f0
		
		c.lt.s $f1, $f31
		bc1t exp_3
		
		la $v0, 4
		la $a0, result
		syscall
		bne $s0, 1, calc_sur_3
		#calc volume 4(pi* r^3)/3
		lwc1 $f3, pi # load pi to f3
		mul.s $f12, $f1 , $f1 # r * r   = r^2 
		mul.s $f12, $f12, $f1 # r^2*r   = r^3
		mul.s $f12, $f12, $f3 # pi r^3 
		add.s $f12, $f12, $f12 # 2 pi r^3
		add.s $f12, $f12, $f12 # 2*2 pi r^3 
		
		li $t0, 3
		mtc1 $t0, $f30
		cvt.s.w $f30, $f30
		
		div.s $f12, $f12, $f30 # f12 / 3
		li $v0, 2
		syscall
		j end_sph
		
		calc_sur_3:
		# 4 pi r^2
		
		lwc1 $f3, pi # load pi to f3
		mul.s $f12, $f1 , $f1 # r * r   = r^2 
		mul.s $f12, $f12, $f3 # r^2 * pi
		add.s $f12, $f12, $f12 # 2 pi r^2 
		add.s $f12, $f12, $f12 # 2*2 pi r^2 
		li $v0, 2
		syscall

		end_sph:
			j exit
		j exit
		
		exp_3:
			la $a0, except
			li $v0, 4
			syscall
			j after_3
		
