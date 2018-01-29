	.data 	
txt1:	.asciiz	"Enter an integer value for A: "
txt2:	.asciiz	"Enter an integer value for B: "
txt3:   .asciiz " choose " 
txt4:	.asciiz " = "
endl:   .asciiz	"\n"

	.text		
main:

   	# Print "Enter an integer value for A: "
        li 	$v0, 4             		# syscall 4 prints a string
	la 	$a0, txt1
	syscall	
        
       	# Read integer for A
        li 	$v0, 5	               		# syscall 5 reads an integer from the user
	syscall
   
   	# move A into register $s0
        move 	$s0, $v0
        
        # Print "Enter an integer value for B: "
        li 	$v0, 4             		
	la 	$a0, txt2
	syscall	

	# Read integer for B
        li 	$v0, 5
	syscall
   
   	# move B into register $s1
        move 	$s1, $v0
        
        # if (A < 0 || B < 0), bad inputs detected.
        blt 	$s0, 0, badInput
        blt 	$s1, 0, badInput
        
        li	$v0, 1
        la	$a0, ($s0)
        syscall
        
        li	$v0, 4
        la	$a0, txt3
        syscall
        
        li	$v0, 1
        la	$a0, ($s1)
        syscall
        
        li	$v0, 4
        la	$a0, txt4
        syscall
        
        
        # if (A < B)
        blt 	$s0, $s1, aLessThanB
        
        
        li 	$s3, 0			# Clear a variable to hold the final answer
	li 	$s4, 0			# Initialize a temp variable
	
	sub	$s3, $s0, $s1
	
	#(A-B)!
	move 	$a0, $s3		# set $a0 to pass into factorial
	jal 	factorial		# find factorial and link return to current jump spot
	move 	$s3, $v0		# set the result of factorial back to $s3
	
	#B!
	move	$a0, $s1
	jal	factorial
	move	$s4, $v0
	
	# B! * (A-B)!
	
	mul	$s3, $s4, $s3
	
	move	$a0, $s0
	jal	factorial
	move	$s4, $v0
	
	div	$s4, $s3
	mflo	$s3
	
answer:	
	# Print k choose n
	li	$v0, 1
	move	$a0, $s3
	syscall

	# Print "\n"
	li	$v0, 4
	la	$a0, endl
	syscall
	
	j	end
	
factorial:
	li	$t0, 1			# initialize a counter for factorial function
	li	$t1, 1			# initialize factorial sum for factorial function

	# use a while loop for calculating the factorial sum
	whileLoop:
		blt	$a0, $t0, endLoop	# condition - while(loopCounter >= inputValue)
 
		mul	$t1, $t1, $t0	# sum *= i
	       	addi	$t0, $t0, 1	# update counter
		
	        j 	whileLoop

	endLoop:
		move 	$v0, $t1	# Save the return value in $v0
		jr 	$ra		# Jump out of the function
		
aLessThanB:
	li	$s3, 0
	j 	answer
	
# Exit the program 
badInput:
end:
	li	$v0, 10			# syscall 10 exits the program
	syscall	
        
        
        
        
