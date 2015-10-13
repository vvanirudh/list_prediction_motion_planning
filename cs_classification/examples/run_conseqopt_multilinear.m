init_conseqopt_multilinear;
weights_list = train_conseqopt_multilinear(input_struct);
[e1,e2] = validation_conseqopt_multilinear(input_struct,weights_list);