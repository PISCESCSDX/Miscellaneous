function mat = normmat_std(A,tt,fcut,norm)
%==========================================================================
%function mat = normmat_std(A,tt,fcut,norm)
%--------------------------------------------------------------------------
% Standardization of couronne-data - lines & columns are normalized to 
% their standard deviation.
%--------------------------------------------------------------------------
% IN: A: [64xSamples] matrix with measurement data
%     tt: time trace /s
%     fcut: cut frequency (cut freq below)
%     norm: 1: norm to 1; 0: norm to mean square
%OUT: mat: normalized matrix
%--------------------------------------------------------------------------
% EX: A = normmat_std(A, tt, fcut, norm);
%==========================================================================

if nargin<4; norm = 1; end;
if nargin<3  fcut = 0; end;
if nargin<2; error('Input A and tt is missing!'); end;

rows = size(A, 1);
cols = size(A, 2);
one_col = ones(1, cols);
one_row = ones(rows, 1);

% calculate smooth intervall for removal of low frequencies
dt = tt(2)-tt(1);
% avoid division by zero
fcut(fcut<500) = 500;
pts_fcut = round(1/(dt*fcut));
for i = 1:rows
  % for removal of low frequent patterns use following 2 lines
  tr_lf = smooth(A(i, :)', pts_fcut);
  A(i, :) = A(i, :) - tr_lf';
end

% remove offset in both dimensions
A = A - mean(A, 2) * one_col;
A = A - one_row * mean(A);
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

% change 
if norm == 0
  mat = 1/sqrt(msq2/msq) .* A;
else
  mat = A;    
end;

% prüfen wofür das ist!
% % normalize data
%    mat = normmat_std(mat, time);
%    [U,S,V] = svds(mat, 5);
%    mat = U*S*V';    

end