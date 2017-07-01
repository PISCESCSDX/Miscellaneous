function [] = applyUndistort(varargin) % undistort single image or video.

% Undistort single image or video (.jpg, .tif, .cin, .cine  or avi) using a
% specified transformation matrix
%
% Only grayscale Phantom camera .cin and .cine files are supported.
%
% Image output for .avi can be .avi, stack of .tif, stack of .jpg
% Image output for .tif can be .tif or .jpg
% Image output for .jpg can be .jpg or .tif
% Image output for .cin or .cine can be stack of .jpg or stack of .tif
%
% Input data may have bit depths of 8, 10, 12, 14 or 16, but all output
% data is 8-bit depth.  
% (Output data is scaled to 8-bit depth just before it is written. For
% single frame input files, the data is written near the end of this
% m-file.  For multiple-frame input files, the data is written in
% addImFrame.m.)
%
% Users may use this to convert movies (e.g., cine) to stacks of jpg or tif
% without (re)processing to remove distortion.  When user clicks "Cancel"
% at prompt for UNDTFORM file, a new prompt allows user to choose "cancel"
% or "continue" to save a movie in a different format with out
% (re)processing to remove distortion.
%
% original code by Dave Baier.
%
% Modified by L. Reiss 29 Nov 2010 (avi output fps set to 30),
% 19 Jan 2011 (added multifile support)
%----------------------------------------------------
defaultdir = cd; % initialize
xrayprojectdirhandle = 0; % initialize
if nargin==0 % no inputs, just run the gui
  % go create the GUI if we didn't get any input arguments

elseif nargin==1 % assume a switchyard call but no data
      xrayprojhandles = varargin{1};
      defaultdir = get(xrayprojhandles.defaultdir,'String');
      xrayprojectdirhandle = xrayprojhandles.defaultdir;
else
  disp('applyUndistort: incorrect number of input arguments')
  return
end

% load variables for Workspace
[fUnd,pUnd]=uigetfile('*.mat','Select your Undistortion Transform File',...
    defaultdir);
undistort=1;
% on Cancel, user may quit or continue to save movie in different format
% without (re)processing to remove distortion.
if fUnd == 0
    qbutton = questdlg(...
        ['Cancel to exit immediately.  ',...
        'Continue to save movie in a different format without ',...
        '(re)processing to remove distortion.'],...
        'Cancel or reformat movie?',...
        'Continue', 'Cancel',...
        'Continue');
    if (strcmp(qbutton, 'Continue'))
        %f flag convert to another format.
        undistort=0;
        % reinitialize fUnd, pUnd
        fUnd='';
        pUnd=defaultdir;
    else
        fprintf('\n No file chosen. Cancelled applyUndistort \n');
    return
    end
end
defaultdir = pUnd; %update default directory
if(xrayprojectdirhandle~=0)
    set(xrayprojectdirhandle,'String',defaultdir);
end

udata.cancel = 0;

if (undistort)
    load([pUnd,fUnd]);
end
% get the directory with the image file(s)
[fImage,pImage]=uigetfile({'*.tif;*.avi;*.cine;*.cin;*.jpg',...
    'Image files (*.tif, *.jpg, *.avi, *.cin, *.cine)'}, ...
    'Select a file to Undistort', pUnd, 'MultiSelect','on');

if strcmp(class(fImage),'double') == 1
    fprintf('\n No file chosen \n');
    return
end
defaultdir = pImage; %update default directory
if(xrayprojectdirhandle~=0)
    set(xrayprojectdirhandle,'String',pImage);
end
% multi-selection or not
% if multiFileCheck = 1, the user selected multiple files
% it may be multiple .avis, .cines, or a stack of tifs or jpegs
multiFileCheck = iscellstr(fImage);
runNum=0;
fList = [1];

if multiFileCheck
    [fList,fRunLen] = getFileRuns(fImage);    
else
    [pOut, fOut, ext] = fileparts([pImage,fImage]);
    pIn = pOut;
    fIn = fOut;
