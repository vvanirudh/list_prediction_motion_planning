function [ weights ] = get_weights_from_alpha( f_hat, alpha, lambda )
% f_hat is [LN,d]
% alpha is [LN,1]

weights = -(1/lambda)*f_hat'*alpha;

end

