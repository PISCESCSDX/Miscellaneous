function varargout = XrayProject(varargin)
% XRAYPROJECT M-file for XrayProject.fig
%      XRAYPROJECT, by itself, creates a new XRAYPROJECT or raises the existing
%      singleton*.
%
%      H = XRAYPROJECT returns the handle to a new XRAYPROJECT or the handle to
%      the existing singleton*.
%
%      XRAYPROJECT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in XRAYPROJECT.M with the given input arguments.
%
%      XRAYPROJECT('Property','Value',...) creates a new XRAYPROJECT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before XrayProject_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to XrayProject_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help XrayProject

% Last Modified by GUIDE v2.5 09-Nov-2009 11:33:03

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @XrayProject_OpeningFcn, ...
                   'gui_OutputFcn',  @XrayProject_OutputFcn, ...
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
end

% --- Executes just before XrayProject is made visible.
function XrayProject_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to XrayProject (see VARARGIN)

% Choose default command line output for XrayProject
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes XrayProject wait for user response (see UIRESUME)
% uiwait(handles.figure1);

warning('off', 'MATLAB:aviread:FunctionToBeRemoved');
warning('off', 'MATLAB:aviinfo:FunctionToBeRemoved');
warning('off', 'Images:initSize:adjustingMag');
warning('off', 'Images:inv_lwm:cannotEvaluateTransfAtSomeOutputLocations');

set(handles.defaultdir,'String',pwd); % set initial default directory

set(hObject,'Name','XrayProject-2.2.0');
end

% --- Outputs from this function are returned to the command line.
function varargout = XrayProject_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end

% --- Executes during object creation, after setting all properties.
function defaultdir_CreateFcn(hObject, eventdata, handles)
% hObject    handle to defaultdir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function defaultdir_Callback(hObject, eventdata, handles)
% hObject    handle to defaultdir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of defaultdir as text
%        str2double(get(hObject,'String')) returns contents of defaultdir as a double

end


% --- Executes on button press in uddHaveC1 radio button.
function uddHaveC1_Callback(hObject, eventdata, handles)
% hObject    handle to uddHaveC1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of uddHaveC1
    % Callback function run you have an Undistortion (*UNDTFORM) file 
    % (radio button 1)
    set(handles.uddHaveC1,'value',1);
    set(handles.uddNeedC1,'value',0);
    set(handles.udcHaveC1,'value',0);
    set(handles.udcNeedC1,'value',0);    
    set(handles.dltHaveC1,'value',0);
    set(handles.dltNeedC1,'value',0);
    set(handles.mergeHave,'value',0);
    set(handles.mergeNeed,'value',0);
    set(handles.digitizeHave,'value',0);
    set(handles.digitizeNeed,'value',0);
    set(handles.filteredMarkerCoordHave,'value',0);
    set(handles.filteredMarkerCoordNeed,'value',0);   
    set(handles.boneModelMarkerHave,'value',0);
    set(handles.boneModelMarkerNeed,'value',0);   
    set(handles.uddHaveC1,'enable','on');
    set(handles.uddNeedC1,'enable','on');
    set(handles.udcHaveC1,'enable','on');
    set(handles.udcNeedC1,'enable','on');    
    set(handles.dltHaveC1,'enable','off');
    set(handles.dltNeedC1,'enable','off');
    set(handles.mergeHave,'enable','off');
    set(handles.mergeNeed,'enable','off');
    set(handles.digitizeHave,'enable','off');
    set(handles.digitizeNeed,'enable','off');
    set(handles.filteredMarkerCoordHave,'enable','off');
    set(handles.filteredMarkerCoordNeed,'enable','off'); 
    set(handles.boneModelMarkerHave,'enable','off');
    set(handles.boneModelMarkerNeed,'enable','off'); 

    set(handles.undistortC1Button,'enable','off');
    set(handles.undcalC1Button,'enable','off');
    set(handles.calibrateC1Button,'enable','off');
    set(handles.MergeButton,'enable','off');
    set(handles.DigitizeButton,'enable','off');   
    set(handles.filterXYZButton,'enable','off');
    set(handles.rigidBodyInstructionButton,'enable','off');
    set(handles.svdRigidButton,'enable','off');
end

% --- Executes on button press in uddNeedC1 radio button.
function uddNeedC1_Callback(hObject, eventdata, handles)
% hObject    handle to uddNeedC1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of uddNeedC1
    % Callback function run if you need to create an Undistortion file
    % (radio button 2)
    set(handles.uddHaveC1,'value',0);
    set(handles.uddNeedC1,'value',1);
    set(handles.udcHaveC1,'value',0);
    set(handles.udcNeedC1,'value',0);    
    set(handles.dltHaveC1,'value',0);
    set(handles.dltNeedC1,'value',0);
    set(handles.mergeHave,'value',0);
    set(handles.mergeNeed,'value',0);
    set(handles.digitizeHave,'value',0);
    set(handles.digitizeNeed,'value',0);
    set(handles.filteredMarkerCoordHave,'value',0);
    set(handles.filteredMarkerCoordNeed,'value',0);    
    set(handles.boneModelMarkerHave,'value',0);
    set(handles.boneModelMarkerNeed,'value',0);    
    set(handles.uddHaveC1,'enable','on');
    set(handles.uddNeedC1,'enable','on');
    set(handles.udcHaveC1,'enable','off');
    set(handles.udcNeedC1,'enable','off');
    set(handles.dltHaveC1,'enable','off');
    set(handles.dltNeedC1,'enable','off');
    set(handles.mergeHave,'enable','off');
    set(handles.mergeNeed,'enable','off');
    set(handles.digitizeHave,'enable','off');
    set(handles.digitizeNeed,'enable','off');
    set(handles.filteredMarkerCoordHave,'enable','off');
    set(handles.filteredMarkerCoordNeed,'enable','off'); 
    set(handles.boneModelMarkerHave,'enable','off');
    set(handles.boneModelMarkerNeed,'enable','off'); 
   
    set(handles.undistortC1Button,'enable','on');
    set(handles.undcalC1Button,'enable','off');
    set(handles.calibrateC1Button,'enable','off');
    set(handles.MergeButton,'enable','off');
    set(handles.DigitizeButton,'enable','off'); 
    set(handles.filterXYZButton,'enable','off');
    set(handles.rigidBodyInstructionButton,'enable','off');
    set(handles.svdRigidButton,'enable','off');
