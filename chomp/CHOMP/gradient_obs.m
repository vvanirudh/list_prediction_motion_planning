function grad = gradient_obs( xi, cost_map, cost_map_x, cost_map_y, p_start )
%GRADIENT_OBS Summary of this function goes here
%   Detailed explanation goes here

c = cost_fn_map_value_wp( xi, cost_map );
delta_c = [cost_fn_map_value_wp( xi, cost_map_x ) cost_fn_map_value_wp( xi, cost_map_y )];

n = size(xi,1) + 1;
xi_d = n*diff([p_start; xi]);
xi_d_norm = normr(xi_d);

xi_dd = n*([0 0; diff(xi_d)]);

kappa = repmat((1./sum((xi_d).^2,2)), [1 2]).*(xi_dd - xi_d_norm.*repmat(sum(xi_dd.*xi_d_norm, 2), [1 2]));

grad = (1/n).*repmat(sqrt(sum((xi_d).^2,2)), [1 2]) .* ( delta_c - xi_d_norm.*repmat(sum(delta_c.*xi_d_norm,2), [1 2])  - repmat(c, [1 2]).*kappa);

end
