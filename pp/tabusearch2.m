function [sBest, tabulist2] = tabusearch2(theif_obj, tabusize, niter, nneigh, abc, tabulist2)
    %--- abc = bee number;
    %init_obj = theif_obj;
    sBest = theif_obj;
    %last_cost = -Inf;
    %global last_cost_tabu;
    %last_cost = theif_obj.profit;
    %global tabulist2;
    t_list = tabulist2; % index of particular bee
    

    for iter = 1:niter
        for vns = 1:1
            tabusack = t_list(:).sack;
            tabutour = t_list(:).tour;
            %sck = theif_obj.sack;
            %[neighbr, ~] = getneighbourhood(theif_obj, vns); %k: parameter for VNS
            neighbr = getneighrand(theif_obj, nneigh);
            sz = size(neighbr);
            neighbours = [];
            for i=1:sz(1);
                %{
                sack_neighbr = sack(neighbr(i,:));
                sack_neighbr = modify_sack(sack_neighbr, 'weight-to-profit');                
                if ~ismember(sack_neighbr.selection_list, vertcat(t_list(:).selection_list), 'rows')
                    neighbours = [neighbours ...
                        theif(theif_obj.tour,sack_neighbr,theif_obj.z)];
                   
                end
                %}
                sck = neighbr(i).sack;
                tr = neighbr(i).tour;
                if ~ismember(sck.selection_list, vertcat(tabusack.selection_list), 'rows')...
                        && ~ismember(tr.cities, vertcat(tabutour.cities), 'rows')
                    %neighbours = [neighbours ...
                    %    theif(theif_obj.tour,sack_neighbr,theif_obj.z)];
                    neighbours = [neighbours neighbr(i)];
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

            t_list = [t_list; bestcandidate];
            theif_obj = bestcandidate;
            sz = size(t_list);
            if sz(1)>tabusize  %..........parameter of tabu_search
                t_list = t_list(round(tabusize/2):end);
            end
            if bestcost>sBest.profit
                sBest = bestcandidate;
            end
            %fprintf('\n Bee number= %d', abc);
            %fprintf('\n bestcost = %d', uint64(sBest.profit));
        end
    end
    tabulist2 = t_list;
end