end

% --- Executes on button press in udcHaveC1 radio button.
function udcHaveC1_Callback(hObject, eventdata, handles)
% hObject    handle to udcHaveC1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of udcHaveC1
    % Callback function run if you have undistorted calibration cube images
    % (radio button 3)
    set(handles.uddHaveC1,'value',1);
    set(handles.uddNeedC1,'value',0);
    set(handles.udcHaveC1,'value',1);
    set(handles.udcNeedC1,'value',0);    
    set(handles.dltHaveC1,'value',0);
    set(handles.dltNeedC1,'value',0);
    set(handles.mergeHave,'value',0);
    set(handles.mergeNeed,'value',0);
    set(handles.digitizeHave,'value',0);
    set(handles.digitizeNeed,'value',0);
    set(handles.filteredMarkerCoordHave,'value',0);
    set(handles.filteredMarkerCoordNeed,'value',0);   
    set(handles.boneModelMarkerHave,'value',0);
    set(handles.boneModelMarkerNeed,'value',0);   
    set(handles.uddHaveC1,'enable','on');
    set(handles.uddNeedC1,'enable','on');
    set(handles.udcHaveC1,'enable','on');
    set(handles.udcNeedC1,'enable','on');
    set(handles.dltHaveC1,'enable','on');
    set(handles.dltNeedC1,'enable','on');
    set(handles.mergeHave,'enable','off');
    set(handles.mergeNeed,'enable','off');
    set(handles.digitizeHave,'enable','off');
    set(handles.digitizeNeed,'enable','off');
    set(handles.filteredMarkerCoordHave,'enable','off');
    set(handles.filteredMarkerCoordNeed,'enable','off'); 
    set(handles.boneModelMarkerHave,'enable','off');
    set(handles.boneModelMarkerNeed,'enable','off'); 
    
    set(handles.undistortC1Button,'enable','off');
    set(handles.undcalC1Button,'enable','off');
    set(handles.calibrateC1Button,'enable','off');
    set(handles.MergeButton,'enable','off');
    set(handles.DigitizeButton,'enable','off');    
    set(handles.filterXYZButton,'enable','off');
    set(handles.rigidBodyInstructionButton,'enable','off');
    set(handles.svdRigidButton,'enable','off');
end

% --- Executes on button press in udcNeedC1 radio button.
function udcNeedC1_Callback(hObject, eventdata, handles)
% hObject    handle to udcNeedC1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of udcNeedC1
    % Callback function run if you need to undistort calibration cube images
    % (radio button 4)
    set(handles.uddHaveC1,'value',1);
    set(handles.uddNeedC1,'value',0);
    set(handles.udcHaveC1,'value',0);
    set(handles.udcNeedC1,'value',1);
    set(handles.dltHaveC1,'value',0);
    set(handles.dltNeedC1,'value',0);
    set(handles.mergeHave,'value',0);
    set(handles.mergeNeed,'value',0);
    set(handles.digitizeHave,'value',0);
    set(handles.digitizeNeed,'value',0);
    set(handles.filteredMarkerCoordHave,'value',0);
    set(handles.filteredMarkerCoordNeed,'value',0);   
    set(handles.boneModelMarkerHave,'value',0);
    set(handles.boneModelMarkerNeed,'value',0);   
    set(handles.uddHaveC1,'enable','on');
    set(handles.uddNeedC1,'enable','on');
    set(handles.udcHaveC1,'enable','on');
    set(handles.udcNeedC1,'enable','on');
    set(handles.dltHaveC1,'enable','off');
    set(handles.dltNeedC1,'enable','off');
    set(handles.mergeHave,'enable','off');
    set(handles.mergeNeed,'enable','off');
    set(handles.digitizeHave,'enable','off');
    set(handles.digitizeNeed,'enable','off');
    set(handles.filteredMarkerCoordHave,'enable','off');
    set(handles.filteredMarkerCoordNeed,'enable','off'); 
    set(handles.boneModelMarkerHave,'enable','off');
    set(handles.boneModelMarkerNeed,'enable','off'); 
    
    set(handles.undistortC1Button,'enable','off');
    set(handles.undcalC1Button,'enable','on');
    set(handles.calibrateC1Button,'enable','off');
    set(handles.MergeButton,'enable','off');
    set(handles.DigitizeButton,'enable','off');    
    set(handles.filterXYZButton,'enable','off');
    set(handles.rigidBodyInstructionButton,'enable','off');
    set(handles.svdRigidButton,'enable','off');
end

