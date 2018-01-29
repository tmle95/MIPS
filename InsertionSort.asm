	.data 	
array:	.word	 1234, 87, 16, 854, 112, 117, -1, 6, 133, 11, 11, 337, 1337, -1 #array of 14 elements
txt0:	.asciiz	"Array before Insertion Sort: \n"
txt2:   .asciiz "Array after Insertion Sort: \n"
space:	.asciiz " "
endl:   .asciiz "\n"

	.text		
main:

	li 	$t0, 56		# array size, 14 * 4 = 56
	li 	$t1, 0		# array ptr
	

	#Array before Insertion Sort:
        li	$v0, 4
	la	$a0, txt0
	syscall
	
	jal 	print	#jumps to function to print array
	
	# print a new line "\n"
        li	$v0, 4
	la	$a0, endl
	syscall
	
	jal	insertionSort	#jumps to function to sort array
	
	#Array after Insertion Sort:
        li	$v0, 4
	la	$a0, txt2
	syscall
	
	jal 	print
	
# Exit the program 
exit:
	li	$v0, 10			# syscall 10 exits the program
	syscall	

# This function sorts the array through insertion sort
insertionSort:
	
	li 	$s0, 4			# int i, to access array[i]
	li 	$s1, 0			# int j, to access array[i-4] (prev number)
	li	$t2, 0			# int from array[i]
	
	for:
		bge	$s0, $t0, doneFor	# for (i, i < n, i++)
	
		move	$s1, $s0		# j = i - 4
		subi	$s1, $s1, 4
	
		lw	$t2, array($s0) 	# num = array[i]
	
		while:
			lw	$t3, array($s1) 	# t3 = array[j]
			move	$t4, $s1		# t4 = j + 4, bytes count by 4 to access next num
			addi 	$t4, $t4, 4 
	
			blt	$s1, 0, doneWhile	# if (j <= 0 ) done looping
			ble	$t3, $t2, doneWhile	# if (array[j] < num) done looping for current num
	
			lw	$t5, array($s1)
			sw	$t5, array($t4)
			subi	$s1, $s1, 4
			
			j	while
	
	doneWhile:	
		sw 	$t2, array($t4)
	
		addi	$s0, $s0, 4		# i += 4, to access next spot in array
		j	for
	
doneFor:	
	jr 	$ra
	
#Fucntion to print the array
print:
	
	li 	$t1, 0		# Reset the array pointer 

	# use a whileLoop to print
	printWhileLoop: 
		# Print number from array at ptr
		lw	$t2 , array($t1)
		li	$v0, 1
		move	$a0, $t2
		syscall
		
		#adding a space between numbers
        	li	$v0, 4
		la	$a0, space
		syscall
		
	       	addi	$t1, $t1, 4		 # update ptr
	       	bne	$t1, $t0, printWhileLoop # if(ptr != number of elemetns in array)  loop back

	done:

		# Return from function
		jr	$ra

