function improcess6l_auto(info,fastmode)
%==========================================================================
% function improcess6l_auto(info,fastmode)
%--------------------------------------------------------------------------
% IN: info structure-array
%       info.dir: cell array with directories to evaluate
%       info.fi1: cell array with number of first file
%       info.fin: cell array with number of amount of files
%       info.mov: cell array (0: no, 1: yes)
%       info.den: cell array (0: no, 1: wdenoise)
%       fastmode: 1: no picture drawing
%--------------------------------------------------------------------------
%IMPROCESS5L_AUTO evaluates Photron camera measurements in all directories
%saved in the variable 'info.dir{i}' with i=1..N. It calculates the 
%average picture of the number of 'info.fin{i}' picture files starting
%with picture nr 'info.fi1{i}'. In each directory the original cih-file is 
%necessary to detect the original filenames. The average picture will be 
%saved as 'avg.tif'. Finally the average will be removed from the chosen
%pictures and saved as ['a' picture name]. If a avi-movie 'movie.avi' 
% should be created set info.mov{i}=1.
%The saved images are shifted to positive values, so that the conversion
%to uint-numbers doesn't truncate the negative values. The following
%programs have to substract this shift to recover the original values
%The shift is saved in the shift.mat-file. For denoising set info.den{i}=1.
%--------------------------------------------------------------------------
% Ex: 
% info.dir{1} = 'd:\work\!now\12He\rawdata';
% info.fi1{1} = 1;
% info.fin{1} = 396;
% info.mov{1} = 0;
% info.den{1} = 0;
% improcess6l_auto(info);
%--------------------------------------------------------------------------
% (C) 17.03.2011 08:19, C. Brandt
%     - simplified averaging
% (C) 05.01.2011 11:30, C. Brandt
%     - added remainder of clusters (nrest)
%     - create wavelet decomposed video "wavdec.avi"
%     - added movie rawdata, black&white
%     - added movie wavdec, black&white
%     - added movie wavdec, color
% (C) 04.01.2011 16:50, C. Brandt
%==========================================================================

if nargin<2; fastmode=0; end

% Save start directory
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
startdir = pwd;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FOR loop: amount of directories
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ldir = length(info.dir);
for idir=1:ldir

% change to evaluation directory
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp(['go to ' info.dir{idir}])

% Load camera parameter file
filecih = dir('*.cih');
fs = readcih(filecih(1).name); dt = 1e3/fs;
filestr = filecih(1).name(1:end-4);
a = dir([filestr '*.tif']);

% Check if amount of claimed files is available, if not change n
if length(a) >= info.fin{idir}
  n = info.fin{idir};
else
  n = length(a);
end

% Load image and make averaged image
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear before after fin
disp('load raw pictures and calculate average ...')
% preallocate arrays (faster)
helppic = double(imread(a(1).name));
szx = size(helppic,1);
szy = size(helppic,2); clear helppic

%==========================================================================
% Calculate Average Picture
%==========================================================================
% Don't average in clusters
aver = 0;
for i=1:n
  num = info.fi1{idir} + i-1;
  curfile = a(num).name;
  pic = double(imread(curfile));
  aver = aver + pic;
end
aver = aver/n;
% save averaged picture (tif only saves integer values!)
  fn = 'avg.tif';
  imwrite(uint16(aver),fn);


% Load average picture
aver = double(imread('avg.tif'));
shift = max(max(aver));

%==========================================================================
% Substract the average picture -> Obtain fluctuation data
%==========================================================================
disp(['load raw pictures, substract average and save ' ...
  'difference files a*.tif'])
% remove the averaged image and save the corresponding images
  % cmin and cmax defined for finding the color limits
  cmin = +inf; cmax = -inf;
for i=1:n
  curfile = a(i-1+info.fi1{idir}).name;
  curpic = double(imread(curfile));
  after = curpic-aver;
  if min(min(after))<cmin
    cmin = min(min(after));
  end
  if max(max(after))>cmax
    cmax = max(max(after));
  end
  % name of the saved files
  nomfin=['a' a(i-1+info.fi1{idir}).name];
  imwrite(uint16(after+shift),nomfin,'tif');
end
clim = max([abs(cmin) abs(cmax)]);


% % Make movie of rawdata substracted by average
% %==========================================================================
% mov=avifile('rawminusavg.avi','compression','none','quality',100,'fps',5);
% figeps(12,10,1);
% for i=1:n
%   curfile = ['a' a(i-1+info.fi1{idir}).name];
%   curpic = double(imread(curfile)) - shift;
%   pcolor(curpic); shading flat
%   disp(['time (ms): ' num2str((i-1)*dt)]); % show time in milliseconds
%   % caxis([cmin cmax])
%   caxis(clim*[-1 1]);
%   colorbar;
%   colormap(pastell)
%   F = getframe;
%   if info.mov{idir}==1
%     mov = addframe(mov,F);
%   end
% end
% mov = close(mov);

