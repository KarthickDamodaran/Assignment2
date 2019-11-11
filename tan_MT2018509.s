     AREA     appcode, CODE, READONLY
     EXPORT __main
     ENTRY
;Input is in radian given in s3 register. Number of Series terms in s6 register. Tangent of input is available in s14	 
__main  FUNCTION	
     VLDR.F32 s6,=30;Number of series terms required
	 VLDR.F32 s5,=1
	 VLDR.F32 s8,=0
	 VLDR.F32 s9,=0
	 VLDR.F32 s11,=0
	 MOV r5,#1
	 MOV r6,#0
	 MOV r7,#0
	 MOV r8,#0
sign VLDR.F32 s7,=1
     VMOV.F32 s10,s8
loop VCMP.F32 s8, #0
     vmrs    APSR_nzcv, FPSCR
     BEQ next
     VMUL.F32 s7,s8,s7
     VSUB.F32 s8,s8,s5
     B loop
	 
next VMOV.F32 s8,s10
     VLDR.F32 s3,=6.283185307;Number for which tan x is to be calculated i.e x input in radian
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
	 
new  AND r4,r6,#1
	 CMP r4,r5
	 BEQ sin
	 AND r10,r7,#1
	 CMP r10,r5
     BEQ oddcos
     VDIV.F32 s4,s4,s7
     VADD.F32 s9,s4,s9
	 ADD r7,r7,r5
com	 VMOV.F32 s8,s10
	 VADD.F32 s8,s8,s5
	 ADD r6,r6,r5
	 VCMP.F32 s8,s6
	 vmrs    APSR_nzcv, FPSCR
	 BLT sign
	 
stop VDIV.F32 s14,s11,s9
here B here

sin	 AND r10,r8,#1
     CMP r10,r5
     BEQ oddsin
     VDIV.F32 s4,s4,s7
     VADD.F32 s11,s4,s11
	 ADD r8,r8,r5
	 B com
	 
oddsin VDIV.F32 s4,s4,s7
       VSUB.F32 s11,s11,s4
	   ADD r8,r8,r5
	   B com
	   
oddcos VDIV.F32 s4,s4,s7
       VSUB.F32 s9,s9,s4
	   ADD r7,r7,r5
	   B com	   
	   
     ENDFUNC
     END 