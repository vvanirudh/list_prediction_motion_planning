function F_hat = wrap_features(features)
% features is length {N}, features{i} is [L,d]
% F_hat is [LN,d]

F_hat = [];
N = length(features);
for i = 1:N
    f_e = features{i};
    f_hat = bsxfun(@minus,f_e,mean(f_e)); % normalize feautures
    F_hat = [F_hat; f_hat];
end
end
