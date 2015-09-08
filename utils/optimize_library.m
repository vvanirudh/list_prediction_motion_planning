function [ optim_library ] = optimize_library(library, cost_map )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here


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

for i = 1:length(library)
    [cost_traversal, ~, cost_history, traj_history] = covariant_gradient_descent( library{i}.traj, c_final, grad_final, chomp_options );
    [optim_library{i}.cost, idx] = min(cost_history);
    optim_library{i}.traj = traj_history(idx).x;
    optim_library{i}.traj_history = traj_history;
end


end