end

while (runNum<size(fList,2))
    
runNum = runNum + 1;    

if multiFileCheck    
    [pOut, fOut, ext] = fileparts([pImage,fList{runNum}]);
    [pIn,fIn] = fileparts([pImage,fList{1}]);
else
    [pOut, fOut, ext] = fileparts([pImage,fImage]);
    pIn = pOut;
    fIn = fOut;
end


% read file header and first image

[I,Iinfo] = calimread([pOut filesep fOut ext]);
rawImax=max(max(I(:,:))); % maximum raw image pixel value
moviemax = rawImax; % initialize
if (multiFileCheck==1)
    switch (ext)
        case {'.jpg','.JPG','.jpeg','.JPEG','.tif','.TIF','.tiff','.TIFF'}
            Iinfo.NumFrames = fRunLen(runNum);
        otherwise
    end
end

% skip when not doing undistortion (i.e., just changing file format)
if undistort
    % check for pixel lookup table for fast distortion correction method
    if (exist('pixLUT', 'var') == 1)
        transformLUT = pixLUT;
    else
        button = questdlg(...
            ['Lookup table is missing. '...
            'Continue lookup table creation or cancel?  '...
            'This process will take 5 to 20 minutes.  '...
            'Once started, the process can only be stopped by crashing Matlab.'],...
            'Create lookup table?',...
            'Continue', 'Cancel',...
            'Continue');
        if (strcmp(button, 'Continue'))
            lutBar = waitbar(0,'Lookup table is missing.  Creating one now.');
            transformLUT = xCreateLookupTable(undistortTform,[info.Width info.Height]);
            pixLUT = transformLUT;
            save([pUnd,fUnd],'pixLUT','-append');
            lutBar = waitbar(100, lutBar);
            if exist('lutbar','var')
                close(lutBar);
            end
        else
            fprintf('\n Cancelled applyUndistort \n');
            return
        end
    end
