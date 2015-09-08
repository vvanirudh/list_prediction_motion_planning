function [classes,scores] = mcsvm_predict(model,features)
% model comes from train_mcsvm
% features is num queries x dim features
% scores is num queries x num classes

num_queries = size(features,1);
classes = zeros(num_queries,1);
scores = zeros(num_queries,model.num_classes);
for i = 1:num_queries
    k = pdist2(model.features,features(i,:),@(x,y) model.kernel(x,y,model.kernelParams));
    s = model.cMat'*k+model.b; 
    scores(i,:) = s;
    [~,classes(i)] = max(s);
end
end