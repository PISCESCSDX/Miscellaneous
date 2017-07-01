% read first image in file and get image info.
function [image, imageinfo]=calimread(fpathname)
% last changed 2 Feb 2011 L J Reiss  TIFF stack support added
% read first image in file (usually 'grid' or 'calibration cube'
%   or first image of video).
% check the file extension
if strcmpi('.avi',fpathname(end-3:end))
    if exist('mmreader','file')
        obj = mmreader(fpathname);
        image = read(obj,1); % read first frame
        image=image(:,:,1);
        imageinfo = get(mmreader(fpathname));
        imageinfo.FramesPerSecond = imageinfo.FrameRate;
        imageinfo.NumFrames = imageinfo.NumberOfFrames;
        imageinfo.colormap = [0:1/255:1;0:1/255:1;0:1/255:1]';
    else %    % cannot read with mmreader on this system.
        mov=aviread(fpathname,1); % read first frame only
        image=mov.cdata(:,:,1);
        imageinfo = aviinfo(fpathname);
        imageinfo.colormap = mov.colormap;
    end
    % initialize to empty (colormap Field for Truecolor avi image)
    %            imageinfo.colormap = ones(0,3);
elseif strcmpi('.cin',fpathname(end-3:end)) || ...
        strcmpi('.cine',fpathname(end-4:end))
    image = flipud(cineRead(fpathname,1));
    imageinfo = cineInfo(fpathname);
    % initialize colormap for grayscale
    imageinfo.colormap = [0:1/255:1;0:1/255:1;0:1/255:1]';
    imageinfo.FramesPerSecond = 1/imageinfo.frameRate;
else
    image=imread(fpathname);
    image=image(:,:,1);
    imageinfo = imfinfo(fpathname);
    stacksize = size(imageinfo,1);
    imageinfo = imageinfo(1);
    if(strcmp(imageinfo.ColorType,'grayscale'))
        % initialize colormap for grayscale
        imageinfo.colormap = [0:1/255:1;0:1/255:1;0:1/255:1]';
    else
        % initialize to empty (colormap Field for Truecolor avi image)
        imageinfo.colormap = ones(0,3);
    end
    imageinfo.FramesPerSecond = 30; % default
    imageinfo.NumFrames = stacksize; % default
    
end

