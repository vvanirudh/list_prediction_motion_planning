function [ f ] = get_signed_distance_features( xi, cost_map, cost_map_x, cost_map_y )
%GET_SIGNED_DISTANCE_FEATURES Summary of this function goes here
%   Detailed explanation goes here

cost_wp = cost_fn_map_value_wp( xi, cost_map );
delta_c = [cost_fn_map_value_wp( xi, cost_map_x ) cost_fn_map_value_wp( xi, cost_map_y )];

xi_d = diff([0 0; xi]);
dot_vec = normr(xi_d);
perp_vec = [-dot_vec(:,2) dot_vec(:,1)];

f = [cost_wp sum(dot_vec.*delta_c,2) sum(perp_vec.*delta_c,2) delta_c.*[0 0; delta_c(2:end,:)]];
f = reshape(f,1,[]);


end

