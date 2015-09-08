function [y,beta] = weighted_linear_regression(varargin)
%WEIGHTED_LINEAR_REGRESSION actually a cs classification relaxation
%
% weighted_linear_regression(beta)
% weighted_linear_regression(XTrain,yTrain,X,lambda)
%
% y_train is [N,1]
% X_train is [N,d]
% 
% [y,beta] = WEIGHETED_LINEAR_REGRESSION(varargin)
% 
% y        - Predicted array.
% beta     - Fit weights.

if nargin == 1
    beta = varargin{1};
elseif nargin == 4
        X_train = varargin{1};
		y_train = varargin{2};
		X_train_w = bsxfun(@times,X_train,y_train);
		X = varargin{3};
        lambda = varargin{4};
        beta = (X_train_w'*X_train+lambda*eye(size(X_train,2)))\(X_train'*y_train);
end
if isempty(X)
	y = [];
else
	y = X*beta;
end
end

