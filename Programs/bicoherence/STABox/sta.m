function varargout = sta(varargin)
% STA M-file for STA.fig
%
%      STA is a Graphical Interface for the Spatio-Temporal Analysis Box
%      by F. Brochard, 2006
%      Read the STA User's Guide included in the same directory to know 
%      how to use it.
%
%      STA, by itself, creates a new STA or raises the existing
%      singleton*.
%
%      H = STA returns the handle to a new STA or the handle to
%      the existing singleton*.
%
%      STA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in STA.M with the given input arguments.
%
%      STA('Property','Value',...) creates a new STA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before STA_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to STA_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @STA_OpeningFcn, ...
                   'gui_OutputFcn',  @STA_OutputFcn, ...
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

% --- Executes just before STA is made visible.
function STA_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to STA (see VARARGIN)

% Choose default command line output for STA
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes STA wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = STA_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
h = uipanel('Units','characters', ...
        'Title','STABOX v. 0.1 - (c) F. Brochard 2006');

axes(handles.axes1); grid;
handles.fileproperties.autosave = 0; guidata(hObject, handles);
% --------------------------------------------------------------------
function Open_Menu_Callback(hObject, eventdata, handles)
% menu de chargement d'un fichier *.mat
file = uigetfile('*.mat');
if ~isequal(file, 0)
    open(file);
else
    return
end

% chargement et représentation graphique
fdata=importdata(file);
[dim1,dim2]=size(fdata);

axes(handles.axes1);
cla;

if dim2==1
    fdata=fdata';
    [dim1,dim2]=size(fdata);
end

if dim1==1
    plot(fdata);
    title(['Time serie of data file: ', file, ' - dimensions ', ...
        num2str(dim1), ' * ', num2str(dim2)]);
    xlabel('Time'),ylabel('Amplitude')
    handles.fileproperties.dim = 1; guidata(hObject, handles);
    handles.fileproperties.tmax = dim2; guidata(hObject, handles); 
    set(handles.tmax, 'String', dim2);
    
    set(handles.transpose, 'Visible', 'off');
