function sBest = tabusearch(theif_obj, tabusize, ~, niter, abc, ~)
    sBest = theif_obj;
    global tabulist;
    t_list = tabulist{abc}; % index of particular bee
    tr = theif_obj.tour;
    score_indices = tr.d_array;
    for iter = 1:niter
        for vns = 1:3
            sck = theif_obj.sack;
            
            [neighbr, ~] = getneighbourhood(sck.selection_list,vns); %k: parameter for VNS
            sz = size(neighbr);
            neighbours = [];
            for i=1:sz(1);
                sack_neighbr = sack(neighbr(i,:));
                sack_neighbr = modify_sack(sack_neighbr,score_indices,'weight-to-profit');

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
                neighbours(i)=neighbours(i).cal_obj();
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
    tabulist{abc} = t_list; %t_list is append to previous tabulist of the bee
end