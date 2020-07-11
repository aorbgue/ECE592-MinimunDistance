function [NC_city_names, NC_city_array, NC_city_array_H] = data_retrieval(filename, upper_dist)
% Reading File
NC_map_table = readtable(filename);
NC_city_size = size(NC_map_table); % Length of NC_map
% Converting distances to array
NC_city_array = table2array(NC_map_table(1:NC_city_size(1),2:NC_city_size(2)));
% Converting cities names to vector
NC_city_names = table2array(NC_map_table(:,1));
% Data Preprocessing
% Replacing NaN values in NC matrix by 0
NC_city_array(isnan(NC_city_array))=0;
% Creating auxiliary distances array for Heuristics
NC_city_array_H=NC_city_array;
% Replacing values greater than upper distance by Inf
NC_city_array(NC_city_array > upper_dist) = Inf;