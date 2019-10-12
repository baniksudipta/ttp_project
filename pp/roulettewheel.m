function index = roulettewheel(P)
    C=cumsum(P);
    r=rand*max(C);
    
    index=find(r<=C,1,'first');

end