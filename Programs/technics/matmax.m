function [maxA] = matmax(A)
%function [maxA] = matmax(A)
% Detects absolut maximum of matrix A.
% 
% EX: maxA = matmax(A)

% Number of dimensions
lsize = length( size(A) );

for i = 1:lsize
  A = max(A);
end

maxA = A;

end