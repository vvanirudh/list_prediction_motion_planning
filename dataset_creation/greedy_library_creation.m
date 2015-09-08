clc
clear 
%close all

load library.mat
L = 100; % library size
thresh = 1.6;
attempts = 1;
while (1)
    fprintf('Attempts: %d Library Size: %d \n', attempts, length(library));
    attempts = attempts + 1;
    shapes_array = get_project_shapes_array();
    map = convert_rectangle_map(shapes_array);
    epsilon = 0.05;
    cost_map = create_obstacle_cost_map(map, epsilon);
    
    
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

    did_lib_solve = 0;
    for j = 1:length(library)
        [cost_traversal, ~, cost_history] = covariant_gradient_descent( library{j}.traj, c_final, grad_final, chomp_options );
        if (min(cost_history) < thresh)
            did_lib_solve = 1;
            break;
        end
    end
    
    if (did_lib_solve == 1)
        continue;
    end
    
    n_sparse = 5;
    N_samples = 100;
    rho = 0.1;
    param_mu = zeros(1, n_sparse);
    param_sigma = 0.1*eye(n_sparse);
    sigma_inject = 0.0001;
    max_epochs = 10;
    ce_options = v2struct(n_sparse, N_samples, rho, param_mu, param_sigma, sigma_inject, max_epochs);
    
    chomp_fn = @(xi) covariant_gradient_descent( xi, c_final, grad_final, chomp_options );
    [glob_opt_traj,  glob_opt_cost]  = cross_entropy_chomp( p_start, p_goal, n, ce_options, chomp_fn );
    
    if (glob_opt_cost < thresh)
        l = 1+length(library);
        library{l}.cost_map = cost_map;
        library{l}.traj = glob_opt_traj.x';
        figure;
        hold on;
        visualize_cost_map(cost_map);
        plot(library{end}.traj(:,1), library{end}.traj(:,2));
        pause(1);
    end
    
end