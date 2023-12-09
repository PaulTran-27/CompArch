        .data
fout:   .asciiz "/mnt/Workspace/BK_assignment/CompArchitecture/test.txt"      # filename for output
buffer: .word 0
buff: .asciiz ""
fdesc:  .word 0
        .text
  ###############################################################
  # Open (for writing) a file that does not exist
  li   $v0, 13       # system call for open file
  la   $a0, fout     # output file name
  li   $a1, 1        # Open for writing (flags are 0: read, 1: write)
  li   $a2, 0        # mode is ignored
  syscall            # open a file (file descriptor returned in $v0)
  #move $s6, $v0      # save the file descriptor 
  sw   $v0, fdesc
  
  li $a0, 50000123
  jal recur_print
  j out
  ###############################################################
  # Write to file just opened
  li   $v0, 15       # system call for write to file
  lw   $a0, fdesc      # file descriptor 
  lw $t0, buffer
  li $t2, 10
  while:
#  beqz $t0, out
  div $t0, $t2
  mfhi $t1
  mflo $t0
  move   $a1, $t1   # address of buffer from which to write
  add    $a1, $a1, 48
  sw   $a1, buff
  la $a1, buff
  li   $a2, 1       # hardcoded buffer length
  syscall            # write to file
  j while 
  ###############################################################
  # Close the file 
  out:
  li   $v0, 16       # system call for close file
  move $a0, $s6      # file descriptor to close
  syscall            # close file
  
  li $v0, 10
  syscall
  ###############################################################
  
  
  # recur_print(int):
  #	if int == 0 return
  # 	else print
  recur_print:
  	# $a0
  	bnez $a0, recur

  	
  	jr $ra 
  	
  	recur:
  	addi $sp, $sp, -8

  	sw $ra, 0($sp)
  	
  	li $t9, 10 
  	div $a0, $t9
  	div $a0, $a0, $t9
  	mfhi $t1
  	sw $t1, 4($sp)
  	
  	
  	jal recur_print
  	
  	


  	lw $ra, 0($sp)
  	lw $t1, 4($sp)
  	addi $sp, $sp, 8
  	

  	add $a1, $t1, 48
  	sb   $a1, buff($zero)
  	la $a1, buff
  	li   $v0, 15       # system call for write to file
  	lw   $a0, fdesc      # file descriptor 
  	li   $a2, 1       # hardcoded buffer length
  	syscall            # write to file
  	jr $ra
  	
  	
  	