end
%
if (Iinfo.NumFrames > 1) || (strcmp(ext,'.tif'))&&(multiFileCheck==1) ...
        || (strcmp(ext,'.jpg'))&&(multiFileCheck==1)
    
    % multiple frames (default is all frames)

    %get ext for output file
    [startframe,endframe,outext,scaleType] = ExtAndRangeGUI(Iinfo.NumFrames, ext); 
 
    if(endframe == 0)
        fprintf('Cancelled by user.\n');
        return;
    end
    tempid=0;
    if strcmp(scaleType,'moviemax')
        tmp_nam = 'scratch_tmp';
        %       tmp_nam = tempname; % generate a temporary file name, 
                                % likely to be unique but not guaranteed
                                % so.
        
        tempid = fopen(tmp_nam,'w');
    end
    filterSpec = ['*' outext];
    
    %create a new movie
    
   % cancel box setup -----------------------
    defaultBackground = get(0,'defaultUicontrolBackgroundColor');
    hfig = figure(...
        'Name','UndistortVideo',...
        'Toolbar','none',...
        'Menubar','none',...
        'Units','pixels',...
        'Color',defaultBackground,...
        'Position',[190,500,282,215], ...
        'NumberTitle','off', 'Tag','cancelfigure',...
        'Visible','on','Interruptible','on',...
        'Resize','off');
    hcancelbutton = uicontrol('Parent',hfig,...
        'Style','pushbutton',...
        'Units','normalized','Position',[0.1 0.3 0.4 0.2],...
        'String', 'CANCEL','Callback','cancelCallback');
     htextstring = uicontrol('Parent', hfig,...
        'Units','normalized','Position',[0.1 0.6 0.8 0.3],...
        'Style','text',...
        'String','');
    set(hcancelbutton,'Userdata',udata);
    % end cancel box setup ----------------------
    
    if undistort
        suffix = sprintf('UNDIST_%u_%u',startframe,endframe);
        if startframe == 1 && endframe == Iinfo.NumFrames
            suffix = 'UNDIST';
        end
    else
        suffix = sprintf('_%u_%u',startframe,endframe);
        if startframe == 1 && endframe == Iinfo.NumFrames
            suffix = '';
        end
    end
    
    [pDefault,fDefault] = fileparts([pIn,filesep,fIn,ext]);
    
    [pOut,fOut] = OutFileGUI(pDefault,fDefault);
    
    if ((numel(pOut) == 0) && (numel(fOut) == 0))
        disp(sprintf('\n Cancelled applyUndistort \n'))
        if exist('hfig','var')
            close(hfig);
        end
        
        return
    end
    defaultdir = pOut; %update default directory to output file directory
    if(xrayprojectdirhandle~=0)
        set(xrayprojectdirhandle,'String',pOut);
    end
    newmovie = -1;
    initsuffix = suffix;
    if (strcmp(outext,'.avi'))
        % initialize avi output file
        
        % Check if file already exists to avold overwriting.
        checkingfilename = 1;
        nx=0;
        while (checkingfilename)
            if exist([pOut,filesep,fOut,suffix,outext],'file')
                nx=nx+1;
                suffix = [initsuffix sprintf('_%04d',nx)];
            else
                checkingfilename = 0;
                if nx>0
                    disp('Proposed filename in use. File saved as:  ');
                    disp(sprintf('%s',[pOut,filesep,fOut,suffix,outext]));
                end
            end
        end
              
        newmovie = avifile([pOut,filesep,fOut,suffix,outext],...
            'colormap',Iinfo.colormap,...
            'fps',30,...
            'Compression','None');
    end
    finalframe = endframe;
    % iterate through frames
    for i=startframe:endframe
        set(htextstring, 'String',...
            (sprintf('\n frame %u of %u Working...\n',...
            i-startframe+1,endframe-startframe+1)));
        disp(sprintf('\n frame %u of %u Working...',...
            i-startframe+1,endframe-startframe+1));
        inframe = getNextFrame(ext,pIn,fIn,i);
        outframeNum = sprintf('.%5.5u',i);
        
        pause(0.001); % allow user to cancel
        
        if undistort
            % do image processing here %%
            outframe = xFastDistortionCorrection(transformLUT, inframe);
            %add the next frame
            moviemax = max (max(max(outframe)),moviemax);
            newmovie = addImFrame(newmovie,outframe,...
                [pOut,filesep,fOut,outframeNum,outext],outext,...
                scaleType,ext,Iinfo,tempid);
        else
            moviemax = max (max(max(inframe)),moviemax);
            newmovie = addImFrame(newmovie,inframe,...
                [pOut,filesep,fOut,outframeNum,outext],outext,...
                scaleType,ext,Iinfo,tempid);
        end
        udata = get(hcancelbutton,'UserData');
        if (udata.cancel == 1)
            fprintf(' \nInterrupted by user.  If frame numbers are in file name,');
            fprintf(' \nit may be desirable to rename the file to correct them.');
            fprintf(' \nLast input file frame processed was frame %d.',i);
            udata.cancel = 0;
            set(hcancelbutton,'Userdata', udata);
            finalframe = i;
            
            break;
        end
        
    end
    if(strcmp(scaleType,'moviemax'))
        % read temporary file and write file(s) scaled so the movie's
        % maximum pixel value is mapped to the value that can be
        % represented in eight bits.
        fclose(tempid);
        tempid = fopen(tmp_nam,'r');
        precision = ['*' class(inframe)];
        for i = startframe:finalframe
            set(htextstring,'String',...
                (sprintf('\n frame %u of %u Scaling...\n',...
                i-startframe+1,finalframe-startframe+1)));
            disp(sprintf('\n frame %u of %u Scaling...',...
                i-startframe+1,finalframe-startframe+1));
            outframeNum = sprintf('.%5.5u',i);
            pause(0.001); % allow user to cancel
            outframe = fread(tempid,Iinfo.Height*Iinfo.Width,precision);
            outframe = reshape(outframe,Iinfo.Height,Iinfo.Width);
            outframe = uint8((double(double(2^8)/double(moviemax)))*outframe);
            newmovie = addImFrame(newmovie,outframe,...
                [pOut,filesep,fOut,outframeNum,outext],outext,...
                'none',ext,Iinfo,tempid);
            udata = get(hcancelbutton,'UserData');
            if (udata.cancel == 1)
                disp(sprintf(' \nInterrupted by user.  If frame numbers are in file name,'));
                disp(sprintf(' \nit may be desirable to rename the file to correct them.'));
                disp(sprintf(' \nLast input file frame processed was frame %d.',i));
                finalframe = i;
                break;
            end
            
        end
        % delete temporary file.
        fclose(tempid); % Windows will not allow delete if file is open
        pause(0.01); 
        
        delete (tmp_nam);
    end
    if (strcmp(outext, '.avi'))
        newmovie = close(newmovie);
    end
    if exist('hfig','var')
        close(hfig);
    end
    
    disp(sprintf('\n finished \n'))
    
