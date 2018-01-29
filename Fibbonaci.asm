#COSC2440 Homework 6
#Tony Trong Le
#PSID: 1553677

.data
	message: .asciiz "Enter a number : "
	errormessage: .asciiz "Please enter another number :"
	Array: .word 0:47
	Number: .word 0
	comma: .asciiz ","
	
.text

.globl main
	main :
		#Display Enter number message
		li $v0, 4
		la $a0, message
		syscall
				
		while:
			li $v0, 5 # Get Input
			syscall
			move $t0, $v0 #store Input into $t0
			bge $t0, 1, while2 #If more than 1 go to next loop
			li $v0, 4 
			la $a0, errormessage #Number less than 1,Enter another number
			syscall
			j while #Go back to beginning of While Loop
		while2:
			blt $t0, 47, next #If Input less than 47 go to next
			li $v0 ,4
			la $a0, errormessage #Number more than 47, Enter another number
			syscall
			j while #Go back to first while Loop
		next:
			addi $t1, $zero, 0 #set index to 0
			beq $t1, $t0, done #if index equals to Number go to done
			sub $t0,$t0,1 #decrement Number by 1
			sw $t0, Number #Store Number into global variable
			lw $a0, Number #set Number as argument
			jal fib #call fibonacci function
			sw $v0, Array($t1) #store result of fib into array
			lw $t6, Array($zero)
			li $v0, 1 #Display Array
			addi $a0, $t6, 0
			syscall
			li $v0, 4
			la $a0, comma #line after each result
			syscall
			j next #Loop Next until t1 equals $t0
		done:
			li $v0, 10
			syscall


fib:    
	subi $sp,$sp,12         # increase stack size by 12
        sw $a0, 0($sp)          # store $a0 = n
        sw $s0, 4($sp)          # store $s0
        sw $ra, 8($sp)          # store return address $ra
        bgt $a0,1, gen          # if n>1 then goto generic case
        move $v0,$a0            # output = input if n=0 or n=1
        j restore               # goto restore registers
gen:   
	subi $a0,$a0,1         # param = n-1
        jal fib                 # compute fib(n-1)
        move $s0,$v0            # save fib(n-1)
        sub $a0,$a0,1           # set param to n-2
        jal fib                 # and make recursive call
        add $v0, $v0, $s0       # $v0 = fib(n-2)+fib(n-1)
restore:   
	lw  $a0, 0($sp)         # restore registers from stack
        lw  $s0, 4($sp)         
        lw  $ra, 8($sp)         
        addi $sp, $sp, 12       # decrease the stack size
        jr $ra
