function [sBest, tabulist] = tabusearch(theif_obj, tabusize,niter, ~,tabulist,items_weight,items_cost,city_dist,vmax,vmin,rent,capacity)
    %--- abc = bee number;
    sBest = theif_obj;
    t_list = tabulist;
    tr = theif_obj.tour;
    score_indices = tr.d_array;
    
    for iter = 1:niter
        for vns = 1:3
            sck = theif_obj.sack; % to be removed later
            
            neighbr = getneighbourhood(sck.selection_list,vns); %k: parameter for VNS
            sz = size(neighbr);
            neighbours = [];
            for i=1:sz(1);
                sack_neighbr = sack(neighbr(i,:),items_weight , items_cost);
                sack_neighbr = modify_sack(sack_neighbr,score_indices,'weight-to-profit',capacity,items_weight , items_cost);

                if ~ismember(sack_neighbr.selection_list, vertcat(t_list(:).selection_list), 'rows')
                    neighbours = [neighbours ...
                        theif(theif_obj.tour,sack_neighbr,theif_obj.z)];
                   
                end
            end
            if isempty(neighbours)
                break;
            end
            profit = zeros(1,length(neighbours));
            for i=1:length(neighbours)
                neighbours(i)=neighbours(i).cal_obj(items_weight,items_cost,city_dist,vmax,vmin,rent,capacity);
                profit(i) = neighbours(i).profit;
            end
            [bestcost, index3] = max(profit); %%
            bestcandidate = neighbours(index3);

            t_list = [t_list; bestcandidate.sack];
            
            sz = size(t_list);
            if sz(1)>tabusize  %..........parameter of tabu_search
                t_list = t_list(round(tabusize/2):end);
            end
            if bestcost>sBest.profit
                sBest = bestcandidate;
            end
        end
        theif_obj = sBest;
    end
    tabulist = t_list; %t_list is append to previous tabulist of the bee
end