% --- Executes on button press in dltHaveC1 radio button.
function dltHaveC1_Callback(hObject, eventdata, handles)
% hObject    handle to dltHaveC1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of dltHaveC1
    % Callback function run if you have DLT coefficients from calibration
    % (radio button 5)
    set(handles.uddHaveC1,'value',1);
    set(handles.uddNeedC1,'value',0);
    set(handles.udcHaveC1,'value',1);
    set(handles.udcNeedC1,'value',0);    
    set(handles.dltHaveC1,'value',1);
    set(handles.dltNeedC1,'value',0);
    set(handles.mergeHave,'value',0);
    set(handles.mergeNeed,'value',0);
    set(handles.digitizeHave,'value',0);
    set(handles.digitizeNeed,'value',0);
    set(handles.filteredMarkerCoordHave,'value',0);
    set(handles.filteredMarkerCoordNeed,'value',0);   
    set(handles.boneModelMarkerHave,'value',0);
    set(handles.boneModelMarkerNeed,'value',0);   
    set(handles.uddHaveC1,'enable','on');
    set(handles.uddNeedC1,'enable','on');
    set(handles.udcHaveC1,'enable','on');
    set(handles.udcNeedC1,'enable','on');
    set(handles.dltHaveC1,'enable','on');
    set(handles.dltNeedC1,'enable','on');
    % if both camera1 and camera2 files are processed, enable merge:
    if(get(handles.dltHaveC2,'value')== 1),
        set(handles.mergeHave,'enable','on');
        set(handles.mergeNeed,'enable','on');
    end
    set(handles.digitizeHave,'enable','off');
    set(handles.digitizeNeed,'enable','off');
    set(handles.filteredMarkerCoordHave,'enable','off');
    set(handles.filteredMarkerCoordNeed,'enable','off'); 
    set(handles.boneModelMarkerHave,'enable','off');
    set(handles.boneModelMarkerNeed,'enable','off'); 
   
    set(handles.undistortC1Button,'enable','off');
    set(handles.undcalC1Button,'enable','off'); 
    set(handles.calibrateC1Button,'enable','off');
    set(handles.MergeButton,'enable','off');
    set(handles.DigitizeButton,'enable','off');
    set(handles.filterXYZButton,'enable','off');
    set(handles.rigidBodyInstructionButton,'enable','off');
    set(handles.svdRigidButton,'enable','off');
end

% --- Executes on button press in dltNeedC1 radio button.
function dltNeedC1_Callback(hObject, eventdata, handles)
% hObject    handle to dltNeedC1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of dltNeedC1
    % Callback function run you need to calibrate
    % (radio button 6)
    set(handles.uddHaveC1,'value',1);
    set(handles.uddNeedC1,'value',0);
    set(handles.udcHaveC1,'value',1);
    set(handles.udcNeedC1,'value',0);    
    set(handles.dltHaveC1,'value',0);
    set(handles.dltNeedC1,'value',1);
    set(handles.mergeHave,'value',0);
    set(handles.mergeNeed,'value',0);
    set(handles.digitizeHave,'value',0);
    set(handles.digitizeNeed,'value',0);
    set(handles.filteredMarkerCoordHave,'value',0);
    set(handles.filteredMarkerCoordNeed,'value',0);   
    set(handles.boneModelMarkerHave,'value',0);
    set(handles.boneModelMarkerNeed,'value',0);   
    set(handles.uddHaveC1,'enable','on');
    set(handles.uddNeedC1,'enable','on');
    set(handles.udcHaveC1,'enable','on');
    set(handles.udcNeedC1,'enable','on');
    set(handles.dltHaveC1,'enable','on');
    set(handles.dltNeedC1,'enable','on');
    set(handles.mergeHave,'enable','off');
    set(handles.mergeNeed,'enable','off'); 
    set(handles.digitizeHave,'enable','off');
    set(handles.digitizeNeed,'enable','off');
    set(handles.filteredMarkerCoordHave,'enable','off');
    set(handles.filteredMarkerCoordNeed,'enable','off'); 
    set(handles.boneModelMarkerHave,'enable','off');
    set(handles.boneModelMarkerNeed,'enable','off'); 
    
    set(handles.undistortC1Button,'enable','off');
    set(handles.undcalC1Button,'enable','off'); 
    set(handles.calibrateC1Button,'enable','on');
    set(handles.MergeButton,'enable','off');
    set(handles.DigitizeButton,'enable','off');
    set(handles.filterXYZButton,'enable','off');
    set(handles.rigidBodyInstructionButton,'enable','off');
    set(handles.svdRigidButton,'enable','off');
end

% --- Executes on button press in uddHaveC2 radio button.
function uddHaveC2_Callback(hObject, eventdata, handles)
% hObject    handle to uddHaveC2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of uddHaveC2
    % Callback function run you have an Undistortion (*UNDTFORM) file 
    % (radio button 7) Camera 2
    set(handles.uddHaveC2,'value',1);
    set(handles.uddNeedC2,'value',0);
    set(handles.udcHaveC2,'value',0);
    set(handles.udcNeedC2,'value',0);    
    set(handles.dltHaveC2,'value',0);
    set(handles.dltNeedC2,'value',0);
    set(handles.mergeHave,'value',0);
    set(handles.mergeNeed,'value',0);
    set(handles.digitizeHave,'value',0);
    set(handles.digitizeNeed,'value',0);
    set(handles.filteredMarkerCoordHave,'value',0);
    set(handles.filteredMarkerCoordNeed,'value',0);   
    set(handles.boneModelMarkerHave,'value',0);
    set(handles.boneModelMarkerNeed,'value',0);   
    set(handles.uddHaveC2,'enable','on');
    set(handles.uddNeedC2,'enable','on');
    set(handles.udcHaveC2,'enable','on');
    set(handles.udcNeedC2,'enable','on');    
    set(handles.dltHaveC2,'enable','off');
    set(handles.dltNeedC2,'enable','off');
    set(handles.mergeHave,'enable','off');
    set(handles.mergeNeed,'enable','off');
    set(handles.digitizeHave,'enable','off');
    set(handles.digitizeNeed,'enable','off');
    set(handles.filteredMarkerCoordHave,'enable','off');
    set(handles.filteredMarkerCoordNeed,'enable','off'); 
    set(handles.boneModelMarkerHave,'enable','off');
    set(handles.boneModelMarkerNeed,'enable','off'); 
    
    set(handles.undistortC2Button,'enable','off');
    set(handles.undcalC2Button,'enable','off');
    set(handles.calibrateC2Button,'enable','off');
    set(handles.MergeButton,'enable','off');
    set(handles.DigitizeButton,'enable','off');    
    set(handles.filterXYZButton,'enable','off');
    set(handles.rigidBodyInstructionButton,'enable','off');
    set(handles.svdRigidButton,'enable','off');
