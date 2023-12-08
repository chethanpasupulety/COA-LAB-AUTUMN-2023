#GROUP NO:14
#ASSIGNMENT 1
#Question No 1
#NAMES: Pasupulety Chethan Krishna Venkat(21CS30036)
#      :Vikhyath Gummadi (21CS10028)
#Autumn 2023

.data

enter_no_cycles:
 .asciiz "Enter number of cycles in permutation: "

enter_cycle_size:
 .asciiz "Enter the cycle size: "

enter_cycle_numbers:
    .asciiz "Enter the cycle numbers: "



newline:
 .asciiz "\n"



f:                                       #storing 1st input in f
.word 0,1,2,3,4,5,6,7,8,9

g:                                        #storing 2nd input in g
.word 0,1,2,3,4,5,6,7,8,9

h:                                        #storing final answer  in h
.word 0,1,2,3,4,5,6,7,8,9

cycle :                                     #storing intermediate cycle arrays in cycle
.word -1,-1,-1,-1,-1,-1,-1,-1,-1,-1




# iterations:
#  .asciiz "The number of iterations  is: "

###########Code Segment#####################
 .text
 .globl main

main:

    la $a0,enter_no_cycles       #loads $a0 with the address of “prompt”
    li $v0,4             #prints the string
    syscall

    li $v0,5             #reads first integer
    syscall
    move $s0, $v0        # cycles1 stored in $s0





    
    
     # loads t0 to 0
    li $t1,10
    li $t2,0



li $t3,0

loop_cycle:
    beq $s0,$t3,end_loop_cycle  #running the loop no_cycles times

    la $a0,enter_cycle_size    #loads $a0 with the address of “enter_cycle_size”
    li $v0,4             #prints the string
    syscall

    li $v0,5             #reads first integer
    syscall
    move $t0, $v0        # number of elements in the cycle  $t0

    la $a0,enter_cycle_numbers    #loads $a0 with the address of “enter_cycle_numbers ”
    li $v0,4             #prints the string
    syscall





    li $t1,0
    la $t5,cycle

    #loop4 is used to take input from the user and store it in the cycle array

    loop4:
        beq $t0,$t1,endl4
        
        
        li $v0,5             #reads first integer
        syscall
        move $t2, $v0       # number moved to $t2


        sw $t2,($t5)        #storing input read to temp cycle array
        addi $t5,$t5,4      #moving to the next address(4 bytes)
        addi $t1,$t1,1      #iterator increased
        j loop4

    endl4:



    la $t4,f
    la $t5,cycle  
    addi $t6,$t5,4

    #taking input from temp cycle array  to reconstruct f from its cycle form

    loop5:

        lw $t0,($t6)  #loads value from address of t6

      





        beq $t0,-1,end5  #if -1 is encountered the cycle is completed
        lw $t7,($t5)    #loads word from t5 to t7

        #calculating the position to be stored in f array
        mul $t7,$t7,4   
        add $t8,$t4,$t7

        #storing the number in f array
        sw $t6,($t8)
        addi $t5,$t5,4
        addi $t6,$t6,4
        j loop5

        
    end5:
        la $t1,cycle
        mul $t7,$t5,4
        add $t8,$t4,$t7
        sw $t1,($t8)


    #reinnitializing temp cycle array
    jal cycle_init




    addi $t3,$t3,1 #adding iteraro

    j loop_cycle

end_loop_cycle:

jal print1




    
#print fn for an array
print1:
    la $t0,f

    li $t1,0

    loop6:
        beq $t1,10,endl6
        lw $t2,($t0)

        move $a0,$t2           #copies value of the sum in t0 to a0
        li   $v0,1              #prints the integer
        syscall
        addi $t0,$t0,4
        addi $t1,$t1,1
        j loop6

    endl6:
jr $ra





#reinitialize funtion for cycle array    
cycle_init:
    li $t5,-1
    li $t1,10
    li $t2,0

    loop100:
    beq $t2,$t1,end_init
    
    
    sw  $t5,($t6)
    
    addi $t2,$t2,1
    
    addi $t6,$t6,4

    j loop100


    end_init:
jr $ra




li $v0,10                   #exit
syscall

