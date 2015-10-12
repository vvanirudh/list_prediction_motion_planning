init_conseqopt;
weights_list = train_conseqopt(input_struct);
[e1,e2] = validation_conseqopt(input_struct,weights_list);