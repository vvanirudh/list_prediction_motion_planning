function pts_library = get_library_features(train_data)
% train_data is in common format
% pts_library is dim x L

pts_library = train_data(1).lib_contexts';

end

