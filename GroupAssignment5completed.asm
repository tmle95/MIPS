.data
	array: .word 10,26,5,3,6,8,9,21,32,55
	length: .word 10
	comma:  .asciiz " "
	newline:  .asciiz "\n"
	message: .asciiz "Array after sorting : "
	message2: .asciiz "Array before sorting : "
	
.text

.globl main
	main:
		la 	$s0, array
		lw 	$t1, ($s0)
		lw	$s1, length
		addi $t0, $zero, 0 #i
		li $v0, 4
		la $a0, message2
		syscall
		
 	while: #This while loop will print unsorted array
		beq $t0, $s1, Sort
		add $t2, $t0, $t0
		add $t2, $t2, $t2
		add $t2, $t2, $s0
		addi $t0, $t0, 1
		lw $t3, 0($t2)
		li $v0, 1
		move $a0, $t3
		syscall
		li $v0, 4
		la $a0, comma
		syscall
		j while
	Sort:
		li $v0, 4
		la $a0, newline
		syscall
		li $v0 4
		la $a0, message
		syscall
		move    $a0, $s0	# a0 = array
        	move    $a1, $s1	# a1 = size of array
        	jal     selectionsort	#call sort function
        	
        	move    $a0, $s0
       	 	move    $a1, $s1
        	jal     printlist	#call print function to print array after selection sort
        exit:
        	li $v0, 10
        	syscall
        	
selectionsort:
	addi    $sp, $sp, -24           # Make space for registers
        sw      $ra, 20($sp)  
        sw      $s0, 16($sp)          
        sw      $s1, 12($sp)          
        sw      $s2,  8($sp)           
        sw      $s3,  4($sp)           
        sw      $s4,  0($sp)             


        move    $s0, $a0                # $s0 = list
        move    $s1, $a1                # $s1 = length

        addi    $s3, $s1, -1            #when i >= n-1 = $s3, end
        move    $s2, $zero
loop: 
	bge     $s2, $s3, return        # when $s2 >= $s3 = n-1, go to return
        #Find local minimum
        move    $a0, $s0                # $a0 = list
        move    $a1, $s2                # $a1 = length
        move    $a2, $s3                # $a2 = length - 1
        jal     Minimum                 # Call Minimum function
        move    $s4, $v0                # $s4 = j

        # swap array[i] and array[j]
        move    $a0, $s0                # array
        move    $a1, $s2                # a1 = i
        move    $a2, $s4                # a2 = subscropt returned
        jal     swap                    # calls swap function
        addi    $s2, $s2, 1             # i++
        j       loop			# jump to loop
return:
	lw      $ra, 20($sp)            #return address
        lw      $s0, 16($sp)            
        lw      $s1, 12($sp)           
        lw      $s2,  8($sp)            
        lw      $s3,  4($sp)            
        lw      $s4,  0($sp)           
        addi    $sp, $sp, 24            # Adjust stack ptr
        jr      $ra                     
        
Minimum:
        move    $t0, $a1                # array[begin] = current minimum
        sll     $t3, $t0, 2 
        addu    $t3, $t3, $a0           # set t3 as address
        lw      $t5, 0($t3)             # t5 = current minimum
        addi    $t1, $a1, 1             # t1 = loop variable
MinLoop:  
	bgt     $t1, $a2, done        	# When k = $t1 > $a2 = last, go to done
        sll     $t2, $t1, 2             # $t1 counts ints, $t2 counts bytes
        addu    $t2, $a0, $t2           # $t2 is address of list[k]
        lw      $t4, 0($t2)             # $t4 = list[k]
        bge     $t4, $t5, Moveon        # Go to Moveon if $t4 >= $t5
        move    $t0, $t1                # Move Min to $t0, $t1 = k
        move    $t5, $t4                # Move Min to $t5

Moveon:
	addi    $t1, $t1, 1             #k++
        j       MinLoop

done: 
	move    $v0, $t0                 # v0 = minimum
        jr      $ra                     	
swap:
        #move array[i] to $t1
        sll     $t0, $a1, 2             # $a1 counts ints, $t0 bytes
        add     $t0, $a0, $t0           # $t0 = array[i] address
        lw      $t1, 0($t0)             # $t1 = array[i]

        #move array[j] to $t3
        sll     $t2, $a2, 2
        add     $t2, $a0, $t2           # $t2 is address of array[j]
        lw      $t3, 0($t2)             # $t3 is array[j]

        # Store $t1 in array[j] and $t3 in array[i]
        sw      $t1, 0($t2)             # Store array[i] to array[j]
        sw      $t3, 0($t0)             # Store array[j] to array[i]

        jr      $ra	

printlist:
        addi    $sp, $sp, -4            # space for return address
        sw      $ra, 0($sp)             # save return address
        move    $t2, $a0                # a0 for syscall
        move    $t0, $zero              # $t0 = 0
plist:
	bge     $t0, $a1, print         # when i = $t0 >= $a1 = length
        sll     $t1, $t0, 2
        add     $t1, $t2, $t1           # $t1 = array + i
        lw      $a0, 0($t1)             # a0 = print value
        li      $v0, 1                  # print an int
        syscall

        # Print a space 
        la      $a0, comma              # a0 = comma
        li      $v0, 4                  # Code for print string
        syscall

        addi    $t0, $t0, 1            # i++
        j       plist                  # jump to plist
print: 
        lw      $ra, 0($sp)             # retrieve return address
        addi    $sp, $sp 4              # adjust stack pointer
        jr      $ra                     # return						