end


% --- Executes on button press in uddNeedC2 radio button.
function uddNeedC2_Callback(hObject, eventdata, handles)
% hObject    handle to uddNeedC2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of uddNeedC2
    % Callback function run if you need to create an Undistortion file
    % (radio button 8)Camera 2
    set(handles.uddHaveC2,'value',0);
    set(handles.uddNeedC2,'value',1);
    set(handles.udcHaveC2,'value',0);
    set(handles.udcNeedC2,'value',0);    
    set(handles.dltHaveC2,'value',0);
    set(handles.dltNeedC2,'value',0);
    set(handles.mergeHave,'value',0);
    set(handles.mergeNeed,'value',0);
    set(handles.digitizeHave,'value',0);
    set(handles.digitizeNeed,'value',0);
    set(handles.filteredMarkerCoordHave,'value',0);
    set(handles.filteredMarkerCoordNeed,'value',0);   
    set(handles.boneModelMarkerHave,'value',0);
    set(handles.boneModelMarkerNeed,'value',0);   
    set(handles.uddHaveC2,'enable','on');
    set(handles.uddNeedC2,'enable','on');
    set(handles.udcHaveC2,'enable','off');
    set(handles.udcNeedC2,'enable','off');
    set(handles.dltHaveC2,'enable','off');
    set(handles.dltNeedC2,'enable','off'); 
    set(handles.mergeHave,'enable','off');
    set(handles.mergeNeed,'enable','off');
    set(handles.digitizeHave,'enable','off');
    set(handles.digitizeNeed,'enable','off');
    set(handles.filteredMarkerCoordHave,'enable','off');
    set(handles.filteredMarkerCoordNeed,'enable','off'); 
    set(handles.boneModelMarkerHave,'enable','off');
    set(handles.boneModelMarkerNeed,'enable','off'); 
    
    set(handles.undistortC2Button,'enable','on');
    set(handles.undcalC2Button,'enable','off');
    set(handles.calibrateC2Button,'enable','off');
    set(handles.MergeButton,'enable','off');
    set(handles.DigitizeButton,'enable','off');    
    set(handles.filterXYZButton,'enable','off');
    set(handles.rigidBodyInstructionButton,'enable','off');
    set(handles.svdRigidButton,'enable','off');
end

% --- Executes on button press in udcHaveC2 radio button.
function udcHaveC2_Callback(hObject, eventdata, handles)
% hObject    handle to udcHaveC2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of udcHaveC2
    % Callback function run if you have undistorted calibration cube images
    % (radio button 9) Camera 2
    set(handles.uddHaveC2,'value',1);
    set(handles.uddNeedC2,'value',0);
    set(handles.udcHaveC2,'value',1);
    set(handles.udcNeedC2,'value',0);    
    set(handles.dltHaveC2,'value',0);
    set(handles.dltNeedC2,'value',0);
    set(handles.mergeHave,'value',0);
    set(handles.mergeNeed,'value',0);
    set(handles.digitizeHave,'value',0);
    set(handles.digitizeNeed,'value',0);
    set(handles.filteredMarkerCoordHave,'value',0);
    set(handles.filteredMarkerCoordNeed,'value',0);   
    set(handles.boneModelMarkerHave,'value',0);
    set(handles.boneModelMarkerNeed,'value',0);   
    set(handles.uddHaveC2,'enable','on');
    set(handles.uddNeedC2,'enable','on');
    set(handles.udcHaveC2,'enable','on');
    set(handles.udcNeedC2,'enable','on');
    set(handles.dltHaveC2,'enable','on');
    set(handles.dltNeedC2,'enable','on');
    set(handles.mergeHave,'enable','off');
    set(handles.mergeNeed,'enable','off');
    set(handles.digitizeHave,'enable','off');
    set(handles.digitizeNeed,'enable','off');
    set(handles.filteredMarkerCoordHave,'enable','off');
    set(handles.filteredMarkerCoordNeed,'enable','off'); 
    set(handles.boneModelMarkerHave,'enable','off');
    set(handles.boneModelMarkerNeed,'enable','off'); 
    
    set(handles.undistortC2Button,'enable','off');
    set(handles.undcalC2Button,'enable','off');
    set(handles.calibrateC2Button,'enable','off');
    set(handles.MergeButton,'enable','off');
    set(handles.DigitizeButton,'enable','off');   
    set(handles.filterXYZButton,'enable','off');
    set(handles.rigidBodyInstructionButton,'enable','off');
    set(handles.svdRigidButton,'enable','off');
