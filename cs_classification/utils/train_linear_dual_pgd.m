function [alpha, obj] = train_linear_dual_pgd( f, c, lambda, alpha0 )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

if (nargin <= 3)
    alpha0 = zeros(size(c));
end
alpha = alpha0;
% negative of objective
g = @(alpha) -((0.5/lambda)*(f'*alpha)'*(f'*alpha) - ones(size(alpha))'*alpha);
% objective
g_m = @(alpha) -g(alpha);
h = @(alpha) c'*max(0, 1 - (1/lambda)*f*(f'*alpha)) + (0.5/lambda)*(f'*alpha)'*(f'*alpha);

max_count = 1000;
tic
obj = [];
beta = 0.9;
v = alpha;
for i = 1:max_count;
    t = 1;
    val = f'*v;
    grad = (f*val)/lambda - 1;
    alpha_plus = min(c, max(0, v - t*grad));
    while (g_m(alpha_plus) >= g_m(v) + grad'*(alpha_plus - v) ...
           + (1/(2*t))*(alpha_plus-v)'*(alpha_plus -v))
        t = beta*t;
        alpha_plus = min(c, max(0, v - t*grad));
    end
    
    alpha_prev = alpha;
    alpha = alpha_plus;
    
    v = alpha + ((i-1)/(i+2))*(alpha - alpha_prev);
    
    obj = [obj; toc i g(alpha) h(alpha)];
    obj(end,:)
end

end

