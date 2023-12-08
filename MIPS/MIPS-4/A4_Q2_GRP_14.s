#GROUP NO:14
#ASSIGNMENT 4
#Question No 2
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
    
    jal collatz_calc

    move $t0,$v0                            # moving the returned value to print

    
    la $a0,output                           #loads $a0 with the address of output
    li $v0,4                                #prints the string
    syscall

    move $a0,$t0                            #copies value of the sum in t0 to a0
    li   $v0,1                              #prints the integer
    syscall

    la $a0,newline                          # printing the newline            
    li $v0,4                                    
    syscall

    
    li $v0,10                                #exit the program
    syscall



collatz_calc:
    addi $sp,$sp,-8                             #storing values to the stack
    sw   $ra,4($sp)                             # storing the return address
    sw   $a0,0($sp)                             # storing the value n for future recursive calls

    slti $t0,$a0,2                              # if n>1 jump to recurse
    beq  $t0,$zero,recurse

    add $v0,$zero,$zero                        # if (n<2) return 0
    lw   $a0,0($sp)                           # getting n back
    lw   $ra,4($sp)                           # getting the return address back
    addi $sp,$sp,8                            # popping items in the stack as they are of no use for base condition
    jr   $ra

recurse:
    li $t0, 2           # Load 2 into $t0
    div $a0, $t0        # Divide n by 2
    mfhi $t1            # Remainder in $t1

    bnez $t1, odd_case   # If remainder != 0, go to odd_case
    j even_case          # else jump to even_case


even_case:              # calculating f(n/2)+1
    
    li $t5,2            # calculating a0=n/2
    div $a0,$t5
    mflo $a0

    
    jal collatz_calc    # calling f(n/2)
    
    lw $a0,0($sp)       # getting previous n
    lw $ra,4($sp)       # getting previous return address
    addi $sp,$sp,8      # popping the stack back

    addi $v0,$v0,1      # returning f(n/2)+1
    jr $ra


odd_case:               # calling f(3*n+1)

    li $t6,3            # calculating a0=3*n+1 and passing it as new argument
    mul $a0,$a0,$t6
    add $a0,$a0,1

    jal collatz_calc    # calling f(3*n+1)

    lw $a0,0($sp)       # getting previous n
    lw $ra,4($sp)       # getting previous return address
    addi $sp,$sp,8      # popping the stack back

    addi $v0,$v0,1     # returning f(3*n+1)+1
    jr $ra



    




