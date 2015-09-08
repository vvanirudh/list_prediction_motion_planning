function train_ranking_model(varargin)
% train_ranking_model(fname_train)
% train_ranking_model(values,features)
% train_ranking_model(values,features,qid)
% train_ranking_model(values,features,qid,fname)

if nargin == 1
    fname_train = varargin{1};
end
if nargin > 1
    values = varargin{1};
    features = varargin{2};
    qids = ones(length(values),1);
    fname_train = 'ranking_features';
end
if nargin > 2
    qids = varargin{3};
end
if nargin > 3
    fname_train = varargin{4};
end
if nargin > 1
    save_ranking_data(values,features,qids,fname_train);
end

p = which('svm-train.c');
assert(~isempty(p),'LIBSVM_RANKING-3.18 NOT IN PATH. RUN INIT_SETUP.');
id = strfind(p,'svm-train.c');
p = strrep(p,p(id:end),'svm-train');
command = [p, ' -t 1 -m 3000 ', fname_train];
command
[res, msg] = system(command);
end