function [newmat, keepind] = remove_nan(mat, col_or_lines);
%function [newmat, nanvec] = remove_nan(mat, col_or_lines);
% Removes the lines or columns of a matrix mat, which are completely filled
% with NaN values.
% m-files needed:   reshape
% input:    mat     2d matrix mxn (lines x columns)
%           (opt) col_or_lines  0: lines (default); 1 columns
% output:   mat     2d matrix, lines and columns which contained NaN-values
%                   are deleted
%           keepind vector containing the good channels 1, otherwise 0
% EXAMPLE:  [A nanvec] = remove_nan(A, 0);

if nargin < 2;  col_or_lines = 0; end;

% get number of lines m, and columns n
  [m n] = size(mat);
% get NaN matrix (Not a Number)
  nanmat = isnan(mat);
% check the first column (for removal of lines) or first line (for 
% removal of columns)
  if col_or_lines == 0
    keepind = ~nanmat(:, 1);
    newmat = reshape(mat(~nanmat), sum(keepind), n);
  else
    keepind = ~nanmat(1, :);
    newmat = reshape(mat(~nanmat), m, sum(keepind));
  end;

end