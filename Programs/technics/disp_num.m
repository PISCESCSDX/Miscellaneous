function disp_num(num, endnum)
%==========================================================================
%function disp_num(num, endnum)
%--------------------------------------------------------------------------
% DISP_NUM shows the the current number of a running process.
% (14.02.2007 Brandt)
%--------------------------------------------------------------------------
% IN:    num: current number
%     endnum: last number
%--------------------------------------------------------------------------
% EX: disp_num(1, 51)  and you get: " 1/51"
%==========================================================================

% get length of endnum
  str_end = num2str(endnum);
  l_end   = length(str_end);
% create num-string
  str_num = mkstring('', '0', num, endnum, '');
% create display-string
  str_disp = [str_num '/' str_end];
% length of display string
  l_disp = length(str_disp);

% use backspaces
bspace=[];
if num==1
  bspace='';
else
  for i=1:l_disp+1
    bspace=[bspace '\b'];
  end
end

bspace = sprintf(bspace);
disp([bspace str_disp]);