% Save file with value of shift of the picture
save('shift.mat','shift');

% Denoise if activated
if info.den{idir} == 1
  subinfo.dir{1} = info.dir{idir};
  subinfo.fi1{1} = info.fi1{idir};
  subinfo.fin{1} = info.fin{idir};
  wdenoise5l_auto(subinfo,fastmode);
end

% Make movie of wavelet smoothed pictures (color)
%==========================================================================
mov = avifile('wavdec_col.avi',...
  'compression','none','quality',100,'fps',10);
close all
fig1 = figeps(12,10,1,5,5);
% Prepare figure for correct video export
  wysiwyg_vid(300)
load shift.mat
% First find color limits
for i=1:n
  curfile = ['sym4smootha' a(i-1+info.fi1{idir}).name];
  curpic = double(imread(curfile)) - shift;
  clim1(i) = matmin(curpic);
  clim2(i) = matmax(curpic);
end
clim = [mean(clim1) mean(clim2)];
cmax = max(abs(clim));
clim = cmax*[-1 1];
%
for i=1:n
  curfile = ['sym4smootha' a(i-1+info.fi1{idir}).name];
  curpic = (double(imread(curfile)) - shift) / cmax;
  pcolor(curpic); shading flat
  colormap(pastell)
  disp(['time (ms): ' num2str((i-1)*dt)]); % show time in milliseconds
  caxis(1.1*[-1 1])
  % put time on plot
  tstr = ['t=' sprintf('%0.2f', (i-1)*dt) 'ms'];
  htext = puttextonplot(gca, 5, 90, tstr, 0, 12, 'k');
    pos = get(htext, 'position');
    set(htext, 'position', [pos(1) pos(2) 1]);
  axis image
  mkplotnice('x (arb.u.)', 'y (arb.u.)', 12, -30);
  hc = our_colorbar('\Gamma(light)_{AC} (arb.u.)', 12, 10, 0.020, -0.060);
  set(hc, 'ytick', [-1 0 1])
  F = getframe(fig1);
  if info.mov{idir}==1
    mov = addframe(mov,F);
  end
end
mov = close(mov);

% % % Make movie of wavelet smoothed pictures (color)
% % %==========================================================================
% % close all
% % load shift.mat
% % fig1 = figeps(12,10,1,5,5);
% % % First find color limits
% % for i=1:n
% %   curfile = ['sym4smootha' a(i-1+info.fi1{idir}).name];
% %   curpic = double(imread(curfile)) - shift;
% %   clim1(i) = matmin(curpic);
% %   clim2(i) = matmax(curpic);
% % end
% % clim = [mean(clim1) mean(clim2)];
% % %
% % for i=1:n
% %   curfile = ['sym4smootha' a(i-1+info.fi1{idir}).name];
% %   curpic = double(imread(curfile)) - shift;
% %   pcolor(curpic); shading flat
% %   colormap(pastell)
% %   disp(['time (ms): ' num2str((i-1)*dt)]); % show time in milliseconds
% %   caxis(1.1*clim)
% %   % put time on plot
% %   tstr = [sprintf('%0.2f', (i-1)*dt) ' ms'];
% %   htext = puttextonplot(gca, 5, 90, tstr, 0, 12, 'k');
% %     pos = get(htext, 'position');
% %     set(htext, 'position', [pos(1) pos(2) 1]);
% %   colorbar;
% %   F = getframe;
% %   if info.mov{idir}==1
% %     F1(i) = getframe(fig1);
% %   end
% % end
% % fn = ['wavdec_col_new.avi'];
% % movie2avi(F1, fn, 'FPS', 5, 'compression', 'none');

% % Make movie of rawdata
% %==========================================================================
% mov = avifile('rawdata.avi','compression','none','quality',100,'fps',5);
% close all
% load shift.mat
% figeps(12,10,1);
% % First find color limits
% for i=1:n
%   curfile = [ a(i-1+info.fi1{idir}).name];
%   curpic = double(imread(curfile)) - shift;
%   clim1(i) = matmin(curpic);
%   clim2(i) = matmax(curpic);
% end
% clim = [mean(clim1) mean(clim2)];
% %
% for i=1:n
%   curfile = [ a(i-1+info.fi1{idir}).name];
%   curpic = double(imread(curfile)) - shift;
%   pcolor(curpic); shading flat
%   colormap(gray)
%   disp(['time (ms): ' num2str((i-1)*dt)]); % show time in milliseconds
%   caxis(1.1*clim)
%   colorbar;
%   F = getframe;
%   if info.mov{idir}==1
%     mov = addframe(mov,F);
%   end
% end
% mov = close(mov);

close all
end %for-loop idir


% Change to start directory
cd(startdir);

end %function
