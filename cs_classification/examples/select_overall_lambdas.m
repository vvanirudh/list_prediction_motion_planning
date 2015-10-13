scorer_type = 'multilinear';
if strcmp(scorer_type,'linear')
    init_conseqopt_linear;
    train_conseqopt = @train_conseqopt_linear;
    validation_conseqopt = @validation_conseqopt_linear;
else
    init_conseqopt_multilinear;
    train_conseqopt = @train_conseqopt_multilinear;
    validation_conseqopt = @validation_conseqopt_multilinear;
end

%% specify lambda values
lambda_array = 10.^[4:9];
error_array = zeros(size(lambda_array));

%% sweep
clock_local = tic();
for i = 1:length(lambda_array)
    input_struct.lambdas = lambda_array(i)*ones(1,input_struct.B);
    weights_list = train_conseqopt(input_struct);
    [error_array(i),~] = validation_conseqopt(input_struct,weights_list);
end
[min_error,min_id] = min(error_array);
lambda_optimal = lambda_array(min_id);
fprintf('Computation took %.2fs\n',toc(clock_local));
fprintf('Min error: %.4f.\n',min_error);
fprintf('Optimal lambda: %.2f.\n',lambda_optimal);