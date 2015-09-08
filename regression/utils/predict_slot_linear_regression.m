function id = predict_slot_linear_regression(features,beta)
% features is [L,d]
% beta is [d,1]

y = features*beta;
[~,id] = min(y);
end