function PuiParc = funPuiParc(v,vr)
    rho = 1.292 ; % en kg/m3
    R = 21.65 ; % en mètres
    PuiParc = 0.5*rho*pi*(R^2)*(v^3)*funCpParc(v,vr);
end 

