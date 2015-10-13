function [e1,e2] = test_conseqopt_linear(input_struct,weights_list)
    fprintf('Test.\n');
    features_choice_struct = input_struct.features_choice_struct;
    test_folder = input_struct.test_folder;
    submodular_fn_params = input_struct.submodular_fn_params;
    
    load(test_folder);
    S = predict_list_cs_classification(test_data,weights_list,features_choice_struct);
    level_losses = evaluate_level_losses(test_data,S,submodular_fn_params);
    for k = 1:length(level_losses)
        fprintf('DEBUG: Loss at level %d: %.2f.\n',k,level_losses(k));
    end
    
    [e1,e2] = evaluate_list_prediction(test_data,S);
    fprintf('Evaluation error: %f %f\n', e1, e2);
end