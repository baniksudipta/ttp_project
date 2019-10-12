function neighbour = getneighrand(theif_obj, nneighbour,capacity, items_weight , items_cost)
	%%neighbourhood generator function of binary array
    %nneighbour = number of neighbours
    if nargin<2
        nneighbour = 5;
    end
    neighbour = [];
    for i =1:nneighbour
        r = randi(theif_obj.tour.size-1,1,2); %cities to be swapped
        newtour = swap(theif_obj.tour, r);
        nflip = randi(length(theif_obj.sack.selection_list)); %number of bits to be flipped
        r = randi(length(theif_obj.sack.selection_list),1,nflip); %the bits to be flipped
        newsack = arrflip(theif_obj.sack,r ,items_weight , items_cost);
        newsack = modify_sack(newsack,theif_obj.tour.d_array,'weight-to-profit',capacity,items_weight ,items_cost);
                
        neighbour = [neighbour, theif(newtour,newsack,theif_obj.z)];
    end
end
function sck = arrflip(sck, r,items_weight , items_cost)
    list = sck.selection_list;
    for i=1:length(r)
        list(r(i)) = 1- list(r(i));
    end
    sck = sack(list , items_weight , items_cost);
end
function tr = swap(tr,r)
    temp = tr.cities(r(1));
    tr.cities(r(1)) = tr.cities(r(2));
    tr.cities(r(2)) = temp;
    tr.cities(end) = tr.cities(1);
end