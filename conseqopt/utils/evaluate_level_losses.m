function level_losses = evaluate_level_losses(data,S,submodular_fn_params)
% data is in common format
% S is [N,B]

[N,B] = size(S);
sum_losses = zeros(1,B);
non_zero_loss_env = zeros(1,B);

for k = 1:B
	C = conseqopt_losses(data,S(:,1:k-1),submodular_fn_params);
	vec = zeros(1,N);
	for i = 1:N
		vec(i) = C(i,S(i,k));
		sum_losses(k) = sum_losses(k)+C(i,S(i,k));
		if max(C(i,:)) ~= 0
			non_zero_loss_env(k) = non_zero_loss_env(k)+1;
		end
	end
% 	figure;
% 	hist(vec); 
% 	title(sprintf('level %d',k));
	% only divide by those environments not correctly classified already.
	level_losses(k) = sum_losses(k)/non_zero_loss_env(k);
end

end
