function bees = updt_employed(bees,string)
global colonysize;
for i =1:colonysize
    selected = bees(i).theif;
    tabulist = bees(i).tabulist;
    [updted, tabulist] = local_search(selected,string,i,bees(i).vns,tabulist);
    bees(i).tabulist = tabulist;
    if updted.profit==selected.profit
        bees(i).abandon = bees(i).abandon+1;
        %vns(i) = vns(i) + 1;
    end
    bees(i).theif = updted;
    fprintf('\n [Bee->[%d] "%dth" time in local optimum]',i, bees(i).abandon);
end
end
