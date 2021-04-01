Vx = 8.81255;
Req = 3098.898337 ; %Req = R5
C = 1e-06; %1 uF

%Time Constant (T=1/(RC))
K = (Req*C);

t=[0:0.00005:0.02];

nat_sol=Vx*exp(-t/K);

plot(t,nat_sol), xlabel("t (Time) [s]"), ylabel("Capacitor Voltage [V]"), 
                 title("Natural Solution"), grid on