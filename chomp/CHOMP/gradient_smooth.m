function grad = gradient_smooth( xi, A, b )
%GRADIENT_SMOOTH Summary of this function goes here
%   Detailed explanation goes here

grad = size(xi,1)*(A*xi+b);
end

