function [selected_theif, tabulist] = local_search(selected_theif,index, tabulist,items_weight,items_cost,city_dist,vmax,vmin,rent,capacity,z,wghtbyprft , nobject)
    tabusize = 100; %default tabusize
    tabu_iter = 1; %default tabu iteration
    twoopt_iter = 2; %default 2opt iteration
   
    if rand()>0.5
        selected_theif = two_opt(selected_theif, twoopt_iter,index,items_weight,items_cost,city_dist,vmax,vmin,rent,capacity,z,wghtbyprft , nobject);
        [selected_theif, tabulist] = tabusearch(selected_theif, tabusize,tabu_iter,index,tabulist,items_weight,items_cost,city_dist,vmax,vmin,rent,capacity);
    else
        [selected_theif, tabulist] = tabusearch(selected_theif, tabusize,tabu_iter,index,tabulist,items_weight,items_cost,city_dist,vmax,vmin,rent,capacity);
        selected_theif = two_opt(selected_theif, twoopt_iter,index,items_weight,items_cost,city_dist,vmax,vmin,rent,capacity,z,wghtbyprft , nobject);
    end
    %fprintf('\nBee Name->: [%d], with Updated Cost---> [%d]', index, selected_theif.profit);
end