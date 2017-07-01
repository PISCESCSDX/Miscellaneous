function varargout = Undistorter(varargin)
% UNDISTORTER M-file for Undistorter.fig
%      UNDISTORTER, by itself, creates a new UNDISTORTER or raises the existing
%      singleton*.
%
%      H = UNDISTORTER returns the handle to a new UNDISTORTER or the handle to
%      the existing singleton*.
%
%      UNDISTORTER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in UNDISTORTER.M with the given input arguments.
%
%      UNDISTORTER('Property','Value',...) creates a new UNDISTORTER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Undistorter_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Undistorter_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Undistorter

% Last Modified by GUIDE v2.5 25-Jan-2011 11:35:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @Undistorter_OpeningFcn, ...
    'gui_OutputFcn',  @Undistorter_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

%-----------------------------------------
% --- Executes just before Undistorter is made visible.
function Undistorter_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Undistorter (see VARARGIN)

% Choose default command line output for Undistorter
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
defaultdir = cd; % initialize
xrayprojectdirhandle = 0; % initialize
if nargin==3 % no inputs, just run the gui
    % go create the GUI if we didn't get any input arguments
    
elseif nargin==4 % assume a switchyard call but no data
    
    xrayprojhandles = varargin{1};
    defaultdir = get(xrayprojhandles.defaultdir,'String');    
    xrayprojectdirhandle = xrayprojhandles.defaultdir;
else
    disp('DLTdv3Brown: incorrect number of input arguments')
    return
end

set(handles.defdir,'String',defaultdir);
uda(1) = handles.defdir;
uda(2) = xrayprojectdirhandle;

set(handles.hopen,'UserData',uda);
% UIWAIT makes Undistorter wait for user response (see UIRESUME)
% uiwait(handles.undistorterfigure);

%-----------------------------------------
% --- Outputs from this function are returned to the command line.
function varargout = Undistorter_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%-----------------------------------------
% --- Executes on button press in hset.
function hset_Callback(hObject, eventdata, handles)
% hObject    handle to hset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

I = get(handles.undistorterfigure,'UserData');
levelMax = (2^8)-1;
if(isa(I,'uint16'))
    levelMax = (2^16)-1;
end
level = get(handles.hsGray,'Value')/levelMax;
sizeLim = get(handles.hsSize,'Value');
%         set(hWorking,'visible','on'); pause(0.1);

    % We don't want to include insufficiently sized cells that may alter
    % our calculations, so color the pixels from such cells black.
    badPixels = removesmalls(I,level,sizeLim);
            set(handles.hsSize,'UserData',badPixels);
    I(badPixels) = 0;
    
[InputPoints, BasePoints, dY, dX, dOffY, gridOrient] = ...
    getControlPoints(I, level, sizeLim);
iResolution = [size(I,2) size(I,1)]; % LJR

set(0,'CurrentFigure',imgcf) % plot blue asterisks over red cells
% Some cells (which are partial) may not get blue asterisks.
hold on
plot(InputPoints(:,1),InputPoints(:,2),'b*')
button = questdlg(...
    'Continue lookup table creation or cancel?  This process will take 5 to 20 minutes.',...
    'Create lookup table?',...
    'Continue', 'Cancel without Saving',...
    'Continue');
