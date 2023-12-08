#GROUP NO:14
#ASSIGNMENT 1
#Question No 1
#NAMES: Pasupulety Chethan Krishna Venkat(21CS30036)
#      :Vikhyath Gummadi (21CS10028)
#Autumn 2023

.data

prompt:
 .asciiz "Enter integer x: "

sum_msg:
 .asciiz "The value of e^x is: "
newline:
 .asciiz "\n"

iterations:
 .asciiz "The number of iterations  is: "

###########Code Segment#####################
 .text
 .globl main

 main:
    la $a0,prompt        #loads $a0 with the address of “prompt”
    li $v0,4             #prints the string
    syscall

    li $v0,5             #reads first integer
    syscall
    move $s0, $v0        # x stored in $s0

    li $t0,1              #t0 contains i
    li $t1,1              #t1 contains the sum
    li $t2,1              #t2 contains x^i-1
    li $t3,1              #t3 contains factorial (i-1)!
    

loop:
    mul	    $t2,$s0,$t2     # t2=t2*x ; t2 contains x^i
    mul     $t3,$t0,$t3     # t3=t3*i ; t3 contains i!
    addi	$t0, $t0, 1		# $t0 = $t0 + 1; t0 contains i

    div  $t2,$t3            #dividing x^i by i!
    mflo $t4                #copying the quotient to t4


    beq $t4,$zero,endl      #checking if quotient ==0 to end the loop
    add $t1,$t1,$t4         #adding the quotient to the sum
    j loop                  #continuing the loop

endl:

    la $a0,sum_msg          #loads $a0 with the address of “sum_msg”
    li $v0,4                #prints the string
    syscall

    move $a0,$t1            #copies value of the sum in t0 to a0
    li   $v0,1              #prints the integer
    syscall

    la $a0,newline          #loads $a0 with the address of “newline”
    li $v0,4                #prints the string
    syscall


    la $a0,iterations       #loads $a0 with the address of “iterations”
    li $v0,4                #prints the string
    syscall

    addi $t0,$t0,-1         #calculating the number of iterations
    move $a0,$t0            #copies value from t0 to a0 to print the iterations
    li   $v0,1
    syscall

    
    la $a0,newline          #loads $a0 with the address of “newline”
    li $v0,4                #prints the string
    syscall



li $v0,10                   #exit
syscall

