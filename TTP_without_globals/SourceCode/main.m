clc;
clear;
clear global;
%============DATA Read=========%
bestfound = inf; %18740%
dataset_name = 'eil76_n75_bsc2';
%{
PROBLEM NAME: 	eil76-TTP
KNAPSACK DATA TYPE: bounded strongly corr 02
DIMENSION:	76
NUMBER OF ITEMS: 	75
CAPACITY OF KNAPSACK: 	11560
MIN SPEED: 	0.1
MAX SPEED: 	1
RENTING RATIO: 	13.01
%}

%% ----------TSP-----------%%
file = fopen(strcat(dataset_name,'_tsp.txt'),'r');%%%%%%%%%%%%%%
tr = fscanf(file, '%f', [3 Inf]);
fclose(file);
tr = tr(2:3, :)';
%global coordinates city_dist ncity;
coordinates = tr;
city_dist = pdist2(tr,tr);
ncity = length(tr);

%% ----------------KP-------------%%
file = fopen(strcat(dataset_name,'_kp.txt'),'r');%%%%%%%%%%%%%%%
kp = fscanf(file, '%f', [4 Inf]);
fclose(file);
kp = kp';
%global z items_weight items_cost nobject;%%%%%%%%%%%%%%%% KP Constants
items_weight = kp(:,3);
items_cost = kp(:,2);
nobject = length(kp);% total number of items
z(kp(:,1)) = kp(:,4); %an array showing which item from which city (if z(i)==j, it means item i from city j)

%% TTP Dataset Specific Parameters===================================================%
%global vmin vmax rent capacity;
vmin = 0.1;
vmax = 1;
rent = 		13.01;
capacity =  11560;

%% =================PARAMETERS to local search functions==========%
tabusize = round(0.5*length(kp)); %10times of length of item numbers
%nimprv = 50;

%% =================Create Bee Colony===============%
%global colonysize wghtbyprft limit;
colonysize = 10;                        % BeeColonySize
limit = 6;                              % Abandonment limit
wghtbyprft = items_weight./items_cost;  % weight to profit ratio


for i=1:colonysize
    r = randperm(length(tr));
    tour_obj = tour(r, coordinates,city_dist,z,wghtbyprft , nobject);
    distance_array = tour_obj.dist_array(city_dist , z , wghtbyprft , nobject); %needed for modify_sack

    x = rand(1,nobject)>0.5; %random binary vector initialization
    sack_obj = sack(x,items_weight , items_cost);
    sack_obj = modify_sack(sack_obj,distance_array, 'weight-to-profit',capacity,items_weight ,items_cost);

    theif_obj = theif(tour_obj,sack_obj,z);
    theif_obj = theif_obj.cal_obj(items_weight,items_cost,city_dist,vmax,vmin,rent,capacity);
    bees(i).theif = theif_obj;
    bees(i).abandon = 0;
    bees(i).tabulist = sack_obj;
    bees(i).tabulist2 = theif_obj;
    bees(i).vns = 1;
    bees(i).index = i;
end 

start_time = tic();
iterations = 400;
bestbenefit = -Inf;

conv_curv = [];
best_curv = [];


%% =========================ITERATION STARTS=====================%
prev_benefits = -Inf*ones(1,colonysize);
figure('position',[100,100,1000,500]);

p = gcp('nocreate'); % If no pool, do not create new one.
poolsize = 0;

iter = 0;
while(iter < iterations)
    iter = iter+1;
    
    if ~isempty(p)
        poolsize = p.NumWorkers;
    end
    iter_start_time = tic();
    fprintf('\n|-----------------------------------------------------|');
    fprintf('\n|-----Hybrid:: Bee Colony :: iteration number: %3d----|', iter);
    fprintf('\n|------------------   %2d  ---------------------------|',poolsize);
    
    
    bees = updt_employed(bees,colonysize,items_weight,items_cost,city_dist,vmax,vmin,rent,capacity,z,wghtbyprft , nobject);
    
    bees = sendonlookers(bees,colonysize,limit,items_weight,items_cost,city_dist,vmax,vmin,rent,capacity,z,wghtbyprft , nobject);
                        
    bees = sendscouts(bees,limit,coordinates,colonysize,items_weight,items_cost,city_dist,vmax,vmin,rent,capacity,z,wghtbyprft , nobject);
    
    
    fprintf('\n     Iter TIME:  %4d S\n',uint64(toc(iter_start_time)));
    %% Plotting
    iter_best = -Inf;
    benefits = zeros(1,colonysize);
    for i=1:colonysize
        
        benefits(i)= bees(i).theif.profit;
        if benefits(i) >iter_best
            iter_best = benefits(i);
        end
        if benefits(i) >bestbenefit
            besttour = bees(i).theif;
            bestbenefit = benefits(i);
        end
    end
    conv_curv = [conv_curv, bestbenefit];
    best_curv = [best_curv, iter_best];
    subplot(1,2,1);
    plot(conv_curv,'LineWidth', 1.6);
    drawnow;
    hold on;
    plot(best_curv, 'r', 'LineWidth', 2);
    hold off;
    subplot(1,2,2);
    if iter>1
        stem(1:colonysize, prev_benefits, 'MarkerFaceColor','red', 'LineWidth', 1, 'MarkerSize', 4);
    end
    hold on;
    prev_benefits = benefits;
    stem(1:colonysize, benefits, 'MarkerFaceColor','black', 'LineWidth', 1, 'MarkerSize', 4);
    xlabel(num2str(bestbenefit));
    drawnow;
    
    
    
    
    if bestbenefit>=bestfound
        break;
    end
end
runtime = toc(start_time);

secs = uint64(runtime);
hr = secs/3600;
minute = (hr*3600 - secs)/60;
secs = mod(secs,60);
fprintf('\ntotal runtime = %d hr %d min %d sec\n', hr,minute,secs);
fprintf('\nbest  benefit = %d\n', uint64(bestbenefit));

if(input('Plot Tour ? 1 : 0 -->') == 1)
    tr = besttour.tour;
    figure;
    for li=1:tr.size-1
        plot([tr.coordinates(tr.cities(li),1),tr.coordinates(tr.cities(li+1),1)],...
            [tr.coordinates(tr.cities(li),2),tr.coordinates(tr.cities(li+1),2)]);
        hold on;
    end
end

if(input('Save workspace ? 1 : 0 -->')==1)
    save(strcat(dataset_name,'__',num2str(bestbenefit),'.mat'));
end