else
    pcolor(fdata'),shading('interp');
    colormap(pastell);
    title(['Spatiotemporal image of: ', file, ' - dimensions ', ...
        num2str(dim1), ' * ', num2str(dim2)]);
    xlabel('Time'),ylabel('Space');
    colorbar
    handles.fileproperties.dim = 2;guidata(hObject, handles);
    set(handles.tmax, 'String', dim1);
    handles.fileproperties.tmax = dim1; guidata(hObject, handles);
    
    set(handles.transpose, 'Visible', 'on');
end

% saving data
handles.fileproperties.name = file;guidata(hObject,handles);
handles.fileproperties.data = fdata;guidata(hObject,handles);
handles.fileproperties.dim1 = dim1;guidata(hObject, handles);
handles.fileproperties.dim2 = dim2;guidata(hObject, handles);
% --- temporary data used for evaluations ---
handles.fileproperties.dtmp = handles.fileproperties.data; 
guidata(hObject, handles);
handles.fileproperties.tmin = 1;guidata(hObject, handles);
handles.fileproperties.step = 1;guidata(hObject, handles);
handles.fileproperties.tmax = dim2;guidata(hObject, handles);


% --------------------------------------------------------------------
function Save_Menu_Callback(hObject, eventdata, handles)
% menu de sauvegarde d'un fichier
[file,path] = uiputfile('*.mat', 'Save as');


% --------------------------------------------------------------------
function Print_Menu_Callback(hObject, eventdata, handles)
% imprime la figure active
printdlg(handles.figure1)


% --------------------------------------------------------------------
function Pref_Menus_Callback(hObject, eventdata, handles)
% hObject    handle to Pref_Menus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Close_Menu_Callback(hObject, eventdata, handles)
% ferme la fenetre active apres confirmation
h = uipanel('Units','characters', ...
        'Title','STABOX v. 0.1 - (c) F. Brochard 2006');

% --------------------------------------------------------------------
function Exit_Menu_Callback(hObject, eventdata, handles)
selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
                     ['Close ' get(handles.figure1,'Name') '...'],...
                     'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end
%gca
delete(handles.figure1)


% ************************ 1D Fourier Spectrum ****************************
function FSpectrum1_Menu_Callback(hObject, eventdata, handles)

handles.spec.fs = 100; guidata(hObject, handles);
set(handles.edit_multi_param1, 'String', handles.spec.fs);
handles.spec.fmax = handles.spec.fs/4; guidata(hObject, handles);
set(handles.freqmax, 'String', 'Maximum Frequency (kHz)', 'Visible', 'on')
set(handles.edit_freqmax, 'String', handles.spec.fmax, 'Visible', 'on');

inter = ceil((handles.fileproperties.tmax-handles.fileproperties.tmin)/ ...
        handles.fileproperties.step);
if inter > 2047
    handles.spec.ncoef = 1024; guidata(hObject, handles);
else
    if inter > 1023
        handles.spec.ncoef = 512; guidata(hObject, handles);
    else
        if inter > 511
            handles.spec.ncoef = 256; guidata(hObject, handles);
        else
            handles.spec.ncoef = 128; guidata(hObject, handles);
        end
    end
end

set(handles.edit_number_coef, 'String', handles.spec.ncoef);
set(handles.number_coef, 'Visible', 'on');
set(handles.edit_number_coef, 'Visible', 'on');
set(handles.current_wavelet, 'Visible', 'off');

set(handles.choose_wavelet, 'Visible', 'off');
set(handles.edit_multi_param1, 'Visible', 'on');
set(handles.multi_param1, 'String', 'Sampling Frequency (kHz)', 'Visible', 'on');
set(handles.pushbutton_pdf, 'Visible', 'on');

set(handles.edit_overlap, 'Visible', 'on');
set(handles.overlap, 'Visible', 'on');

handles.multi.operation = 'FSpectrum1f'; guidata(hObject, handles);




% **********************  1D Fourier k-Spectrum  **************************
function FSpectrum1k_Menu_Callback(hObject, eventdata, handles)
handles.spec.radius = 1; guidata(hObject, handles);
handles.spec.ncoef = 128; guidata(hObject, handles);

handles.spec.fmax = 16/handles.spec.radius; guidata(hObject, handles);
set(handles.freqmax, 'String', 'Maximum Wavenumber (cm^{-1})', 'Visible', 'on')
set(handles.edit_freqmax, 'String', handles.spec.fmax, 'Visible', 'on');

set(handles.edit_multi_param1, 'String', handles.spec.radius);
set(handles.edit_number_coef, 'String', handles.spec.ncoef);

set(handles.number_coef, 'Visible', 'on');
set(handles.edit_number_coef, 'Visible', 'on');
set(handles.current_wavelet, 'Visible', 'off');
set(handles.choose_wavelet, 'Visible', 'off');

set(handles.edit_multi_param1, 'Visible', 'on');
set(handles.multi_param1, 'String', 'Radius of the COURONNE (cm)', 'Visible', 'on');
set(handles.pushbutton_pdf, 'Visible', 'on');

set(handles.edit_overlap, 'Visible', 'on');
set(handles.overlap, 'Visible', 'on');

handles.multi.operation = 'FSpectrum1k'; guidata(hObject, handles);




% --------------------------------------------------------------------
function FSpectrum2_Menu_Callback(hObject, eventdata, handles)

handles.spec.fs = 100; guidata(hObject, handles);
set(handles.edit_multi_param1, 'String', handles.spec.fs);

set(handles.freqmax, 'Visible', 'off')
set(handles.edit_freqmax, 'Visible', 'off');

set(handles.edit_multi_param1, 'Visible', 'on');
set(handles.multi_param1, 'String', 'Sampling Frequency (kHz)', 'Visible', 'on');
set(handles.pushbutton_pdf, 'Visible', 'on');
set(handles.current_wavelet, 'Visible', 'off');

set(handles.choose_wavelet, 'Visible', 'off');

set(handles.edit_overlap, 'Visible', 'off');
set(handles.overlap, 'Visible', 'off');

handles.multi.operation = 'FSpectrum2'; guidata(hObject, handles);



% *********************  1D Wavelet F- Spectrum  *************************
function WSpectrum1_Menu_Callback(hObject, eventdata, handles)
handles.spec.fs = 100; guidata(hObject, handles);
set(handles.edit_multi_param1, 'String', handles.spec.fs);

handles.spec.fmax = handles.spec.fs/2; guidata(hObject, handles);
set(handles.freqmax, 'String', 'Maximum Frequency (kHz)', 'Visible', 'on')
set(handles.edit_freqmax, 'String', handles.spec.fmax, 'Visible', 'on');

handles.spec.ncoef = 256; guidata(hObject, handles);
set(handles.edit_number_coef, 'String', handles.spec.ncoef);
set(handles.number_coef, 'Visible', 'on');
set(handles.edit_number_coef, 'Visible', 'on');
set(handles.current_wavelet, 'Visible', 'on');

set(handles.choose_wavelet, 'Visible', 'on');
set(handles.edit_multi_param1, 'Visible', 'on');
set(handles.multi_param1, 'String', 'Sampling Frequency (kHz)', 'Visible', 'on');
set(handles.pushbutton_pdf, 'Visible', 'on');

set(handles.edit_overlap, 'Visible', 'off');
set(handles.overlap, 'Visible', 'off');

handles.multi.operation = 'WSpectrum1f'; guidata(hObject, handles);



% *********************  1D Wavelet k- Spectrum  *************************
function WSpectrum1k_Menu_Callback(hObject, eventdata, handles)
handles.spec.radius = 1; guidata(hObject, handles);
handles.spec.ncoef = 128; guidata(hObject, handles);

handles.spec.fmax = 16/handles.spec.radius; guidata(hObject, handles);
set(handles.freqmax, 'String', 'Maximum Wavenumber (cm^{-1})', 'Visible', 'on')
set(handles.edit_freqmax, 'String', handles.spec.fmax, 'Visible', 'on');

set(handles.edit_multi_param1, 'String', handles.spec.radius);
set(handles.edit_number_coef, 'String', handles.spec.ncoef);
set(handles.number_coef, 'Visible', 'on');
set(handles.edit_number_coef, 'Visible', 'on');
set(handles.current_wavelet, 'Visible', 'on');

set(handles.choose_wavelet, 'Visible', 'on');
set(handles.edit_multi_param1, 'Visible', 'on');
set(handles.multi_param1, 'String', 'Radius of the COURONNE (cm)', 'Visible', 'on');
set(handles.pushbutton_pdf, 'Visible', 'on');

set(handles.edit_overlap, 'Visible', 'off');
set(handles.overlap, 'Visible', 'off');

handles.multi.operation = 'WSpectrum1k'; guidata(hObject, handles);




% --------------------------------------------------------------------
function File_Menu_Callback(hObject, eventdata, handles)
% hObject    handle to File_Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Lin_Menu_Callback(hObject, eventdata, handles)
% hObject    handle to Lin_Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function NLin_Menu_Callback(hObject, eventdata, handles)
% hObject    handle to NLin_Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Menu_About_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_About (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function HSpectrum_Menu_Callback(hObject, eventdata, handles)
% hObject    handle to HSpectrum_Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function HH_Menu_Callback(hObject, eventdata, handles)
% hObject    handle to HH_Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function PPortrait_Menu_Callback(hObject, eventdata, handles)
% hObject    handle to PPortrait_Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%clearbuttons
set(handles.edit_multi_param1, 'Visible', 'off');
set(handles.multi_param1, 'Visible', 'off');
set(handles.number_coef, 'Visible', 'off');
set(handles.edit_number_coef, 'Visible', 'off');
set(handles.pushbutton_pdf, 'Visible', 'off');
set(handles.current_wavelet, 'Visible', 'off');
set(handles.choose_wavelet, 'Visible', 'off');
set(handles.edit_overlap, 'Visible', 'off');
set(handles.overlap, 'Visible', 'off');
%disp('wspectrum1_menu')


% *********************** PDF functions ***************************
% --------------------------------------------------------------------
function PDF_Menu_Callback(hObject, eventdata, handles)

set(handles.edit_multi_param1, 'Visible', 'on');
set(handles.multi_param1, 'String', '# of summands (pdf resolution)', ...
    'Visible', 'on');
set(handles.pushbutton_pdf, 'Visible', 'on');
set(handles.number_coef, 'Visible', 'off');
set(handles.edit_number_coef, 'Visible', 'off');
set(handles.current_wavelet, 'Visible', 'off');

set(handles.freqmax, 'Visible', 'off')
set(handles.edit_freqmax, 'Visible', 'on');

set(handles.choose_wavelet, 'Visible', 'off');
handles.pdf.npdf = 200; guidata(hObject, handles);
set(handles.edit_multi_param1, 'String', handles.pdf.npdf);

set(handles.edit_overlap, 'Visible', 'off');
set(handles.overlap, 'Visible', 'off');

handles.multi.operation = 'pdf'; guidata(hObject, handles);


% ******************  end of PDF functions  **********************


% --------------------------------------------------------------------
function Untitled_18_Callback(hObject, eventdata, handles)
% hObject    handle to PDF_Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Stat_Menu_Callback(hObject, eventdata, handles)
% hObject    handle to Stat_Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function FourierKBic_Menu_Callback(hObject, eventdata, handles)
% hObject    handle to FourierKBic_Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function FourierFBic_Menu_Callback(hObject, eventdata, handles)
% hObject    handle to FourierFBic_Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



%********************* Wavelet k bicoherence *************************
% --------------------------------------------------------------------
function WaveletKBic_Menu_Callback(hObject, eventdata, handles)
handles.spec.radius = 1; guidata(hObject, handles);
handles.spec.ncoef = 128; guidata(hObject, handles);

handles.spec.fmax = 16/handles.spec.radius; guidata(hObject, handles);
set(handles.freqmax, 'String', 'Maximum Wavenumber (cm^{-1})', 'Visible', 'on')
set(handles.edit_freqmax, 'String', handles.spec.fmax, 'Visible', 'on');

set(handles.edit_multi_param1, 'String', handles.spec.radius);
set(handles.edit_number_coef, 'String', handles.spec.ncoef);
set(handles.number_coef, 'Visible', 'on');
set(handles.edit_number_coef, 'Visible', 'on');
set(handles.current_wavelet, 'Visible', 'on');

set(handles.choose_wavelet, 'Visible', 'on');
set(handles.edit_multi_param1, 'Visible', 'on');
set(handles.multi_param1, 'String', 'Radius of the COURONNE (cm)', 'Visible', 'on');
set(handles.pushbutton_pdf, 'Visible', 'on');

set(handles.edit_overlap, 'Visible', 'off');
set(handles.overlap, 'Visible', 'off');

handles.multi.operation = 'WKBic'; guidata(hObject, handles);


% --------------------------------------------------------------------
function WaveletFBic_Menu_Callback(hObject, eventdata, handles)
handles.spec.fs = 100; guidata(hObject, handles);
set(handles.edit_multi_param1, 'String', handles.spec.fs);


handles.spec.fmax = handles.spec.fs/2; guidata(hObject, handles);
set(handles.freqmax, 'String', 'Maximum Frequency (kHz)', 'Visible', 'on')
set(handles.edit_freqmax, 'String', handles.spec.fmax, 'Visible', 'on');

inter = ceil((handles.fileproperties.tmax-handles.fileproperties.tmin)/ ...
        handles.fileproperties.step);
if inter > 2047
    handles.spec.ncoef = 1024; guidata(hObject, handles);
else
    if inter > 1023
        handles.spec.ncoef = 512; guidata(hObject, handles);
    else
        if inter > 511
            handles.spec.ncoef = 256; guidata(hObject, handles);
        else
            handles.spec.ncoef = 128; guidata(hObject, handles);
        end
    end
end

set(handles.edit_multi_param1, 'Visible', 'on');
set(handles.multi_param1, 'String', 'Sampling Frequency (kHz)', 'Visible', 'on');
set(handles.pushbutton_pdf, 'Visible', 'on');

set(handles.edit_number_coef, 'String', handles.spec.ncoef);
set(handles.number_coef, 'Visible', 'on');
set(handles.edit_number_coef, 'Visible', 'on');
set(handles.current_wavelet, 'Visible', 'on');

set(handles.choose_wavelet, 'Visible', 'on');
set(handles.pushbutton_pdf, 'Visible', 'on');

set(handles.edit_overlap, 'Visible', 'off');
set(handles.overlap, 'Visible', 'off');

handles.multi.operation = 'WFBic'; guidata(hObject, handles);



%**********************  Movie k bicoherence  *************************
function kbicmovie_menu_Callback(hObject, eventdata, handles)

filename = uigetfile('*.mat', 'Select k-bicoherence data  (ex: wavkbic.mat)');
moviename = uiputfile('*.avi', 'Save the movie as');

kbicmov(filename, moviename);



% --------------------------------------------------------------------
function Version_Menu_Callback(hObject, eventdata, handles)
h = uipanel('Units','characters', ...
        'Title','STABOX v. 0.01 - (c) F. Brochard 2006');

fprintf('\n Spatio Temporal Analysis Toolbox');
fprintf('\n \n Version 0.01');
fprintf('\n \n Author: Frederic Brochard \n');


%########################################################################
%##            Parameters Selection and Buttons Management             ##
%########################################################################

% -----------------------------------------------------
% -----            interval parameters            -----
% -----------------------------------------------------

%  ***   T MIN
function tmin_Callback(hObject, eventdata, handles)

tmin= str2num(get(hObject,'String'));
if isnan(tmin)
    set(hObject, 'String', 0);
    errordlg('Input must be an integer', 'Error');
end

% --- saving the value of Tmin
handles.fileproperties.tmin = tmin;guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function tmin_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), ...
        get(0,'defaultUicontrolBackgroundColor'))
        set(hObject, 'BackgroundColor','white');
