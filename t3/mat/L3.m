pkg load symbolic

format long
close all
clear

Vin= vpa(201.135);
Ndiodos= vpa(18);
Von= vpa(12/Ndiodos);
f= 50;
w= vpa(2*pi*f);
R_env= vpa(140000);
R_vreg= vpa(120000);
C= vpa(600*10^(-6));
Req= R_env*R_vreg/(R_env+R_vreg);

syms t;

eqn1=(Vin*sin(w*t)-2*Von)/(Req)+Vin*w*C*cos(w*t)==0;
sol1 = solve(eqn1,t);

toff=real(max(sol1)); %toffnext=toff+T/2

voff=vpa(Vin*sin(w*toff)-2*Von);

eqn2 = voff*exp(-(t-toff)/(Req*C))+Vin*sin(w*t)+2*Von==0;
sol2 = vpasolve(eqn2, t, [vpa(0) vpa(3/(4*f))]);

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

t=0:.01:200;
y=zeros(20000,1);
y(1)=double(-2*Von);
z=zeros(20000,1);
z(1)=0;

ton_antigo=0;
toff_antigo=toff;
AC=0;
DC=0;
soma_vo=y(1);

for i=1:20000
  if(i<toff*100000 && i>ton_antigo*100000)
    y(i+1)=abs(Vin*sin(w*(i+1)*10^(-5)))-2*Von;
  endif
  if(i>=toff*100000 && i<=ton*100000)
    y(i+1)=voff*exp((-(((i+1)*10^(-5)-toff)))/(Req*C));
  endif
  if(i+1>ton*100000)
    toff= toff+1/(2*f);
    ton_antigo=ton;
    ton=ton+1/(2*f);
  endif
  
  soma_vo = soma_vo + y(i+1);
endfor

media_vo= soma_vo/20001;

for i=1:20000
  if(y(i+1)>Ndiodos*Von)
    %componente DC
    DC=Ndiodos*Von;
    
    %componente AC
    AC=(y(i+1)-media_vo)*rd/(rd+R_vreg);
    
    z(i+1)=DC+AC;
  else
    z(i+1)=y(i+1);
  endif
endfor

soma=0;
maximo=-999999;
minimo=999999;
for i=2000:20000
  soma=soma+z(i);
  if(z(i)>=maximo);
    maximo=z(i);
  endif
  if(z(i)<=minimo);
    minimo=z(i);
  endif
endfor

average= soma/18001;
disp("desvio");
disp((average-12));
disp("DC level");
disp(average);
disp("ripple");
disp(maximo-minimo);

f_theo_table=fopen('theo_table_del.tex', 'w');

string=strcat("Deviation","\t&\t",num2str(average-12,'%.6f'),'\\','\\','\\',"hline\n");
fprintf(f_theo_table,string);
string=strcat("DC level","\t&\t",num2str(average,'%.6f'),'\\','\\','\\',"hline\n");
fprintf(f_theo_table,string);
string=strcat("Ripple","\t&\t",num2str(maximo-minimo,'%.6f'),'\\','\\','\\',"hline\n");
fprintf(f_theo_table,string);

fclose(f_theo_table);


fig1=figure;
plot(t,y,t,z);
ylim([-220 220]);
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
plot(t,z-12, 'color', 'red',t, average+t*0-12, 'color', [0.4660 0.6740 0.1880]);
ylim([(minimo-12.00005) (maximo-11.99995)]);
xlabel("Time [ms]");
ylabel("Voltage [V]");
title("Ripple");
legend({"Ripple", "Average"}, 'Location', 'southeast');
print (fig2, "theo_ripple.eps", "-depsc");
