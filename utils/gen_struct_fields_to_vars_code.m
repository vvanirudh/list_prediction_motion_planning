function snippet = gen_struct_fields_to_vars_code(input_struct)
    f = fields(input_struct);
    snippet = [];
    for i = 1:length(f)
        line = [f{i} ' = ' 'input_struct.' f{i} ';'];
        line = sprintf('%s\n',line);
        fprintf('%s',line);
        snippet = [snippet line];        
    end
end