end
handles.fileproperties.tmin = 1;guidata(hObject, handles);
set(hObject, 'String', handles.fileproperties.tmin);

%  ***   STEP
function step_Callback(hObject, eventdata, handles)

step= str2num(get(hObject,'String'));
if isnan(step)
    set(hObject, 'String', 0);
    errordlg('Input must be an integer', 'Error');
end

% --- saving the value of Step
handles.fileproperties.step = step;guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function step_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
handles.fileproperties.step = 1;guidata(hObject, handles);
set(hObject, 'String', handles.fileproperties.step);

%  ***  T Max
function tmax_Callback(hObject, eventdata, handles)

tmax= str2num(get(hObject,'String'));
if isnan(tmax)
    set(hObject, 'String', 0);
    errordlg('Input must be an integer', 'Error');
end

% --- saving the value of Tmax
handles.fileproperties.tmax = tmax;guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function tmax_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

handles.fileproperties.tmax = 1;guidata(hObject, handles);
set(hObject, 'String', handles.fileproperties.tmax);


% ***********  Actualizing time interval in active figure  ************
% --- Executes on button press in pushbutton1.
function interval_Callback(hObject, eventdata, handles)

cla;
axes(handles.axes1);

if handles.fileproperties.dim1==1
    handles.fileproperties.dtmp = handles.fileproperties.data(handles.fileproperties.tmin:handles.fileproperties.step:handles.fileproperties.tmax);
    guidata(hObject,handles);   % - save temp file with new interval
    plot(handles.fileproperties.dtmp);
    [dim1,dim2] = size(handles.fileproperties.dtmp);
    title(['Time serie of data file: ', handles.fileproperties.name, ...
        ' (zoom) - dimensions ', ...
        num2str(dim1), ' * ', num2str(dim2)]);
    xlabel('Time'),ylabel('Amplitude')
