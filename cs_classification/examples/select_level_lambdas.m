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
levelLambdaCell = cell(1,B);
for k = 1:B
    lambdaArray_b = 10.^[-3:3];
    levelLambdaCell{k} = lambdaArray_b;
end
errorsCell = cell(1,B);
lambdasOptimal = zeros(1,B);

%% sweep
clock_local = tic();
for k = 1:B
    fprintf('Level %d.\n',k);
    input_struct.B = k;
    lambdaArray_b = levelLambdaCell{k};
    errorArray_b = zeros(size(lambdaArray_b));
    for i = 1:length(lambdaArray_b)
        input_struct.lambdas = [lambdasOptimal(1:k-1) lambdaArray_b(i)];
        weights_list = train_conseqopt(input_struct);
        [errorArray_b(i),~] = validation_conseqopt(input_struct,weights_list);
    end
    errorsCell{k} = errorArray_b;
    [~,min_id] = min(errorArray_b);
    lambdasOptimal(k) = lambdaArray_b(min_id);
end
fprintf('Computation took %.2fs\n',toc(clock_local));

