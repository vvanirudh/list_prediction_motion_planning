function [ c, grad ] = fmincon_cost( x ,p_start, p_goal)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

c = 1000000*sum(sum(diff([p_start; reshape(x, [], 2); p_goal]).^2));
grad = 2*1000000*reshape(diff([reshape(x, [], 2); p_goal]) - diff([p_start; reshape(x, [], 2)]), [], 1);
end