end

% --- Executes on button press in udcNeedC2 radio button.
function udcNeedC2_Callback(hObject, eventdata, handles)
% hObject    handle to udcNeedC2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of udcNeedC2
    % Callback function run if you need to undistort calibration cube images
    % (radio button 10) Camera 2
    set(handles.uddHaveC2,'value',1);
    set(handles.uddNeedC2,'value',0);
    set(handles.udcHaveC2,'value',0);
    set(handles.udcNeedC2,'value',1);
    set(handles.dltHaveC2,'value',0);
    set(handles.dltNeedC2,'value',0);
    set(handles.mergeHave,'value',0);
    set(handles.mergeNeed,'value',0);
    set(handles.digitizeHave,'value',0);
    set(handles.digitizeNeed,'value',0);
    set(handles.filteredMarkerCoordHave,'value',0);
    set(handles.filteredMarkerCoordNeed,'value',0);   
    set(handles.boneModelMarkerHave,'value',0);
    set(handles.boneModelMarkerNeed,'value',0);   
    set(handles.uddHaveC2,'enable','on');
    set(handles.uddNeedC2,'enable','on');
    set(handles.udcHaveC2,'enable','on');
    set(handles.udcNeedC2,'enable','on');
    set(handles.dltHaveC2,'enable','off');
    set(handles.dltNeedC2,'enable','off');
    set(handles.mergeHave,'enable','off');
    set(handles.mergeNeed,'enable','off');
    set(handles.digitizeHave,'enable','off');
    set(handles.digitizeNeed,'enable','off');
    set(handles.filteredMarkerCoordHave,'enable','off');
    set(handles.filteredMarkerCoordNeed,'enable','off'); 
    set(handles.boneModelMarkerHave,'enable','off');
    set(handles.boneModelMarkerNeed,'enable','off'); 
    
    set(handles.undistortC2Button,'enable','off');
    set(handles.undcalC2Button,'enable','on');
    set(handles.calibrateC2Button,'enable','off');
    set(handles.MergeButton,'enable','off');
    set(handles.DigitizeButton,'enable','off');    
    set(handles.filterXYZButton,'enable','off');
    set(handles.rigidBodyInstructionButton,'enable','off');
    set(handles.svdRigidButton,'enable','off');
end

% --- Executes on button press in dltHaveC2 radio button.
function dltHaveC2_Callback(hObject, eventdata, handles)
% hObject    handle to dltHaveC2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of dltHaveC2
    % Callback function run if you have DLT coefficients from calibration
    % (radio button 11) Camera 2
    set(handles.uddHaveC2,'value',1);
    set(handles.uddNeedC2,'value',0);
    set(handles.udcHaveC2,'value',1);
    set(handles.udcNeedC2,'value',0);    
    set(handles.dltHaveC2,'value',1);
    set(handles.dltNeedC2,'value',0);
    set(handles.mergeHave,'value',0);
    set(handles.mergeNeed,'value',0);
    set(handles.digitizeHave,'value',0);
    set(handles.digitizeNeed,'value',0);
    set(handles.filteredMarkerCoordHave,'value',0);
    set(handles.filteredMarkerCoordNeed,'value',0);   
    set(handles.boneModelMarkerHave,'value',0);
    set(handles.boneModelMarkerNeed,'value',0);   
    set(handles.uddHaveC2,'enable','on');
    set(handles.uddNeedC2,'enable','on');
    set(handles.udcHaveC2,'enable','on');
    set(handles.udcNeedC2,'enable','on');
    set(handles.dltHaveC2,'enable','on');
    set(handles.dltNeedC2,'enable','on');
    % if both camera1 and camera2 files are processed, enable merge:
    if(get(handles.dltHaveC1,'value')== 1),
        set(handles.mergeHave,'enable','on');
        set(handles.mergeNeed,'enable','on');
    end
    set(handles.digitizeHave,'enable','off');
    set(handles.digitizeNeed,'enable','off');
    set(handles.filteredMarkerCoordHave,'enable','off');
    set(handles.filteredMarkerCoordNeed,'enable','off'); 
    set(handles.boneModelMarkerHave,'enable','off');
    set(handles.boneModelMarkerNeed,'enable','off'); 
    
    set(handles.undistortC2Button,'enable','off');
    set(handles.undcalC2Button,'enable','off'); 
    set(handles.calibrateC2Button,'enable','off');
    set(handles.MergeButton,'enable','off');
    set(handles.DigitizeButton,'enable','off');
    set(handles.filterXYZButton,'enable','off');
    set(handles.rigidBodyInstructionButton,'enable','off');
    set(handles.svdRigidButton,'enable','off');
end

