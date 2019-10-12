%                                       
function [sBest, tabulist2] = tabusearch2(theif_obj, tabusize, niter, nneigh, bee_index, tabulist2,items_weight , items_cost,city_dist,vmax,vmin,rent,capacity)
    sBest = theif_obj;
    t_list = tabulist2; % index of particular bee
    disp('\n-----------\ntabu search 2 fuction called\n------------\n');

    for iter = 1:niter
        for vns = 1:1
            tabusack = t_list(:).sack;
            tabutour = t_list(:).tour;
                    % getneighrand(theif_obj, nneighbour,capacity, items_weight , items_cost)
            neighbr = getneighrand(theif_obj, nneigh,capacity, items_weight , items_cost);
            sz = size(neighbr);
            neighbours = [];
            for i=1:sz(1);
                sck = neighbr(i).sack;
                tr = neighbr(i).tour;
                if ~ismember(sck.selection_list, vertcat(tabusack.selection_list), 'rows')...
                        && ~ismember(tr.cities, vertcat(tabutour.cities), 'rows')
                    neighbours = [neighbours neighbr(i)];
                end
            end
            if isempty(neighbours)
                break;
            end
            profit = zeros(1,length(neighbours));
            for i=1:length(neighbours)     % (obj,items_weight,items_cost,city_dist,vmax,vmin,rent,capacity)
                neighbours(i)=neighbours(i).cal_obj(items_weight,items_cost,city_dist,vmax,vmin,rent,capacity);
                profit(i) = neighbours(i).profit;
            end
            
            [bestcost, index3] = max(profit); %%
            bestcandidate = neighbours(index3);

            t_list = [t_list; bestcandidate];
            theif_obj = bestcandidate;
            sz = size(t_list);
            if sz(1)>tabusize  %..........parameter of tabu_search
                t_list = t_list(round(tabusize/2):end);
            end
            if bestcost>sBest.profit
                sBest = bestcandidate;
            end
            %fprintf('\n Bee number= %d', bee_index);
            %fprintf('\n bestcost = %d', uint64(sBest.profit));
        end
    end
    tabulist2 = t_list;
end