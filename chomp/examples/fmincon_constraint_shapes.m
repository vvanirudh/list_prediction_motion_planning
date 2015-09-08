function [ out1, out2, out3, out4 ] = fmincon_constraint_shapes( x, cfn, grad_fn )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

out1 = cfn(x);
out2 = [];
out3 = grad_fn(x);
out4 = [];
end

