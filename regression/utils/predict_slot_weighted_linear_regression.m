function id = predict_slot_weighted_linear_regression(features,beta)
% features is [L,d]
% beta is [d,1]

% center features
features = bsxfun(@minus,features,mean(features,1));
y = features*beta;
[~,id] = min(y);
end