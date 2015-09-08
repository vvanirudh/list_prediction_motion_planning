function C = scp_costs_data_instance(data_instance,S,submodular_fn_params)
% S is [1,B]
% C is [B,L]

B = length(S);
L = length(data_instance.costs);
C = zeros(B,L);

for k = 1:B
	f_values = zeros(1,L);
	for j = 1:L
		f_values(j) = submodular_fn(data_instance.costs,[S(1:k-1) j],submodular_fn_params);
	end
	[max_f,~] = max(f_values);
	C(k,:) = max_f-f_values;
end

end