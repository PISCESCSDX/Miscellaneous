function [minA] = matmin(A)
%function [minA] = matmin(A)
% Detects absolut minimum of matrix A.
% 
% EX: minA = matmin(A)

% Number of dimensions
lsize = length( size(A) );

for i = 1:lsize
  A = min(A);
end

minA = A;

end