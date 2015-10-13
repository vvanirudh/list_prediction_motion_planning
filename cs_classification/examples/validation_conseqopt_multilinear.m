function [e1,e2] = validation_conseqopt_multilinear(input_struct,weights_list)
    fprintf('Validation.\n');
    validation_folder = input_struct.validation_folder;
    submodular_fn_params = input_struct.submodular_fn_params;
    
    load(validation_folder);
    S = predict_list_multilinear_cs_classification(validation_data,weights_list);
    level_losses = evaluate_level_losses(validation_data,S,submodular_fn_params);
    for k = 1:length(level_losses)
        fprintf('DEBUG: Loss at level %d: %.2f.\n',k,level_losses(k));
    end
    
    [e1,e2] = evaluate_list_prediction(validation_data,S);
    fprintf('Evaluation error: %f %f\n', e1, e2);
end