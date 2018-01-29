.data 
	file: .ascii ""
	file_input: .space 1024
	message: .asciiz "Enter name for text file : "
	message2: .asciiz "Enter input atleast 10 characters to write to text file : "
	errormsg: .asciiz "There was an error, could not open file"
	file_end:

.text #enables text input / output, kind of like String.h in C++
	

main: #main function is always called in any mips program, so the program will start here with actual assembly code

	li $v0, 4
	la $a0, message
	syscall

	li $v0, 8 #prompt user to input strings
	la $a0 , file #address of file
	li $a1, 1024 #length
	syscall
	move $s1, $v0 #store input into s1
	
	jal Validate #Make the filename valid for reading
	
	li $v0, 13 #call for open file
	la $a0, file	#file address
	li   $a1, 1    # write flag
	li   $a2, 0        # ignore mode
	syscall  
	bltz $v0 , error #error, display error message       
	move $s6, $v0       # save descriptor into s6
	
	li $v0, 4
	la $a0, message2
	syscall
	
	li $v0, 8 #prompt user to input strings
	la $a0 , file_input #address of input text
	li $a1, 100 #length
	syscall
	move $s7, $v0

	move $a0, $s6  # move descriptor to a0
	li $v0, 15	#write
   	la $a1, file_input #address of data 
    	li $a2, 100	#length
    	syscall
    	
    	li $v0, 16 #close file
    	move $a0, $s6
    	syscall

exit:
	li $v0, 10 #loads op code into $v0 to exit program
	syscall #reads $v0 and exits program
	
Validate:
    		li $t0, 0     
   		li $t1, 50
	clean:
   		beq $t0, $t1, done
    		lb $t3, file($t0)
    		bne $t3, 0x0a, inc
    		sb $zero, file($t0)
    	inc:
    		addi $t0, $t0, 1
		j clean
	done:
		jr $ra

error:
	la $a0, errormsg
	li $v0, 4
	syscall
	j exit
