function str = pwdl
%==========================================================================
%function pwdl
%--------------------------------------------------------------------------
% PWDL shows the last folder of the current directory pwd.
%==========================================================================

%==================================================
% Test on which operating system matlab is running
%==================================================
compinfo = computer;

c_linux = strfind(compinfo, 'LNX');
if ~isempty(c_linux)
  slstr = '/';
else
  c_windows = strfind(compinfo, 'WIN');
  if ~isempty(c_windows)
    slstr = '\';    
  else
    error('Can not detect the operating system!')
  end
end
%==================================================

a = pwd;
slloc = strfind(a, slstr);

str = a(slloc(end):end);

end