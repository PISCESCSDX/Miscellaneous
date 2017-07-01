function [mat] = normmat_std(A, norm);
%function [mat] = normmat_std(A, norm);
% 
% Standardization of couronne-data - lines & columns are normalized to 
% their standard deviation.
%
% INPUT:    A       [64xSamples] matrix with measurement data
%           norm    1: norm to 1; 0: norm to mean square
% OUTPUT:   mat     normalized matrix
% EXAMPLE: A = normmat_std(A, norm);

if nargin<2; norm = 1; end;
if nargin<1; error('Input A is missing!'); end;

rows = size(A, 1);
cols = size(A, 2);
one_col = ones(1, cols);
one_row = ones(rows, 1);

% remove offset in both dimensions
  A = A - mean(A, 2)*one_col;
  A = A - one_row*mean(A);
% remove whole offset
  A = A - mean(mean(A));

% save mean square value of original matrix
  msq = mean(mean(A.*A));

% normalization along time
  std_time = std(A);
  std_time(std_time == 0) = 1e-10;    %avoid division by 0
  A = A ./ (one_row * std_time);

% normalization along angle
  std_probe = std(A, [], 2);
  std_probe(std_probe == 0) = 1e-10;  %avoid division by 0
  A = A ./ (std_probe * one_col);
  msq2 = mean(mean(A.*A));

% NORMALIZATION
  if norm == 0
    mat = 1/sqrt(msq2/msq) .* A;
  else
    mat = A;    
  end;

end