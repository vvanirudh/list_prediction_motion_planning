function [c] = squared_dist_shapes( pt, shapes_array, epsilon )
%SQUARED_DIST_SHAPES Summary of this function goes here
%   Detailed explanation goes here

[~, d, ~] = shapes_point_check( pt, shapes_array );
if (d < 0)
    c = -d + 0.5*epsilon;
elseif (d < epsilon)
    c = (1/(2*epsilon))*(d - epsilon)^2;
else
    c = 0;
end

end

