function theif_obj = LinKernighan(theif_obj, iterations, bee_number)
    
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
                        newtour = newtour.recostDP(i,i+1,j,1);
                    else
                        newtour = newtour.recostDP(i,i+1,j,j+1);
                    end
                    newtheif = theif(newtour,theif_obj.sack,theif_obj.z);
                    newtheif = newtheif.cal_obj();
                    if(newtheif.profit > bestprofit)
                        theif_obj = newtheif;
                        tour_obj = newtour;
                        bestprofit = theif_obj.profit;
                    end

                end
            end


        end

    fprintf('\n Bee number= %d', bee_number);
    fprintf(' Two_opt:iter: %d Bestcost= %d', iter, bestprofit);

    end


    %{
    tr = tour_obj.cities;
    figure;
    scatter(tour.cities(:,1),tour.cities(:,2))
    txt=(1:tour.size)';
    txt=num2str(txt);
    txt=cellstr(txt);
    text(tour.cities(:,1),tour.cities(:,2),txt)
    hold on;
    for li=1:tour.size-1
        plot([tour.cities(li,1),tour.cities(li+1,1)],[tour.cities(li,2),tour.cities(li+1,2)])
    end
    %}


end