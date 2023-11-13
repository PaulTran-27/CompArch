.data
bitmap: .space 65536      # 512 * 512 / 4

.text
main:
    # Initialize the bitmap with all pixels set to white
    la $t1, bitmap
    fill:

        li $t0, 0xFFFFFFFF     # Set all bits to 1 (white)
    	sw $t0, 0($t1)         # Store the pattern in the bitmap
	addi $t1, $t1, 4
	j fill
    # Continue initializing other rows as needed

    # Display the bitmap
    li $v0, 10             # Exit program
    syscall