.data 
	fp_array: .float 0.01, 0.02, 0.03, 0.04, 0.8, 1.1, 2.0, 3.0, 4.0, 5.0
	print_array: .asciiz " Original array: 0.01, 0.02, 0.03, 0.04, 0.8, 1.1, 2.0, 3.0, 4.0, 5.0 \n --- Array after print recursively: \n	"
.text
	# float print ( float *v , int k) {
	#	if ( k == 1) cout << v [0];
	#	else {
	# 		print (& v [1] , k -1) ;
	# 		cout << v [0];
	#	}
	#}
	main:
		la $a0, print_array
		li $v0, 4
		syscall 
		
		la $a0, fp_array
		li $a1, 10       #hardcode k = 10
		jal print
		
	exit:
		li $v0, 10
		syscall
		
	print:
		#input  $a0 -> address of array
		#	$a1 -> int k
		#output print f12
		
		bne $a1, 1, recur
		
		li $v0, 2
		l.s $f12, 0($a0)
		syscall
		# print space
		li $v0, 11
		li $a0, 32
		syscall
		jr $ra
		
		
		
		recur:
		addi $sp, $sp, -12
		sw   $a0, 0($sp)
		sw   $a1, 4($sp)
		sw   $ra, 8($sp)

		
		
		addi $a0, $a0, 4
		addi $a1, $a1, -1
		jal print
		
		
		lw   $a0, 0($sp)
		l.s  $f12, 0($a0)
		li $v0, 2
		syscall
		
		li $v0, 11
		li $a0, 32
		syscall
		
		lw   $a1, 4($sp)
		lw   $ra, 8($sp)  
		addi $sp, $sp, 12
			
		jr $ra 
