R1 = 1.03504497262 ;
R2 = 2.01159104669 ;
R3 = 3.03557466091 ;
R4 = 4.10235086526 ;
R5 = 3.09889833746 ;
R6 = 2.00952426524 ;
R7 = 1.04158528578 ;
Vs = 0 ;
Vx = 8.801255 ;
C = 1.04791133328 ;
Kb = 7.3172497028 ;
Kd = 8.09359354837 ;

pkg load symbolic
format long

 R1=R1*1000;
 R2=R2*1000;
 R3=R3*1000;
 R4=R4*1000;
 R5=R5*1000;
 R6=R6*1000;
 R7=R7*1000;
 C=C/1000000;
 Kb=Kb/1000;
 Kd=Kd*1000;

 G1=1/R1;
 G2=1/R2;
 G3=1/R3;
 G4=1/R4;
 G5=1/R5;
 G6=1/R6;
 G7=1/R7;
 
 
 
A=[[0 0 0 1 0 0 0 0];[1 0 0 0 0 0 0 0];[0 0 0 -Kd*G6 1 0 Kd*G6 -1];
   [G1 -G1-G2-G3 G2 0 G3 0 0 0];[0 G2+Kb -G2 0 -Kb 0 0 0];
   [0 G3-Kb 0 G4 -G3-G4+Kb 0 G7 -G7];[0 0 0 G6 0 0 -G6-G7 G7];
   [0 0 0 0 0 1 0 -1]];
    
B=[0;0;0;0;0;0;0;Vx];
 
C=A\B;
 
Ix=(C(6)-C(5))*G5 + Kb*(C(2)-C(5));

Req=Vx/Ix;

string=strcat("Vx","\t&\t",num2str(Vx,'%.6f')," V "," \\","\\"," \\hline");
disp(string);
string=strcat("Ix","\t&\t",num2str(Ix,'%.6f')," A "," \\","\\"," \\hline");
disp(string);
string=strcat("Req","\t&\t",num2str(Req,'%.6f')," Ohms "," \\","\\"," \\hline");
disp(string);




