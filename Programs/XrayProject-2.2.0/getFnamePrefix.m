% peel prefix off filename of DLT coefficients file for camera 1.   
%  Prefix is followed by one of: Cam1, cam1, C1, c1, C01, c01,
% C001, or c001. 
% Recommended prefix begins with 8-digits (yyyymmdd) and project title.
% Example: 20080730myproject.  Other prefixes may be used.  This routine
% assumes prefix is everything before Cam1, cam1, C1, c1, C01, c01, C001,
% or c001.  If none of these patterns is found, '' is returned as prefix.
function [pfix] = getFnamePrefix(fname)

ind = regexp(fname, '(C001|c001|C01|c01|C1|c1|Cam1|cam1)');

if (size(ind) == 0)
    pfix = '';
    return;
end
ind = ind(1);
pfix = fname(1:(ind-1));

%return 
