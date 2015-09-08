function [c_grad] = squared_dist_grad_shapes( pt, shapes_array, epsilon )
%SQUARED_DIST_SHAPES Summary of this function goes here
%   Detailed explanation goes here

[~, d, grad] = shapes_point_check( pt, shapes_array );
if (d < 0)
    c_grad = -grad;
elseif (d < epsilon)
    c_grad = (1/epsilon)*(d - epsilon)*grad;
else
    c_grad = zeros(size(pt));
end

end