function mdfpcolor(fn, ind, defch)
%function mdfpcolor(fn, ind, defch)
% For testing defch.
% EX: mdfpcolor('cou0001.MDF', 23000:33000, [24 36 40])

[B tt] = mdfprep( fn, defch, ind);
B = flipud(B);
rows = size(B, 1);
cols = size(B, 2);
one_col = ones(rows, 1);
one_row = ones(1, cols);

A=B;
stdA = std(A')';
lind = length(ind);
A = A./(stdA*one_row);

figeps(20,5,1); pcolor(B); shading flat
figeps(20,5,2); pcolor(A); shading flat

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SAVE to FILE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nfn = filenamenext('zebra', '.mat', 4);
save(nfn, 'tt', 'A');

end