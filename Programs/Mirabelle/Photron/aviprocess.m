% aviprocess: reads *.avi files and performs background removal
% and/or bandpass filtering.
% resulting frames are saved in uncompressed *.tif format
% here, background = mean[frame(i-shift)+frame(i+shift)]
% routine bpass.m is needed to perform bandpass filtering

% parameters
BGremov = 1;    % If = 0, background is not removed
                % if = 1, background (average frame +/-1) is removed
shift = 2;      % frames considered for background removal are i +/-shift                
BpFilter= 0;    % If = 1, frames are bandpass-filtered

autosave = 1; % Processed frames are saved if = 1
dfolder='tmp/mir00'; % Destination Folder (where images will be saved)
dformat='.tif'; % format of new images

initial = 1;
final = 1001;

% Loading video file
[filename, pathname] = uigetfile('*.avi; *.cin; *.ser','E:');
chfilename = char(filename);
fileformat = chfilename(length(chfilename)-3:length(chfilename));
tic % time reference for knowing processing time

switch fileformat
    case '.avi'
        infos=aviinfo([pathname chfilename]);
        disp('Number of Frames:')
        Nframes = infos.NumFrames % # of frames of the movie      
        framewidth = infos.Width;
        frameheight= infos.Height;
end

if final>Nframes
    final = Nframes;
end

% working in this box only:
xinit = 1; xfin = framewidth;
yinit = 1; yfin = frameheight;

if BpFilter == 1
    dfolder=[dfolder 'Bp'];
end
if BGremov == 1
    dfolder=[dfolder 'BG'];
end

    
% Temporal loop: where frames are processed
for t=initial+shift:final-shift
    
    tframe = aviread([pathname char(filename)],t);  % frame @ t
    
    if BGremov == 1
        m1frame = aviread([pathname char(filename)],t-1);   % frame @ t-shift
        p1frame = aviread([pathname char(filename)],t+1);   % frame @ t+shift
    end        
    
    % dealing with different kind of avi structures
    if ndims(tframe.cdata)==3
        
        tframe = rgb2gray(tframe.cdata(xinit:xfin,yinit:yfin,:)); %converting rgb into grayscale
        if BGremov == 1
            m1frame= rgb2gray(m1frame.cdata(xinit:xfin,yinit:yfin,:));
            p1frame= rgb2gray(p1frame.cdata(xinit:xfin,yinit:yfin,:));
        end
            
    else
            tframe = tframe.cdata(xinit:xfin,yinit:yfin); %no color conversion needed
            if BGremov == 1
                m1frame= m1frame.cdata(xinit:xfin,yinit:yfin);
                p1frame= p1frame.cdata(xinit:xfin,yinit:yfin);
            end
                
    end
    
    % background removal?
    if BGremov ==1
        tframe = tframe-0.5*(m1frame+p1frame);
        tframe = tframe+min(min(tframe)); % avoiding <0 intensity
    end
    
    % bandpass filtering?
    if BpFilter == 1
        b = bpass(tframe,1,10);
    end
    
    if autosave==1  % saving processed frames
        name=[dfolder num2str(t,'%0.4d') dformat];
        imwrite(tframe,name);
    end
    
end

toc