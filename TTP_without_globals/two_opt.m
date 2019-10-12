function theif_obj = two_opt(theif_obj, iterations, ~,items_weight,items_cost,city_dist,vmax,vmin,rent,capacity,z,wghtbyprft , nobject)
    
    tour_obj = theif_obj.tour;
    newtour = tour_obj;
    bestprofit = theif_obj.profit;
    for iter=1: iterations
       for i = 1:tour_obj.size-2
            for j = i+1:tour_obj.size-1
                if crosscheck(...
                            tour_obj.coordinates(tour_obj.cities(i),:),...
                            tour_obj.coordinates(tour_obj.cities(i+1),:),...
                            tour_obj.coordinates(tour_obj.cities(j),:),...
                            tour_obj.coordinates(tour_obj.cities(j+1),:)...
                        )
                    newtour.cities = two_opt_swap(tour_obj.cities, tour_obj.size, i+1, j);

                    if(j== (tour_obj.size-1))
                        newtour = newtour.recostDP(i,i+1,j,1,city_dist,z , wghtbyprft , nobject);
                    else
                        newtour = newtour.recostDP(i,i+1,j,j+1,city_dist,z , wghtbyprft , nobject);
                    end
                    newtheif = theif(newtour,theif_obj.sack,theif_obj.z);
                    newtheif = newtheif.cal_obj(items_weight,items_cost,city_dist,vmax,vmin,rent,capacity);
                    if(newtheif.profit > bestprofit)
                        theif_obj = newtheif;
                        %bestprofit = theif_obj.profit;
                    end

                end
            end

        end

    %fprintf('\n Bee number= %d', abc);
    %fprintf(' Two_opt:iter: %d Bestcost= %d', iter, bestprofit);

    end
end
%% Helper Functions
function out = crosscheck(point1, point2, point3, point4)
    %point1---->point2   point3---->point4

    %line1: u1x+v1y=w1
    u1 = point2(2)-point1(2);
    v1 = point1(1)-point2(1);
    w1 = det([point1(1), point1(2); point2(1), point2(2)]);

    %line2: u2x+v2y=w2
    u2 = point4(2)-point3(2);
    v2 = point3(1)-point4(1);
    w2 = det([point3(1), point3(2); point4(1), point4(2)]);

    %intersection of L1 and L2
    if det([u1 v1; u2 v2])==0
        out = false;
    else
        x = det([v2 v1;w2 w1])/det([u1 v1; u2 v2]);
        y = det([u1 u2;w1 w2])/det([u1 v1; u2 v2]);
        out = (pdist2([x,y],point1)<pdist2(point2,point1))&&(pdist2([x,y],point3)<pdist2(point4,point3));
    end
    %out = false for no cross and vice-versa
end

function temp = two_opt_swap(cities, size, a, b)
    temp = cities(1:a-1);
    temp = [temp cities(b:-1:a)];
    temp = [temp cities(b+1:size)];
end