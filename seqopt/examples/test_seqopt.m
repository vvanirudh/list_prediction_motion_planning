function [e1,e2] = test_seqopt(input_struct,static_list)
    fprintf('Test.\n');
    test_folder = input_struct.test_folder;
    submodular_fn_params = input_struct.submodular_fn_params;
    
    load(test_folder);
    S = repmat(static_list,length(validation_data),1);
    level_losses = evaluate_level_losses(test_data,S,submodular_fn_params);
    for k = 1:length(level_losses)
        fprintf('DEBUG: Loss at level %d: %.2f.\n',k,level_losses(k));
    end
    
    [e1,e2] = evaluate_list_prediction(test_data,S);
    fprintf('Evaluation error: %f %f\n', e1, e2);
end