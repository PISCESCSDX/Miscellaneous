function improcess7(data,fastmode)
%==========================================================================
% function improcess7(data,fastmode)
%--------------------------------------------------------------------------
% IN: data structure-array
%       data.fn : cell array with movie filenames to evaluate
%       data.fr1: cell array with number of first frame
%       data.fin: cell array with number of amount of frames
%       data.mov: cell array (0: no, 1: yes)
%       data.den: cell array (0: no, 1: wdenoise)
%       data.cut: data.cur{num}.lr indices; data.cur{num}.ud indices; or []
%       fastmode: 1: no picture drawing
%--------------------------------------------------------------------------
%IMPROCESS7 evaluates camera measurements of all filenames
%stored in the variable 'data.fn{i}' with i=1..N. It calculates the 
%average picture of the amount of 'data.fin{i}' picture files starting
%with picture nr 'data.fr1{i}'. In each directory the original cih-file is 
%necessary to detect the original filenames. The average picture will be 
%saved as 'avg.tif'. Finally the average will be removed from the chosen
%pictures and saved as ['a' picture name]. If a avi-movie 'movie.avi' 
% should be created set data.mov{i}=1.
%The saved images are shifted to positive values, so that the conversion
%to uint-numbers doesn't truncate the negative values. The following
%programs have to substract this shift to recover the original values
%The shift is saved in the shift.mat-file. For denoising set data.den{i}=1.
%--------------------------------------------------------------------------
% Ex: 
% data.fn{1}  = 'G:\work_20130615\rawdata\18222.cine';
% data.fr1{1} = 1;
% data.fin{1} = 5000;
% data.mov{1} = 0;
% data.den{1} = 0;
% improcess7(data,0);
%--------------------------------------------------------------------------
% (C) 04.07.2013 15:17, C. Brandt
%     - changed input to filename
% (C) 07.06.2012 17:45, C. Brandt
%     - new version: renamed to improcess7.m
%     - include read cine files, improved shift-file saving
% (C) 04.06.2012 16:43, C. Brandt
%     - included reading cine-files
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
ldir = length(data.dir);
for idir=1:ldir

% Change to evaluation directory
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp(['go to ' data.dir{idir}])
cd(data.dir{idir});


% Load camera parameters
a = dir('*.cih');
b = dir('*.cine');


% Decide whether to read tif or cine files
if ~isempty(a) && ~isempty(b)
  inp = input('TIF (0) and CINE (1) files are available. Take which?');
  switch inp
    case '0'
      fs = readcih(filecih(1).name);
      dt = 1/fs;
      filetype = 'tif';
    case '1'
      info_cine = cineInfo(fn);
      dt = 1/info_cine.frameRate;
      filetype = 'cine';
  end
  
else
  
  if ~isempty(a);
    filetype = 'tif';
  end

  if ~isempty(b);
    filetype = 'cine';
    info_cine = cineInfo(b(1).name);
    dt = 1/info_cine.frameRate;    
  end
  
  if isempty(a) && isempty(b);
    disp('No files available!');
    return
  end
end



% Check if amount of claimed files is available, if not -> change n
switch filetype
  case 'tif'
    if length(a) >= data.fin{idir}
      n = data.fin{idir};
    else
      n = length(a);
    end
    
  case 'cine'
    if info_cine.NumFrames >= data.fin{idir}
      n = data.fin{idir};
    else
      n = info_cine.NumFrames;
    end    
end



%==========================================================================
% Calculate Average Picture of chosen pictures
%==========================================================================
disp('load raw pictures and calculate average ...')

% Don't average in clusters
aver = 0;
switch filetype
  
  case 'tif'   
    for i=1:n
      num = data.fr1{idir} + i-1;
      curfile = a(num).name;
      pic = double(imread(curfile));
      aver = aver + pic;
    end
    
  case 'cine'
    for i=1:n
      num = data.fr1{idir} + i-1;       % CINE file: pic=1 means start at 0
      pic = double(cineRead(b(1).name, num));
      aver = aver + pic;
    end

end
aver = aver/n;
% save averaged picture (tif only saves integer values!)
  fnavg = ['avg_' num2str(data.fr1{idir}) 'ToN' num2str(n) '.tif'];
  imwrite(uint16(aver), fnavg);

% Load average picture
aver = double(imread(fnavg));
shift = max(max(aver));

%==========================================================================
% Substract the average picture -> Obtain fluctuation data
%==========================================================================
disp(['load raw pictures, substract average and save ' ...
  'difference files a*.tif'])
% Remove the averaged image and save the corresponding images
  % cmin and cmax defined for finding the color limits
  cmin = +inf; cmax = -inf;
for i=1:n
  switch filetype
    case 'tif'
      curfile = a(i-1+data.fr1{idir}).name;
      curpic = double(imread(curfile));
    case 'cine'
      curpic = double(cineRead(b(1).name, i-1+data.fr1{idir}));
  end
  after = curpic-aver;
  
  % Cut pictures if wanted
  if ~isempty(data.cut{idir}.lr)
    after = after(data.cut{idir}.ud, data.cut{idir}.lr);
  end
  
  if min(min(after))<cmin
    cmin = min(min(after));
  end
  if max(max(after))>cmax
    cmax = max(max(after));
  end
  % name of the saved files
  num = i-1+data.fr1{idir};
  switch filetype
    case 'tif'
      nomfin=['a' a(num).name];
    case 'cine'
      str=mkstring('a/a','0',num,n,'.tif');
      nomfin=str;      
  end
  imwrite(uint16(after+shift),nomfin,'tif');
end
clim = max([abs(cmin) abs(cmax)]);


% Save file with value of shift of the picture
disp('Removed average on all pictures')
%fnshift = ['shift_avg_' num2str(data.fr1{idir}) 'ToN' num2str(n) '.mat'];
fnshift = 'shift.mat';
vid.avg = aver;
vid.shift = shift;
vid.info = 'shift contains the shift value to the originals, aver is the AVG';
save(fnshift,'vid');


% Play Video of average removed data
if ~fastmode
  figeps(12,10,1);
  tifavg = dir('a*.tif');
  for i=1:n
    num = i-1+data.fr1{idir};
    curfile = tifavg(num).name;
    curpic = double(imread(curfile)) - shift;
    pcolor(curpic); shading flat
    disp(['time (ms): ' num2str(1e3*(i-1)*dt)]); % show time in milliseconds
    caxis(0.5*clim*[-1 1]);
    colorbar;
    colormap(pastelldeep(128))
    axis equal
    pause(0.05)
  end
end


% Denoise if activated
if data.den{idir} == 1
  disp('Denoise images')
  subdata.dir{1} = data.dir{idir};
  subdata.fr1{1} = data.fr1{idir};
  subdata.fin{1} = data.fin{idir};
  wdenoise7(subdata,fastmode);
end


end %for-loop idir

% Change to start directory
cd(startdir);

end %function
