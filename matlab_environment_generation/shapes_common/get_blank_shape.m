function [ shape ] = get_blank_shape()
%GET_BLANK_MAP Defines a simple shapes structure but it contains nothing
%   shape is a struct with the following fields
%   :   name - string saying what the shape is
%   :   data - matrix whose structure is determined by the shape
shape = struct('name', '', 'data', []);

end

