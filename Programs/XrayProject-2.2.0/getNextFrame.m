% getNextFrame returns next image frame.  
function [im] = getNextFrame(ext,pImage,fImage,iframe)
% pImage -- path, without final slash, for image file
% fImage -- filename, without extension, for image file
%    (or filename for first image in stack)
% ext -- image file extention (.avi, .cin, .cine, .jpg, .tif)
% iframe -- frame index number 
% 
% last modified 2011 Feb 2, L Reiss  tiff stack support added
switch (ext)
    case '.avi'
        % check whether mmread can read an .avi file on current system
        if exist('mmreader','file')
            % can use mmreader on this system.
            obj = mmreader([pImage,filesep,fImage,ext]);
            mov = read(obj,iframe);
            im = mov(:,:,1);
        else     % cannot read with mmreader on this system.
            mov = aviread([pImage,filesep,fImage,ext],iframe);
            im = mov.cdata;
        end
    case {'.cine','.cin','.CINE','.CIN'}
        im = flipud(cineRead([pImage,filesep,fImage,ext],iframe));
    case {'.tif','.tiff','.TIF','.TIFF','.jpg','.jpeg','.JPG','.JPEG'}
    % assume a stack of jpg or tif files with framenumber encoded at end of
    % file name, e.g., rat.00004.tif is frame 4 of rat file.
    % obtain frame number from file name e.g., rat.00004.tif is frame 4.
    % Dots in  filename prefix are permitted--e.g., rat.003.00005.tif is
    % frame 5 of rat.003 file.

        i1=strfind(fImage(1:end),'.');
        if (iframe==1) || (isempty(i1))
            newFname = fImage; 
            if (iframe==1) % single frame or first in stack
                im = imread([pImage,filesep,newFname,ext]);
            else
            % stack of tif frames
                im = imread([pImage,filesep,newFname,ext],iframe);
            end
        else
            frameNo = sscanf(fImage(i1(end)+1:end),'%d',1);
            iCharsInFrameNo = length(fImage)-i1(end);
            nextFrameNo = frameNo+iframe-1;
            newFname = [fImage(1:i1(end)),...
                sprintf('%0*d',iCharsInFrameNo,nextFrameNo),...
                ];
            im = imread([pImage,filesep,newFname,ext]);
        end
  
end

