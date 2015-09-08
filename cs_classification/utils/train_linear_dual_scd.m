function [alpha, obj] = train_linear_dual_scd( f, c, lambda, alpha0 )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

if (nargin <= 3)
    alpha0 = zeros(size(c));
end
alpha = alpha0;
g = @(alpha) -((0.5/lambda)*(f'*alpha)'*(f'*alpha) - ones(size(alpha))'*alpha);
h = @(alpha) c'*max(0, 1 - (1/lambda)*f*(f'*alpha)) + (0.5/lambda)*(f'*alpha)'*(f'*alpha);

max_count = 100000;
tic
obj = [];
for count = 1:max_count;
    i = randi(size(alpha,1));
    f_i = f(i,:);
    f_mi = f; f_mi(i,:) = [];
    alpha_mi = alpha; alpha_mi(i) = [];
    alpha_i = (1/(f_i*f_i'))*(lambda - f_i*f_mi'*alpha_mi);
    alpha_i = min(c(i), max(0, alpha_i));
    alpha(i) = alpha_i;
    if (mod(count, 100)==0)
        obj = [obj; toc count g(alpha) h(alpha)];
        obj(end,:)
    end
end

end

