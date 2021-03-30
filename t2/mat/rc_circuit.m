R1 = 1.03504497262 ;
R2 = 2.01159104669 ;
R3 = 3.03557466091 ;
R4 = 4.10235086526 ;
R5 = 3.09889833746 ;
R6 = 2.00952426524 ;
R7 = 1.04158528578 ;
Vs = 5.22552047598 ;
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
 
 
 
 A=[[0 0 0 1 0 0 0 0];[1 0 0 -1 0 0 0 0];[0 0 0 -Kd*G6 1 0 Kd*G6 -1];
    [G1 -G1-G2-G3 G2 0 G3 0 0 0];[0 G2+Kb -G2 0 -Kb 0 0 0];
    [0 -Kb 0 0 G5+Kb -G5 0 0];[0 0 0 G6 0 0 -G6-G7 G7];
    [0 G3 0 G4 -G3-G4-G5 G5 G7 -G7]];
    
 B=[0;Vs;0;0;0;0;0;0];
 
 C=A\B;
 
for n=1:size(C,1)
  string=strcat("V",num2str(n),"\t&\t",num2str(C(n,1),'%.6f'),"\\","\\"," \\hline");
  disp(string);
end

IR1=G1*(C(1)-C(2))*1000;
string=strcat("@IR1","\t&\t",num2str(IR1,'%.6f'),"\\","\\"," \\hline");
disp(string);
  
IR2=G2*(C(3)-C(2))*1000;
string=strcat("@IR2","\t&\t",num2str(IR2,'%.6f'),"\\","\\"," \\hline");
disp(string);

IR3=G3*(C(2)-C(5))*1000;
string=strcat("@IR3","\t&\t",num2str(IR3,'%.6f'),"\\","\\"," \\hline");
disp(string);

IR4=G4*(C(5)-C(4))*1000;
string=strcat("@IR4","\t&\t",num2str(IR4,'%.6f'),"\\","\\"," \\hline");
disp(string);

IR5=G5*(C(5)-C(6))*1000;
string=strcat("@IR5","\t&\t",num2str(IR5,'%.6f'),"\\","\\"," \\hline");
disp(string);

IR6=G6*(C(4)-C(7))*1000;
string=strcat("@IR6","\t&\t",num2str(IR6,'%.6f'),"\\","\\"," \\hline");
disp(string);

IR7=G7*(C(7)-C(8))*1000;
string=strcat("@IR7","\t&\t",num2str(IR7,'%.6f'),"\\","\\"," \\hline");
disp(string);

Ib=Kb*(C(2)-C(5))*1000;
string=strcat("@Ib","\t&\t",num2str(Ib,'%.6f'),"\\","\\"," \\hline");
disp(string);

IVs=IR1;
string=strcat("@IVs","\t&\t",num2str(IVs,'%.6f'),"\\","\\"," \\hline");
disp(string);

IVd=IR7;
string=strcat("@IVd","\t&\t",num2str(IVd,'%.6f'),"\\","\\"," \\hline");
disp(string);