if (strcmp(button,'Continue'))
    undistortTform = cp2tform(InputPoints, BasePoints, 'lwm');
    pixLUT = xCreateLookupTable(undistortTform,iResolution);
    tic;
    preview = xFastDistortionCorrection(pixLUT, I);
    tTime = toc;
    figure('NumberTitle', 'off', ...
        'Name', 'Undistorted Calibration Grid Image');
    imshow(preview);
    
    % get error calculations on preview image
    meanAreaOrig = meanCellArea(I,level); %level is grey level threshold value
    meanAreaPrev = meanCellArea(preview,level);
    sizeLimPreview = meanAreaPrev*(sizeLim/meanAreaOrig);
    
        % We don't want to include insufficiently sized cells that may alter
    % our calculations, so color the pixels from such cells black.
    badPixels = removesmalls(I,level,sizeLim);
            set(handles.hsSize,'UserData',badPixels);
    I(badPixels) = 0;
    
    [ip, bp] = getControlPoints(preview, level, sizeLimPreview);
    [mE, maxE] = xMeasureAccuracy(ip, bp);
    tError = mE;
    tMaxError = maxE;
    
    %image coordinates flipped to upper right quadrant (like a graph)
    BasePointsflip(:,1)= BasePoints(:,1);
    InputPointsflip(:,1)= InputPoints(:,1);
    BasePointsflip(:,2)= iResolution(2)-BasePoints(:,2);
    InputPointsflip(:,2)= iResolution(2)-InputPoints(:,2);
    
    %variables that will be loaded by the digitizing program
    camud=cp2tform(BasePointsflip,InputPointsflip,'lwm');
    camud.xlim=[min(InputPointsflip(:,1)),max(InputPointsflip(:,1))];
    camud.ylim=[min(InputPointsflip(:,2)),max(InputPointsflip(:,2))];
    camd=cp2tform(InputPointsflip,BasePointsflip,'lwm');
    camd.xlim=[min(BasePointsflip(:,1)),max(BasePointsflip(:,1))];
    camd.ylim=[min(BasePointsflip(:,2)),max(BasePointsflip(:,2))];
    
    tType = 'LWM';
    tForm = undistortTform;
    button = 'Save';
    
    while (strcmp(button,'Save'))
        uda = get(handles.hopen, 'UserData');
        filespec = get(uda(1),'UserData');
        [pathname, filename, ext, version] = ...
            fileparts(filespec);
        if (strcmp(button,'Save'))
            [file,path] = uiputfile('*.mat','Save Workspace As',...
                [pathname,filesep,filename,'UNDTFORM']);
            if isequal(path,0)
                button = questdlg(...
                    'Bad file name or Save cancelled by user.',...
                    'Undistorter Warning',...
                    'Save', 'Exit without Saving',...
                    'Save');
                if (strcmp(button,'Exit without Saving'))
                    return;
                end
            end
        end
        try
            save([path,file], 'InputPoints', 'BasePoints',...
                'undistortTform',...
                'dY','dX','dOffY','BasePointsflip',...
                'InputPointsflip','camud',...
                'camd','level','sizeLim','tError',...
                'tMaxError','tTime',...
                'tType','tForm','pixLUT','iResolution');
            button = 'Exit without Saving';
        catch
            if isequal(path,0) % prompt again
                button = 'Save';
            elseif exist([path file],'file')
                smsg = sprintf('Unable to save file %s\n', file);
                smsg2 = 'Save with new name or Exit without saving?';
                button = questdlg(...
                    [smsg smsg2],...
                    'Undistorter Error',...
                    'Save', 'Exit without Saving',...
                    'Exit without Saving');
            else
                button = 'Exit without Saving';
            end
        end
    end
    % do not update uda(1)'UserData'. It is filespec for undistorted image.
    set(uda(1),'String',path);   % update default directory here
    if(uda(2))
        set(uda(2),'String',path);   % update default directory in caller
    end
    % try to save undistorted image same folder (current default directory)
    [fim,pim] = uiputfile([path,filesep,filename,'UND.tif'],'Save image As');
    if isequal(fim,0)
        disp(sprintf('Save undistorted image cancelled by user.\n'));
    else
        imwrite(preview,[pim,filesep,fim],'tif');
    end
end
set(handles.hset,'Visible','off');
set(handles.hopen,'Visible','on');
set(handles.heGrayThreshold,'Enable','off');
set(handles.heSizeThreshold,'Enable','off');
set(handles.hsGray,'Enable','off');
set(handles.hsSize,'Enable','off');
set(handles.hsSizeScaleUp,'Enable','off');
set(handles.hsSizeScaleDn,'Enable','off');
set(handles.hsGrayScaleUp,'Enable','off');
set(handles.hsGrayScaleDn,'Enable','off');

%-----------------------------------------
% --- Executes on button press in hopen.
function hopen_Callback(hObject, eventdata, handles)
% hObject    handle to hopen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

uda = get(hObject,'UserData');
defaultdir = get(uda(1),'String');
xrayprojectdirhandle = uda(2);

% get file
[fname,pname]=uigetfile({'*.tif;*.jpg;*.avi;*.cin;*.cine', ...
    'Image files (*.tif, *.jpg, *.avi, *.cin, *.cine)';
    '*.avi','(*.avi)';...
    '*.jpg','(*.jpg)';...
    '*.tif','(*.tif)'},...
    'Select a distorted grid image', defaultdir);

if fname == 0
    disp(sprintf('\nNo File Chosen - aborting undistortion\n'))
    close
    return
end

[I,Iinfo] = calimread([pname,fname]);
rawImax=max(max(I(:,:))); % maximum raw image pixel value



%do some initial processing (Adjusted strel value to accomodate
%image size)
Ibackground = imopen(I,strel('disk',round(Iinfo.Height*(15/1024))));
I = imsubtract(I,Ibackground);
I = imadjust(I);
%       set(hopen,'UserData',[pname,fname]);
set(uda(1),'UserData',[pname,fname]); % for hsetCallback
set(uda(1),'String',pname);   % update default directory here
if(uda(2))
    set(uda(2),'String',pname);   % update default directory in caller
end
% update Size threshold slider maximum value
set(handles.hsSize,'Max',round((130/1024)*size(I,1)));
set(handles.hsSizeScaleText,'String',...
    ['Max: ' num2str(get(handles.hsSize,'Max'))]); %update Size thresh.max. display
% update Gray level threshold slider maximum value
levelMax = (2^8)-1;
if(isa(I,'uint16'))
    levelMax = (2^16)-1;
    
end
set(handles.hsGray,'Max',levelMax); 
set(handles.hsGrayScaleText, ...
    'String',['Max: ' num2str(levelMax)]); % update Gray thresh.max. display
