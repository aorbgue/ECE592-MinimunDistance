function [miles, Route] = s_path_A(NC_city_names,NC_city_array,NC_city_array_H,start_city,end_city)
%% Parameters
%% Main Variables
NC_city_size = size(NC_city_array);
NC_city_cost = Inf*ones(NC_city_size(1),1); % Saves the minimum distance from a given city to the start city
NC_city_unvisit = NC_city_names; % Saves the unvisited cities
NC_city_previous = strings(NC_city_size(1),1); % Saves the previous city from which the distance to start city is minimum 
No_path = false; % Verifies if there is a path between start and end cities
%% Algorithm Init
actual_city = start_city; % Start city is Actual city
NC_city_cost(strcmp(NC_city_names,actual_city)) = 0; % Actual city initialized with 0 cost
%% Calculating Heuristics
city_h_idx = strcmp(NC_city_names,end_city); % end city index (For Heuristics)
city_h = NC_city_array_H(:,city_h_idx); % Heuristics vector for end city
%% LOOP over all Table Cities, STOPS when end_city is reached
for idy = 1:length(NC_city_names)
    %% LOOP over all cities connected to actual city
    % Verifies if actual distance from start city is less than current one
    % in each city connected to actual city
    city_idx = find(strcmp(NC_city_names,actual_city)); % Actual city index
    city_g = NC_city_array(:,city_idx); % Internal variable to store all distances between vector of Actual city
    for idx = 1:length(city_g)
        cityIsUnvisited = find(strcmp(NC_city_unvisit,NC_city_names{idx})); % Verify if city is unvisited
        if (cityIsUnvisited ~= 0)    
            if ((city_g(idx)~=Inf)&&(idx~=city_idx))
                if (NC_city_cost(city_idx)+city_g(idx)+city_h(idx)<NC_city_cost(idx))
                    NC_city_cost(idx) = NC_city_cost(city_idx)+city_g(idx);
                    NC_city_previous(idx) = NC_city_names(city_idx);
                end
            end
        end        
    end
    %% Removing actual city from unvisted array
    NC_city_unvisit{city_idx} = '';
    %% Finds unvisited city with lowest distance from start city and updates actual city
    NC_city_cost_temp = NC_city_cost+city_h; % Auxiliary copy of city distances vector plus heuristics distance    
    NC_city_cost_temp(not(~cellfun(@isempty,NC_city_unvisit)))=Inf; % All unvisited cities get Inf value in auxiliary distance vector
    [~, dist_min_idx] = min(NC_city_cost_temp);
    actual_city = NC_city_names{dist_min_idx}; % City with lowest distance is actual city     
    %% STOP Conditions
    % If end_city is reached
    if (strcmp(actual_city,end_city))
        break
    end
    % If not possible to find shortest path
    No_path = sum(isinf(NC_city_cost_temp))==length(NC_city_cost_temp); % Verifies if all elements of vector are Inf
    if (No_path)
        miles=-1;
        Route=-1;
        break
    end
end
%% Calculating ROUTE and MILES
% If exists a PATH
if (not(No_path))
    % Calculating Miles
    city_idx = strcmp(NC_city_names,end_city);
    miles = NC_city_cost(city_idx);
    % Calculating Route
    Route = [];
    city = end_city;
    while (not(strcmp(city,start_city)))
        city_idx = strcmp(NC_city_names,city);
        Route =[Route,city];
        city = NC_city_previous(city_idx);
    end
    Route =[Route,city];
    Route = fliplr(Route);
end