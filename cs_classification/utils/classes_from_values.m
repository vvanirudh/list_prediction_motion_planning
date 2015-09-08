function classes = classes_from_values(values)
%CLASSES_FROM_VALUES Decide class based on max value.
% 
% classes = CLASSES_FROM_VALUES(values)
% 
% values  - n x num classes array. 
% 
% classes - n x 1 array.

n = size(values,1);
classes = zeros(n,1);
for i = 1:n
    [~,classes(i)] = max(values(i,:));
end

end

