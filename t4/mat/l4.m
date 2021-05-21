
clear all

%gain stage

VT=25e-3
BFN=178.7
VAFN=69.7
RE1=100
RC1=1000
RB1=80000
RB2=20000
VBEON=0.7
VCC=12
RS=100
Ci=1e-3
Ce=1e-3
Co=1e-6
RL=8

RB=1/(1/RB1+1/RB2)
VEQ=RB2/(RB1+RB2)*VCC
IB1=(VEQ-VBEON)/(RB+(1+BFN)*RE1)
IC1=BFN*IB1
IE1=(1+BFN)*IB1
VE1=RE1*IE1
VO1=VCC-RC1*IC1
VCE=VO1-VE1


gm1=IC1/VT
rpi1=BFN/gm1
ro1=VAFN/IC1

RSB=RB*RS/(RB+RS)

AV1 = RSB/RS * RC1*(RE1-gm1*rpi1*ro1)/((ro1+RC1+RE1)*(RSB+rpi1+RE1)+gm1*RE1*ro1*rpi1 - RE1^2)
AVI_DB = 20*log10(abs(AV1))
AV1simple = RB/(RB+RS) * gm1*RC1/(1+gm1*RE1)
AVIsimple_DB = 20*log10(abs(AV1simple))

RE1=0
AV1 = RSB/RS * RC1*(RE1-gm1*rpi1*ro1)/((ro1+RC1+RE1)*(RSB+rpi1+RE1)+gm1*RE1*ro1*rpi1 - RE1^2)
AVI_DB = 20*log10(abs(AV1))
AV1simple =  - RSB/RS * gm1*RC1/(1+gm1*RE1)
AVIsimple_DB = 20*log10(abs(AV1simple))

RE1=100
ZI1 = 1/(1/RB+1/(((ro1+RC1+RE1)*(rpi1+RE1)+gm1*RE1*ro1*rpi1 - RE1^2)/(ro1+RC1+RE1)))
ZX = ro1*((RSB+rpi1)*RE1/(RSB+rpi1+RE1))/(1/(1/ro1+1/(rpi1+RSB)+1/RE1+gm1*rpi1/(rpi1+RSB)))
ZX = ro1*(   1/RE1+1/(rpi1+RSB)+1/ro1+gm1*rpi1/(rpi1+RSB)  )/(   1/RE1+1/(rpi1+RSB) ) 
ZO1 = 1/(1/ZX+1/RC1)

RE1=0
ZI1 = 1/(1/RB+1/(((ro1+RC1+RE1)*(rpi1+RE1)+gm1*RE1*ro1*rpi1 - RE1^2)/(ro1+RC1+RE1)))
ZO1 = 1/(1/ro1+1/RC1)

%ouput stage
BFP = 227.3
VAFP = 37.2
RE2 = 100
VEBON = 0.7
VI2 = VO1
IE2 = (VCC-VEBON-VI2)/RE2
IC2 = BFP/(BFP+1)*IE2
VO2 = VCC - RE2*IE2

gm2 = IC2/VT
go2 = IC2/VAFP
gpi2 = gm2/BFP
ge2 = 1/RE2

AV2 = gm2/(gm2+gpi2+go2+ge2)
ZI2 = (gm2+gpi2+go2+ge2)/gpi2/(gpi2+go2+ge2)
ZO2 = 1/(gm2+gpi2+go2+ge2)


%total
gB = 1/(1/gpi2+ZO1)
AV = (gB+gm2/gpi2*gB)/(gB+ge2+go2+gm2/gpi2*gB)*AV1
AV_DB = 20*log10(abs(AV))
ZI=ZI1
ZO=1/(go2+gm2/gpi2*gB+ge2+gB)

fich= fopen("theo_imp_del.tex","w");
string=strcat("$Z1_I$","\t&\t",num2str(ZI1,'%.6f'),'\\','\\','\\',"hline\n");
fprintf(fich,string);
string=strcat("$Z1_O$","\t&\t",num2str(ZO1,'%.6f'),'\\','\\','\\',"hline\n");
fprintf(fich,string);
string=strcat("$Z2_I$","\t&\t",num2str(ZI2,'%.6f'),'\\','\\','\\',"hline\n");
fprintf(fich,string);
string=strcat("$Z2_O$","\t&\t",num2str(ZO2,'%.6f'),'\\','\\','\\',"hline\n");
fprintf(fich,string);
string=strcat("$Z_O$","\t&\t",num2str(ZO,'%.6f'),'\\','\\','\\',"hline\n");
fprintf(fich,string);
fclose(fich);

fich = fopen("theo_gain_del.tex","w");
string=strcat("$G_1$","\t&\t",num2str(AV1,'%.6f'),'\\','\\','\\',"hline\n");
fprintf(fich,string);
string=strcat("$G_2$","\t&\t",num2str(AV2,'%.6f'),'\\','\\','\\',"hline\n");
fprintf(fich,string);
string=strcat("$G_T$","\t&\t",num2str(AV,'%.6f'),'\\','\\','\\',"hline\n");
fprintf(fich,string);
string=strcat("$G_{T_{dB}}$","\t&\t",num2str(AV_DB,'%.6f'),'\\','\\','\\',"hline\n");
fprintf(fich,string);
fclose(fich);

%lower CO-freq
w_L= 1/(3*Ce)+ 1/((ZO+RL)*Co) +1/((ZI+RS)*Ci);
f_L=w_L/(2*pi);

%higher CO-freq
w_H=100000*2*pi;
f_H=w_H/(2*pi);

band = f_H-f_L;

fich = fopen("theo_CO_freq_band.tex","w");
string=strcat("Lower CO freq","\t&\t",num2str(f_L,'%.6f'),'\\','\\','\\',"hline\n");
fprintf(fich,string);
string=strcat("Higher CO freq","\t&\t",num2str(f_H,'%.6f'),'\\','\\','\\',"hline\n");
fprintf(fich,string);
string=strcat("Bandwidth","\t&\t",num2str(band,'%.6f'),'\\','\\','\\',"hline\n");
fprintf(fich,string);
fclose(fich);

