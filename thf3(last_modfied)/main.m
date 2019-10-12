%% ============DATA Read=========%
clc;
clear;
clear global;
%define tour tr from _tsp file
%define sack kp from _kp file


%--------------TSP--------------%

%{
PROBLEM NAME: 	a280-TTP
KNAPSACK DATA TYPE: bounded strongly corr
DIMENSION:	280
NUMBER OF ITEMS: 	279
CAPACITY OF KNAPSACK: 	259360
MIN SPEED: 	0.1
MAX SPEED: 	1
RENTING RATIO: 	48.89
%}

bestfound = inf;
dataset_name = 'berlin52'
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
capacity = 87591;%%%%%%%%----SACK---CAPACITY---%%%%%%%%%
items_weight = kp(:,3);
items_cost = kp(:,2);
nobject = length(kp);
z(kp(:,1)) = kp(:,4); %an array showing which item from which city (if z(i)==j, it means item i from city j)
z = diag(z);

%% ==================datasent specific parameters================%
global vmin vmax rent;
vmin = 0.1;     % Maximum Velocity
vmax = 1;       % Minimum Velocity
rent = 	5.64;  % RENTING--RATIO

%% =================PARAMETERS to local functions==========%
tabusize = 2*length(kp(:,3)); %10times of length of item numbers
%nimprv = 50;

%% =================Initialization of Theif Object===============%
global wghtbyprft score score_indices;
wghtbyprft = items_weight./items_cost;   %weight to profit ratio

r = randperm(length(tr));
tour_obj = tour(r, tr);
distance_array = tour_obj.dist_array(); %needed for modify_sack

x = rand(1,nobject)>0.5; %random binary vector initialization
sack_obj = sack(x);
sack_obj = modify_sack(sack_obj,distance_array, 'weight-to-profit');

theif_obj = theif(tour_obj,sack_obj,z);

%% ==================Beecolony Init===================%
global colonysize ;
colonysize = 16;
score = cell(1,colonysize); %score of each object in a specific tour plan
score_indices= cell(1,colonysize); %sorted index of score in a specific tour plan
limit = 6; %Abandonment limit
abandon = zeros(colonysize,1); %abandonment counter
theives = beecolony(theif_obj,colonysize,limit,abandon); % creating the initial population
start_time = tic();
iterations = 40; %% Iterations
count = 1;
bestbenefit = -Inf;
global tabulist tabulist2;
tabulist = cell(1,colonysize);
tabulist2 = cell(1,colonysize);
for i = 1:colonysize
    tabulist{i} = sack_obj;
    tabulist2{i} = theif_obj;
end
global vns;
vns = ones(1,colonysize);
conv_curv = [];
best_curv = [];


%% =========================ITERATION STARTS=====================%
prev_benefits = -Inf*ones(1,colonysize);
figure('position',[100,100,1000,500]);
theives = theives.sendemployed();
iter = 0;
while iter < iterations
    iter = iter+1;
    fprintf('\n|-----------------------------------------------------|');
    fprintf('\n|-----Hybrid:: Bee Colony :: iteration number: %3d----|', iter);
    fprintf('\n|-----------------------------------------------------|');
    
    now = tic();
    theives = theives.updt_employed('theif');%% Step_1
    updt_time = toc(now);
    fprintf('\n|----------Employed Bees Update Time = %d-------|', updt_time);
    theives = theives.sendonlookers(); %% Step_2
    
    count = count+1;
    iter_best = -Inf;
    for i=1:theives.colonysize
        cost = theives.employed(i).profit;
        benefits(i)= theives.employed(i).profit;
        %d=d+1;
        if cost>iter_best
            iter_best = cost;
        end
        if cost>bestbenefit
            besttour = theives.employed(i);
            bestbenefit = cost;
        end
    end

    conv_curv = [conv_curv, bestbenefit];
    best_curv = [best_curv, iter_best];
    subplot(1,2,1);
    plot(conv_curv,'LineWidth', 1.5);
    drawnow;
    hold on;
    plot(best_curv, 'g', 'LineWidth', 2);
    hold off;
    subplot(1,2,2);
    if iter>1
        stem(1:theives.colonysize, prev_benefits, 'MarkerFaceColor','red', 'LineWidth', 1, 'MarkerSize', 5);
    end
    hold on;
    prev_benefits = benefits;
    stem(1:theives.colonysize, benefits, 'MarkerFaceColor','green', 'LineWidth', 1, 'MarkerSize', 5);
    drawnow;

    theives = theives.sendscouts(); %__step 3
    
    
    if bestbenefit>=bestfound
        break;
    end
    fprintf('!!!!!! BEST BENEFIT !!!!! = %d',bestbenefit);
end

%% Results
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
