	.data 		
array:  .space  52				# initialized with space for 13 elements max (52 bytes total, 4 bytes per integer)
txt1:	.asciiz	"Enter an integer between 0 and 13: "
txt2:	.asciiz	"Factorial = "
return: .asciiz	"\n"

	.text		
main:
						# Print "Enter an integer between 0 and 13: "
        li 	$v0, 4             		# syscall 4 prints
	la 	$a0, txt1
	syscall	
      						# Read users input
        li 	$v0, 5				# syscall 5 reads an integer
	syscall
   
   						# move n into register $t0
        move 	$t0, $v0
        
      						# if (n < 0 || n > 12), exit the program
      	bge 	$t0, 14,end
        blt 	$t0, 0,	end
               
        li	$t1, 1				# set counter to 1
	li	$t2, 1				# set current factorial sum = 1
	li	$t3, 0				# set array pointer = 0
				
						# store current factorial value into array	
	sw 	$t2, array($t3)       		# store 1 (for 0!) in array
    	addi  	$t3, $t3, 4   			# add 4 to array pointer
	
						# Print current factorial sum (0! = 1)
	li	$v0, 1				# syscall 1 prints an integer 
	move	$a0, $t2
	syscall
	
						#return to a new line
	li	$v0, 4
	la	$a0, return
	syscall
	
						# Calculate the factorial sum using a while loop
loop:
	blt	$t0, $t1, done			# condition - while(inputValue >= loopCounter)
 
	mul	$t2, $t2, $t1			# sum *= i
       	addi	$t1, $t1, 1			# loopCounter + 1

    	sw 	$t2, array($t3)   	    	# store current factorial sum in array
    	addi  	$t3, $t3, 4   			# add 4 to array pointer

    						# Print current factorial sum
	li	$v0, 1
	move	$a0, $t2
	syscall
    	
    						#return to a new line
	li	$v0, 4
	la	$a0, return
	syscall
	
        j 	loop
        
done:
						# Print "Factorial = "
        li	$v0, 4
	la	$a0, txt2
	syscall

						# Print final factorial sum
	li	$v0, 1
	move	$a0, $t2
	syscall

						#return to a new line
	li	$v0, 4
	la	$a0, return
	syscall


						# Exit the program 
end:
	li	$v0, 10			# syscall code 10 exits the program
	syscall
