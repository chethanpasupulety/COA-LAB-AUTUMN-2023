# GCD of 39 and 52

ADDI R1, R0, #39;
ADDI R2, R0, #52;
ST   R1, 0(R0);
ST   R2, 1(R0);
SUB  R3, R1, R2;         	
BMI  R3, #3; 	// if R1<R2 (X)
BPL  R3, #6; 	// if R1>R2 (Y)
BZ   R3, #8; 	// if R1=R2 (Z)
HLT;
SUB  R3, R2, R1; // if R1<R2 
MOVE R2, R3;
BR   #-8;                	(W)
HLT;
MOVE R1, R3; 	// if R1>R2 (Y)
BR   #-11;               	(W)
HLT;
ST   R1, 2(R0);  // if R1=R2 (Z)
HLT;

