function sack_obj = modify_sack(sack_obj,score_indices,string)
    global capacity;
    if strcmp(string, 'weight-to-profit')
        index = length(score_indices);
        nn = length(score_indices);
        
        r = rand;
        if(r>0.2)
            while(sack_obj.weight> capacity)
            
                if sack_obj.selection_list(score_indices(index))
                    sack_obj.selection_list(score_indices(index)) = 0; %items are neglected as per their detrimental ratio of weight to profit
                    sack_obj = sack_obj.modify_weight_cost(score_indices(index));
                end
                index = index-1;
                if(index == 0)
                    break;
                end 
            end %endwhile
        else
           while(sack_obj.weight> capacity)
                random_index = randi(nn);
                if sack_obj.selection_list(random_index)
                    sack_obj.selection_list(random_index) = 0; 
                    sack_obj = sack_obj.modify_weight_cost(random_index);
                end
            end %endwhile
        end
    end %weight-to-profit


    if strcmp(string, 'random')
        while(sack_obj.weight>capacity)
            index = randi(length(sack_obj.selection_list));
            if sack_obj.selection_list(index)
                sack_obj.selection_list(index) = 0; %items are neglected as per their detrimental ratio of weight to profit
            end
            sack_obj = sack_obj.cal_weight();
            %fprintf('\n%d',sack_obj.weight)
        end
        sack_obj = sack_obj.cal_cost();
    end

end