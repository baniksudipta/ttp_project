function bees = sendscouts(bees)
global last_cost_tabu;
global colonysize limit nobject ncity;
fprintf('\n|---------------------------|');
fprintf('\n|---   sending-scouts    ---|');
fprintf('\n|---------------------------|\n');
%global vns;
for i=1:colonysize
    if bees(i).abandon>limit
        %bees_to_mutate = [bees_to_mutate i];

        fprintf('\nbee %d is randomly initialized', i);
        sz = nobject;
        instance = bees(i).theif;
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
        bees(i).theif = theif_obj;
        bees(i).abandon = 0;
        bees(i).tabulist = sack_obj; %theif_obj
        bees(i).vns = 1;
        last_cost_tabu(i) = -Inf;
        %vns(i) = 1;

        %}
    end%if
end%for
end%function_send_scouts
