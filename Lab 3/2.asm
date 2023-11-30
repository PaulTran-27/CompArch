.data
	input_prompt: .asciiz "	Please input parameters:\n"
	a_prompt: .asciiz "		a: "
	b_prompt: .asciiz "		b: "
	c_prompt: .asciiz "		c: "
	d_prompt: .asciiz "		d: "
	e_prompt: .asciiz "		e: 7 (Student ID 2252623)\n"
	u_prompt: .asciiz "		u: "
	v_prompt: .asciiz "		v: "
	Int_res: .asciiz  "	Integral result: "
	a: .double 0 
	b: .double 0
	c: .double 0
	d: .double 0
	e: .double 7.0
	u: .double 0
	v: .double 0
	Fu: .double 0
	Fv: .double 0
.text
	main:
		li $v0, 4
		la $a0, input_prompt
		syscall
		
		la $a0, a_prompt
		syscall
		la $v0, 7
		syscall
		s.d $f0, a
		
		li $v0, 4
		la $a0, b_prompt
		syscall
		la $v0, 7
		syscall
		s.d $f0, b
		
		li $v0, 4
		la $a0, c_prompt
		syscall
		la $v0, 7
		syscall
		s.d $f0, c
		
		li $v0, 4
		la $a0, d_prompt
		syscall
		la $v0, 7
		syscall
		s.d $f0, d
		
		li $v0, 4
		la $a0, e_prompt
		syscall 
		
		li $v0, 4
		la $a0, u_prompt
		syscall
		la $v0, 7
		syscall
		s.d $f0, u
		
		li $v0, 4
		la $a0, v_prompt
		syscall
		la $v0, 7
		syscall
		s.d $f0, v
		
		# Calc integral from v -> u = F(u) - F(v)
		## F(u)
		l.d $f12, u
		jal calc_F_x
		s.d $f30, Fu
		
		## F(v)
		l.d $f12, v
		jal calc_F_x
		s.d $f30, Fv
		
		## F(u) - F(v)
		l.d $f2, Fu
		l.d $f0, Fv
		sub.d $f12, $f2, $f0
		## print result
		la $a0, Int_res
		li $v0, 4
		syscall
		li $v0,3
		syscall 
	exit:
		li $v0, 10
	  	syscall  
	  	
	calc_F_x:
		# input $f12 -> x
		# output $f30 -> F(x)
		addi $sp, $sp, -4
		sw   $ra, 0($sp)
		l.d $f0, a
		l.d $f2, b
		l.d $f4, c
		l.d $f6, d
		l.d $f8, e
		
		mtc1.d $zero, $f30
		cvt.d.w $f30, $f30
		# integral ax^4 -> ax^5/5
		mov.d $f28, $f12 
		li    $a0 , 5
		jal   power      # calc x^5
		li $t0, 5
		mtc1.d $t0, $f11
		cvt.d.w $f10,$f11
		div.d $f28, $f28, $f10 # x^5/5
		mul.d $f28, $f28, $f0 # ax^5/5
		add.d $f30, $f30, $f28 # add to result
		
		# integral bx^3 -> bx^4/4
		mov.d $f28, $f12 
		li    $a0 , 4
		jal   power      # calc x^4
		li $t0, 4
		mtc1.d $t0, $f11
		cvt.d.w $f10,$f11
		div.d $f28, $f28, $f10 # x^4/4
		mul.d $f28, $f28, $f2 # bx^4/4
		add.d $f30, $f30, $f28 # add to result
		
		# integral cx^2 -> cx^3/3
		mov.d $f28, $f12 
		li    $a0 , 3
		jal   power      # calc x^3
		li $t0, 3
		mtc1.d $t0, $f11
		cvt.d.w $f10,$f11
		div.d $f28, $f28, $f10 # x^3/3
		mul.d $f28, $f28, $f4 # cx^3/3
		add.d $f30, $f30, $f28 # add to result
		
		# integral dx^0 -> dx
		mov.d $f28, $f12 
		#li    $a0 , 4
		#jal   power      # No need to power
		#li $t0, 4
		#mtc1 $t0, $f5
		#div.s $f28, $f28, $f5 #
		mul.d $f28, $f28, $f6 # dx
		add.d $f30, $f30, $f28 # add to result
		
		
		# integral constant multiplicant 1/e^2
		mov.d $f28, $f8
		li    $a0 , 2
		jal   power      # calc e^2
		li $t0, 1
		mtc1.d $t0, $f11
		cvt.d.w $f10,$f11
		div.d $f28, $f10, $f28 # 1/e^2
		mul.d $f30, $f30, $f28 # multiply with the result
		
		lw $ra, 0($sp)
		addi $sp, $sp, 4
		jr $ra
		
	power:
		#input: $f28 -> to be mul
		#	$a0    -> power
		#return $f28
		
		li $t0, 1
		mov.d $f26, $f28
		pow_loop:
			beq $t0, $a0, end_pow_loop
			mul.d $f28, $f28, $f26
			
			addi $t0, $t0, 1
			j pow_loop
		end_pow_loop:
			jr $ra
		