set(handles.hsGray,'Value',round((150/255)*levelMax));
set(handles.heGrayThreshold,'String',get(handles.hsGray,'Value'));
%turn on controls
set(handles.heGrayThreshold,'enable','on'); % grayscale edit box
set(handles.heSizeThreshold,'enable','on'); % cell size edit box
set(handles.hsGray,'enable','on');  % grayscale slider
set(handles.hsSize,'enable','on'); % cell size slider
set(handles.hsSizeScaleUp,'Enable','on');
set(handles.hsSizeScaleDn,'Enable','on');
set(handles.hsGrayScaleUp,'Enable','on');
set(handles.hsGrayScaleDn,'Enable','on');

% attach grayscale image data to window for later access
set(handles.undistorterfigure,'UserData',I);

% uses the default value set in hsSize control to remove small cells
level = get(handles.hsGray,'Value')/levelMax;
sizeLim = get(handles.hsSize,'Value');
pixlist = removesmalls(I,level,sizeLim);
        set(handles.hsSize,'UserData',pixlist);
I(pixlist) = 0;

RGB = updateRed(I,level,sizeLim,handles); %set initial value for pixel selection
figure, imshow(RGB)
set(gcf,'name',['Original Distorted Image - ',fname], ...
    'NumberTitle', 'off')

figure_handle = imgcf; % get the figure handle for distorted image
set(figure_handle,'UserData',I); % update image

set(handles.hopen,'visible','off'); % turn the open button off
set(handles.hset,'visible','on'); % turn the set button on


%-----------------------------------------
% --- Executes during object creation, after setting all properties.
function defdir_CreateFcn(hObject, eventdata, handles)
% hObject    handle to defdir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

%-----------------------------------------
% --- Executes on Size Threshold slider movement.
% size threshold slider control
function hsSize_Callback(hObject, eventdata, handles)
% hObject    handle to hsSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of
%        slider

%update if small cells are updated
set(handles.heSizeThreshold,'String',num2str(round(get(handles.hsSize,'Value'))));
I = get(handles.undistorterfigure,'UserData');

levelMax = (2^8)-1;
if(isa(I,'uint16'))
    levelMax = (2^16)-1;
end

level = get(handles.hsGray,'Value')/levelMax;
RGB = updateRed(I,level,get(handles.hsSize,'Value'),handles);
axes_handle = get(imgcf,'CurrentAxes');
set(get(axes_handle,'children'),'CData',RGB);


%-----------------------------------------
% --- Executes during object creation, after setting all properties.
function hsSize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hsSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


%-----------------------------------------
% size threshold edit box
function heSizeThreshold_Callback(hObject, eventdata, handles)
% hObject    handle to heSizeThreshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of heSizeThreshold as text
%        str2double(get(hObject,'String')) returns contents of heSizeThreshold as a double

set(handles.hsSize,'Value',str2num(get(handles.heSizeThreshold,'String')));
I = get(handles.undistorterfigure,'UserData');

levelMax = (2^8)-1;
if(isa(I,'uint16'))
    levelMax = (2^16)-1;
end

level = get(handles.hsGray,'Value')/levelMax;
RGB = updateRed(I,level,get(handles.hsSize,'Value'),handles);
axes_handle = get(imgcf,'CurrentAxes');


%-----------------------------------------
% --- Executes during object creation, after setting all properties.
function heSizeThreshold_CreateFcn(hObject, eventdata, handles)
% hObject    handle to heSizeThreshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%-----------------------------------------
% --- Executes on button press in hsSizeScaleUp.
function hsSizeScaleUp_Callback(hObject, eventdata, handles)
% hObject    handle to hsSizeScaleUp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% slider 2X scale button clicked

set(handles.hsSize,'Max',(2*get(handles.hsSize,'Max')));
set(handles.hsSizeScaleText,'String',sprintf('Max: %d',get(handles.hsSize,'Max')));
hsSize_Callback(hObject, eventdata, handles);


%-----------------------------------------
% --- Executes on button press in hsSizeScaleDn.
function hsSizeScaleDn_Callback(hObject, eventdata, handles)
% hObject    handle to hsSizeScaleDn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% slider 1/2X scale button clicked

newsMax = ceil(0.5*get(handles.hsSize,'Max'));
sVal = get(handles.hsSize,'Value');
set(handles.hsSize,'Value',min(sVal,newsMax));
set(handles.hsSize,'Max',newsMax);
set(handles.hsSizeScaleText,'String',sprintf('Max: %d',get(handles.hsSize,'Max')));
hsSize_Callback(hObject, eventdata, handles);

%-----------------------------------------
% --- Executes on button press in hsGrayScaleUp.
function hsGrayScaleUp_Callback(hObject, eventdata, handles)
% hObject    handle to hsGrayScaleUp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% slider 2X scale button clicked

set(handles.hsGray,'Max',(2*get(handles.hsGray,'Max')));
set(handles.hsGrayScaleText,'String',sprintf('Max: %d',get(handles.hsGray,'Max')));
hsGray_Callback(hObject, eventdata, handles);


