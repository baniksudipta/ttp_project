function bees = updt_employed(bees,colonysize,items_weight,items_cost,city_dist,vmax,vmin,rent,capacity,z,wghtbyprft , nobject)
                                
    fprintf('\n|---------------------------|');
    fprintf('\n|---   Update Emplyed    ---|');
    fprintf('\n|------ [ Parallel ] -------|\n');
    
    parfor i =1:colonysize
        
        selected_theif = bees(i).theif;
        
        [updated_theif, updated_tabulist] = local_search(selected_theif,i,bees(i).tabulist,items_weight,items_cost,city_dist,vmax,vmin,rent,capacity,z,wghtbyprft , nobject);
                                            
        bees(i).tabulist = updated_tabulist;
        
        if updated_theif.profit==selected_theif.profit
            bees(i).abandon = bees(i).abandon+1;
        end
        bees(i).theif = updated_theif;
        fprintf('\n [Bee->[%d] [ %dth ] time in local optimum]',i, bees(i).abandon);
    end
end
