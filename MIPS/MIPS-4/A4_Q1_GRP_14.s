#GROUP NO:14
#ASSIGNMENT 4
#Question No 1
#NAMES: Pasupulety Chethan Krishna Venkat(21CS30036)
#      :Vikhyath Gummadi (21CS10028)
#Autumn 2023


.data

invalid_input:
     .asciiz "Invalid input. Enter n>0 "

enter_number:
 .asciiz "Input : N = "

output:
 .asciiz "Output : "

newline:
 .asciiz "\n"   


.text
 .globl main


# $s0 stores n

main:

    la $a0,enter_number                     #loads $a0 with the address of enter_number
    li $v0,4                                #prints the string
    syscall

    li $v0,5                                #reads first integer
    syscall

    bgt $v0,$zero,program_starts            # sanity check for n>0

    
    la $a0,invalid_input                    #loads $a0 with the address of enter_number
    li $v0,4                                #prints the string
    syscall

    la $a0,newline                          #loads $a0 with the address of newline
    li $v0,4                                #prints the string
    syscall

    j main


program_starts:

    move $s0, $v0                           # Value n is stored in $s0

    la $a0,newline                          #loads $a0 with the address of newline
    li $v0,4                                #prints the string
    syscall


    add $a0,$s0,$zero                       # passing n as argument to the function call
    
    jal sum_series

    move $t0,$v0                            # moving the returned value to print

    
    la $a0,output                           #loads $a0 with the address of output
    li $v0,4                                #prints the string
    syscall

    move $a0,$t0                            #copies value of the sum in t0 to a0
    li   $v0,1                              #prints the integer
    syscall

    la $a0,newline                          
    li $v0,4                                    
    syscall

    
    li $v0,10                                #exit the program
    syscall



sum_series:
    addi $sp,$sp,-8
    sw   $ra,4($sp)
    sw   $a0,0($sp)

    slti $t0,$a0,2
    beq  $t0,$zero,recurse

    addi $v0,$zero,1                          # if (n<2) return 1
    lw   $a0,0($sp)                           # getting n back
    lw   $ra,4($sp)                           # getting the return address back
    addi $sp,$sp,8                            # popping items in the stack as they are of no use for base condition
    jr   $ra

recurse:
    addi $a0,$a0,-1                           # calling sum_series(n-1)
    jal  sum_series

    move $t5,$v0

    lw   $a0,0($sp)                           # getting the value of n
    lw   $ra,4($sp)                           # getting the return address back
    addi $sp,$sp,8                            # popping the stack

    addi $t0,$zero,1                          # t0=1
    move $t1,$zero                            # t1=i iterator

loop:                                         # loop for calculating n^n to add to f(n-1)
    beq $t1,$a0,end
    mul $t0,$a0,$t0                           # t0=n*t0
    addi $t1,$t1,1                            # i=i+1
    j loop

end:
    add $v0,$t0,$t5                           # returning n^n+ sum_series(n-1)
    jr $ra




