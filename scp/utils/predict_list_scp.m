function S = predict_list_scp(data,beta,B,mode)
% data is in common format

N = length(data);
S = zeros(N,B);
d = length(beta);

% do it for each datum
for i = 1:N
	[S(i,:),~] = predict_list_scp_data_instance(data(i),beta,B,mode);
end

end