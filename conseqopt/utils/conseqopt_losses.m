function C = conseqopt_losses(data,S,submodular_fn_params)
% data is a length N struct array 
% S is [N,K]
% C is [N,L]

[N,K] = size(S);
L = length(data(1).costs);
C = zeros(N,L);

for i = 1:N
	seed_costs = data(i).costs; % [L,1]
	f_values = zeros(1,L);
	% edge case: environment i already classified
	if any(S(i,:) == 0)
		C(i,:) = 0;
		continue;
	end	
	for j = 1:L
		f_values(j) = submodular_fn(seed_costs,[S(i,:) j],submodular_fn_params);
	end
	[max_f,~] = max(f_values);
	C(i,:) = max_f-f_values;
end
end