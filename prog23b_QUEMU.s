/*** Using LEN and STRIDE to sum vectors ***/
	.global	main
	.func main
main:
/*	SUB SP, SP, #24	@ room for printf */
	LDR R8,=value1	@ Get addr of values
	LDR R9,=value2
	LDR R6,=value3
	MOV R10,#3
ciclo:
	VLDR S16, [R8]		@ load values into
	VLDR S17, [R8,#4]		@ registers
	VLDR S18, [R8,#8]
	VLDR S19, [R8,#12]
	VLDR S24, [R9]
	VLDR S25, [R9,#4]
	VLDR S26, [R9,#8]
	VLDR S27, [R9,#12]
lenstride:
@@LEN=4, STRIDE=1
	VMRS R3, FPSCR		@ get current FPSCR
	MOV R4,  #0b000011	@ bit pattern
	MOV R4, R4, LSL #16	@ move across to b21
	ORR R3, R3, R4		@ keep all 1's
	VMSR FPSCR, R3		@ transfer to FPSCR  
	
	VSQRT.F32 S16, S16	@ Vector addition in parallel
	VSQRT.F32 S24, S24	@ Vector addition in parallel

	VADD.F32 S8, S16, S24	@ Vector addition in parallel

	VSTR S8, [R6]
	VSTR S9, [R6,#4]
	VSTR S10, [R6,#8]
	VSTR S11, [R6,#12]

	
	
	ADD R6,#16
	ADD R8,#16
	ADD R9,#16
	SUBS R10,#1
	BNE  ciclo

convert_and_print:
/* Do conversion for printing, making sure not */
/* to corrupt Sx registers by over writing */
	MOV R10,#12
	LDR R6,add_value3
imprimir:
	VLDR S8,[R6]
	VCVT.F64.F32 D0, S8
	LDR R0,=formatoF		@ set up for printf
	VMOV R2, R3, D0
		BL printf
	ADD R6,#4
	SUBS R10,#1
	BNE imprimir 
_exit:
	MOV R0, #0
	MOV R7, #1
	SWI 0

add_value3: .word value3

	.data
value1:	.float 1.0, 4.0, 9.0, 16.0, 25.0, 36.0, 49.0, 64.0, 81.0, 100.0, 121.0, 144.0
value2:	.float 1.0, 4.0, 9.0, 16.0, 25.0, 36.0, 49.0, 64.0, 81.0, 100.0, 121.0, 144.0
value3:	.float 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0

string:
.asciz " S8 is %f\n S10 is %f\n S12 is %f\n S14 is %f\n"

formatoF:
.asciz  "Valor %f\n"

