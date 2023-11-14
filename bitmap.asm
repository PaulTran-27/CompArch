.data
bitmap: .space  131072 #128     # 512 * 256

.text
main:
    # Initialize the bitmap with all pixels set to white
    la $t1, bitmap
    li $t2, 131072
    li $t0, 0xFFFFFFFF
    fill:
    	beqz $t2, exit
	     # Set all bits to 1 (white)
    	sw $t0, 0($t1)         # Store the pattern in the bitmap
	subi $t0, $t0, 0x0101
	addi $t1, $t1, 4
	addi $t2, $t2, -1
	j fill
    # Continue initializing other rows as needed
    exit:
    # Display the bitmap
    	li $v0, 10             # Exit program
    	syscall
