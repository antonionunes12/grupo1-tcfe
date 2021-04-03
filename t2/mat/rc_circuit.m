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
 
 V=A\B;
 
 f_node_analysis=fopen('node_analysis_init_del.tex', 'w');
 
for n=1:size(V,1)
  string=strcat("V",num2str(n),"\t&\t",num2str(V(n,1),'%.6f'),'\\','\\','\\',"hline\n");
  fprintf(f_node_analysis,string);
end

IR1=G1*(V(1)-V(2))*1000;
string=strcat("@IR1","\t&\t",num2str(IR1,'%.6f'),'\\','\\','\\',"hline\n");
fprintf(f_node_analysis,string);
  
IR2=G2*(V(3)-V(2))*1000;
string=strcat("@IR2","\t&\t",num2str(IR2,'%.6f'),'\\','\\','\\',"hline\n");
fprintf(f_node_analysis,string);

IR3=G3*(V(2)-V(5))*1000;
string=strcat("@IR3","\t&\t",num2str(IR3,'%.6f'),'\\','\\','\\',"hline\n");
fprintf(f_node_analysis,string);

IR4=G4*(V(5)-V(4))*1000;
string=strcat("@IR4","\t&\t",num2str(IR4,'%.6f'),'\\','\\','\\',"hline\n");
fprintf(f_node_analysis,string);

IR5=G5*(V(5)-V(6))*1000;
string=strcat("@IR5","\t&\t",num2str(IR5,'%.6f'),'\\','\\','\\',"hline\n");
fprintf(f_node_analysis,string);

IR6=G6*(V(4)-V(7))*1000;
string=strcat("@IR6","\t&\t",num2str(IR6,'%.6f'),'\\','\\','\\',"hline\n");
fprintf(f_node_analysis,string);

IR7=G7*(V(7)-V(8))*1000;
string=strcat("@IR7","\t&\t",num2str(IR7,'%.6f'),'\\','\\','\\',"hline\n");
fprintf(f_node_analysis,string);

Ib=Kb*(V(2)-V(5))*1000;
string=strcat("@Ib","\t&\t",num2str(Ib,'%.6f'),'\\','\\','\\',"hline\n");
fprintf(f_node_analysis,string);

IVs=IR1;
string=strcat("@IVs","\t&\t",num2str(IVs,'%.6f'),'\\','\\','\\',"hline\n");
fprintf(f_node_analysis,string);

IVd=IR7;
string=strcat("@IVd","\t&\t",num2str(IVd,'%.6f'),'\\','\\','\\',"hline\n");
fprintf(f_node_analysis,string);

fclose(f_node_analysis);

f_req=fopen('req_del.tex', 'w');

B=[0;0;0;0;0;-1;0;1];

D=A\B;

Req=D(6)-D(8);

string=strcat("Vx","\t&\t",num2str(D(6)-D(8),'%.6f'),'\\','\\','\\',"hline\n");
fprintf(f_req,string);
string=strcat("Ix","\t&\t",num2str(1,'%.6f'),'\\','\\','\\',"hline\n");
fprintf(f_req,string);
string=strcat("Req","\t&\t",num2str(Req,'%.6f'),'\\','\\','\\',"hline\n");
fprintf(f_req,string);

fclose(f_req);

%Time Constant (T=1/(RC))
K = (Req*C);

t=[0:0.00005:0.02];

nat_sol=(V(6)-V(8))*exp(-t/K);

fig=figure();
plot(t,nat_sol, 'color', 'red');
xlabel("t (Time) [s]");
ylabel("Voltage at V6 [V]");
title("Natural Solution");
grid on;
print (fig, "natural_solution.eps", "-depsc");

%|---------------------------|Forced Node Analysis|---------------------------|%

f_forced_nodal= fopen('forced_amplitudes_del.tex','w');

w=2000*pi;
 
Yc=(j*w*C);
vs=1;
 
A=[[0 0 0 1 0 0 0 0];[1 0 0 -1 0 0 0 0];[0 0 0 -Kd*G6 1 0 Kd*G6 -1];
    [G1 -G1-G2-G3 G2 0 G3 0 0 0];[0 G2+Kb -G2 0 -Kb 0 0 0];
    [0 -Kb 0 0 G5+Kb -G5-Yc 0 Yc];[0 0 0 G6 0 0 -G6-G7 G7];
    [0 G3 0 G4 -G3-G4-G5 G5+Yc G7 -G7-Yc]];
    
