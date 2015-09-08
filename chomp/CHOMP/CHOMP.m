function [ cost_traversal, time_taken, cost_history, traj_history, h_traj, h_cost ] = CHOMP(p_start, p_goal, cost_map, w_obs, lambda, options, xi_0, lambda_original)
close all;

p_start = p_start';
p_goal = p_goal';
%% Set up trajectory parameterization
d = options.d; %2D config space 
n = options.n; %How many waypoints
if (nargin <= 6)
    xi = [linspace(p_start(1),p_goal(1),n+2)' linspace(p_start(2),p_goal(2),n+2)'];
else
    xi = xi_0;
end
xi(1,:) = [];
xi(end,:) = [];

%% Set up smoothness matrices
[ A, b, c ] = smooth_matrices( p_start, p_goal, n );

[ cost_map_x, cost_map_y] = get_cost_map_derivatives( cost_map );


%% Optimization
eta = options.eta;
max_iter = options.max_iter;
min_iter = options.min_iter;

if (nargin > 7)
    cost_fn = @(xi) w_obs*cost_obs( xi, cost_map, p_start ) + lambda_original*cost_smooth( xi, A, b, c);
else
    cost_fn = @(xi) w_obs*cost_obs( xi, cost_map, p_start ) + lambda*cost_smooth( xi, A, b, c);
end
grad_fn = @(xi) w_obs*gradient_obs( xi, cost_map, cost_map_x, cost_map_y, p_start ) + lambda*gradient_smooth( xi, A, b );

cost_history = [];
traj_history = [];

traj.x = [p_start; xi; p_goal]';
traj_history = [traj_history; traj];
cost_history = [cost_history; cost_fn(xi)];

tic
for i = 1:max_iter
    grad = grad_fn(xi);
    
    xi = xi - (1\eta)*A\(grad);
    
    traj.x = [p_start; xi; p_goal]';
    traj_history = [traj_history; traj];
    cost_history = [cost_history; cost_fn(xi)];
    
    if (i > min_iter)
        if ((cost_history(i-1) - cost_history(i)) > 0 && (cost_history(i-1) - cost_history(i))/cost_history(i-1) < options.min_cost_improv_frac)
            break;
        end
    end
end
time_taken = toc;
cost_traversal = cost_history(end);

if (nargout > 4)
    figure(1);
    visualize_cost_map(cost_map);
    hold on;
    cc=hsv(size(traj_history,1));
    for i = 1:size(traj_history,1)
        plot(traj_history(i).x(1,:), traj_history(i).x(2,:),'color',cc(i,:))
    end
    h_traj = gcf;

    figure(2);
    plot(cost_history);
    h_cost = gcf;
end
end

