classdef tour
    %'tour' Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
      cities; % 1 x m+1 array
      size
      coordinates;
      cost;
      d_array;%an m x 1 array, each entry of array being the distance to
        %travel from that city point to the end
    end
    
    methods
        function obj = tour(tr,coordinates)
            if nargin>0
                %if isnumeric(tr)
                    obj.cities = tr;
                    obj.cities = [obj.cities obj.cities(1)];
                    obj.coordinates = coordinates;
                    obj.coordinates = [obj.coordinates;obj.coordinates(1,:)];
                    obj.size = length(tr)+1;
                   
                    obj.cost = cal_cost(obj);
                    obj.d_array = dist_array(obj);
                %else error('dTypeError: values must be numeric');
                %end
            end
        end
        
        function obj = recostDP(obj,p1,p2,p3,p4)
            global city_dist;
            obj.cost = obj.cost - city_dist(p1,p2) - city_dist(p3,p4) + city_dist(p1,p3) + city_dist(p2,p4);
            
            %obj.d_array(p1) = obj.d_array(p1) - city_dist(p1,p2) - city_dist(p3,p4) + city_dist(p1,p3) + city_dist(p2,p4);
            %obj.d_array(p3) = obj.d_array(p1) - city_dist(p1,p3);
            %obj.d_array(p4) = obj.d_array(p4);
            %obj.d_array(p2) = obj.d_array(p4) + city_dist(p2,p4);
            obj.d_array = obj.dist_array();
            %--------------------------%
            % primary:          after 2opt:
            % p1-->|___|<--p3  |  p1---->p3
            % p4<--|   |-->p2  |  p4<----p2
        end
        
        function obj = recost(obj)
            global city_dist;
            cst = 0;
            for i=1:obj.size-1
                cst = cst + city_dist(obj.cities(i),obj.cities(i+1));
            end
            obj.cost=cst;
            obj.d_array = obj.dist_array();
            %cst = cst + pdist2(obj.cities(obj.size,:),obj.cities(1,:));
        end
        
        %array: an ncity x 1 array, each entry of array being the distance to
        %travel from that city point to the end
        %indices: an nobject x 1 array showing sorted index of scores of
        %being selected
        function indices = dist_array(obj)
            global city_dist z wghtbyprft nobject
            array(obj.cities(obj.size))=0;
            for i=obj.size-1:-1:1
                array(obj.cities(i))=array(obj.cities(i+1))+city_dist(obj.cities(i),obj.cities(i+1)); 
            end
            a = diag(z);
            for i=1:nobject
                score(i) = wghtbyprft(i)*array(a(i));
            end
            [~, indices] = sort(score);
            
        end
    end
    
end

function cst = cal_cost(obj)
    global city_dist;
    cst = 0;
    for i=1:obj.size-1
        cst = cst + city_dist(obj.cities(i),obj.cities(i+1));
    end
end