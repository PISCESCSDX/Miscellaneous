function [mat, timevec] = mdf_read8(num, fn, defch);
%function [mat, timevec] = mdf_read8(num, fn, defch);
% Reads the 8 MDF-files of filename_vec and puts them
% together to one mdf-matrix (usally: [64 x 2^16]).
%
% needs:    readmdf
% input     num number of file in filename_vec
%           fn  vector of 8 filename strings - in the correct card-order
%           defch (opt) list of defect channels
% output    mat             whole couronne-matrix [64 x 2^16]
%           timevec         timevector [2^16 x 1]
% EXAMPLES: [A, tt] =  mdf_read8(1, fn);
%           [A, tt] =  mdf_read8(1, fn, [3 45]);
%
% continue pcolor(A(:, 1:5000)); shading flat;

if nargin<3
    defch=[];
end;


% read in all 8 matrices
mat=[];
for i=1:8
    [A timevec] = readmdf(fn{i, num});
    mat=[mat A];
end;

% transpose to usual needed format
mat=mat';

% set defect channels to NaN
mat(defch, :) = NaN;
end