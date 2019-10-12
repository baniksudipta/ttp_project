classdef theif
    properties
        tour;
        sack;
        profit;%out
        Wend;%out
        gain;%out
        time;%out
        z; %z diagonal matrix
    end
    
    methods
        function theif = theif(tour, sack, z)
            theif.tour = tour;
            theif.sack = sack;
            theif.z = z;
        end
        
        function obj = cal_obj(obj,items_weight,items_cost,city_dist,vmax,vmin,rent,capacity)
            sck = obj.sack;
            tr = obj.tour; % the tour 
            %tmp_z = (diag(diag(sck.selection_list)*obj.z))'; <--old
            tmp_z = sck.selection_list.*obj.z; % <--new 
            [obj.gain,obj.time,obj.profit,obj.Wend] = TTP1Objective(tr.cities,tmp_z,items_weight,items_cost,city_dist,vmax,vmin,rent,capacity);
        end
       
    end
end
