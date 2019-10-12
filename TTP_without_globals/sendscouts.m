function bees = sendscouts(bees,limit,coordinates,colonysize,items_weight,items_cost,city_dist,vmax,vmin,rent,capacity,z,wghtbyprft , nobject)
    fprintf('\n|---------------------------|');
    fprintf('\n|---   sending-scouts    ---|');
    fprintf('\n|------ [ Parallel ] -------|\n');
    parfor i=1:colonysize
        if bees(i).abandon>limit

            fprintf('\n[ %d th ] Bee is randomly initialized', i);
            sz = nobject;
            tr = bees(i).theif.tour;
            

            r = randperm(tr.size-1);
            tour_obj = tour(r,coordinates,city_dist,z,wghtbyprft , nobject);
            distance_array = tour_obj.d_array; %needed for modify_sack

            x = rand(1,sz)>0.5; %random binary vector initialization
            sack_obj = sack(x, items_weight , items_cost);
            sack_obj = modify_sack(sack_obj,distance_array, 'weight-to-profit',capacity,items_weight ,items_cost);
                        
            theif_obj = theif(tour_obj,sack_obj,z);
            theif_obj = theif_obj.cal_obj(items_weight,items_cost,city_dist,vmax,vmin,rent,capacity);
            bees(i).theif = theif_obj;
            bees(i).abandon = 0;
            bees(i).tabulist = sack_obj; %theif_obj
            bees(i).vns = 1;
        end%if
    end%for
end%function_send_scouts
