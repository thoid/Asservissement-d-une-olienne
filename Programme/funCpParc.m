function CpParc = funCpParc(v,vr)
    alpha = (v-vr)/v;
    CpParc = 4*alpha*(1-alpha)^2;
end
