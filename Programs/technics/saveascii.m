function saveascii(mat, fn)
%function saveascii(mat)
% Save matrix mat as ASCII file with the filename fn.
% IN: mat: 
%      fn: 
%OUT: 

fid = fopen(fn, 'w');
fprintf(fid, '%6.6f  %6.6f\n', mat');
fclose(fid);

end