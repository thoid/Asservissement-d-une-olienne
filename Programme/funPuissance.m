function Pr = funPuissance(wr,theta,V)
    rho = 1.225 ; % en kg/m3
    R = 21.65 ; % en mètres
    lambda=(wr*R)/V ;
    Pr = 0.5*rho*pi*(R^2)*(V^3)*funCp(lambda,theta);
end

