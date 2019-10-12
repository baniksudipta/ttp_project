function neighbours = getneighbourhood(binarr, k)
    %Helper Function of TabuSearch
	%%neighbourhood generator function of binary array
	%bitflipinfo carries the information about which bit is flipped
	%corresponding to a neighbour , [neighbours, bitflipinfo]
	
    neighbours = [];
	if (k<3)
		for i =1:floor(length(binarr)/k)
			new = arrflip(binarr, k*(i-1)+1, k*i);
			neighbours = [neighbours; new];
		end
	else 
		for i=1:length(binarr)
			if rand(1,1)>0.5
				new = arrflip(binarr, i, i);
				neighbours = [neighbours; new];
			end
		end
	end
end
function arr = arrflip(arr, a, b)
    for i=a:b
        arr(i) = 1- arr(i);
    end
end
