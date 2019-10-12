classdef sack
   
    properties
        weight;
        cost;
        selection_list;
    end
    
    methods
        %--------------%
        %-----INIT-----%
        %--------------%
        function obj = sack(selectionList)
            
            obj.selection_list = selectionList;
            obj = cal_weight(obj);
            obj = cal_cost(obj);
            
        end
        %-------Calculate_weight-------%
        function obj = cal_weight(obj)
            global items_weight;
            obj.weight = obj.selection_list * items_weight;
        end
        %-------Calculate_cost--------%
        function obj = cal_cost(obj)
            global items_cost;
            obj.cost = obj.selection_list *items_cost;
        end
        
        function obj = recal_weight(obj, obj2, item_weight, cond)
            if cond
                obj.weight = obj2.weight - item_weight;
            else obj.weight = obj2.weight + item_weight;
            end
        end
        
        
        function obj = recal_cost(obj, obj2, item_cost, cond)
            if cond
                obj.cost = obj2.cost - item_cost;
            else obj.cost = obj2.cost + item_cost;
            end
        end
        
        
        %--------------------------%
        %----------Modify----------%
        %-----Weight-&-Cost--------%
        %--------------------------%
        function obj = modify_weight_cost(obj,removed_item_index)
            global items_weight items_cost;
            obj.weight = obj.weight - items_weight(removed_item_index);
            obj.cost = obj.cost - items_cost(removed_item_index);
        end
        
        
    end
end