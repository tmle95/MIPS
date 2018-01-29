	.data
fib:	.space 124 #array of size 31, must use F(n-1) to calculate lucas numbers
luc:	.space 120 #array of size 30

txt1:	.asciiz "Enter a number between 1 and 30: "
txt2:	.asciiz "Fibonacci: "
txt3:	.asciiz "Lucas: "
space:	.asciiz " "
endl:	.asciiz "\n"

	.text
main:
	li	$v0, 4		#syscall to print a string
	la 	$a0, txt1
	syscall
	
	li	$v0, 5		#reads in user input
	syscall
	
	move	$s0, $v0
	
		#end if number is not between 1 and 30
	blt 	$s0, 1, end		
   	bgt 	$s0, 30, end
   	
   	#loading the size of the user input for luc
	mul 	$s1, $s0, 4	
   	
   	#must also load the size for fib array
   	move	$s2, $s1	
	
	li	$v0, 4		#syscall to print a string
	la	$a0, txt2
	syscall
	
	move 	$a0, $s0
	jal 	calcFibAndLuc

	li 	$s3, 0
	li	$s4, 0


#Prints the fibonacci array
printFib:
	lw	$t3, fib($s3)
	
	li	$v0, 1
	move	$a0, $t3
	syscall
	li	$v0, 4
	la	$a0, space
	syscall
	
	addi 	$s3, $s3, 4
	bne	$s3, $s2, printFib
		
#function to add a new line and print Lucas: tag
btwn:
	li	$v0, 4
	la	$a0, endl
	syscall
	li	$v0, 4
	la	$a0, txt3
	syscall
	
#prints the lucas array
printLuc:
	lw	$t3, luc($s4)
	
	li	$v0, 1
	move	$a0, $t3
	syscall
	
	li	$v0, 4
	la	$a0, space
	syscall
	
	addi 	$s4, $s4, 4
	bne	$s4, $s1, printLuc
	
end:
	li	$v0, 10		#exit the program
	syscall	

# calculates the fibonacci and lucas numbers using the requested methods
calcFibAndLuc:
	li	$t0, 2 #L(0)
	li	$t1, 1 #L(1)
	li	$t2, 3 #L(2)
	li	$t3, 0 #F(0)
	li	$t4, 1 #F(1)
	li	$t5, 1 #F(2)
	li	$t6, 0 #counter
	li	$t7, 0 #temp variable
	li	$t8, 0 #temp variable

 	#used to calculate the first numbers of fibonacci and lucas numbers
 	sw 	$t0, luc($s4)
	addi  	$s4, $s4, 4
 	sw 	$t1, luc($s4)
    	addi  	$s4, $s4, 4  
    	sw 	$t2, luc($s4)
    	addi  	$s4, $s4, 4  
    	
	sw 	$t3, fib($s3)
    	addi  	$s3, $s3, 4
 	sw 	$t4, fib($s3)
    	addi  	$s3, $s3, 4  
    	sw 	$t5, fib($s3)
    	addi  	$s3, $s3, 4  

    	
 	addi 	$t6, $t6, 2
 	li	$t5, 4
	li	$t0, 5
	
 	addi 	$t3, $t6, 1
	sra 	$t3, $t3, 1
	sub 	$t4, $t6, $t3
	addi 	$t4, $t4, 1
	addi 	$t3, $t3, 1
	mul 	$t3, $t3, $t5
	mul 	$t4, $t4, $t5
	lw 	$t1, luc($t3)
	lw 	$t2, fib($t4)
	mul 	$t8, $t1, $t2
	move	$t7, $t8
	subi 	$t3, $t3, 4
	subi 	$t4, $t4, 4
	lw 	$t1, luc($t3)
	lw 	$t2, fib($t4)
	mul 	$t8, $t1, $t2 #L(m) * F(n-1) 
	add 	$t7, $t7, $t8
		
	sw 	$t7, luc($s4)
	addi  	$s4, $s4, 4
   		
	addi 	$t6, $t6, 1
 		
 	forLoop:
 		addi 	$t3, $t6, 1
		sra 	$t3, $t3, 1	
		sub 	$t4, $t6, $t3
		addi 	$t4, $t4, 1
		addi 	$t3, $t3, 1
		mul 	$t3, $t3, $t5
		mul 	$t4, $t4, $t5
		lw 	$t1, luc($t3)
		lw 	$t2, fib($t4)
		mul 	$t8, $t1, $t2
		move	$t7, $t8
		subi 	$t3, $t3, 4
		subi 	$t4, $t4, 4
		lw 	$t1, luc($t3)
		lw 	$t2, fib($t4)
		mul 	$t8, $t1, $t2
		add 	$t7, $t7, $t8
		
		sw 	$t7, luc($s4)
    		addi  	$s4, $s4, 4 
		
		#store the previous number of luc for use in fib
		subi $t3, $t6, 1
		mul $t3, $t3, $t5
		lw $t4, luc($t3)
		addi $t3, $t3, 8
		lw $t1, luc($t3)
		add $t2, $t4, $t1
		div $t2, $t2, 5
		
		sw $t2, fib($s3)
    		addi  $s3, $s3, 4 
    		
   		addi	$t6, $t6, 1
	       	ble 	$t6, $s0, forLoop	#checks if counter is greater than the user specified number
 
	exit:
		jr $ra

	
	
