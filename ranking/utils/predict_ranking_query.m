function ranks = predict_ranking_query(features,fname_model)
%PREDICTRANKINGQUERY
% 
% ranks = PREDICTRANKINGQUERY(features,fnameModel)
% 
% features   - Array of size n instances x dim features.
% fnameModel - String, defaults to 'ranking_features.model'.
% 
% ranks      - Array of ranks.


if nargin < 2
    fname_model = 'ranking_features.model';
end
if isempty(strfind(fname_model,'.model'))
    fname_model = strcat(fname_model,'.model');
end

bogusValues = zeros(size(features,1),1);
fnameTest = 'tmp_test'; fnameOut = 'tmp_out';
save_ranking_data(bogusValues,features,[],fnameTest);

p = which('svm-train.c');
assert(~isempty(p),'LIBSVM_RANKING-3.18 NOT IN PATH. RUN INIT_SETUP.');
id = strfind(p,'svm-train.c');
p = strrep(p,p(id:end),'svm-predict');
command = [p ' ' fnameTest ' ' fname_model ' ' fnameOut];
[res,msg] = system(command);

fout = fopen(fnameOut,'r');
values = fscanf(fout,'%f');
[~,ranks] = sort(values,'descend');

fclose(fout);
delete(fnameTest);
delete(fnameOut);
end

