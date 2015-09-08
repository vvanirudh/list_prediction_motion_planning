function list_weights = scp_list_weights(B)

list_weights = zeros(1,B);
for k = 1:B
	list_weights(k) = (1-1/B).^(B-k);
end
end