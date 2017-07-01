function str = mkstring(mainstr, prestr, i, maxnum, ext)
%==========================================================================
%function str = mkstring(mainstr, prestr, i, maxnum, ext)
%--------------------------------------------------------------------------
% MKSTRING creates a string of the form "filename00045.dat",
% if used mainstr='filename', prestr='0', i=45, maxnum=10000, ext='.dat'.
%--------------------------------------------------------------------------
% mainstr: string with the main name
% prestr: string with pre chars of the number
% i: number of current file
% maxnum: maximum number that can occur
% ext: string of the file extension (if point needed enter one!)
%--------------------------------------------------------------------------
% EX: str=mkstring('filename','0',45,10000,'.dat');
%==========================================================================

pre_max = floor(log10(maxnum));
pre_i   = floor(log10(i));
diff = pre_max-pre_i;

if diff==0
  finalpre = [];
else
  if i==0
    finalpre(1:pre_max) = prestr;
  else
    finalpre(1:diff) = prestr;
  end
end

str = [mainstr finalpre num2str(i) ext];

end