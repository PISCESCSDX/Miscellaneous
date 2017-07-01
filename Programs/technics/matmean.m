function [meanA] = matmean(A)
%==========================================================================
%function [meanA] = matmean(A)
%--------------------------------------------------------------------------
% MATMEAN calculates the average of a matrix A.
%--------------------------------------------------------------------------
% EX: meanA = matmean(A)
%==========================================================================

% Number of dimensions
lsize = length( size(A) );

for i = 1:lsize
  A = mean(A);
end

meanA = A;

end