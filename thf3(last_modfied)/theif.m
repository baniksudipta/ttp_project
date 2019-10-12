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
        
        function obj = cal_obj(obj)
            sck = obj.sack;
            tr = obj.tour; % the tour 
            tmp = (diag(diag(sck.selection_list)*obj.z))'; 
            
            [obj.gain,obj.time,obj.profit,obj.Wend] = TTP1Objective(tr.cities,tmp);
        end
       
    end
end
