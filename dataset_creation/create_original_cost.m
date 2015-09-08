clc
clear 
close all

library_path = '../dataset/library/';
cost_data_set = '../dataset/env_cost_map_dataset/';
output_data_set = '../dataset/original_cost_dataset/';


listing = dir(fullfile(cost_data_set,'cost_map*.mat'));
L = 100; % library size

load(strcat(library_path,'library.mat'), 'library');
 
for i = 1:length(listing)
    i
    load(strcat(cost_data_set,'cost_map_',num2str(i),'.mat'), 'cost_map');
    
    p_start = [0 0];
    p_goal = [1 1];

    n = 100;
    eta = 2000;
    max_iter = 100;
    lambda = 1;
    w_obs = 100;
    min_iter = 10;
    min_cost_improv_frac = 1e-5;
    decrease_wt = 1;


    [ A, b, c ] = smooth_matrices( p_start, p_goal, n - 2);
    M = A;
    f_smooth = @(xi) cost_smooth( xi, A, b, c);

    c_scalar_obs_fn = @(xi) cost_obs( xi, cost_map, p_start );

    c_final = @(xi, xi_der) lambda*f_smooth(xi) + w_obs*c_scalar_obs_fn(xi);
    c_final_xi = @(xi) lambda*f_smooth(xi) + w_obs*c_scalar_obs_fn(xi);

    original_cost_library = [];
    for j = 1:length(library)
        original_cost_library = [original_cost_library; c_final_xi(library{j}.traj(2:(end-1),:))];
    end
    save(strcat(output_data_set, 'original_cost_library_',num2str(i),'.mat'), 'original_cost_library');
end