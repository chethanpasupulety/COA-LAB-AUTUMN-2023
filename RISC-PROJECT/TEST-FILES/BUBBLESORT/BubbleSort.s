/* Instructions According to the given RISC architecture*/

ADDI  R1, R0, #100;	// arr[0]
MOVE  R2, R0;      	// i=0
MOVE  R3, R0;      	// j=0
ADDI  R4, R0, #10; 	// n=10
ADDI  R5, R0, #10; 	// n-i for inner loop
MOVE  R6, R1;      	// for iterating addr by i
MOVE  R7, R1;      	// for iterating addr by j
SUBI  R4, R4, #1;
MOVE  R3, R0;      	// outer_loop // j=0           	(X)
SUBI  R5, R5, #1;  	// decreasing size for inner_loop
ADD   R7, R0, R1;  	// resetting addr itr j
LD	R8, 0(R7);   	// inner_loop // arr[j]        	(Z)
ADDI  R7, R7, #1;  	// addr itr j += 1
LD	R9, 0(R7);   	// arr[j+1]
ADDI  R3, R3, #1;  	// j++
SUB   R10, R8, R9; 	// R10 = R8 - R9;
BMI   R10, #3;     	// if R8 < R9 then Branch      	(Y)
ST	R8, 0(R7);   	// swap
ST	R9, -1(R7);
LD	R9, 0(R7);
SUB   R11, R3, R5;                                    	(Y)
BZ	R11, #1;     	// Exiting from inner_loop     	(W)
BR	#-12;        	// Address to inner_loop       	(Z)
ADDI  R2, R2, #1;  	// After  Exiting From inner_loop  (W)
SUB   R12,R2, R4;  	// i!=n
BZ	R12, #1;     	// Program Completed           	(EXIT)
BR	#-19;        	// outer_loop                  	(X)
HLT;                                                  	(EXIT)

