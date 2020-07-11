%% 2) Data Retrieval
%% Parameters
filename = 'NC.csv';
upper_dist = 70;
%% Gets city table, city names, city distances 
[NC_city_names, NC_city_array, NC_city_array_H] = data_retrieval(filename,upper_dist);
%% 3) Dikjstra algorithm for 4 pairs of cities
% Parameters
start_cities = ["Murphy","Sparta","Tabor City","Andrews"];
end_cities = ["Elizabeth City","Nags Head","Eden","Surf City"];
% Variables
Miles_A = zeros(1,length(start_cities));
Routes_A = string(zeros(length(start_cities),25));
% Loop for each city
for i=1:length(start_cities)
    cityA = start_cities(i);
    cityB = end_cities(i);
    [Miles_A(i),R] = s_path_D(NC_city_names,NC_city_array,cityA,cityB);
    Routes_A(i,1:length(R))=R;
end
%% 4) Analysis
%% a) Verify Dikjstra Algorithm empirically
% Parameters
Num = 40; % Number random cities
start_cities_E = repmat("Nags Head",1,Num);
end_cities_E = NC_city_names(floor((length(NC_city_names)-1)*rand(1,Num))+1);
% Variables
Miles_DE = zeros(1,length(start_cities_E));
Routes_DE = string(zeros(length(start_cities_E),20));
time_D = zeros(1,length(start_cities_E));
% Loop for each city
for i=1:length(start_cities_E)
    cityA = start_cities_E(i);
    cityB = end_cities_E(i);
    tic % Start Time
    [Miles_DE(i),R] = s_path_D(NC_city_names,NC_city_array,cityA,cityB);
    time_D(i) = toc; % End Time 
    Routes_DE(i,1:length(R))=R;
end
%% PLOT
% Reordering in increasing distance and eliminating repeated cities for visualization
[ord_dist,ord] = sort(Miles_DE);
time_D_ord = time_D(ord);
[unq_dist,unqA,unqB] = unique(ord_dist);
time_D_unq = time_D_ord(unqA);
% PLOT
figure(1)
plot(unq_dist,time_D_unq,'o-');
title("Time Complexity")
xlabel("Distance (Miles)")
ylabel("Time (s)")
%% b) A* algorithm for 4 pairs of cities
% Parameters
start_cities = ["Murphy","Sparta","Tabor City","Andrews"];
end_cities = ["Elizabeth City","Nags Head","Eden","Surf City"];
% Variables
Miles_A = zeros(1,length(start_cities));
Routes_A = string(zeros(length(start_cities),25));
% Loop for each city
for i=1:length(start_cities)
    cityA = start_cities(i);
    cityB = end_cities(i);
    [Miles_A(i),R] = s_path_A(NC_city_names,NC_city_array,NC_city_array_H,cityA,cityB);
    Routes_A(i,1:length(R))=R;
end
%% c) Verify A* and Dikjstra Algorithms Computational Time
% Parameters: Same Parameters as Dikjstra Algorithm (section a)
% Variables
Miles_AE = zeros(1,length(start_cities_E));
Routes_AE = string(zeros(length(start_cities_E),20));
time_A = zeros(1,length(start_cities_E));
% Loop for each city
for i=1:length(start_cities_E)
    cityA = start_cities_E(i);
    cityB = end_cities_E(i);
    tic % Start Time
    [Miles_AE(i),R] = s_path_A(NC_city_names,NC_city_array,NC_city_array_H,cityA,cityB);
    time_A(i) = toc; % End Time 
    Routes_AE(i,1:length(R))=R;
end
%% PLOT
% Reordering in increasing distance and eliminating repeated cities for visualization
time_A_ord=time_A(ord);
time_A_unq=time_A_ord(unqA);
% PLOT
figure(2)
plot(unq_dist,time_D_unq,'o-');
hold on
plot(unq_dist,time_A_unq,'o-');
title("Time A* vs Dikjstra")
xlabel("Distance (Miles)")
ylabel("Time (s)")
legend('Dijkstra','A*')