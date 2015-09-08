%% Avoding a pole using an 
clc
clear
close all

%% Set up obstacle representation
load cost_map_ddp_hard.mat
p_start = [6 95];
p_goal =  [237.5 95]; 

%% Set up trajectory parameterization
d = 2; %2D config space 
n = 500; %How many waypoints
xi = [linspace(p_start(1),p_goal(1),n+2)' linspace(p_start(2),p_goal(2),n+2)'];
xi(1,:) = [];
xi(end,:) = [];

%% Set up smoothness matrices
[ A, b, c ] = smooth_matrices( p_start, p_goal, n );

[ cost_map_x, cost_map_y] = get_cost_map_derivatives( cost_map );


%% Optimization
eta = 700;
iter = 100;

w_obs = 0.5;
lambda = 4.5455e-05;

cost_fn = @(xi) w_obs*cost_obs( xi, cost_map, p_start ) + lambda*cost_smooth( xi, A, b, c);
grad_fn = @(xi) w_obs*gradient_obs( xi, cost_map, cost_map_x, cost_map_y, p_start ) + lambda*gradient_smooth( xi, A, b );



figure(1);
visualize_cost_map(cost_map);
hold on;
cc=hsv(iter+1);
traj = [p_start; xi; p_goal];
plot(traj(:,1), traj(:,2),'color',cc(1,:));
cost = cost_fn(xi)
pause
for i = 1:iter
    grad = grad_fn(xi);
    
    xi = xi - (1\eta)*A\(grad);
    
    traj = [p_start; xi; p_goal];
    plot(traj(:,1), traj(:,2),'color',cc(i+1,:));

    cost = cost_fn(xi)
    pause
end






