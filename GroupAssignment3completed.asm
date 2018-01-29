.data
	Array: .word 30, 2 , 33 , 20 , 10, 51, -23
	length: .word 7
	sum: .word 0
	average: .word 0
	min: .word 0
	max: .word 0
	ans: .asciiz "The average of numbers in array is : "
	ansmax: .asciiz "The Maximum in the array is : "
	ansmin: .asciiz "The minimum in the array is: "
	newline: .asciiz "\n"
	space: .asciiz " "
	message: .asciiz "The numbers in the array are : "
.text

.globl main
	main:
		la $s1, Array
		lw $t0, ($s1) #t0 = array[i]
		la $t6, length
		lw $s2, ($t6)
		move $t1, $zero #t1 = i
		
		li $v0, 4
		la $a0, message
		syscall
		
		move	$t4, $zero
		move	$t5, $zero
		move	$t8, $s2
		Loop:
			beq $t1, $s2, done #exit after reading entire array
			add $t2, $t1, $t1
			add $t2, $t2, $t2
			add $t2, $t2, $s1
			add $t1, $t1, 1 #i++
			lw $t3, 0($t2)
			
			li $v0, 1	#prints out array
			move $a0, $t3 #prints out array
			syscall		#prints out array
			
			li $v0, 4	#prints space
			la $a0, space	#prints space
			syscall
			
			add $t7, $t7, $t3 #t7 = sum
			slt $t4, $t0, $t3 #if $t0 < $t3 , $t4 = 1, else = 0
			jal minimum
			beq $t4, $zero, Loop # beq gives maximum , bgt would give minimum
			move $t0, $t3 #t0 = maximum
			
			
			j Loop
		done:
			la $a0, newline
			li $v0, 4
			syscall
			la $a0, ans
			li $v0, 4
			syscall
			div $t5, $t7, $s2 #t5 = average
			
			move $a0, $t5
			li $v0, 1
			syscall
			
			li $v0, 4
			la $a0, newline
			syscall
			
			li $v0, 4
			la $a0, ansmax
			syscall
			
			li $v0, 1
			move $a0, $t0
			syscall
			
			li $v0, 4
			la $a0, newline
			syscall
			
			li $v0, 4
			la $a0, ansmin
			syscall
			
			li $v0, 1
			move $a0, $t8
			syscall

			li $v0, 10
			syscall
			
			
minimum:
	bgt	$t8, $t3, newMin
	jr	$ra

newMin:
	move 	$t8, $t3
	jr	$ra
		
