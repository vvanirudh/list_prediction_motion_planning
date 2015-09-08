function res = kernelRBF(x1,x2,kernelParams)
%KERNELRBF
%
% res = KERNELRBF(x1,x2,kernelParams)
% 
% x1           - 1 x dimX.
% x2           - n x dimX.
% kernelParams - struct with fields ('h'), bandwidth. Default = 1.0 if
%                passed empty struct.
% 
% res          - 1 x n kernel values.

dimX = length(x1);
n = size(x2,1);

% h is bandwidth
if isfield(kernelParams,'h')
    h = kernelParams.h;
else
    h = 1.0;
end

if iscolumn(x1)
    x1 = x1';
end

temp = bsxfun(@minus,x2,x1);
temp = sqrt(sum(temp.^2,2));
if iscolumn(temp) 
    temp = temp';
end
temp = -temp.^2/(2*h^2);
res = exp(temp);
% normalizer = ((2*pi)^(dimX/2))*(h^dimX);
% res = exp(temp)/normalizer;
end

