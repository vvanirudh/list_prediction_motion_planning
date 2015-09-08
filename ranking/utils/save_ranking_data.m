function save_ranking_data(values,features,qid,fname)
%SAVERANKINGDATA 
% 
% SAVERANKINGDATA(values,features,fname)
% 
% values   - Array of ranks.
% features - Array of size n instances x dim features
% qid      - Group id.
% fname    - Optional file name.

if nargin < 3
   qid = ones(length(values),1); 
end
if nargin < 4
    fname = 'ranking_features';
end
f = fopen(fname,'w');

for i = 1:length(values)
    line = sprintf('%.4f',values(i));
    if ~isempty(qid)
        line = [line ' ' sprintf('qid: %d',qid(i))];
    end
    for j = 1:size(features,2)
        line = [line ' ' sprintf('%d: %.4f',j,features(i,j))];
    end
    fprintf(f,line);
    fprintf(f,'\n');
end
fclose(f);

end

