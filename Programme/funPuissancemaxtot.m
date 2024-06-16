function Ptm = funPuissancemaxtot(v)
    Ptm = [] ;
    Ptot = 0 ;
    for i = 1:10 
        Ptot = Ptot + funPuiParc(v,v*2/3) ; 
        Ptm = [Ptm, Ptot] ;
        v=v*2/3;
    end
end 
      