else
    
    % only one frame
    
    inframe = I;
    ftype2 = strcmp(ext, '.tif');
    disp(sprintf('\t Working...'))
    if undistort
        % do image processing here %
        outframe = xFastDistortionCorrection(transformLUT, inframe);

    % scale to bitdepth 8
    outframe = uint8((double(2^8)/double(max(max(outframe))))*outframe);
    else
        inframe = uint8((double(2^8)/double(max(max(inframe))))*inframe);
    end
    [pOut, fOut] = fileparts([pIn,filesep,fIn,ext]);
    
    % single frame - prompt user to approve output file name or
    % change it
    if (strcmp(ext,'.cine')||strcmp(ext,'.cin'))
        ext = '.tif'; % set default output for cine input files
    end
    if strcmp(ext,'.avi') 
        ext = '.jpg'; % set default output for avi input file
    end
    if undistort
        [fout,pout] = uiputfile({'*.tif;*.jpg',...
            'Image files (*.tif, *.jpg)'},...
            'Save file As',...
            [defaultdir,filesep,fOut,'UNDIST',ext]);
    else
        [fout,pout] = uiputfile({'*.tif;*.jpg',...
            'Image files (*.tif, *.jpg)'},...
            'Save file As',...
            [defaultdir,filesep,fOut,ext]);
    end
    
    % if fout is zero, user canceled save
    if fout == 0
        disp('save cancelled by user.');
        return;
    end
    % Did user change output file extension?
    if strcmp(fout(end-2:end),'jpg')
        ftype2 = 0;
    elseif strcmp(fout(end-2:end),'tif')
        ftype2 = 1;
    else
        disp('Unrecognized output file extension.');
        if ftype2 == 1
            disp('Output file type is tif.');
            fout(end-3:end) = '.tif';
        else
            disp('Output file type is jpg.');
            fout(end-3:end) = '.jpg';
        end
    end
    defaultdir = pout; %update default directory
    if(xrayprojectdirhandle~=0)
        set(xrayprojectdirhandle,'String',pout);
    end
    if ftype2 == 1
         % output tif
         if undistort
            imwrite(outframe,[pout,filesep,fout],'tiff',...
                'Compression','none');
        else
            imwrite(inframe,[pout,filesep,fout],'tiff',...
                'Compression','none');
        end
    else
         %output jpg
         outfilename = [pout,filesep,fout];
        if undistort
            imwrite(outframe,outfilename,'jpg','Mode','lossy',...
                 'Quality', 75);
        else
            imwrite(inframe,outfilename,'jpg','Mode','lossy',...
                'Quality', 75);
        end
        
    end
    disp(sprintf('\n finished \n'))
end
end
% ----------------------------------------------

function cancelCallback
udata.cancel = 1;
set(gcbo,'Userdata', udata);
return;






