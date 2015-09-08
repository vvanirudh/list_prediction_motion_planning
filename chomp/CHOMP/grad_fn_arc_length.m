function grad = grad_fn_arc_length( xi, c_fn, grad_c_fn, p_start)
%GRAD_FN_ARC_LENGTH Summary of this function goes here
%   Detailed explanation goes here
n = size(xi,1) + 1;
d = size(xi,2);
xi_d = n*diff([p_start; xi]);
c = c_fn( xi, xi_d);
delta_c = grad_c_fn(xi, xi_d);

xi_d_norm = normr(xi_d);

xi_dd = n*([zeros(1,d); diff(xi_d)]);

kappa = repmat((1./sum((xi_d).^2,2)), [1 d]).*(xi_dd - xi_d_norm.*repmat(sum(xi_dd.*xi_d_norm, 2), [1 d]));

grad = (1/n).*repmat(sqrt(sum((xi_d).^2,2)), [1 d]) .* ( delta_c - xi_d_norm.*repmat(sum(delta_c.*xi_d_norm,2), [1 d])  - repmat(c, [1 d]).*kappa);

end

