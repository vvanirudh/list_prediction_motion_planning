init_conseqopt_linear;
weights_list = train_conseqopt_linear(input_struct);
[e1,e2] = validation_conseqopt_linear(input_struct,weights_list);