else
    handles.fileproperties.dtmp = handles.fileproperties.dtmp(handles.fileproperties.tmin:handles.fileproperties.step:handles.fileproperties.tmax,:);
    guidata(hObject,handles);   % - save temp file with new interval
    [dim1,dim2] = size(handles.fileproperties.dtmp);
    if dim1==1 %in case time interval is reduced to only 1 step
        temp = [handles.fileproperties.dtmp; handles.fileproperties.dtmp];
        pcolor(temp'),shading('interp');
        colormap(pastell);
        title(['Spatiotemporal image of: ', handles.fileproperties.name, ...
        ' (zoom) - dimensions ', ...
        num2str(dim1), ' * ', num2str(dim2)]);
        xlabel('Time'),ylabel('Space'); colorbar
    else
    pcolor(handles.fileproperties.dtmp'),shading('interp');
    colormap(pastell);
    title(['Spatiotemporal image of: ', handles.fileproperties.name, ...
        ' (zoom) - dimensions ', ...
        num2str(dim1), ' * ', num2str(dim2)]);
    xlabel('Time'),ylabel('Space');
    colorbar
    end
end
% *************************************************************************


% **********  Re-initializing time interval in active figure  ************
% --- Executes on button press in pushbutton2.
function Interval_reset_Callback(hObject, eventdata, handles)

cla;
axes(handles.axes1);

if handles.fileproperties.dim==1
    handles.fileproperties.dtmp = handles.fileproperties.data;
    guidata(hObject,handles);   % - save temp file with new interval
    plot(handles.fileproperties.dtmp);
    [dim1,dim2] = size(handles.fileproperties.dtmp);
    title(['Time serie of data file: ', handles.fileproperties.name, ...
        ' - dimensions ', ...
        num2str(1), ' * ', num2str(handles.fileproperties.dim2)]);
    xlabel('Time'),ylabel('Amplitude')
    set(handles.tmax, 'String', dim2);
    set(handles.tmin, 'String', 1);
    set(handles.step, 'String', 1);
    handles.fileproperties.tmax = dim2; guidata(hObject,handles);
    handles.fileproperties.tmin = 1; guidata(hObject,handles);
    handles.fileproperties.step = 1; guidata(hObject,handles);
    
else
    
    handles.fileproperties.dtmp = handles.fileproperties.data;
    guidata(hObject,handles);   % - save temp file with new interval
    [dim1,dim2] = size(handles.fileproperties.dtmp);
    pcolor(handles.fileproperties.dtmp'),shading('interp');
    colormap(pastell);
    title(['Spatiotemporal image of: ', handles.fileproperties.name, ...
        ' - dimensions ', ...
        num2str(dim1), ' * ', num2str(dim2)]);
    xlabel('Time'),ylabel('Space');
    colorbar
    
    set(handles.tmax, 'String', dim1);
    set(handles.tmin, 'String', 1);
    set(handles.step, 'String', 1);
    handles.fileproperties.tmax = dim1; guidata(hObject,handles);
    handles.fileproperties.tmin = 1; guidata(hObject,handles);
    handles.fileproperties.step = 1; guidata(hObject,handles);
end
% *************************************************************************

%************************* buttons management *************************
function clearbuttons
set(handles.edit_multi_param1, 'Visible', 'off');
set(handles.multi_param1, 'Visible', 'off');
set(handles.pushbutton_pdf, 'Visible', 'off');

%return
%********************* end of buttons management *************************


% --------------------------------------------------------------------
% -----     Radius of the Couronne                               ----- 
% -----             /    Sampling Frequency                      -----
% -----                     /      PDF resolution                -----
% --------------------------------------------------------------------

function edit_multi_param1_Callback(hObject, eventdata, handles)    
param1 = str2num(get(hObject,'String'));
if isnan(param1)
    set(hObject, 'String', 0);
    errordlg('Input must be an integer', 'Error');
end

%--- saving the value of Param1
switch handles.multi.operation
    case 'pdf'
        handles.pdf.npdf = param1; guidata(hObject, handles);
        
    case {'FSpectrum1f', 'FSpectrum2', 'WSpectrum1f', 'WFBic'}
        handles.spec.fs = param1; guidata(hObject, handles);
        Nyq = handles.spec.fs/2;
        displ=(['Maximum Frequency (kHz)      [ =<' num2str(Nyq) ' ]']);
        set(handles.freqmax, 'String', displ)
        
    case {'FSpectrum1k', 'WSpectrum1k', 'WKBic'}
        handles.spec.radius = param1; guidata(hObject, handles);
        Nyq = 32/handles.spec.radius;
        displ=(['Maximum Wavenumber (m^{-1})     [ =<' num2str(Nyq) ' ]']);
        set(handles.freqmax, 'String', displ)
end

%switch handles.multi.operation
%    case {'FSpectrum1f', 'WSpectrum1f', 'WFBic'}
%        Nyq = handles.spec.fs/2;
%        displ=(['Maximum Frequency (kHz) [=<' num2str(Nyq) ']']);
%        set(handles.freqmax, 'String', displ)
%        
%    case {'FSpectrum1k', 'WSpectrum1k', 'WKBic'}
%        Nyq = 32/handles.spec.radius;
%        displ=(['Maximum Wavenumber (m^{-1}) [=<' num2str(Nyq) ']']);
%        set(handles.fmax, 'String', displ)
%end

% --- Executes during object creation, after setting all properties.
function edit_multi_param1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), ...
        get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
end
% ---------------------------------------------------------------------


% ----------  Number of wavelet/Fourier Coefficients  -----------------
function edit_number_coef_Callback(hObject, eventdata, handles)
ncoef= str2num(get(hObject,'String'));
if isnan(ncoef)
    set(hObject, 'String', 0);
    errordlg('Input must be an integer', 'Error');
end

%--- saving the value of ncoef
handles.spec.ncoef = ncoef; guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit_number_coef_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), ...
        get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
end


% ************* choosing the wavelet for spectral analysis ****************
% --- Executes on selection change in choose_wavelet.
function choose_wavelet_Callback(hObject, eventdata, handles)
wfamily = get(handles.choose_wavelet, 'Value');
switch wfamily
    case 1
        wname='cmor1-1.5';
        
    case 2
        wname='cgau8';
        
    case 3
        wname='coif2';            
end
handles.spec.wname = wname; guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function choose_wavelet_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), ...
        get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
