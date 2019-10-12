function sack_obj = modify_sack2(sack_obj, string)
    global capacity wbp_indices;
    if strcmp(string, 'weight-to-profit')
        index = max(wbp_indices);
        nn = max(wbp_indices);
        
        r = rand;
        if(r>0.25)
            while(sack_obj.weight> capacity)
            
                if sack_obj.selection_list(wbp_indices(index))
                    sack_obj.selection_list(wbp_indices(index)) = 0; %items are neglected as per their detrimental ratio of weight to profit
                    sack_obj = sack_obj.modify_weight_cost(wbp_indices(index));
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