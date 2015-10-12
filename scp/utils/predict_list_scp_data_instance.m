function [S,features_list] = predict_list_scp_data_instance(data_instance,beta,B,features_choice_struct)
% data is in common format

S = zeros(1,B);
d = length(beta);

features_list = {};
for k = 1:B
	% features are [L,d]
	features = scp_features_data_instance(data_instance,features_list,S(1:k-1),features_choice_struct);
	features_list{end+1} = features;

	% center features
	features = bsxfun(@minus,features,mean(features,1));
	scores = features*beta;
	[~,S(k)] = max(scores);
end
end