% --- Executes on button press in dltNeedC2 radio button.
function dltNeedC2_Callback(hObject, eventdata, handles)
% hObject    handle to dltNeedC2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of dltNeedC2
    % Callback function run you need to calibrate
    % (radio button 12) Camera 2
    set(handles.uddHaveC2,'value',1);
    set(handles.uddNeedC2,'value',0);
    set(handles.udcHaveC2,'value',1);
    set(handles.udcNeedC2,'value',0);    
    set(handles.dltHaveC2,'value',0);
    set(handles.dltNeedC2,'value',1);
    set(handles.mergeHave,'value',0);
    set(handles.mergeNeed,'value',0);
    set(handles.digitizeHave,'value',0);
    set(handles.digitizeNeed,'value',0);
    set(handles.filteredMarkerCoordHave,'value',0);
    set(handles.filteredMarkerCoordNeed,'value',0);   
    set(handles.boneModelMarkerHave,'value',0);
    set(handles.boneModelMarkerNeed,'value',0);   
    set(handles.uddHaveC2,'enable','on');
    set(handles.uddNeedC2,'enable','on');
    set(handles.udcHaveC2,'enable','on');
    set(handles.udcNeedC2,'enable','on');
    set(handles.dltHaveC2,'enable','on');
    set(handles.dltNeedC2,'enable','on');
    set(handles.mergeHave,'enable','off');
    set(handles.mergeNeed,'enable','off');
    set(handles.digitizeHave,'enable','off');
    set(handles.digitizeNeed,'enable','off');
    set(handles.filteredMarkerCoordHave,'enable','off');
    set(handles.filteredMarkerCoordNeed,'enable','off'); 
    set(handles.boneModelMarkerHave,'enable','off');
    set(handles.boneModelMarkerNeed,'enable','off'); 
    
    set(handles.undistortC2Button,'enable','off');
    set(handles.undcalC2Button,'enable','off'); 
    set(handles.calibrateC2Button,'enable','on');
    set(handles.MergeButton,'enable','off');
    set(handles.DigitizeButton,'enable','off');
    set(handles.filterXYZButton,'enable','off');
    set(handles.rigidBodyInstructionButton,'enable','off');
    set(handles.svdRigidButton,'enable','off');
end

% --- Executes on button press in mergeHave radio button.
function mergeHave_Callback(hObject, eventdata, handles)
% hObject    handle to mergeHave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of mergeHave
    % Callback function run if you have merged DLT coefficients
    % (radio button 13)
    set(handles.mergeHave,'value',1);
    set(handles.mergeNeed,'value',0);
    set(handles.digitizeHave,'value',0);
    set(handles.digitizeNeed,'value',0);
    set(handles.filteredMarkerCoordHave,'value',0);
    set(handles.filteredMarkerCoordNeed,'value',0);   
    set(handles.boneModelMarkerHave,'value',0);
    set(handles.boneModelMarkerNeed,'value',0);   
    set(handles.mergeHave,'enable','on');
    set(handles.mergeNeed,'enable','on'); 
    set(handles.digitizeHave,'enable','on');
    set(handles.digitizeNeed,'enable','on');
    set(handles.filteredMarkerCoordHave,'enable','off');
    set(handles.filteredMarkerCoordNeed,'enable','off'); 
    set(handles.boneModelMarkerHave,'enable','off');
    set(handles.boneModelMarkerNeed,'enable','off'); 
    
    set(handles.undistortC1Button,'enable','off');
    set(handles.undistortC2Button,'enable','off');
    set(handles.undcalC1Button,'enable','off'); 
    set(handles.undcalC2Button,'enable','off'); 
    set(handles.calibrateC1Button,'enable','off'); 
    set(handles.calibrateC2Button,'enable','off'); 
    set(handles.MergeButton,'enable','off');
    set(handles.DigitizeButton,'enable','off');
    set(handles.filterXYZButton,'enable','off');
    set(handles.rigidBodyInstructionButton,'enable','off');
    set(handles.svdRigidButton,'enable','off');
end

% --- Executes on button press in mergeNeed radio button.
function mergeNeed_Callback(hObject, eventdata, handles)
% hObject    handle to mergeNeed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of mergeNeed
    % Callback function run you need to merge DLT coefficients
    % (radio button 14)
    set(handles.mergeHave,'value',0);
    set(handles.mergeNeed,'value',1);
    set(handles.digitizeHave,'value',0);
    set(handles.digitizeNeed,'value',0);
    set(handles.filteredMarkerCoordHave,'value',0);
    set(handles.filteredMarkerCoordNeed,'value',0);   
    set(handles.boneModelMarkerHave,'value',0);
    set(handles.boneModelMarkerNeed,'value',0);   
    set(handles.mergeHave,'enable','on');
    set(handles.mergeNeed,'enable','on'); 
    set(handles.digitizeHave,'enable','off');
    set(handles.digitizeNeed,'enable','off');
    set(handles.filteredMarkerCoordHave,'enable','off');
    set(handles.filteredMarkerCoordNeed,'enable','off'); 
    set(handles.boneModelMarkerHave,'enable','off');
    set(handles.boneModelMarkerNeed,'enable','off'); 
    
    set(handles.undistortC1Button,'enable','off');
    set(handles.undistortC2Button,'enable','off');
    set(handles.undcalC1Button,'enable','off'); 
    set(handles.undcalC2Button,'enable','off'); 
    set(handles.calibrateC1Button,'enable','off'); 
    set(handles.calibrateC2Button,'enable','off'); 
    set(handles.MergeButton,'enable','on');
    set(handles.DigitizeButton,'enable','off');    
    set(handles.filterXYZButton,'enable','off');
    set(handles.rigidBodyInstructionButton,'enable','off');
    set(handles.svdRigidButton,'enable','off');
end