%-----------------------------------------
% --- Executes on button press in hsGrayScaleDn.
function hsGrayScaleDn_Callback(hObject, eventdata, handles)
% hObject    handle to hsGrayScaleDn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% slider 1/2X scale button clicked

newsMax = ceil(0.5*get(handles.hsGray,'Max'));
sVal = get(handles.hsGray,'Value');
set(handles.hsGray,'Value',min(sVal,newsMax));
set(handles.hsGray,'Max',newsMax);
set(handles.hsGrayScaleText,'String',sprintf('Max: %d',get(handles.hsGray,'Max')));
hsGray_Callback(hObject, eventdata, handles);


%-----------------------------------------
% grayscale level slider control
% --- Executes on grayscale level slider movement.
function hsGray_Callback(hObject, eventdata, handles)
% hObject    handle to hsGray (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

set(handles.heGrayThreshold,'String',...
    num2str(round(get(handles.hsGray,'Value')))); %update Grayscale edit box

%update image with new threshold input
I = get(handles.undistorterfigure,'UserData');

levelMax = (2^8)-1;
if(isa(I,'uint16'))
    levelMax = (2^16)-1;
end

level = get(handles.hsGray,'Value')/levelMax;
RGB = updateRed(I,level,get(handles.hsSize,'Value'),handles);
%         figure_handle = imgcf;
%         set(figure_handle,'UserData',RGB); % update figure

axes_handle = get(imgcf,'CurrentAxes');
set(get(axes_handle,'children'),'CData',RGB); % update current image data array


%-----------------------------------------
% --- Executes during object creation, after setting all properties.
function hsGray_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hsGray (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


%-----------------------------------------
% grey level threshold edit box
function heGrayThreshold_Callback(hObject, eventdata, handles)
% hObject    handle to heGrayThreshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of heGrayThreshold as text
%        str2double(get(hObject,'String')) returns contents of heGrayThreshold as a double


% update if new threshold is typed into the edit box
set(handles.hsGray,'Value',str2num(get(handles.heGrayThreshold,'String')));
I = get(handles.undistorterfigure,'UserData');

levelMax = (2^8)-1;
if(isa(I,'uint16'))
    levelMax = (2^16)-1;
end

level = get(handles.hsGray,'Value')/levelMax;
RGB = updateRed(I,level,get(handles.hsSize,'Value'), handles);
axes_handle = get(imgcf,'CurrentAxes');


%-----------------------------------------
% --- Executes during object creation, after setting all properties.
function heGrayThreshold_CreateFcn(hObject, eventdata, handles)
% hObject    handle to heGrayThreshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    function [RGB] = updateRed(I,level,sizeLim,handles)
%         
%         if get(hc1,'Value') == 1 % flip image if checkbox is checked
%             I = fliplr(I);
%         end
        levelMax = (2^8)-1;
        if (isa(I,'uint16'))
            levelMax = (2^16)-1;
        end
        
        pixlist = removesmalls(I,level,sizeLim); % remove small cells and edge cells
                set(handles.hsSize,'UserData',pixlist);
        I(pixlist) = 0; % turn small cell pixels black        
        
        Ir = I;
        Ib = I;
        Ig = I;
        idx = find(I > (get(handles.hsGray,'Value'))); %indices of cells with values less than slider setting.
        Ir(idx) = levelMax; %(red)
        Ib(idx) = 0;
        Ig(idx) = 0;
        RGB = cat(3,Ir,Ib,Ig);
   % end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % removesmalls is called initially and called by updateRed.  Returns
    % small cell pixels and pixels of cells that touch edge of rectangle
    % bounding entire image I.

    function [pixelList] = removesmalls(I,level,sizeLim)
      
        %level = get(hsGray,'Value')/levelMax;
        udim = size(I,2); %horizontal
        vdim = size(I,1); %vertical

        % create black/white image and extract information
        bw = im2bw(I,level);
        bwlabeled = bwlabel(bw,4);
        celldata = regionprops(bwlabeled,'Area','BoundingBox','PixelIdxList');

        %sizeLim = get(hsSize,'value');% get the size limit from hsSize

        %get areas and bounding boxes
        areas = cat(1,celldata.Area);
        bb= cat(1,celldata.BoundingBox);

        % select pixels with edge touching cells -- i.e., edge of rectangle
        % that bounds entire image.
        idx = find(bb(:,1) == 0.5 | bb(:,1)+bb(:,3) > udim-0.5 |...
            bb(:,2) == 0.5 | bb(:,2)+bb(:,4) > vdim-0.5 );
        edgeTouchingCells = celldata(idx);
        pixlist = cat(1,edgeTouchingCells.PixelIdxList);

        % select small cell pixels
        idx = find(areas < sizeLim);
        smallcells = celldata(idx);

        %stack the two lists
        pixelList = cat(1,pixlist, cat(1,smallcells.PixelIdxList));
 %       set(handles.hsSize,'UserData',pixelList); % <--caller should do this

 % end



    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%Non-Staggered Grid Procedure %%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function [BasePoints,InputPoints,dY,dX,dOffY] = getPts4(cp,centroids,four)

        hwait = waitbar(0, 'Creating/checking Control Points');
        
        % set first point to the point closest to the center of the image
        BasePoints = cp;
        InputPoints = cp;

        % set the cell center to center distance
        dY = mean(rnorm([four(:,1)-cp(1) four(:,2)-cp(2)]));
        dX = NaN;
        dOffY = NaN;
        
        % establish base points to undisort the quadrants.
        r = four(2,:); %get the initial right cell for 1st quadrant
        f.q1 = four(1,:);
        f.q2 = four(3,:);
        f.q3 = four(4,:);

        cp = four(1,:);
        [four] = adj4Cells(cp,centroids);
        f.q4 = four(4,:);

        cp = four(3,:);


        i = 2;
        ychk = 1; % used to check for edge on y image axis
        xchk = 1; % used to check for edge on y image axis
        col = 1; a = 1; b = 2; c = -1; d = 1;

        for j = 1:4

            while xchk == 1

                while ychk == 1

                    [four] = adj4Cells(cp,centroids);

                    angles = (180/pi)*(atan2(four(:,2)-cp(2),four(:,1)-cp(1)));
                    ychk = ycheck(angles);
                    if ychk == 0
                        break
                    end

                    cp = four(a,:);
                    InputPoints(i,:) = cp;
                    BasePoints(i,1) = BasePoints(i-1,1);
                    BasePoints(i,2) = BasePoints(i-1,2)+c*dY;
                    i = i+1;
                end
                
                cp = r;
                [four] = adj4Cells(cp,centroids);

                angles = (180/pi)*(atan2(four(:,2)-cp(2),four(:,1)-cp(1)));
                xchk = ycheck(angles);
                if xchk == 0
                    break
                end

                InputPoints(i,:) = cp;
                BasePoints(i,1) = BasePoints(1,1)+(d*dY)*col;
                if j ==1 || j == 3
                    BasePoints(i,2) = BasePoints(1,2);
                elseif j == 2
                    BasePoints(i,2) = BasePoints(1,2)+dY;                   
                elseif j == 4
                    BasePoints(i,2) = BasePoints(1,2)-dY;  
                end

                r = four(b,:);

                i = i + 1;
                col = col + 1;
                ychk = 1;

            end

            if j == 1

                cp = f.q2;
                [four] = adj4Cells(cp,centroids);

                InputPoints(i,:) = cp;
                BasePoints(i,1) = BasePoints(1,1);
                BasePoints(i,2) = BasePoints(1,2)+dY;
                i = i+1;

                ychk = 1;
                xchk = 1;
                col = 1; a = 3; b = 2; c = 1; d = 1;

                r = four(b,:);

            elseif j == 2

                cp = f.q3;
                [four] = adj4Cells(cp,centroids);

                InputPoints(i,:) = cp;
                BasePoints(i,1) = BasePoints(1,1)-dY;
                BasePoints(i,2) = BasePoints(1,2);
                i = i+1;

                ychk = 1;
                xchk = 1;
                col = 2; a = 3; b = 4; c = 1; d = -1;

                r = four(b,:);

            elseif j == 3

                cp = f.q4;
                [four] = adj4Cells(cp,centroids);

                InputPoints(i,:) = cp;
                BasePoints(i,1) = BasePoints(1,1)-dY;
                BasePoints(i,2) = BasePoints(1,2)-dY;
                i = i+1;

                ychk = 1;
                xchk = 1;
                col = 2; a = 1; b = 4; c = -1; d = -1;

                r = four(b,:);

            end
            waitbar(j*0.25,hwait);
        end
        close(hwait);
 %  end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%% Staggered Grid Procedure %%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % called by getControlPoints.  
    function [BasePoints,InputPoints,dY,dX,dOffY] = getPts6(cp,centroids,six)
        
        hwait = waitbar(0, 'Creating/checking Control Points');
                
        % get matrix of points for staggered cells
        BasePoints = cp;
        InputPoints = cp;

        % set the cell center to center distance.  Use average of distances
        % between centerpoint (cp) and six surrounding points.
        dY = mean(rnorm([six(:,1)-cp(1) six(:,2)-cp(2)]));
        dX = cosd(30)*dY; 
        dOffY = sind(30)*dY;

        % establish base points to undisort the quadrants.
        r = six(2,:); %get the initial right cell for 1st quadrant
        f.q1 = six(1,:);
        f.q2 = six(4,:);
        f.q3 = six(6,:);
        f.q4 = six(5,:);

        i = 2;
        ychk = 1; % used to check for edge on y image axis
        xchk = 1; % used to check for edge on y image axis
        col = 1; a = 1; b = 2; c = -1; d = 1;

        for j = 1:4
            while xchk == 1 % travel down column
                while ychk == 1 %(repeat) until edge (i.e., bottom)reached.

                    [six,sm] = adjCells(cp,centroids);

                    angles = (180/pi)*(atan2(six(:,2)-cp(2),six(:,1)-cp(1)));
                    ychk = ycheck(angles);
                    if ychk == 0
                        break  % break out of while ychk==1 loop
                    end

                    cp = six(a,:); % change centerpoint to point closest to
                    % bottom of hexagon (a=1) or top of hexagon (a=4)
                    InputPoints(i,:) = cp;
                    BasePoints(i,1) = BasePoints(i-1,1);
                    BasePoints(i,2) = BasePoints(i-1,2)+c*dY;
                    i = i+1;
                end   % end while ychk          
   
                cp = r; %change centerpoint--move right (b=2) or left (b=5)
               
                [six,sm] = adjCells(cp,centroids);

                angles = (180/pi)*(atan2(six(:,2)-cp(2),six(:,1)-cp(1)));
                xchk = ycheck(angles);
                if xchk == 0 %break out of while xchk==1 loop.  This stops 
                    % us when edge of grid is reached as we traverse in 
                    % (roughly) the x-direction.
                    break
                end

               
                
                InputPoints(i,:) = cp;
                BasePoints(i,1) = BasePoints(1,1)+(d*dX)*col;
                if j == 3 || j == 4
                    BasePoints(i,1) = BasePoints(1,1)+(d*dX)*(col+1);
                end
               %Next column: 
                col = col + 1;                  
                
                if j == 1
                    if rem(col,2) == 0 % even column number is offset
                        BasePoints(i,2) = BasePoints(1,2)-dOffY; %offset down
                    else % odd column number is same as first column.
                        BasePoints(i,2) = BasePoints(1,2);
                    end
                elseif j == 2
                    if rem(col,2) == 0
                        BasePoints(i,2) = BasePoints(1,2)+dOffY; %offset up
                    else
                        BasePoints(i,2) = BasePoints(1,2)+dY;
                    end
                elseif j == 3
                    if rem(col,2) == 0
                        BasePoints(i,2) = BasePoints(1,2);
                    else
                        BasePoints(i,2) = BasePoints(1,2)+dOffY;
                    end                    
                elseif j == 4
                   if rem(col,2) == 0
                        BasePoints(i,2) = BasePoints(1,2)-dY;
                    else
                        BasePoints(i,2) = BasePoints(1,2)-dOffY;
                    end                    
                end
               
                if rem(col,2) == 0
                    r = six(b+1,:);
                else
                    r = six(b,:); %initialize for next column--to right
                    %(b=2) or left (b=5)
                end
                    

                i = i + 1;
                ychk = 1;

            end % end while xchk==1

            if j == 1 %initialize for pass j=2 for-loop.

                cp = f.q2; % above centerpoint and up
                [six] = adjCells(cp,centroids);

                InputPoints(i,:) = cp;
                BasePoints(i,1) = BasePoints(1,1);
                BasePoints(i,2) = BasePoints(1,2)+dY;
                i = i+1;

                ychk = 1;
                xchk = 1;
                col = 1; a = 4; b = 2; c = 1; d = 1;
                % travel up the column (a=4),
                % next column is to the right (b=2),
                % up (c=1)
                % right (d=1)
                r = six(b,:);

            elseif j == 2 %initialize for pass j=3 for-loop

                cp = f.q3; % left and up
                [six] = adjCells(cp,centroids);

                InputPoints(i,:) = cp;
                BasePoints(i,1) = BasePoints(1,1)-dX;
                BasePoints(i,2) = BasePoints(1,2)+dOffY;
                i = i+1;

                ychk = 1;
                xchk = 1;
                col = 1; a = 4; b = 5; c = 1; d = -1;
                %         up     left   up    left
                r = six(b,:);

            elseif j == 3 % initialize for pass j=4 for-loop

                cp = f.q4; % left and down
                [six] = adjCells(cp,centroids);

                InputPoints(i,:) = cp;
                BasePoints(i,1) = BasePoints(1,1)-dX;
                BasePoints(i,2) = BasePoints(1,2)-dOffY;
                i = i+1;

                ychk = 1;
                xchk = 1;
                col = 1; a = 1; b = 5; c = -1; d = -1;
                %         down   left   down    left
                r = six(b,:);

            end % end of if else...
            waitbar(j*0.25,hwait);
        end % end of for j=1:4
        close(hwait);
 %  end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % called by getControlPoints
    function [gridOrient] = gridOrientation(cp,centroids,gridType)

        dist = rnorm([centroids(:,1)-cp(1) centroids(:,2)-cp(2)]);
        r = sort(dist);

        if strcmp(gridType,'square')==1

            r = r(2:5);

            idx = find(dist == r(1) | dist == r(2) | dist == r(3) | dist == r(4));

            four = centroids(idx,:);

            % reorder four
            angles = (180/pi)*(atan2(four(:,2)-cp(2),four(:,1)-cp(1)));
            perfectlyPlacedGrid = [0;0;0;0];

            idx = find(abs(angles+90)==min(abs(angles+90)));
            perfectlyPlacedGrid(idx) = 90;
            idx = find(abs(angles)==min(abs(angles)));
            perfectlyPlacedGrid(idx) = 0;
            idx = find(abs(angles-90)==min(abs(angles-90)));
            perfectlyPlacedGrid(idx) = -90;
            idx = find(abs(abs(angles)-180) == min(abs(abs(angles)-180)));
            perfectlyPlacedGrid(idx) = -180;

        elseif strcmp(gridType,'hexagonal')==1

            r = r(2:7);

            idx = find(dist == r(1) | dist == r(2) | dist == r(3)...
                | dist == r(4)| dist == r(5)| dist == r(6));

            six = centroids(idx,:);

            % reorder six
            % angles in radians from the center point to each of the six points
            angles = (180/pi)*(atan2(six(:,2)-cp(2),six(:,1)-cp(1)));
            perfectlyPlacedGrid = [0;0;0;0;0;0];

            idx = find(abs(angles+90)==min(abs(angles+90)));
            perfectlyPlacedGrid(idx) = 90;
            idx = find(abs(angles+30)==min(abs(angles+30)));
            perfectlyPlacedGrid(idx) = 30;
            idx = find(abs(angles-30)==min(abs(angles-30)));
            perfectlyPlacedGrid(idx) = -30;
            idx = find(abs(angles-90)==min(abs(angles-90)));
            perfectlyPlacedGrid(idx) = -90;
            idx = find(abs(angles-150)==min(abs(angles-150)));
            perfectlyPlacedGrid(idx) = -150;
            idx = find(abs(angles+150)==min(abs(angles+150)));
            perfectlyPlacedGrid(idx) = 150;
        end
        
        gridOrient = mean(angles+perfectlyPlacedGrid);
        
  %  end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    function [four] = adj4Cells(cp,centroids)

        % returns the 4 closest cells to cp reorders so that 1st row is
        % always up then moves clockwise 2=right 3=down 4=left

        dist = rnorm([centroids(:,1)-cp(1) centroids(:,2)-cp(2)]);
        r = sort(dist);
        r = r(2:5);
        
        idx = find(dist == r(1) | dist == r(2) | dist == r(3) | dist == r(4));
            
        four = centroids(idx,:);

        % reorder four
        angles = (180/pi)*(atan2(four(:,2)-cp(2),four(:,1)-cp(1)));

        idx = find(abs(angles+90)==min(abs(angles+90)));
        U = four(idx,:);
        idx = find(abs(angles)==min(abs(angles)));
        R = four(idx,:);
        idx = find(abs(angles-90)==min(abs(angles-90)));
        D = four(idx,:);
        idx = find(abs(abs(angles)-180) == min(abs(abs(angles)-180)));
        L = four(idx,:);

        four = [U;R;D;L];



   % end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % called by getControlPoints, getPts6
    function [six,sm] = adjCells(cp,centroids)

        % returns the 6 closest cells to cp
        % [note: dist is for all centroids, not just neighborhood of cp.]
        dist = rnorm([centroids(:,1)-cp(1) centroids(:,2)-cp(2)]);
        r = sort(dist);
        r = r(2:7); % r is distance--i.e., radius--from cp to point.
        
        idx = find(dist == r(1) | dist == r(2) | dist == r(3)...
            | dist == r(4)| dist == r(5)| dist == r(6));
            
        six = centroids(idx,:);
        
        sm = std(r)/mean(r);
        
        % reorder six
        % angles from the center point to each of the six points
        angles = (180/pi)*(atan2(six(:,2)-cp(2),six(:,1)-cp(1)));

        idx = find(abs(angles+90)==min(abs(angles+90)));
        U = six(idx,:);
        idx = find(abs(angles+30)==min(abs(angles+30)));
        UR = six(idx,:);
        idx = find(abs(angles-30)==min(abs(angles-30)));
        DR = six(idx,:);
        idx = find(abs(angles-90)==min(abs(angles-90)));
        D = six(idx,:);
        idx = find(abs(angles-150)==min(abs(angles-150)));
        DL = six(idx,:);
        idx = find(abs(angles+150)==min(abs(angles+150)));
        UL = six(idx,:);

        six = [U;UR;DR;D;UL;DL];

  %  end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% called by getPts6
    function [ychk] = ycheck(angles)
        
        ychk = 1;

        if length(angles) == 4 % rectilinear grid
           
            a = [90;0;90;180];
            
            for i = 1:4
                
            hdiff = a(i) - abs(angles(i));
            if  hdiff > 20 || hdiff < -20
                ychk = 0;
            end
            end

        elseif length(angles) == 6 %hexagonal grid
            
            a = [90;30;30;90;150;150]; % ideal absolute angles
            
            for i = 1:6
                
            hdiff = a(i) - abs(angles(i));
            if  hdiff > 20 || hdiff < -20
                ychk = 0;
            end
            end

        else
            return  %error? Grid of neither type.
            ychk = 0;
        end
        
   % end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%not used
 %   function [BaseReduced,InputReduced] = reducePts(BasePoints,InputPoints)
        
%        onumpts = length(BasePoints);
        
%        if onumpts < 700
%        factor = 1;
%        elseif onumpts >= 700 && onumpts < 1000
%            factor = 1;
%        elseif onumpts >= 1000 && onumpts < 1500
%            factor = 2;
%            factor = 3;
%        elseif onumpts >= 2000 && onumpts < 2500
%            factor = 4; 
%        elseif onumpts >= 2500 && onumpts < 3000
%            factor = 5;  
%        else
%            factor = 6;
%        end
        
%        numPoints = round(length(BasePoints)/factor);
%        numPoints = numPoints -10;
        
%        BaseReduced = BasePoints(1,:);
%        for i = 1:numPoints
%            BaseReduced(i+1,:) = BasePoints(i*factor,:);
%        end
        
%        InputReduced = InputPoints(1,:);
%        for i = 1:numPoints
%            InputReduced(i+1,:) = InputPoints(i*factor,:);
%        end
%    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ip, bp, dY, dX, dOffY, gridOrient] = getControlPoints(...
        I, level, sizeLim, dY, dX, dOffY)
% getControlPoints is called when "Set" is clicked (called with 3
% parameters, not six!).
% ip is input points; bp is base points.
% returns ip--coordinates of blue asterisks.
    udim = size(I,2);
    vdim = size(I,1);
    % We don't want to include insufficiently sized cells that may alter
    % our calculations, so color the pixels from such cells black. 
    %  Before calling getControlPoints, caller must do this:
 %   badPixels = removesmalls(I,level,sizeLim);
 %           set(handles.hsSize,'UserData',badPixels);
 %   I(badPixels) = 0;

    % convert original image to black and white
    bw = im2bw(I,level);

    % get centroid data from grid image
    bwlabeled = bwlabel(bw,4);
    celldata = regionprops(bwlabeled,'Centroid');
    centroids = cat(1,celldata.Centroid);

    %find the centroid closest to the center of the image 
    % Note: if bounding box dimensions are even, "centroid" cannot be true
    % center of mass.
    dist = rnorm([centroids(:,1)-udim/2 centroids(:,2)-vdim/2]);
    idx = find(dist == min(dist));

    cp = centroids(idx,:); % set current point to

    % determine if grid cells are staggered or square
    % if sm is below 0.08, then it is the staggered grid
    [six,sm] = adjCells(cp,centroids); 
    
    % set the grid type and get an orientation
    if sm > 0.08

        % set grid type
        gridType = 'square';
        gridOrient = gridOrientation(cp,centroids,gridType);

    else   

       % set grid type
        gridType = 'hexagonal';
        gridOrient = gridOrientation(cp,centroids,gridType);

    end
    
    
    
    % rotate the centroids for processing (they will be returned to
    % original location after "true" grid is determined)
    % move rotation point to center of the image
    centroids(:,1) = centroids(:,1) - (udim/2); %translate center to cp
    centroids(:,2) = centroids(:,2) - (vdim/2);

    % rotate centroids to match true orientation
    rotm = [cosd(gridOrient) -sind(gridOrient); sind(gridOrient) cosd(gridOrient)];
    centroids = centroids*rotm; 

    % move back to original image coordinate system
    centroids(:,1) = centroids(:,1) + (udim/2); %trans. center to original pt.
    centroids(:,2) = centroids(:,2) + (vdim/2);

    cp = centroids(idx,:);

   if sm > 0.08

        [four] = adj4Cells(cp,centroids);
        % Get "true grid" points
        if(nargin > 3)
            [bp,ip,dY,dX,dOffY] = getPts4(cp,centroids,...
                                                four, dY);
        else
            [bp,ip,dY,dX,dOffY] = getPts4(cp,centroids,...
                                                four);
        end

        dX = NaN;
        dOffY = NaN;

   else

        [six,sm] = adjCells(cp,centroids); 
        if(nargin < 6)
            [bp,ip,dY,dX,dOffY] = getPts6(cp,centroids,six);
        else
            [bp,ip,dY,dX,dOffY] = getPts6(cp,centroids,...
                                                six, dY, dX, dOffY);
        end

   end

    % move rotation point to center of the image
    bp(:,1) = bp(:,1) - (udim/2);
    bp(:,2) = bp(:,2) - (vdim/2);
    ip(:,1) = ip(:,1) - (udim/2);
    ip(:,2) = ip(:,2) - (vdim/2);

    % rotate the data ang degrees (clockwise)
    rotm = [cosd(-gridOrient) -sind(-gridOrient); sind(-gridOrient) cosd(-gridOrient)];
    bp = bp*rotm;
    ip = ip*rotm;

    % move the data back to image coordinate system
    bp(:,1) = bp(:,1) + (udim/2);
    bp(:,2) = bp(:,2) + (vdim/2);
    ip(:,1) = ip(:,1) + (udim/2);
    ip(:,2) = ip(:,2) + (vdim/2);
    
% end

    function [meanArea] = meanCellArea(I,level)
        
    bw = im2bw(I,level);

    % get centroid data from grid image
    bwlabeled = bwlabel(bw,4);
    celldata = regionprops(bwlabeled,'Area');
    areas = cat(1,celldata.Area);
    meanArea = mean(areas);
        
%    end
% end


% --- Executes during object creation, after setting all properties.
function hsSizeScaleText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hsSizeScaleText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
