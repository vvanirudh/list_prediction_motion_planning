threshold = 1.5;
[N,B] = size(S);
solved_at_level = cell(1,B+1);
env_left = 1:N;

env_remove = [];
for i = env_left
	if min(data(i).costs) > threshold
		env_remove(end+1) = i;
	end
end
env_left = setdiff(env_left,env_remove);
fprintf('length env_left: %d.\n',length(env_left));

for k = 1:B
	for i = env_left
		if data(i).costs(S(i,k)) < threshold
			solved_at_level{k} = [solved_at_level{k} i];
		end
	end
	env_left = setdiff(env_left,solved_at_level{k});
	fprintf('number solved at level %d: %d.\n',k,length(solved_at_level{k}));
end
solved_at_level{end} = env_left;
fprintf('number unsolved: %d.\n',length(solved_at_level{end}));


