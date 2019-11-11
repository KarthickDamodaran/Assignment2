     AREA     appcode, CODE, READONLY
     EXPORT __main
     ENTRY
;Input is given in s3 register. Number of Series terms in s6 register. Exponent of input is available in s9
__main  FUNCTION	
     VLDR.F32 s6,=10;Number of series terms required
	 VLDR.F32 s5,=1
	 VLDR.F32 s8,=0
	 VLDR.F32 s9,=0
sign VLDR.F32 s7,=1
     VMOV.F32 s10,s8
loop VCMP.F32 s8, #0
     vmrs    APSR_nzcv, FPSCR
     BEQ next
     VMUL.F32 s7,s8,s7
     VSUB.F32 s8,s8,s5
     B loop
	 
next VMOV.F32 s8,s10
     VLDR.F32 s3,=15;Number for which e^x is to be calculated i.e x
	 VLDR.F32 s5,=1
	 VLDR.F32 s4,=1
	 VCMP.F32 s8,#0
	 vmrs    APSR_nzcv, FPSCR
	 BEQ new
	 
term VMUL.F32 s4,s4,s3;
     VSUB.F32 s8,s8,s5
	 VCMP.F32 s8,#0
	 vmrs    APSR_nzcv, FPSCR
	 BGT term
	 
new  VDIV.F32 s4,s4,s7
     VADD.F32 s9,s4,s9
	 VMOV.F32 s8,s10
	 VADD.F32 s8,s8,s5
	 VCMP.F32 s8,s6
	 vmrs    APSR_nzcv, FPSCR
	 BLT sign
	 
stop B stop	 
     ENDFUNC
     END 