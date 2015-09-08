function cost = cost_obs( xi, cost_map, p_start )
%COST_OBS Summary of this function goes here
%   Detailed explanation goes here

cost_wp = cost_fn_map_value_wp( xi, cost_map );

n = size(xi,1) + 1;
xi_d = n*diff([p_start; xi]);

cost = sum((1/n).*sqrt(sum((xi_d).^2,2)) .* cost_wp);

end

