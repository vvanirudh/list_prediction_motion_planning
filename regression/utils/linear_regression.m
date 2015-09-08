function [y,beta] = linear_regression(varargin)
%LINEAR_REGRESSION 
%
% linear_regression(beta)
% linear_regression(XTrain,yTrain,X,lambda)
%
% y_train is [N,1]
% X_train is [N,d]
% 
% [y,beta] = LINEARREGRESSION(varargin)
% 
% y        - Predicted array.
% beta     - Fit weights.

if nargin == 1
    beta = varargin{1};
elseif nargin == 4
        X_train = varargin{1};
        y_train = varargin{2};
		X = varargin{3};
        lambda = varargin{4};
        beta = (X_train'*X_train+lambda*eye(size(X_train,2)))\(X_train'*y_train);
end
if isempty(X)
	y = [];
else
	y = X*beta;
end
end

