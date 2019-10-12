classdef beecolony
   
    properties
        colonysize;
        nobject;
        ncities;
        colony;
        employed;
        onlookers;
        scout;
        limit;
        abandon;
    end
    
    methods
        function obj = beecolony(instance, colonysize, limit, abandon)
            %to be changed for different implementations
            obj.colonysize = colonysize;
            obj.limit = limit;
            obj.abandon = abandon;
            sck = instance.sack;
            tr = instance.tour;
            sz = length(sck.selection_list);
            obj.nobject = sz;
            obj.ncities = tr.size-1;
            obj.colony = [];
            
            for m = 1:colonysize
                
                r = randperm(tr.size-1);
                tour_obj = tour(r,tr.coordinates);
                distance_array = tour_obj.d_array; %needed for modify_sack

                x = rand(1,sz)>0.5; %random binary vector initialization
                sack_obj = sack(x);
                sack_obj = modify_sack(sack_obj,distance_array, 'weight-to-profit');
                
                theif_obj = theif(tour_obj,sack_obj,instance.z);
                theif_obj = theif_obj.cal_obj();
                obj.colony = [obj.colony theif_obj];
            end
        end
        
        function obj = sendemployed(obj)
            obj.employed = obj.colony;
        end
        
        function obj = sendonlookers(obj)
            fprintf('\n|---------------------------|');
            fprintf('\n|---   sending-onlookers ---|');
            fprintf('\n|---------------------------|\n');
            global vns;
            cost = [];
            for i = 1:obj.colonysize
                cost(i) = obj.employed(i).profit;
            end
            %probability = cost/abs(sum(cost));%probability of *not* getting selected 
            probability = (cost - min(cost))/(max(cost) - min(cost)); %scaling onto [0,1]
            
            for i=1:round(obj.colonysize/2)
                index = roulettewheel(probability);
                fprintf('\n\n Onlooker->[%d] Selected Bee Name: [%d]',i, index);
                fprintf('\n Bee->[%d] "%dth" time in local optimum',index, obj.abandon(index));
                selected = obj.employed(index);
                updted = local_search(selected,'theif',index,vns(i));
                if updted.profit==selected.profit
                     obj.abandon(index) = obj.abandon(index)+1;
                     %vns(i) = vns(i) + 1;
                end
                if obj.abandon(index) > (obj.limit/2)
                     updted = local_search_rand(updted, index);
                end
                obj.employed(index) = updted;
            end
        end
        
        function obj = sendscouts(obj)
            global tabulist;
            global last_cost_tabu;
            fprintf('\n|---------------------------|');
            fprintf('\n|---   sending-scouts    ---|');
            fprintf('\n|---------------------------|\n');
            %global vns;
            bees_to_mutate=[];
            for i=1:obj.colonysize
                if obj.abandon(i)>obj.limit
                    %bees_to_mutate = [bees_to_mutate i];
                    
                    fprintf('\nbee %d is randomly initialized', i);
                    sz = obj.nobject;
                    instance = obj.employed(i);
                    sck = instance.sack;
                    tr = instance.tour;
                    x = rand(1,sz)>0.5; %random binary vector initialization
                
                    r = randperm(tr.size-1);
                    tour_obj = tour(r,tr.coordinates);
                    distance_array = tour_obj.d_array; %needed for modify_sack

                    sack_obj = sack(x);
                    sack_obj = modify_sack(sack_obj,distance_array, 'weight-to-profit');
                    theif_obj = theif(tour_obj,sack_obj,instance.z);
                    theif_obj = theif_obj.cal_obj();
                    obj.employed(i) = theif_obj;
                    obj.abandon(i) = 0;
                    tabulist{i} = sack_obj; %theif_obj
                    last_cost_tabu(i) = -Inf;
                    
                end%if
            end%for 
        end%function_send_scouts
        
        function obj = waggledance(obj)
            obj.colony = [obj.onlookers obj.scout];
        end
        
        function obj = updt_employed(obj,string)
            global vns;
            for i =1:obj.colonysize
                selected = obj.employed(i);
                updted = local_search(selected,string,i,vns(i));
                if updted.profit==selected.profit
                    obj.abandon(i) = obj.abandon(i)+1;
                    %vns(i) = vns(i) + 1;
                end
                obj.employed(i) = updted;
                fprintf('\n [Bee->[%d] "%dth" time in local optimum]',i, obj.abandon(i));
            end
        end
        
    end
    
end

function solution = local_search(solution, search_algorithm, i, vns, param1, param2, param3, param4)
    if nargin>0
        if strcmp(search_algorithm, 'theif')
            if nargin<5
                param1 = 100; %default tabusize
                param2 = 10; %default tabu nimprove
                param3 = 1; %default tabu iteration
                param4 = 2; %default 2opt iteration
            end
            %sck = solution.sack;
            %tr = solution.tour;
            if rand()>0.5
                solution = two_opt(solution, param4,i);
                solution = tabusearch(solution, param1, param2, param3,i,vns);
            else
                solution = tabusearch(solution, param1, param2, param3,i,vns);
                solution = two_opt(solution, param4,i);
            end
            %{
            if max(solution1.profit, solution2.profit)== solution1.profit
                solution = solution1;
            else solution = solution2;
            end
            %}
            fprintf('\nBee Name->: [%d], with Updated Cost---> [%d]', i, solution.profit);
        end
        
    else error('not enough input arguements');
    end
end

function solution = local_search_rand(solution, abc)
    if nargin<5
        param1 = 100; %default tabusize
        param2 = 1; %default tabu iteration
        param3 = 10; %default number of neighbours
    end    
    updted = tabusearch2(solution, param1, param2, param3, abc);
    if(updted.profit>solution.profit)
        fprintf('\n random search made an improvement to bee %d, new cost --> %d',abc ,updted.profit);
        solution = updted;
    else fprintf('\n random search made no improvement to bee %d', abc);
    end
end

function index = roulettewheel(P)
    C=cumsum(P);
    r=rand*max(C);
    index=find(r<=C,1,'first');
end