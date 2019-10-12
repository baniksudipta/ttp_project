%============DATA Read=========%
clc;
clear;
clear global;
%define tour tr from _tsp file
%define sack kp from _kp file


%--------------TSP--------------%

%{
PROBLEM NAME: 	eil51-TTP
KNAPSACK DATA TYPE: uncorr-similar-weights-06
DIMENSION:	51
NUMBER OF ITEMS: 	50
CAPACITY OF KNAPSACK: 	13774
MIN SPEED: 	0.1
MAX SPEED: 	1
RENTING RATIO: 	31.84
best 9952
%}
bestfound = 19348;
dataset_name = 'a280';
file = fopen(strcat(dataset_name,'_tsp.txt'),'r');%%%%%%%%%%%%%%
tr = fscanf(file, '%f', [3 Inf]);
fclose(file);
tr = tr(2:3, :)';
global coordinates city_dist ncity;
coordinates = tr;
city_dist = pdist2(tr,tr);
ncity = length(tr);

%----------------KP-------------%
file = fopen(strcat(dataset_name,'_kp.txt'),'r');%%%%%%%%%%%%%%%
kp = fscanf(file, '%f', [4 Inf]);
fclose(file);
kp = kp';
global z capacity items_weight items_cost nobject;%%%%%%%%%%%%%%%% KP Constants
capacity = 12718;%%%%%%%%%%%%%%%%%
items_weight = kp(:,3);
items_cost = kp(:,2);
nobject = length(kp);
z(kp(:,1)) = kp(:,4); %an array showing which item from which city (if z(i)==j, it means item i from city j)
z = diag(z);

%===================================================%
global vmin vmax rent;%%%%%%%%%%%%% datasent specific parameters
vmin = 0.1;%%%%%%%%%%%%%%%
vmax = 1;%%%%%%%%%%%%%%%
rent = 	5.93;%%%%%%%%%%%%%%%%%%      RENTING RATIO %%%%%%%%%%%%%%%%%

%=================PARAMETERS to local functions==========%
tabusize = 2*length(kp(:,3)); %10times of length of item numbers
%nimprv = 50;

%=================Initialization===============%
global colonysize ;
colonysize = 20;
global wghtbyprft score score_indices;
wghtbyprft = items_weight./items_cost;   %weight to profit ratio
for i=1:colonysize
    r = randperm(length(tr));
    tour_obj = tour(r, tr);
    distance_array = tour_obj.dist_array(); %needed for modify_sack

    x = rand(1,nobject)>0.5; %random binary vector initialization
    sack_obj = sack(x);
    sack_obj = modify_sack(sack_obj,distance_array, 'weight-to-profit');

    theif_obj = theif(tour_obj,sack_obj,z);
    theif_obj = theif_obj.cal_obj();
    bees(i).theif = theif_obj;
    bees(i).abandon = 0;
    bees(i).tabulist = sack_obj;
    bees(i).tabulist2 = theif_obj;
    bees(i).vns = 1;
end
%==================Beecolony===================%
score = cell(1,colonysize); %score of each object in a specific tour plan
score_indices= cell(1,colonysize); %sorted index of score in a specific tour plan
global limit 
limit = 6; %Abandonment limit

start_time = tic();
iterations = 100;
count = 1;
bestbenefit = -Inf;

conv_curv = [];
best_curv = [];


%=========================ITERATION STARTS=====================%
prev_benefits = -Inf*ones(1,colonysize);
figure('position',[100,100,1000,500]);
%theives = theives.sendemployed();
%for iter = 1:iterations
iter = 0;
while(1)
    iter = iter+1;
    fprintf('\n|-----------------------------------------------------|');
    fprintf('\n|-----Hybrid:: Bee Colony :: iteration number: %d-----|', iter);
    fprintf('\n|-----------------------------------------------------|');
    
    now = tic();
    bees = updt_employed(bees,'theif');
    updt_time = toc(now);
    fprintf('\n|----------Employed Bees Update Time = %d-------|', updt_time);
    bees = sendonlookers(bees);
    
    count = count+1;
    iter_best = -Inf;
    for i=1:theives.colonysize
        cost = bees(i).theif.profit;
        benefits(i)= bees(i).theif.profit;
        %d=d+1;
        if cost>iter_best
            iter_best = cost;
        end
        if cost>bestbenefit
            besttour = bees(i).theif;
            bestbenefit = cost;
        end
    end
    conv_curv = [conv_curv, bestbenefit];
    best_curv = [best_curv, iter_best];
    %figure(1);
    subplot(1,2,1);
    plot(conv_curv,'LineWidth', 1.5);
    %xlim([1, iterations]);
    drawnow;
    hold on;
    plot(best_curv, 'g', 'LineWidth', 2);
    hold off;
    
    %figure(2);
    subplot(1,2,2);
    if iter>1
    stem(1:colonysize, prev_benefits, 'MarkerFaceColor','red', 'LineWidth', 2, 'MarkerSize', 10);
    end
    hold on;
    prev_benefits = benefits;
    %find_drop = find(benefits<prev_benefits);
    stem(1:colonysize, benefits, 'MarkerFaceColor','black', 'LineWidth', 2, 'MarkerSize', 10);
    drawnow;
    %hold off;
    
    bees = sendscouts(bees);
    
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
%plot(benefits);

ch = input('Plot Tour ? 1 : 0 -->');
if(ch == 1)
    tr = besttour.tour;
    figure;
    for li=1:tr.size-1
        plot([tr.coordinates(tr.cities(li),1),tr.coordinates(tr.cities(li+1),1)],...
            [tr.coordinates(tr.cities(li),2),tr.coordinates(tr.cities(li+1),2)]);
        hold on;
    end
end

ch = input('Save workspace ? 1 : 0 -->');
if(ch==1)
    save(strcat('last_run',num2str(bestbenefit),'.mat'));
end
