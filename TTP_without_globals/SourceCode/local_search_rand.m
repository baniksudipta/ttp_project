function [solution, tabulist2] = local_search_rand(solution, bee_index, tabulist2,items_weight , items_cost,city_dist,vmax,vmin,rent,capacity)
    disp('\n\n Local Search Rand Called \n\n');
    tabusize = 100; %default tabusize
    tabu_iter = 1; %default tabu iteration
    nneigh = 7; %default number of neighbours   
                        % tabusearch2(theif_obj, tabusize, niter, nneigh, bee_index, tabulist2,items_weight , items_cost,city_dist,vmax,vmin,rent,capacity)
    [updted, tabulist2] = tabusearch2(solution, tabusize, tabu_iter, nneigh, bee_index, tabulist2,items_weight , items_cost,city_dist,vmax,vmin,rent,capacity);
    if(updted.profit>solution.profit)
     %   fprintf('\n random search made an improvement to bee %d, new cost  %d',bee_index ,updted.profit);
        solution = updted;
    %else fprintf('\n random search made no improvement to bee %d', bee_index);
    end
end
