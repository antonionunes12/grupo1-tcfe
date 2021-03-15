pkg load symbolic
format long

%{
syms G1;
syms G2;
syms G3;
syms G4;
syms G5;
syms G6;
syms G7;
syms Va;
syms Id;
syms Kb;
syms Kc;
%}

 R1=(1.03504497262*1000);
 R2=(2.01159104669*1000);
 R3=(3.03557466091*1000);
 R4=(4.10235086526*1000);
 R5=(3.09889833746*1000);
 R6=(2.00952426524*1000);
 R7=(1.04158528578*1000);
 Va=5.22552047598;
 Id=1.04791133328/1000;
 Kb=7.3172497028/1000;
 Kc=8.09359354837*1000;

 G1=1/R1;
 G2=1/R2;
 G3=1/R3;
 G4=1/R4;
 G5=1/R5;
 G6=1/R6;
 G7=1/R7;

A=[[1 0 0 0 0 0 0];
   [0 0 0 1 0 Kc*G6 -1]; [G1 -G1-G2-G3 G2 G3 0 0 0];
   [0 Kb+G2 -G2 -Kb 0 0 0]; [0 -Kb 0 G5+Kb -G5 0 0];
   [0 0 0 0 0 -G6-G7 G7]; [0 G3 0 -G4-G5-G3 G5 G7 -G7]];
   
B=[Va; 0; 0; 0; -Id; 0; Id];

C=A\B;

disp("Nodes");
disp(C);

disp("Currents");
I1=(C(1)-C(2))*G1;
I2=(C(3)-C(2))*G2;
I3=(-C(6))*G6;
disp(I1);
disp(I2);
disp(I3);

