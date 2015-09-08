function [ f ] = get_simple_features( xi, cost_map, cost_map_x, cost_map_y )
%GET_SIGNED_DISTANCE_FEATURES Summary of this function goes here
%   Detailed explanation goes here

xi = xi(2:(end-1),:);
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
grad_fobs = @(xi) gradient_obs( xi, cost_map, cost_map_x, cost_map_y, p_start );

c_final = @(xi, xi_der) lambda*f_smooth(xi) + w_obs*c_scalar_obs_fn(xi);
c_final_xi = @(xi) lambda*f_smooth(xi) + w_obs*c_scalar_obs_fn(xi);
grad_final = @(xi, xi_der) lambda*grad_smooth(xi) + w_obs*grad_fobs(xi);

%cost_wp = cost_fn_map_value_wp( xi, cost_map );
delta_c = [cost_fn_map_value_wp( xi, cost_map_x ) cost_fn_map_value_wp( xi, cost_map_y )];

xi_d = diff([0 0; xi]);
dot_vec = normr(xi_d);
perp_vec = [-dot_vec(:,2) dot_vec(:,1)];

dev = sum(perp_vec.*delta_c,2);
dev = dev(1:10:end);

left = xi + 0.1*perp_vec; left = left(1:10:end,:);
right = xi - 0.1*perp_vec; right = right(1:10:end,:);
strt = xi(1:10:end,:);

cost_strt = cost_fn_map_value_wp( strt, cost_map );
cost_left = cost_fn_map_value_wp( left, cost_map );
cost_right = cost_fn_map_value_wp( right, cost_map );

g = grad_final(xi,xi_d);
g_sub = g(1:10:end,:);
g_sub = normr(g_sub);
cost_left_g = cost_fn_map_value_wp( strt + 0.1*g_sub , cost_map );
cost_right_g = cost_fn_map_value_wp( strt - 0.1*g_sub, cost_map );

f = [c_final_xi(xi) (1e-5)*trace(g'*(A\g)) (1e-2)*sum(sum(delta_c.*[0 0; delta_c(1:(end-1),:)])) abs(dev') sign(dev') cost_left' cost_right' cost_strt' cost_left_g' cost_right_g'];

%f = [(1e-5)*trace(g'*(A\g)) cost_left' cost_right' cost_strt'];

f = reshape(f,1,[]);


end

