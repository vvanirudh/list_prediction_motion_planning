clc
clear
close all

data_set = '../../dataset/env_cost_map_dataset/';
output_data_set = '../../dataset/solution_dataset/';
fig_folder = '../../dataset/solution_env_figs/';

listing = dir(fullfile(data_set,'cost_map*.mat'));
for i = 74:length(listing)
    load(strcat(data_set,'cost_map_',num2str(i),'.mat'), 'cost_map');
    
    p_start = [0 0];
    p_goal = [1 1];

    n_sparse = 5;
    N_samples = 100;
    rho = 0.1;
    param_mu = zeros(1, n_sparse);
    param_sigma = 0.5*eye(n_sparse);
    sigma_inject = 0.0001;
    max_epochs = 20;
    ce_options = v2struct(n_sparse, N_samples, rho, param_mu, param_sigma, sigma_inject, max_epochs);

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
    grad_final = @(xi, xi_der) lambda*grad_smooth(xi) + w_obs*grad_fobs(xi);


    chomp_options = v2struct(eta, max_iter, lambda, w_obs, min_iter, min_cost_improv_frac, M, decrease_wt);

    chomp_fn = @(xi) covariant_gradient_descent( xi, c_final, grad_final, chomp_options );

    [glob_opt_traj]  = cross_entropy_chomp( p_start, p_goal, n, ce_options, chomp_fn );
    save(strcat(output_data_set, 'solution_',num2str(i),'.mat'), 'glob_opt_traj');
    
    figure(1);
    clf;
    hold on;
    visualize_cost_map(cost_map);
    plot(glob_opt_traj.x(1,:), glob_opt_traj.x(2,:),'g');
    pause(0.1);
    saveas(gcf,strcat(fig_folder,'solution_env_',num2str(i),'.png'));
end