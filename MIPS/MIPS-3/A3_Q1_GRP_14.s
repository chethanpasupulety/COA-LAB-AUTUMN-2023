#GROUP NO:14
#ASSIGNMENT 3
#Question No 1
#NAMES: Pasupulety Chethan Krishna Venkat(21CS30036)
#      :Vikhyath Gummadi (21CS10028)
#Autumn 2023

.data


array:
 .space 100

enter_number:
 .asciiz "Input : N = "

enter_array:
 .asciiz "Enter the elements of the array: "



output:
 .asciiz "Output : "

newline:
 .asciiz "\n"   



 .text
 .globl main


 # $s0=n                                    $s0 contains n throughout the program 
 # $s1=array[0]                             $s1 contains address of &array[0] throughout the program

main:

    la $a0,enter_number                     #loads $a0 with the address of enter_number
    li $v0,4                                #prints the string
    syscall

    li $v0,5                                #reads first integer
    syscall
    move $s0, $v0                           # Value n is stored in $s0

    la $a0,newline                          #loads $a0 with the address of newline
    li $v0,4                                #prints the string
    syscall

    
    la $a0,enter_array                      #loads $a0 with the address of enter_number
    li $v0,4                                #prints the string
    syscall

    add $t0,$zero,$zero                     # $t0=i iterator for the for loop
    la $s1,array                            # Loading the address of array to $s1.$s1=&arr[0]

    move $t1,$zero                          # t1 used for calculating 4*i
    

    loop:
        beq   $t0, $s0, target                   # if  i ==n then goto target and break the loop
        
        li $v0,5                                 #reading the array integers using system calls
        syscall 
        
        move $t3, $v0                            # Value arr[i] is stored in $t3
        sll $t1,$t0,2                            # $t1=4*i
        add $t4,$s1,$t1                          # $t4=&arr[i]
        sw $t3,0($t4)                            # saving input to arr[i]
        addi $t0,$t0,1                           # i=i+1
        
        j loop                                   # jump back to the start of the loop.
    
    target:                                     #input taking finished                    

        add $a0,$s1,$zero                       # a0 is the first argument a0=&arr[0]
        add $a1,$s0,$zero                       # a1 is the second argument a1=n


        addi $t7,$zero,1                        # t7=1 used for checking corner case when n=1
       
        beq $s0,$t7,exit1                       # if n==1 print only that element jump to exit1

        jal max_circular_sum                    # calling the max_circular_sum funtion.
        move $t0,$v0

        
        la $a0,output                           #loads $a0 with the address of output
        li $v0,4                                #prints the string
        syscall

    
        move $a0,$t0                            #copies value of the sum in t0 to a0
        li   $v0,1                              #prints the integer
        syscall

        la $a0,newline      
        li $v0,4                                    #prints the string
        syscall

        j exit                                  # jump to exit

        
        exit1:                                  # if n==1 print arr[0] only



            la $a0,output                       #loads $a0 with the address of output
            li $v0,4                            #prints the string
            syscall
                
                
            lw $a0,0($s1)                       # loading a0=arr[0]
    
      
            li   $v0,1                          #prints the integer
            syscall

             la $a0,newline      
             li $v0,4                                    #prints the string
             syscall
            
            j exit

        exit:


                li $v0,10                        #exit the program
                syscall



######################## int max_circular_sum(int arr[],int n) function #########


max_circular_sum :
    move $s7,$a0         # s7=arr[0]
    move $t5,$a1         # t5=n
    lw $s2,0($s7)        # $s2=maximum before including
    lw $s3,0($s7)        # $s3= min before including
    lw $s4,0($s7)        # maximum_so_far after including new element
    lw $s5,0($s7)        # minimum_so_far after including new element
    lw $s6,0($s7)        # total_sum

    li $t0,1             #i=1
    loop2:
        beq $t0,$t5,target2                         # if (i==n) for loop completes jump to target2
    
        addi $s7,$s7,4
        lw $t1,0($s7)           # t1=arr[i]
        addi $t0,$t0,1         
        add $s6,$s6,$t1         # sum=sum+arr[i]

        #current max = max of (max+a[i],a[i])
        cur_max:
        add $t2,$s2,$t1
        bgt $t1,$t2,else1
        move $s2,$t2
        j max_so_far
        else1:
            move $s2,$t1
            j max_so_far

        #max_so_far = max of (max_so_far,max)
        max_so_far:
        bgt $s4,$s2,else2
        move $s4,$s2
        j cur_min
        else2:
            move $s4,$s4
            j cur_min

        #cur_min = min of (curr_min+a[i],a[i])    
        cur_min:
        add $t3,$s3,$t1
        blt $t1,$t3,else3
        move $s3,$t3
        j min_so_far
        else3:
            move $s3,$t1
            j min_so_far

        #min_so_far = min of (min_so_far,curr_min)
        min_so_far:
        blt $s5,$s3,else4
        move $s5,$s3
        j end
        else4:
            move $s5,$s5
            j end

        end:
        j loop2

target2:                                              # for loop finished                                   

    beq $s5,$s6,target3                               # if sum==min_subarray sum print max_subarray sum
   
    sub $t4,$s6,$s5                                   #store diff of sum and min_so_far
   
    bgt $s4,$t4,else5                                 #output the max of max_so_far and diff
    
    move $v0,$t4                                      # moving result in $v0
    j end1
    else5:
        move $v0,$s4                                  # moving result in $v0                  
        j end1
    end1:
    jr $ra    


   
   
    target3:                                        # printing max_subarray sum
        la $a0,newline      
        li $v0,4                                    #prints the string
        syscall

        la $a0,output                                #loads $a0 with the address of output
        li $v0,4                                     #prints the string
        syscall

        move $v0,$s4                                # moving result in $v0 
        jr $ra                                      # returning from the funtion call






