function [ bee1 , bee2 ] = bees_crossover( parent1,parent2 )
%BEES_CROSSOVER Summary of this function goes here
%   Detailed explanation goes here
    fprintf('\n|---------------------------|\n');
    fprintf('\n|------crossover bees-------|\n');
    fprintf('\n|---------------------------|\n');
    global coordinates;
    sack_size = length(parent1.sack.selection_list);
    %generating_the_crossover_points
    ix1 = randi([2,sack_size-1]);
    ix2 = randi([2,sack_size-1]);
    if ix2 < ix1
        [ix2 , ix1] = deal(ix1,ix2);
    end
    child_sack1_selection_list = parent1.sack.selection_list(1:ix1-1);
    child_sack2_selection_list = parent2.sack.selection_list(1:ix1-1);
    %crossover point starts
    child_sack1_selection_list = [child_sack1_selection_list parent2.sack.selection_list(ix1:ix2)];
    child_sack2_selection_list = [child_sack2_selection_list parent1.sack.selection_list(ix1:ix2)];
    for i = ix1:ix2
        p = rand;
        if(p < 0.5)
            child_sack1_selection_list(i) = 1 - child_sack1_selection_list(i);
        else
            child_sack2_selection_list(i) = 1 - child_sack2_selection_list(i);
        end
    end
    %crossover point ends
    child_sack1_selection_list = [child_sack1_selection_list parent1.sack.selection_list(ix2+1:sack_size)];
    child_sack2_selection_list = [child_sack2_selection_list parent2.sack.selection_list(ix2+1:sack_size)];
    %sack_crossover_done
    child_sack_obj1 = sack(child_sack1_selection_list);
    child_sack_obj1 = modify_sack2(child_sack_obj1, 'weight-to-profit');
    child_sack_obj2 = sack(child_sack2_selection_list);
    child_sack_obj2 = modify_sack2(child_sack_obj2, 'weight-to-profit');
    % Paritally Mapped Crossover of tours
    tour_length = parent1.tour.size - 1;
    tour_permutation1 = parent1.tour.cities(1:tour_length);
    tour_permutation2 = parent2.tour.cities(1:tour_length);
	p1 = zeros(1,tour_length);
	p2 = zeros(1,tour_length);
	for i=1:tour_length
		p1(tour_permutation1(i))=i;
		p2(tour_permutation2(i))=i;
	end
	cxpoint1 = randi([1, tour_length]);
    cxpoint2 = randi([1, tour_length-1]);
    if(cxpoint2 >= cxpoint1)
        cxpoint2 = cxpoint2+1;
    else
        [cxpoint1, cxpoint2]=deal(cxpoint2, cxpoint1);
    end
    for i = cxpoint1:cxpoint2
        %keep track of selected values
        temp1 = tour_permutation1(i);
        temp2 = tour_permutation2(i);
        %swap the matched value
        [tour_permutation1(i), tour_permutation1(p1(temp2))] = deal(temp2, temp1);
        [tour_permutation2(i), tour_permutation2(p2(temp1))] = deal(temp1, temp2);
        % Position bookkeeping
        [p1(temp1), p1(temp2)] = deal(p1(temp2), p1(temp1));
        [p2(temp1), p2(temp2)] = deal(p2(temp2), p2(temp1));
    end%for
	
	
	%making child objects
    child_tour_obj1 = tour(tour_permutation1,coordinates);
    child_theif_obj1 = theif(child_tour_obj1,child_sack_obj1,parent1.z);
    child_theif_obj1 = child_theif_obj1.cal_obj();
    child_tour_obj2 = tour(tour_permutation2,coordinates);
    child_theif_obj2 = theif(child_tour_obj2,child_sack_obj2,parent2.z);
    child_theif_obj2 = child_theif_obj2.cal_obj();
    bee1 = child_theif_obj1;
    bee2 = child_theif_obj2;

end