end
set(hObject, 'String', {'Morlet', 'Gaussian', 'Coiflet'});
handles.spec.wname = 'cmor1-1.5'; guidata(hObject, handles);


% ****************** Overlap for Fourier spectra *************************
function edit_overlap_Callback(hObject, eventdata, handles)
over = str2num(get(hObject,'String'));
if isnan(over)
    set(hObject, 'String', 0);
    errordlg('Input must be an integer', 'Error')
end
handles.spec.over = over; guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit_overlap_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
handles.spec.over = 0; guidata(hObject, handles);


% ************* Pushbutton "Transpose Matrix" *******************
function transpose_Callback(hObject, eventdata, handles)

pcolor(handles.fileproperties.dtmp),shading('interp');
colormap(pastell); colorbar;
[dim1,dim2] = size(handles.fileproperties.dtmp'); 
handles.fileproperties.dim1 = dim1; guidata(hObject, handles);
handles.fileproperties.dim2 = dim2; guidata(hObject, handles);

title(['Spatiotemporal image of:', handles.fileproperties.name, ...
    ' - dimensions ', num2str(dim1), ' * ', num2str(dim2)]);
xlabel('Time'), ylabel('Space');

tmin=1; tmax=dim1;
set(handles.tmin, 'String', tmin);
set(handles.tmax, 'String', tmax);
handles.fileproperties.tmin = tmin; guidata(hObject, handles);
handles.fileproperties.tmax = tmax; guidata(hObject, handles);

handles.fileproperties.dtmp = handles.fileproperties.dtmp';
guidata(hObject,handles);

% ***********************************************************************
% ************************  pushbutton # 1 ******************************
% --- Executes on button press in pushbutton_pdf.
% ==> Calls the function corresponding to the selected operation 

function pushbutton_pdf_Callback(hObject, eventdata, handles)

switch handles.multi.operation
    case 'pdf'
        npdf=handles.pdf.npdf;
        autosave = handles.fileproperties.autosave;
        if handles.fileproperties.dim == 1
           pdf(handles.fileproperties.dtmp',npdf,autosave);
        else
          pdf(handles.fileproperties.dtmp, npdf, autosave);
        end
        
    case 'FSpectrum1f'
        fs=handles.spec.fs;
        ncoef = handles.spec.ncoef;
        over = handles.spec.over;
        fmax = handles.spec.fmax;
        autosave = handles.fileproperties.autosave;
        if handles.fileproperties.dim == 1
            fspecFou(handles.fileproperties.dtmp', fs, ncoef, over, fmax, autosave);
        else
            fspecFou(handles.fileproperties.dtmp, fs, ncoef, over, fmax, autosave);
        end
        
    case 'FSpectrum1k'
        if handles.fileproperties.dim == 1
            disp('k spectrum unavailable with a single time series !')
        else
            autosave = handles.fileproperties.autosave;
            radius= handles.spec.radius;
            ncoef = handles.spec.ncoef;
            over = handles.spec.over;
            kmax = handles.spec.fmax;
            kspecFou(handles.fileproperties.dtmp, radius, ncoef, over, kmax, autosave);
        end
    
    case 'FSpectrum2'
        fs=handles.spec.fs;
        autosave = handles.fileproperties.autosave;
        spec2(handles.fileproperties.dtmp, fs, autosave);
        
    case 'WSpectrum1f'
        wname = handles.spec.wname;
        fs=handles.spec.fs;
        ncoef = handles.spec.ncoef;
        fmax = handles.spec.fmax;
        autosave = handles.fileproperties.autosave;
        if handles.fileproperties.dim == 1
            fspec(handles.fileproperties.dtmp', fs, ncoef, autosave, fmax, wname);
        else
            fspec(handles.fileproperties.dtmp, fs, ncoef, autosave, fmax, wname);
        end
        
    case 'WSpectrum1k'
        if handles.fileproperties.dim == 1
            disp('k spectrum unavailable with a single time series !')
        else
            wname = handles.spec.wname;
            radius= handles.spec.radius;
            ncoef = handles.spec.ncoef;
            kmax = handles.spec.fmax;
            autosave = handles.fileproperties.autosave;
            kspec(handles.fileproperties.dtmp, radius, ncoef, autosave, kmax, wname);
        end
        
    case 'WFBic'
        wname = handles.spec.wname;
        fs=handles.spec.fs;
        ncoef = handles.spec.ncoef;
        fmax = handles.spec.fmax;
        autosave = handles.fileproperties.autosave;
        if handles.fileproperties.dim == 1
            wbicw(handles.fileproperties.dtmp', fs, ncoef, autosave, fmax, wname);
        else
            wbicw(handles.fileproperties.dtmp, fs, ncoef, autosave, fmax, wname)
        end
        
    case 'WKBic'
        wname = handles.spec.wname;
        radius= handles.spec.radius;
        ncoef = handles.spec.ncoef;
        kmax = handles.spec.fmax;
        autosave = handles.fileproperties.autosave;
        kbictot(handles.fileproperties.dtmp, radius, ncoef, autosave, kmax, wname);
        
end
% *********************  end of pushbutton # 1  *************************



% ******************* Workspace AutoSave Option *************************
% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
disp('tu as trouvé Untitled_1 !')

% --- Executes on button press in workspace_check.
function save_workspace_Callback(hObject, eventdata, handles)

autosave=get(hObject, 'Value');
handles.fileproperties.autosave = autosave; guidata(hObject, handles);


% ********************  Enter Maximum Freq/k  **************************
function edit_freqmax_Callback(hObject, eventdata, handles)

fmax=str2num(get(hObject,'String'));
if isnan(fmax)
    set(hObject, 'String', 0);
    errordlg('Input must be an integer', 'Error')
end
handles.spec.fmax = fmax; guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit_freqmax_CreateFcn(hObject, eventdata, handles)
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), ...
    get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function multi_param1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to multi_param1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --------------------------------------------------------------------
function Image_Menu_Callback(hObject, eventdata, handles)
% hObject    handle to Image_Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function contact_Menu_Callback(hObject, eventdata, handles)
web mailto:frederic.brochard@lpmi.uhp-nancy.fr