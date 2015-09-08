clc
clear 
close all

library_path = '../dataset/library/';
cost_data_set = '../dataset/env_cost_map_dataset/';


listing = dir(fullfile(cost_data_set,'cost_map*.mat'));
L = 100; % library size

load(strcat(library_path,'library.mat'), 'library');
 
i = 251;
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
grad_smooth = @(xi) fsmooth(xi, A, b);  

c_scalar_obs_fn = @(xi) cost_obs( xi, cost_map, p_start );
[ cost_map_x, cost_map_y] = get_cost_map_derivatives( cost_map );
grad_fobs = @(xi) gradient_obs( xi, cost_map, cost_map_x, cost_map_y, p_start );

c_final = @(xi, xi_der) lambda*f_smooth(xi) + w_obs*c_scalar_obs_fn(xi);
c_final_xi = @(xi) lambda*f_smooth(xi) + w_obs*c_scalar_obs_fn(xi);
grad_final = @(xi, xi_der) lambda*grad_smooth(xi) + w_obs*grad_fobs(xi);
chomp_options = v2struct(eta, max_iter, lambda, w_obs, min_iter, min_cost_improv_frac, M, decrease_wt);

cost_library = [];
for j = 1:length(library)
    [cost_traversal, ~, cost_history, traj_history] = covariant_gradient_descent( library{j}.traj, c_final, grad_final, chomp_options );
    cost_library = [cost_library; min(cost_history)];
    traj_history_lib{j} = traj_history;
end
    
[~, sorted_id] = sort(cost_library);

for i = 1:length(sorted_id)
    idx = sorted_id(i);
    figure;
    hold on;
    visualize_cost_map(library{idx}.cost_map);
    plot(library{idx}.traj(:,1), library{idx}.traj(:,2));
    
    figure;
    hold on;
    visualize_cost_map(cost_map);
    plot(library{idx}.traj(:,1), library{idx}.traj(:,2));
    
    figure;
    hold on;
    visualize_cost_map(cost_map);    
    traj_history = traj_history_lib{idx};
    cc=hsv(3*size(traj_history,1));
    for i = 1:size(traj_history,1)
        if (i==1)
            plot(traj_history(i).x(1,:), traj_history(i).x(2,:),'color',cc(i,:),'LineWidth', 3, 'LineStyle', '--');
        elseif (i == size(traj_history,1))
            plot(traj_history(i).x(1,:), traj_history(i).x(2,:),'color',cc(i,:),'LineWidth', 3);
        else
            plot(traj_history(i).x(1,:), traj_history(i).x(2,:),'color',cc(i,:),'LineWidth', 1, 'LineStyle', ':')
        end
        %plot(traj_history(i).x(1,:), -traj_history(i).x(3,:),'color',cc(i,:))
    end
    pause
    close all
end

