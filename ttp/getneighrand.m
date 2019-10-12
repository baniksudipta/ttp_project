function neighbour = getneighrand(theif_obj, nneighbour)
	%%neighbourhood generator function of binary array
    %nneighbour = number of neighbours
    if nargin<2
        nneighbour = 5;
    end
	%{
    %bitflipinfo carries the information about which bit is flipped
	%corresponding to a neighbour
	neighbours = [];
	bitflipinfo = [];

	if (k==1||k==2)
		for i =1:floor(length(binarr)/k)
			new = arrflip(binarr, k*(i-1)+1, k*i);
			neighbours = [neighbours; new];
			%bitflipinfo = [bitflipinfo; i];
		end
	else 
		for i=1:length(binarr)
            r = rand(1,1);
			if r>0.5
				new = arrflip(binarr, i, i);
				neighbours = [neighbours; new];
			end
		end
	end
    %}
    neighbour = [];
    d_array = theif_obj.tour.d_array;
    for i =1:nneighbour
        r = randi(theif_obj.tour.size-1,1,2); %cities to be swapped
        newtour = swap(theif_obj.tour, r);
        nflip = randi(length(theif_obj.sack.selection_list)); %number of bits to be flipped
        r = randi(length(theif_obj.sack.selection_list),1,nflip); %the bits to be flipped
        newsack = arrflip(theif_obj.sack,r);
        newsack = modify_sack(newsack,d_array, 'weight-to-profit');
        neighbour = [neighbour, theif(newtour,newsack,theif_obj.z)];
    end
end
function sck = arrflip(sck, r)
    list = sck.selection_list;
    for i=1:length(r)
        list(r(i)) = 1- list(r(i));
    end
    sck = sack(list);
end
function tr = swap(tr,r)
    temp = tr.cities(r(1));
    tr.cities(r(1)) = tr.cities(r(2));
    tr.cities(r(2)) = temp;
    tr.cities(end) = tr.cities(1);
end