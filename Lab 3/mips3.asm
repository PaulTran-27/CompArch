.data 
	fp_array: .float 0.01, 0.02, 0.03, 0.04, 0.8, 1.1, 2.0, 3.0, 4.0, 5.0
	
.text
	# float sum ( float *v , int k ) {
	#	if ( k == 1) return v [0];
	#	return v [0] + sum (& v [1] , k -1) ;
	# }
	main:
		la $a0, fp_array
		li $a1, 10
		jal sum
		
		mov.s $f12, $f0
		li $v0, 2
		syscall
	
	exit:
		li $v0, 10
		syscall
		
	sum:
		#input  $a0 -> address of array
		#	$a1 -> int k
		#output f0  -> return value
		
		bne $a1, 1, recur
		
		l.s $f0, 0($a0)

		jr $ra
		
		
		
		recur:
		addi $sp, $sp, -12
		sw   $a0, 0($sp)
		sw   $a1, 4($sp)
		sw   $ra, 8($sp)

		
		
		addi $a0, $a0, 4
		addi $a1, $a1, -1
		jal sum
		
		
		lw   $a0, 0($sp)
		l.s  $f12, 0($a0)

		add.s  $f0, $f0, $f12
		
		lw   $a1, 4($sp)
		lw   $ra, 8($sp)  
		addi $sp, $sp, 12
			
		jr $ra 