	.data 		
txt1:	.asciiz	"Enter an integer value: "
txt2:	.asciiz	"Prime Factorization of "
txt3:	.asciiz " = "
badInd:	.asciiz "ERROR: Bad Input Detected"
comma:  .asciiz	", "
nl:	.asciiz "\n"

	.text		
main:

   		# Print "Enter an integer value: "
        	li	$v0, 4             	# syscall 4 prints a string
		la	$a0, txt1
		syscall	
        
       		# Read integer value n
       	 	li	$v0, 5	               	# syscall 5 reads an integer
		syscall
   
   		# move n into register $s0
        	move	$s0, $v0
        
        	# Bad input if (n < 1)
		#Cannot calculate Prime Factorizations of Numbers less than 1
		blt	$s0, 2, exitBadInput
        
       	 	# Input is valid
        	# Print "Prime Factorization of n = "
      	 	li	$v0, 4             		
		la	$a0, txt2
		syscall	
	
		li	$v0, 1
		la	$a0, ($s0)
		syscall
	
		li	$v0, 4
		la	$a0, txt3
		syscall
	
	
		li	$t2, 2
whileLoop:
     		div	$s0, $t2
     	  	mfhi	$t0
     	   	bnez	$t0, exitWhileLoop
		div	$s0, $s0, 2
	
		beq	$s0, 1, lastTime
	
		# Print 2
		li	$v0, 1			# syscall 1 prints an integer
		move	$a0, $t2
		syscall

		# Print ", "
		li	$v0, 4
		la	$a0, comma
		syscall
	
		j	whileLoop

exitWhileLoop:


		li	$t0, 3
forLoop:
	bgt	$t0, $s0, exitForLoop
	whileLoop2:
		div	$s0, $t0
		mfhi	$t1
		bnez	$t1, exitWhileLoop2
		div	$s0, $s0, $t0
		
		beq	$s0, 1, lastTime2
		
		# Print current value of $t0
		li	$v0, 1			# syscall 1 prints an integer
		move	$a0, $t0
		syscall

		# Print a comma
		li	$v0, 4
		la	$a0, comma
		syscall
		
		j	whileLoop2
		
exitWhileLoop2:

	add	$t0, $t0, 2
	j	forLoop
	




# Print 2
lastTime:	li	$v0, 1			# syscall 1 prints an integer
		move	$a0, $t2
		syscall
		
		j exit
		
lastTime2:	li	$v0, 1			
		move	$a0, $t0
		syscall
		
		j exit

exitBadInput:
		li 	$v0, 4			# syscakk 4 prints text
		la	$a0, badInd
		syscall

exitForLoop:

		# Exit the program 
exit:
		li	$v0, 10			# syscall 10 exits the program
		syscall	
