function [mean_f,std_f] = evaluate_list_prediction(data,S,submodular_fn_params)
% data is in common format
% S is [N,B]

[N,B] = size(S);
f = zeros(1,N);
for i = 1:N
	f(i) = submodular_fn(data(i).costs,S(i,:),submodular_fn_params);
end
mean_f = mean(f);
std_f = std(f);
end