function improcess4l_auto(info)
% IN: info structure-array
%       info.dir: cell array with directories to evaluate
%       info.fi1: cell array with number of first file
%       info.fin: cell array with number of amount of files
%       info.mov: cell array (0: no, 1: yes)
%       info.den: cell array (0: no, 1: wdenoise)
% In each directory the original cih-file is necessary to detect the
% original filenames.
% improcess2: load images from a dialog box, removes the background summed
% over all the images, and saves the resulting images in the same directory
% The resulting movie is played once, and can be save as an .avi file
% The saved images are shifted to positive values, so that the conversion
% to uint-numbers doesn't truncate the negative values. The following
% programs have to substract this shift to recover the original values
% The video is saved as movie.avi. The shift is saved in the 
% shift.mat-file.
% (C) F. Brochard 04/2008, version 10/2009

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
cd(info.dir{idir});
disp(clock_int)
disp('change to path:')
disp([info.dir{idir}])

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
disp('loading files ...')
% preallocate arrays (faster)
helppic = double(imread(a(1).name));
szx = size(helppic,1);
szy = size(helppic,2); clear helppic
before = zeros(szx, szy, n);
for i=1:n
  curfile = a(i+info.fi1{idir}).name;
  before(:,:,i) = double(imread(curfile));
end

% average image
aver = mean(before,3);
aver = double(aver);
shift=max(max(aver));

% Make movie
figure; set(gcf,'color','w');
if info.mov{idir}==1
  mov = avifile('movie.avi','compression','none','quality',100,'fps',5);
end
disp('- done')
disp('removing background ...')
% remove the averaged image and save the corresponding images
  % preallocate array after
  after = zeros(size(before,1),size(before,2),size(before,3));
for i=1:n
  after(:,:,i)=before(:,:,i)-aver;
end

cmin = min(min(min(after)));
cmax = max(max(max(after)));
clim = max([abs(cmin) abs(cmax)]);

% prepare figure
figeps(12,10,1);

for i=1:n
  fin(:,:) = after(:,:,i);

  % name of the saved files
  nomfin=['a' a(i+info.fi1{idir}).name];
  imwrite(uint16(fin+shift),nomfin,'tif');

  pcolor(fin); shading flat
  disp(['time (ms): ' num2str(i*dt)]); % show time in milliseconds
  % caxis([cmin cmax])
  caxis(clim*[-1 1]);
  colorbar;
  colormap(pastell)

  F = getframe;
  if info.mov{idir}==1
    mov = addframe(mov,F);
  end
end

disp('- done')
if info.mov{idir}==1
  mov = close(mov);
else
  movie(F,1,4)
end

% Save file with value of shift of the picture
save('shift.mat','shift');


% Denoise if activated
if info.den{idir} == 1
  subinfo.dir{1} = info.dir{idir};
  subinfo.fi1{1} = info.fi1{idir};
  subinfo.fin{1} = info.fin{idir};
  wdenoise3l_auto(subinfo);
end

close all
end


% Change to start directory
cd(startdir);

end
