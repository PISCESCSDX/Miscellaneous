function camprepfiles
%function camprepfiles
% CAMPREPFILES prepares names of tif-files. This is for a better
% arrangement.

% find all original camera tif-files
a = dir('*.cih');

if ~isempty(a)
  if strcmp(a(1).name,'cam.cih')
    return
  else
    tifprename = a(1).name(1:end-4);
  end
else
  return
end

a = dir([tifprename '*.tif']);
la= length(a);
if isempty(a)
  return
end

sc = clock_int;
for i=1:1000 %la
  curfile = ['cam' pre_string(i,la,'0') num2str(i) '.tif'];
  disp([num2str(i) ' ' a(i).name ' ' curfile]);
  eval(['! mv ' a(i).name ' 01/' curfile]);
end
ec = clock_int;
dd = clockdiff(sc,ec)

% rename cih-file to camera parameter file
% eval(['! mv ' a(1).name ' ' 'cam.cih']);

% x = 1:1e3:la;
% lx=length(x);
% for j=1:lx
%   if j == lx
%     ind = la;
%   else
%     ind = x(j+1)-1;
%   end
% for i=x(j):ind
%   curfile = ['cam' pre_string(i,la,'0') num2str(i) '.tif'];
%   disp([num2str(i) ' ' a(i).name ' ' curfile]);
%   eval(['! mv ' a(i).name ' ' curfile]);
% end
% end

end