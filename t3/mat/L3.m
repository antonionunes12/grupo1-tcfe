pkg load symbolic

format long
close all
clear

Vin= vpa(28.75);
Von= vpa(0.7);
Ndiodos= vpa(18);
f= 50;
w= vpa(2*pi*f);
R_env= vpa(1000);
R_vreg= vpa(6300);
C= vpa(15*10^(-6));
Req= R_env*R_vreg/(R_env+R_vreg);

syms t;

eqn1=(Vin*sin(w*t)-2*Von)/(Req)+Vin*w*C*cos(w*t)==0;
sol1 = solve(eqn1,t);

toff=real(max(sol1)); %toffnext=toff+T/2

voff=vpa(Vin*sin(w*toff)-2*Von);

eqn2 = voff*exp(-(t-toff)/(Req*C))+Vin*sin(w*t)+2*Von==0;
sol2= vpasolve(eqn2, t, [vpa(0) vpa(3/(4*f))]);

ton=real(sol2);



Vin=double(Vin);
Von=double(Von);
Ndiodos=double(Ndiodos);
w=double(w);
R_env=double(R_env);
R_vreg=double(R_vreg);
C= double(C);
Req = double(Req);
toff= double(toff);
ton=double(ton);
voff=double(voff);

Vt=25.88794*10^(-3);
Is=1*10^(-14);
rd=Ndiodos*(Vt/(Is*exp(Von/Vt)));

t=0:.1:200;
y=zeros(2000,1);
y(1)=double(-2*Von);
z=zeros(2000,1);
z(1)=0;

ton_antigo=0;
toff_antigo=toff;
AC=0;
DC=0;

for i=1:2000
  if(i<toff*10000 && i>ton_antigo*10000)
    y(i+1)=abs(Vin*sin(w*(i+1)*10^(-4)))-2*Von;
  endif
  if(i>=toff*10000 && i<=ton*10000)
    y(i+1)=voff*exp((-(((i+1)*10^(-4)-toff)))/(Req*C));
  endif
  if(i+1>ton*10000)
    toff= toff+1/(2*f);
    ton_antigo=ton;
    ton=ton+1/(2*f);
  endif
  
  if(y(i+1)>Ndiodos*Von)
    %componente DC
    DC=Ndiodos*Von;
    
    %componente AC
    AC=y(i+1)*rd/(rd+R_vreg);
    
    z(i+1)=DC+ AC;
  else
    z(i+1)=y(i+1);
  endif
endfor

soma=0;
maximo=-999999;
minimo=999999;

for i=200:2000
  soma=soma+z(i);
  if(z(i)>=maximo);
    maximo=z(i);
  endif
  if(z(i)<=minimo);
    minimo=z(i);
  endif
endfor

average= soma/1801;
disp("desvio");
disp((average-12));
disp("DC level");
disp(Ndiodos*Von);
disp("ripple");
disp(maximo-minimo);

f_theo_table=fopen('theo_table_del.tex', 'w');

string=strcat("Desvio","\t&\t",num2str(average-12,'%.6f'),'\\','\\','\\',"hline\n");
fprintf(f_theo_table,string);
string=strcat("DC level","\t&\t",num2str(Ndiodos*Von,'%.6f'),'\\','\\','\\',"hline\n");
fprintf(f_theo_table,string);
string=strcat("Ripple","\t&\t",num2str(maximo-minimo,'%.6f'),'\\','\\','\\',"hline\n");
fprintf(f_theo_table,string);

fclose(f_theo_table);


fig1=figure;
plot(t,y,t,z);
ylim([-30 30]);
hold on;
x=0:.01:200;
plot(x,Vin*sin(w*x*10^(-3)));
hold off;
xlabel("Time [ms]");
ylabel("Voltage [V]");
title("Theoretical results");
legend({"Envelope Voltage", "Output Voltage", "Input Voltage"}, 'Location', 'southeast');
print (fig1, "theo_results.eps", "-depsc");

fig2=figure;
plot(t,z-12,t, average+t*0-12);
ylim([(minimo-12.05) (maximo-11.95)]);
xlabel("Time [ms]");
ylabel("Voltage [V]");
title("Ripple");
legend({"Ripple", "Average"}, 'Location', 'southeast');
print (fig2, "theo_ripple.eps", "-depsc");