B=[0;vs;0;0;0;0;0;0];
 
F=A\B;
for n=1:size(F,1)
  string=strcat("V",num2str(n),"\t&\t",num2str(abs(F(n,1)),'%.6f'),'\\','\\','\\',"hline\n");
  fprintf(f_forced_nodal,string);
end

fclose(f_forced_nodal);

fig2=figure();

%VC = [V0-Vinf](exp(-t/k))+Vinf.

%vcfn=nat_sol + (abs(F(6))*sin(w*t+arg(F(6)))-abs(F(8))*sin(w*t+arg(F(8)))).*(1-exp(-t/K));
vcfn = nat_sol + imag(F(6)-F(8))*exp(j*w*t).*(1-exp(-t/K));

%v8fn=abs(F(8))*sin(w*t+arg(F(8)));
v8fn = imag(F(8)*exp(j*w*t));

v6fn=vcfn+v8fn;


u=[-0.005: 0.00005:0];
plot(t,v6fn, 'color', 'red');
hold on;
plot(t,sin(w*t), 'color', 'blue');
hold on;
plot(t,vcfn, 'color', [0.9290 0.6940 0.1250], 'linewidth', 1.5);
hold on;
plot(u,V(6)+0*u, 'color', 'red');
hold on;
plot(u,Vs+0*u, 'color', 'blue');
hold on;
plot(u,V(6)-V(8)+0*u,'color', [0.9290 0.6940 0.1250], 'linewidth', 1.5);
hold off;
xlabel("t (Time) [s]");
ylabel("Voltage [V]");
title("Natural & Forced Solutions Superimposed");
grid on;
legend('V6','Vs', 'Vc');
print (fig2, "nat_for_solution.eps", "-depsc");



%|-----------------------|Amplitude Frequency Analysis|-----------------------|%

%Gain (w=2000pi)
Gw = 1 ./ (1+j*((2000*pi)*Req*C)); %Complex Gain (w=2000pi)

Vout = F(6)-F(8); % Phasor Vout (w=2000pi)

Vin = Vout ./ Gw; % Phasor Vin (w=2000pi)

%Vc and V6

f=logspace(-1,6);


G = 1 ./ (1+j*(2*pi*f)*Req*C); % Gain Modulus

Vc = G*Vin; %Vc = GAIN *VIN

V8 = F(8); % Phasor V8

V6 = Vc + V8;

fig3=figure();

semilogx(f, 20*log10(abs(Vc)), 'color', [0.9290 0.6940 0.1250], 'linewidth', 1.5);
hold on;
semilogx(f, 20*log10(abs(V6)), 'color', 'red');
hold on;
semilogx(f, 20*log10(1+0*f), 'color', 'blue');
hold off;
xlabel("Frequency [Hz]");
ylabel("Voltage [dB]");
title("Frequency Response Analysis");
grid on;
legend('Vc','V6','Vs');

print (fig3, "freq_analysis.eps", "-depsc");

%|------------------------------|Phase Analysis|------------------------------|%

f=logspace(-1,6);

PVc=180/pi * arg(Vc);

PV6=180/pi * arg(V6);

fig4=figure();

semilogx(f, PVc, 'color', [0.9290 0.6940 0.1250], 'linewidth', 1.5);
hold on;
semilogx(f, PV6, 'color', 'red');
hold on;
semilogx(f, 0*f, 'color', 'blue');
hold off;
xlabel("Frequency [Hz]");
ylabel("Phase [Degrees]");
title("Phase Response Analysis");
grid on;
legend('Phase Vc','Phase V6','Phase Vs');

print (fig4, "phase_analysis.eps", "-depsc");

addpath("../mat");

cria_spice(1, R1,R2,R3,R4,R5,R6,R7,Vs,C,Kb,Kd, V(6)-V(8));
cria_spice(2, R1,R2,R3,R4,R5,R6,R7,Vs,C,Kb,Kd, V(6)-V(8));
cria_spice(3, R1,R2,R3,R4,R5,R6,R7,Vs,C,Kb,Kd, V(6)-V(8));
cria_spice(4, R1,R2,R3,R4,R5,R6,R7,Vs,C,Kb,Kd, V(6)-V(8));