% --- Executes on button press in digitizeHave.
function digitizeHave_Callback(hObject, eventdata, handles)
% hObject    handle to digitizeHave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of digitizeHave
    set(handles.digitizeHave,'value',1);
    set(handles.digitizeNeed,'value',0);
    set(handles.filteredMarkerCoordHave,'value',0);
    set(handles.filteredMarkerCoordNeed,'value',0);   
    set(handles.boneModelMarkerHave,'value',0);
    set(handles.boneModelMarkerNeed,'value',0);   
    set(handles.digitizeHave,'enable','on');
    set(handles.digitizeNeed,'enable','on'); 
    set(handles.filteredMarkerCoordHave,'enable','on');
    set(handles.filteredMarkerCoordNeed,'enable','on'); 
    set(handles.boneModelMarkerHave,'enable','off');
    set(handles.boneModelMarkerNeed,'enable','off'); 
    
    set(handles.undistortC1Button,'enable','off');
    set(handles.undistortC2Button,'enable','off');
    set(handles.undcalC1Button,'enable','off'); 
    set(handles.undcalC2Button,'enable','off'); 
    set(handles.calibrateC1Button,'enable','off'); 
    set(handles.calibrateC2Button,'enable','off'); 
    set(handles.MergeButton,'enable','off');
    set(handles.DigitizeButton,'enable','off');
    set(handles.filterXYZButton,'enable','off');
    set(handles.rigidBodyInstructionButton,'enable','off');
    set(handles.svdRigidButton,'enable','off');

end

% --- Executes on button press in digitizeNeed.
function digitizeNeed_Callback(hObject, eventdata, handles)
% hObject    handle to digitizeNeed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of digitizeNeed
    set(handles.digitizeHave,'value',0);
    set(handles.digitizeNeed,'value',1);
    set(handles.filteredMarkerCoordHave,'value',0);
    set(handles.filteredMarkerCoordNeed,'value',0);   
    set(handles.boneModelMarkerHave,'value',0);
    set(handles.boneModelMarkerNeed,'value',0);   
    set(handles.digitizeHave,'enable','on');
    set(handles.digitizeNeed,'enable','on'); 
    set(handles.filteredMarkerCoordHave,'enable','off');
    set(handles.filteredMarkerCoordNeed,'enable','off'); 
    set(handles.boneModelMarkerHave,'enable','off');
    set(handles.boneModelMarkerNeed,'enable','off'); 
    
    set(handles.undistortC1Button,'enable','off');
    set(handles.undistortC2Button,'enable','off');
    set(handles.undcalC1Button,'enable','off'); 
    set(handles.undcalC2Button,'enable','off'); 
    set(handles.calibrateC1Button,'enable','off'); 
    set(handles.calibrateC2Button,'enable','off'); 
    set(handles.MergeButton,'enable','off');
    set(handles.DigitizeButton,'enable','on');
    set(handles.filterXYZButton,'enable','off');
    set(handles.rigidBodyInstructionButton,'enable','off');
    set(handles.svdRigidButton,'enable','off');

end


% --- Executes on button press in filteredMarkerCoordHave.
function filteredMarkerCoordHave_Callback(hObject, eventdata, handles)
% hObject    handle to filteredMarkerCoordHave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of filteredMarkerCoordHave
    set(handles.filteredMarkerCoordHave,'value',1);
    set(handles.filteredMarkerCoordNeed,'value',0);   
    set(handles.boneModelMarkerHave,'value',0);
    set(handles.boneModelMarkerNeed,'value',0);   
    set(handles.digitizeHave,'enable','on');
    set(handles.digitizeNeed,'enable','on');
    set(handles.filteredMarkerCoordHave,'enable','on');
    set(handles.filteredMarkerCoordNeed,'enable','on'); 
    set(handles.boneModelMarkerHave,'enable','on');
    set(handles.boneModelMarkerNeed,'enable','on'); 
    
    set(handles.undistortC1Button,'enable','off');
    set(handles.undistortC2Button,'enable','off');
    set(handles.undcalC1Button,'enable','off'); 
    set(handles.undcalC2Button,'enable','off'); 
    set(handles.calibrateC1Button,'enable','off'); 
    set(handles.calibrateC2Button,'enable','off'); 
    set(handles.MergeButton,'enable','off');
    set(handles.DigitizeButton,'enable','off');
    set(handles.filterXYZButton,'enable','off');
    set(handles.rigidBodyInstructionButton,'enable','off');
    set(handles.svdRigidButton,'enable','off');
end

% --- Executes on button press in filteredMarkerCoordNeed.
function filteredMarkerCoordNeed_Callback(hObject, eventdata, handles)
% hObject    handle to filteredMarkerCoordNeed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of filteredMarkerCoordNeed

    set(handles.filteredMarkerCoordHave,'value',0);
    set(handles.filteredMarkerCoordNeed,'value',1);   
    set(handles.boneModelMarkerHave,'value',0);
    set(handles.boneModelMarkerNeed,'value',0);   
    set(handles.digitizeHave,'enable','on');
    set(handles.digitizeNeed,'enable','on');
    set(handles.filteredMarkerCoordHave,'enable','on');
    set(handles.filteredMarkerCoordNeed,'enable','on'); 
    set(handles.boneModelMarkerHave,'enable','off');
    set(handles.boneModelMarkerNeed,'enable','off'); 
    
    set(handles.undistortC1Button,'enable','off');
    set(handles.undistortC2Button,'enable','off');
    set(handles.undcalC1Button,'enable','off'); 
    set(handles.undcalC2Button,'enable','off'); 
    set(handles.calibrateC1Button,'enable','off'); 
    set(handles.calibrateC2Button,'enable','off'); 
    set(handles.MergeButton,'enable','off');
    set(handles.DigitizeButton,'enable','off'); 
    set(handles.filterXYZButton,'enable','on');
    set(handles.rigidBodyInstructionButton,'enable','off');
    set(handles.svdRigidButton,'enable','off');

end

