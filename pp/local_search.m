function [solution, tabulist] = local_search(solution, search_algorithm, i, vns, tabulist, param1, param2, param3, param4)
if nargin>0
    if strcmp(search_algorithm, 'theif')
        if nargin<6
            param1 = 100; %default tabusize
            param2 = 10; %default tabu nimprove
            param3 = 1; %default tabu iteration
            param4 = 2; %default 2opt iteration
        end
        %sck = solution.sack;
        %tr = solution.tour;
        if rand()>0.5
            solution = two_opt(solution, param4,i);
            [solution, tabulist] = tabusearch(solution, param1, param2, param3,i,vns, tabulist);
        else
            [solution, tabulist] = tabusearch(solution, param1, param2, param3,i,vns, tabulist);
             solution = two_opt(solution, param4,i);
        end
        fprintf('\nBee Name->: [%d], with Updated Cost---> [%d]', i, solution.profit);
    end

else error('not enough input arguements');
end
end