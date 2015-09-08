function [predictor, obj_vec, stats] = train_linear_kernelized_dual_pgd(arg1, c, lambda, kernel_params, alpha0)
% linear kernelized dual pgd

if size(arg1,2) == length(c)
    % arg1 is Q
    % assumes used same kernel_params to generate Q
    Q = arg1;
    stats.Q_time = 0;
else
    % arg1 is F_hat
    F_hat = arg1;
    t1 = tic();
    Q = calc_Q(F_hat,kernel_params);
    stats.Q_time = toc(t1);
end
    
if (nargin <= 4)
    alpha0 = zeros(numel(c),1);
end
alpha = alpha0;

% negative of objective
g = @(alpha) -((0.5/lambda)*(alpha'*Q*alpha) - ones(size(alpha))'*alpha);
% objective
g_m = @(alpha) -g(alpha);
% primal
h = @(alpha) c'*max(0, 1 - (1/lambda)*Q*alpha) + (0.5/lambda)*(alpha'*Q*alpha);

max_iter = 100;
obj_vec = [];
beta = 0.9;
v = alpha;

% threshold terminating condition
eps = 1e-6;

% time for operations
stats.max_iter = max_iter;
[stats.grad_time,stats.backtracks,stats.total_backtrack_time] = deal(zeros(1,stats.max_iter));
stats.run_iter = 0;

obj_old = g_m(alpha);
t = 1;
for i = 1:max_iter
    stats.run_iter = stats.run_iter+1;
    fprintf('Iteration %d\n',i);
    % stepsize
    % in accelerated can use t from previous iteration
    %t = 1;
    t1 = tic();
    grad = (Q*v)/lambda - 1;
    stats.grad_time(i) = toc(t1);
   
    % gradient step + projection
    alpha_plus = min(c, max(0, v - t*grad));
    
    % backtracking
    backtrack_count = 0;
    t1 = tic();
    while (g_m(alpha_plus) >= g_m(v) + grad'*(alpha_plus - v) ...
            + (1/(2*t))*(alpha_plus-v)'*(alpha_plus -v))
        t = beta*t;
        alpha_plus = min(c, max(0, v - t*grad));
        backtrack_count = backtrack_count+1;
    end
    stats.backtracks(i) = backtrack_count;
    stats.total_backtrack_time(i) = toc(t1);
    
    alpha_prev = alpha;
    alpha = alpha_plus;
    
    v = alpha + ((i-1)/(i+2))*(alpha - alpha_prev);
    obj = g_m(alpha);
    obj_vec = [obj_vec; obj];
    
    % objective doesn't change by much, break
    if abs(obj-obj_old)/abs(obj_old) < eps
       break; 
    end
    obj_old = obj;
end


% create predictor
predictor.alpha = alpha;
predictor.F_hat = F_hat;
predictor.lambda = lambda;
predictor.kernel_params = kernel_params;

end

function Q = calc_Q(F_hat,kernel_params)
% F_hat is LN x d
% Q is LN x LN

Q = pdist2(F_hat,F_hat,@(x,y) kernelRBF(x,y,kernel_params));

end