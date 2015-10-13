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
level_lambda_cell = cell(1,B);
for k = 1:B
    lambda_array_b = 10.^[-3:3];
    level_lambda_cell{k} = lambda_array_b;
end
errors_cell = cell(1,B);
lambdas_optimal = zeros(1,B);

%% sweep
clock_local = tic();
for k = 1:B
    fprintf('Level %d.\n',k);
    input_struct.B = k;
    lambda_array_b = level_lambda_cell{k};
    errorArray_b = zeros(size(lambda_array_b));
    for i = 1:length(lambda_array_b)
        input_struct.lambdas = [lambdas_optimal(1:k-1) lambda_array_b(i)];
        weights_list = train_conseqopt(input_struct);
        [errorArray_b(i),~] = validation_conseqopt(input_struct,weights_list);
    end
    errors_cell{k} = errorArray_b;
    [~,min_id] = min(errorArray_b);
    lambdas_optimal(k) = lambda_array_b(min_id);
end
fprintf('Computation took %.2fs\n',toc(clock_local));

