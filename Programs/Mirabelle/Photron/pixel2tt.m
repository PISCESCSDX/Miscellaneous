function [tt,P] = pixel2tt(fname,pix,chk,indtime,chkframe)
%==========================================================================
%function [tt,P] = pixel2tt(fname,pix,chk,indtime,chkframe)
%--------------------------------------------------------------------------
% PIXEL2TT extracts time rows from tif-pictures or cine movies of camera
% measurements. For tif-files the cih-file is needed to read the fps.
% !!! ATTENTION !!! Take care of the x-y-definition used here!
% Last change: May-17-2013 C. Brandt, San Diego (included indtime)
% Last change: Oct-02-2012 C. Brandt, San Diego (included cine files)
%--------------------------------------------------------------------------
%INPUT 
% filename: string of movie filename (cine)
% pix: array containing the pixels
%    !!! Definition: For the positioning of pixels the matrix convection is
%    used:               (i+1, j )
%             ( i ,j-1)  ( i , j )  ( i ,j+1)
%                        (i-1, j )
%    pix(i,1) is the vertical pixel position of the i-th pixel
%    pix(i,2) is the horizontal pixel position of the i-th pixel
%   e.g. pix(1,:)=[120 200] means pixel 120 in ver. & 200 in hor. direction
% chk: 'checkplot-off', 'checkplot-on'
% indtime (optional): indices of time intervall to extract
% chkframe (optional): number of frame shown in check plot
%OUTPUT
%  tt: time vector (s)
%  P(ipix(i),tt(i)): matrix with pixels,
%    e.g. P(1,10) means value of pixel 1 in 10. image
%---------------------------------------------------------------- EXAMPLE 1
% fname = 'movie.cine'; chk = 'checkplot-on';
% pix(1,:) = [118 60]; pix(2,:) = [120 60];
% [tt,P] = pixel2tt(fname,pix,chk)
%---------------------------------------------------------------- EXAMPLE 2
% fname = 'movie.cine';
% for i=1:128
%   for j=1:128
%     pix(i,j) = [i,j];
%   end
% end
% [tt,P] = pixel2tt(fname,pix,'checkplot-on');
%==========================================================================

if nargin<5; chkframe = 1; end
if nargin<4; indtime = []; end


lp= size(pix,1);

% Load camera parameters
a = dir('*.cih');
b = dir(fname);

% Decide whether to read tif or cine files
if ~isempty(a) && ~isempty(b)
  inp = input('TIF (0) and CINE (1) files are available. Take which?');
  switch inp
    case '0'
      fs = readcih(filecih(1).name);
      dt = 1/fs;
      filetype = 'tif';
      if nargin<4
        a = dir('*.tif');
        la = length(a);
        indtime = 1:la;
      end
    case '1'
      info_cine = cineInfo(fn);
      dt = 1/info_cine.frameRate;
      filetype = 'cine';
      if nargin<4
        indtime = 1:info_cine.NumFrames;
      end
  end
  
else
  
  if ~isempty(a);
    filetype = 'tif';
    if nargin<4
      a = dir('*.tif');
      la = length(a);
      indtime = 1:la;
    end
  end

  if ~isempty(b);
    filetype = 'cine';
    info_cine = cineInfo(fname);
    dt = 1/info_cine.frameRate;
    if isempty(indtime)
      indtime = 1:info_cine.NumFrames;
    end
  end
  
  if isempty(a) && isempty(b);
    disp('No files available!');
    return
  end
end

   
% Create time vector
switch filetype
  case 'tif'
    tt = ((indtime(1):indtime(end))'-1)*dt;
  case 'cine'
    tt = ((indtime(1):indtime(end))'-1)*dt;
    lb = length(tt);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Show a test picture (Are the choosen pixels ok?)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if strcmp(chk,'checkplot-on')
switch filetype
  case 'tif'
    pic = double(imread(a(chkframe).name));
  case 'cine'
    pic = double(cineRead(fname, chkframe));
end

% Go through all defined pixels (and set a high marker value)
maxp = matmax(pic);
for i=1:lp
  pic( pix(i,1) , pix(i,2) ) = maxp + i*maxp/lp;
end
figeps(20,20,1);pcolor(pic);xlabel('horizontal #');ylabel('vertical #');
title('!!! Attention: Position Convention !!!')
input('chosen pixels ok -> press any key');
close;
end

% Read In each picture file and store pixel data in variables
  switch filetype
    case 'tif'
      P = zeros(la,lp);
      for i=1:la
        disp_num(i,la)
        pic = double(imread(a(i).name));
        for p=1:lp
          P(i,p) = pic(pix(p,1), pix(p,2));
        end
      end
      
    case 'cine'
      P = zeros(lb,lp);
      for i=indtime
        disp_num(i,indtime(end))
        pic = double(cineRead(fname, i));
        for p=1:lp
          ii = i-indtime(1)+1;
          P(ii,p) = pic(pix(p,1), pix(p,2));
        end
      end
  end

end