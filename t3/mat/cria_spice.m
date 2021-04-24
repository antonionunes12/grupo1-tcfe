function cria_spice(n, R1, R2, R3, R4, R5, R6, R7, Vs, C, Kb, Kd, Vx)
  if(n==1)
    f_init= fopen('circuitoL2init.net','w');
    fprintf(f_init, "Circuito L2 Init\n");
    inicio(n,f_init, R1, R2, R3, R4, R5, R6, R7, Vs, C, Kb, Kd, Vx);
    fprintf(f_init,'Vs 1 0 %.11f\n\n', Vs);
    fim(f_init,n);
    
    fclose(f_init);
  end
  if(n==2)
    f_l2vs0= fopen('circuitoL2vs0.net','w');
    fprintf(f_l2vs0, "Circuito L2vs0\n");
    inicio(n,f_l2vs0, R1, R2, R3, R4, R5, R6, R7, Vs, C, Kb, Kd, Vx);
    fprintf(f_l2vs0,'Vs 1 0 0\n\n');
    fim(f_l2vs0,n);
    
    fclose(f_l2vs0);
  end
  if(n==3)
    f_nat= fopen('circuitoL2natural.net','w');
    fprintf(f_nat, "Circuito L2 Nat\n");
    inicio(n,f_nat, R1, R2, R3, R4, R5, R6, R7, Vs, C, Kb, Kd, Vx);
    fprintf(f_nat,'Vs 1 0 0\n\n');
    fprintf(f_nat,'C 6 8 %.11fu ic=%.11f\n\n', C*1000000, Vx);
    fprintf(f_nat,'.ic v(6)=%.11f v(8)=0\n', Vx);
    fim(f_nat,n);
    
    fclose(f_nat);
  end
  if(n==4)
    f_for= fopen('circuitoL2natforced.net','w');
    fprintf(f_for, "Circuito L2 Nat Forced\n");
    inicio(n,f_for, R1, R2, R3, R4, R5, R6, R7, Vs, C, Kb, Kd, Vx);
    fprintf(f_for,'Vs 1 0 0.0 ac 1.0 sin(0 1 1000 0 0)\n\n');
    fprintf(f_for,'C 6 8 %.11fu ic=%.11f\n\n', C*1000000, Vx);
    fprintf(f_for,'.ic v(6)=%.11f v(8)=0\n', Vx);
    fim(f_for,n);
    
    fclose(f_for);
  end
  
  
end

function inicio(n,ficheiro, R1, R2, R3, R4, R5, R6, R7, Vs, C, Kb, Kd, Vx)
  fprintf(ficheiro, "\n.options savecurrents\n\n");
  if(n==2)
    fprintf(ficheiro,'Vx 6 8 %.9f\n\n', Vx);
  endif
  fprintf(ficheiro, 'R1 1 2 %.11fk\n', R1/1000);
  fprintf(ficheiro, 'R2 3 2 %.11fk\n', R2/1000);
  fprintf(ficheiro, 'R3 2 5 %.11fk\n', R3/1000);
  fprintf(ficheiro, 'R4 5 0 %.11fk\n', R4/1000);
  fprintf(ficheiro, 'R5 5 6 %.11fk\n', R5/1000);
  fprintf(ficheiro, 'R6 0 7 %.11fk\n', R6/1000);
  fprintf(ficheiro, 'R7 ne 8 %.11fk\n\n', R7/1000);
  
  fprintf(ficheiro, 'Vaux 7 ne 0.0\n\n');
  
  fprintf(ficheiro, 'Hd 5 8 Vaux %.11fk\n\n', Kd/1000);
  fprintf(ficheiro, 'Gb 6 3 (2,5) %.11fm\n\n', Kb*1000);
endfunction

function fim(ficheiro,n)
  fprintf(ficheiro, ".model linearcircuit NPN\n.control\n\n");
  if(n<=2)
    fprintf(ficheiro, "op\n\necho \"op_TAB\"\nprint all\necho \"op_END\"\n\n");
  endif
  if(n>=3)
    fprintf(ficheiro, "set hcopypscolor=0\nset color0=white\nset color1=black\n");
    fprintf(ficheiro, "set color2=red\nset color3=blue\nset color4=violet\n");
    fprintf(ficheiro, "set color5=rgb:3/8/0\nset color6=rgb:4/0/0\n\n");
    fprintf(ficheiro, "run\ntran 1u 20m 0 uic\n\n");
  endif
  if(n==3)
    fprintf(ficheiro, "hardcopy spicenat.ps v(6)\n\n");
  endif
  if(n==4)
    fprintf(ficheiro, "hardcopy spicenatforced.ps v(6) v(1) v(6)-v(8)\n\n");
    fprintf(ficheiro, "ac dec 10 0.1 1MEG\n\n");
    fprintf(ficheiro, "hardcopy ampfreqresponse.ps db(v(6)) db(v(1)) db(v(6)-v(8))\n\n");
    fprintf(ficheiro, "hardcopy phasefreqresponse.ps 180/PI*phase(v(6)) 180/PI*phase(v(1)) 180/PI*phase(v(6)-v(8))\n\n");
  endif
  fprintf(ficheiro,"quit\n.endc\n\n.end");
endfunction
