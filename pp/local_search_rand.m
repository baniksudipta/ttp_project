function [solution, tabulist2] = local_search_rand(solution, abc, tabulist2)
    if nargin<5
        param1 = 100; %default tabusize
        param2 = 1; %default tabu iteration
        param3 = 10; %default number of neighbours
    end    
    [updted, tabulist2] = tabusearch2(solution, param1, param2, param3, abc, tabulist2);
    if(updted.profit>solution.profit)
        fprintf('\n random search made an improvement to bee %d, new cost --> %d',abc ,updted.profit);
        solution = updted;
    else fprintf('\n random search made no improvement to bee %d', abc);
    end
end
