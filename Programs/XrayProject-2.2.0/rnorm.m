function [norms] = rnorm(matrix)

% function [norms] = rnorm(matrix)
%
% Description: rnorm returns a column of norm values.  Given an input
% 	       matrix of X rows and Y columns it returns an X by 1
%	       column of norms.

% for i=1:size(matrix,1)
%   norms(i,1)=norm(matrix(i,:));
% end

% possibly a faster method
norms=sqrt(dot(matrix',matrix'))';