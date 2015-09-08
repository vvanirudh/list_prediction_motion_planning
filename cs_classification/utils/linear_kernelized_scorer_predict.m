function [class_pred,scores] = linear_kernelized_scorer_predict(features, predictor)
% output predicted classes and normalized scores
% class_pred is 1 x N_query
% scores is N_query x L

N_query = length(features);
L = size(features{1},1);
scores = zeros(N_query,L);
class_pred = zeros(1,N_query);
for i = 1:N_query
    % f is L x d
    f = features{i};
    % normalize to get f_hat
    f_mean = mean(f,1);
    f_hat = bsxfun(@minus,f,f_mean);
    % k is [LN,L]
    k = pdist2(predictor.F_hat,f_hat, ...
        @(x,y) kernelRBF(x,y,predictor.kernel_params));
    % s is [1,L]
    s = predictor.alpha'*k; s = -s/predictor.lambda;
    scores(i,:) = s;
    [~,class_pred(i)] = max(s);
end
end