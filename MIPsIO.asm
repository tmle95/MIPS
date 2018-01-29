.data
	message: .asciiz "Please enter a text file name : "
	newline: .asciiz "\n"
	errormsg: .asciiz "There was an error, could not open file"
	file: .ascii ""
	buffer: .space 1024
.text

.globl main
	main:
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
		la $a0, file	
		li   $a1, 0        # read flag
		li   $a2, 0        # ignore mode
		syscall     
		bltz $v0 , error #error, display error message       
		move $s6, $v0      # save descriptor into s6

		li $v0, 14 #call to write file
		move $a0, $s6	#store descriptor into arg a0
		la $a1, buffer	#addres for buffer
		li $a2, 1024	#length
		syscall
		la $a0, buffer	#prints file text
		li $v0, 4
		syscall
		li $v0, 16	#close file
		move $a0, $s6
		syscall
	exit:
		li $v0 , 10
		syscall
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
