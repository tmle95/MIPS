.data
	array: .word 1,2,3,4,5,7,6,8,9,10
	last:
	length: .word 10
	num: .word 0
	NF: .asciiz "Could not "
	F: .asciiz "Found Number in Array"
	enter: .asciiz "Enter a number to search for in array : "
	newline: .asciiz "\n"
	message: .asciiz "This array contains numbers from 1-10"
.text

.globl main
	main:
		li $v0, 4
		la $a0, message
		syscall
		li $v0, 4
		la $a0, newline
		syscall
		li $v0, 4
		la $a0, enter
		syscall
		li $v0, 5	#enter a number	
		syscall
		sw $v0, num
		lw $a0 , num
		move $s0, $a0 #s1 = number
		la $a1, array
		la $a2, last
		move $s1, $a1 #s1 = array first
		move $s2, $a2 #s2 = last of array
		jal BinarySearch
		li $v0, 4
		la $a0, F
		syscall
		
done:
	li $v0, 10
	syscall

BinarySearch:
		addi $sp, $sp, -4	#Make space for reg, 4 stack bytes
		sw $ra, 4($sp)	   	#save return address 

		sub $t1, $s2, $s1	#t1 = last - first
		subi $t1, $t1, 4	#t1 = size = t1 - 1
		srl $t1, $t1, 2		#*4
		bnez $t1, Search	#if t1 > 0, go Search
		move $v1, $s1	#v1 = address of array
		lw $t1, 0($v1)	#t1 = entry of array
		beq $s0, $t1, return	#return if = val
		la $a0, NF	#print not found message
		li $v0, 4
		syscall
		j return
Search:
		srl $t1, $t1, 1 #t1 = mid = t0/2
		sll $t1, $t1, 2 # *4
		add $v1, $s1, $t1 # v1 = middle of array
		lw $t1, 0($v1) # t1 = array[mid]
		beq $s0, $t1, return #if array[mid] = searchelement, return mid
		blt $s0, $t1, SearchLeft # search element is less than mid, search left of mid
SearchRight:
		add $s1, $v1, 4 #mid + 1
		jal BinarySearch
		j return
SearchLeft:
		move $s2, $v1 #mid -1
		jal BinarySearch
return:
		move $s0, $v1
		lw $ra, 4($sp)	#retrieve return address
		addi $sp, $sp, 4	##recover stack bytes
		jr $ra	
