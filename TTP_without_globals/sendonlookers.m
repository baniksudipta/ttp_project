function bees = sendonlookers(bees,colonysize,limit,items_weight,items_cost,city_dist,vmax,vmin,rent,capacity,z,wghtbyprft , nobject)
    fprintf('\n|---------------------------|');
    fprintf('\n|---   sending-onlookers ---|');
    fprintf('\n|---------[ Parallel]-------|\n');
    cost = zeros(1,colonysize);
    for i = 1:colonysize
        cost(i) = bees(i).theif.profit;
    end
    %probability = cost/abs(sum(cost));%probability of *not* getting selected 
    probability = (cost - min(cost))/(max(cost) - min(cost)); %scaling onto [0,1]

    num_onlookers = round(colonysize/2);
    
    IDX = zeros(1,num_onlookers);
    for i = 1:num_onlookers
        IDX(i) = roulettewheel(probability);
    end
    
    IDX = (unique(IDX));
    
    onlookers = bees(IDX);
    num_onlookers = length(IDX);
    disp(IDX);
    parfor i=1: num_onlookers %onlooker bees are half of colonysize in number
        
        index = IDX(i);
        fprintf('\n\n Onlooker->[%d] Selected Bee Name: [%d]',i, index);
        fprintf('\n Bee->[%d] "%dth" time in local optimum',index, onlookers(i).abandon);
        selected = onlookers(i).theif;
        tabulist = onlookers(i).tabulist;
        tabulist2 = onlookers(i).tabulist2;
        [updted, tabulist] = local_search(selected,index, tabulist,items_weight,items_cost,city_dist,vmax,vmin,rent,capacity,z,wghtbyprft , nobject);
                            
         if updted.profit==selected.profit
             onlookers(i).abandon = onlookers(i).abandon+1;
         end
         if (2*onlookers(i).abandon) > limit
             fprintf('\n\nlocal search rand wil be called here\n\n');
             [updted, tabulist2] = local_search_rand(updted, index,tabulist2,items_weight , items_cost,city_dist,vmax,vmin,rent,capacity);
         end
         onlookers(i).theif = updted;
         onlookers(i).tabulist = tabulist;
         onlookers(i).tabulist2 = tabulist2;
    end
    
    for i= 1:num_onlookers
       bees(IDX(i)) = onlookers(i); 
    end
end

function index = roulettewheel(P)
    C=cumsum(P);
    r=rand*max(C);
    
    index=find(r<=C,1,'first');

end