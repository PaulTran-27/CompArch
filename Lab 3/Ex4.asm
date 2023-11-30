.data 
	fp_array: .float 6.01, 0.02, 83.123456, 0.04, 0.8, 1.1, 2.0, 3.0, 4.0, 5.0
	print_array: .asciiz " Original array: 6.01, 0.02, 83.123456, 0.04, 0.8, 1.1, 2.0, 3.0, 4.0, 5.0 \n --- Minimum element in array: "
.text
	# float min ( float *v , int k ) {
	#	if ( k == 1) return v [0];
	#	float temp = min (& v [1] , k - 1) ;
	#	if ( v [0] < temp ) return v [0];
	#	else return temp ;
	#}

	main:
		la $a0, print_array
		li $v0, 4
		syscall 
		
		la $a0, fp_array
		li $a1, 10		# hard coded k = 10
		jal min
		
		mov.s $f12, $f0
		li $v0, 2
		syscall
	
	exit:
		li $v0, 10
		syscall
		
	min:
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
		jal min
		
		
		lw   $a0, 0($sp)
		l.s  $f12, 0($a0) # V[0]
		#f0 -> temp
		#min 
		c.lt.s $f12, $f0  # bool condition flag 0 = v[0] < temp
		
		movt.s $f0, $f12  # move if flag 0 == True ( or return v[0] if v[0] < temp else keep temp from saved value in $f0
		
		lw   $a1, 4($sp)
		lw   $ra, 8($sp)  
		addi $sp, $sp, 12
			
		jr $ra 