% --- Executes on button press in boneModelMarkerHave.
function boneModelMarkerHave_Callback(hObject, eventdata, handles)
% hObject    handle to boneModelMarkerHave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of boneModelMarkerHave
    set(handles.boneModelMarkerHave,'value',1);
    set(handles.boneModelMarkerNeed,'value',0);   
    set(handles.digitizeHave,'enable','on');
    set(handles.digitizeNeed,'enable','on');
    set(handles.boneModelMarkerHave,'enable','on');
    set(handles.boneModelMarkerNeed,'enable','on'); 
    
    set(handles.undistortC1Button,'enable','off');
    set(handles.undistortC2Button,'enable','off');
    set(handles.undcalC1Button,'enable','off'); 
    set(handles.undcalC2Button,'enable','off'); 
    set(handles.calibrateC1Button,'enable','off'); 
    set(handles.calibrateC2Button,'enable','off'); 
    set(handles.MergeButton,'enable','off');
    set(handles.DigitizeButton,'enable','off');
    set(handles.filterXYZButton,'enable','off');
    set(handles.rigidBodyInstructionButton,'enable','off');
    if (get(handles.digitizeHave,'value') == 1)
        set(handles.svdRigidButton,'enable','on');
    else
        set (handles.svdRigidButton,'enable','off');
    end
end

% --- Executes on button press in boneModelMarkerNeed.
function boneModelMarkerNeed_Callback(hObject, eventdata, handles)
% hObject    handle to boneModelMarkerNeed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of boneModelMarkerNeed
    set(handles.boneModelMarkerHave,'value',0);
    set(handles.boneModelMarkerNeed,'value',1);   
    set(handles.digitizeHave,'enable','on');
    set(handles.digitizeNeed,'enable','on');
    set(handles.boneModelMarkerHave,'enable','on');
    set(handles.boneModelMarkerNeed,'enable','on'); 
    
    set(handles.undistortC1Button,'enable','off');
    set(handles.undistortC2Button,'enable','off');
    set(handles.undcalC1Button,'enable','off'); 
    set(handles.undcalC2Button,'enable','off'); 
    set(handles.calibrateC1Button,'enable','off'); 
    set(handles.calibrateC2Button,'enable','off'); 
    set(handles.MergeButton,'enable','off');
    set(handles.DigitizeButton,'enable','off'); 
    set(handles.filterXYZButton,'enable','off');
    set(handles.rigidBodyInstructionButton,'enable','on');
    set(handles.svdRigidButton,'enable','off');

end

% --- Executes on button press in undistortC1Button.
function undistortC1Button_Callback(hObject, eventdata, handles)
% hObject    handle to undistortC1Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of undistortC1Button
 Undistorter(handles);
%   UndistortAuto6x(handles);
end

% --- Executes on button press in undcalC1Button.
function undcalC1Button_Callback(hObject, eventdata, handles)
% hObject    handle to undcalC1Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of undcalC1Button
    
   applyUndistort(handles);
end

% --- Executes on button press in calibrateC1Button.
function calibrateC1Button_Callback(hObject, eventdata, handles)
% hObject    handle to calibrateC1Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of calibrateC1Button

   DLTcalibration5X(99,handles);
end

% --- Executes on button press in undistortC2Button.
function undistortC2Button_Callback(hObject, eventdata, handles)
% hObject    handle to undistortC2Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of undistortC2Button

Undistorter(handles);
%   UndistortAuto6x(handles);
end

% --- Executes on button press in undcalC2Button.
function undcalC2Button_Callback(hObject, eventdata, handles)
% hObject    handle to undcalC2Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of undcalC2Button

   applyUndistort(handles);
% CorrectDistortion;
end

% --- Executes on button press in calibrateC2Button.
function calibrateC2Button_Callback(hObject, eventdata, handles)
% hObject    handle to calibrateC2Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of calibrateC2Button

   DLTcalibration5X(99,handles);
  
end

% --- Executes on button press in MergeButton.
function MergeButton_Callback(hObject, eventdata, handles)
% hObject    handle to MergeButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of MergeButton

% handles is passed to allow MergeDLTcoeffFiles to find default directory 
% for first file prompt, and to update default directory as user browses.

   MergeDLTcoeffFiles(handles);
   return;
end

% --- Executes on button press in DigitizeButton.
function DigitizeButton_Callback(hObject, eventdata, handles)
% hObject    handle to DigitizeButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of DigitizeButton

    DLTdv3Brown(99,handles);
end

% --- Executes on button press in undistortVideoButton.
function undistortVideoButton_Callback(hObject, eventdata, handles)

% hObject    handle to undistortVideoButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

applyUndistort(handles);

end

% --- Executes on button press in filterXYZButton.
function filterXYZButton_Callback(hObject, eventdata, handles)
% hObject    handle to filterXYZButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

butterBatch(handles);

end


% --- Executes on button press in rigidBodyInstructionButton.
function rigidBodyInstructionButton_Callback(hObject, eventdata, handles)
% hObject    handle to rigidBodyInstructionButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

stat = web (...
    'https://wiki.brown.edu/confluence/display/ctx/Create+a+Setup+Scene+in+Maya',...
    '-browser');
if (stat ~= 0)
    disp('Could not launch web browser.');
    disp('For instructions for obtaining 3D marker positions relative to ');
    disp('the polygonal mesh bone models, see XROMM wiki ');
    disp('https://wiki.brown.edu/confluence/display/ctx/Create+a+Setup+Scene+in+Maya');
end
end


% --- Executes on button press in svdRigidButton.
function svdRigidButton_Callback(hObject, eventdata, handles)
% hObject    handle to svdRigidButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

rigidBody(handles);

end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over uddHaveC1.
function uddHaveC1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to uddHaveC1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over uddNeedC1.
function uddNeedC1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to uddNeedC1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

end

