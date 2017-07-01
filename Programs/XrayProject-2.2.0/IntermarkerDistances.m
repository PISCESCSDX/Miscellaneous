function varargout = IntermarkerDistances(varargin)
% Author:  Trevor O'Brien  trevor@cs.brown.edu
% Date:    October 19, 2007
% 
%         This function is called from DLTdataviewer within the XRayProject
%         package.  As 3D Marker positions are reconstructed using DLT
%         data, this method allows for the display of inter-marker
%         distances at each frame of a markered-data video sequence.
%                                                                        
% INTERMARKERDISTANCES M-file for IntermarkerDistances.fig

% Last Modified by GUIDE v2.5 10-Feb-2009 10:12:35
% Modified 05-Nov-2008 (restrict statistics to "genuine" points) LJReiss
% Save button callback code removed 27-Jan-2009 LJReiss
% Case MarkerA=MarkerB returns -1 for undigitized (unlabelled) frames.
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @IntermarkerDistances_OpeningFcn, ...
                   'gui_OutputFcn',  @IntermarkerDistances_OutputFcn, ...
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


% --- Executes just before IntermarkerDistances is made visible.
function IntermarkerDistances_OpeningFcn(hObject, eventdata, handles, varargin)
    handles.output = hObject;
    
    movegui(hObject, 'center');
    
    if (size(varargin, 2) > 0)
        handles.pointData = CalculateIntermarkerDistances(varargin{1});
        handles.numMarkers = size(varargin{1}, 3);
    else
        handles.numMarkers = 1;
    end
        
    for i = 1 : handles.numMarkers
        stringList{i} = num2str(i);
    end

    set(handles.popup_ptA, 'String', stringList);
    set(handles.popup_ptB, 'String', stringList);
    
    % Update handles structure
    guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = IntermarkerDistances_OutputFcn(hObject, eventdata, handles) 
    % Get default command line output from handles structure
    varargout{1} = handles.output;


% --- Executes on button press in button_plot.
function button_plot_Callback(hObject, eventdata, handles)

    % Clear the axis of any previous plotting.
    cla(handles.axes_main);

    % Figure out which markers have been selected in the popup menus.
    markerA = get(handles.popup_ptA, 'Value');
    markerB = get(handles.popup_ptB, 'Value');
    
    % Data is formatted as numFrames x IntermarkerDistances
    dltData = handles.pointData;
    numFrames = size(dltData, 1);
    numMarkers = handles.numMarkers;
    
    distancesToPlot = ones(numFrames, 2) * -1;
   
    % Store frame numbers for plotting later.
    for i = 1:numFrames
        distancesToPlot(i, 1) = i;
    end
    
    % Find the appropriate index into the distance data for the given point
    % pair.
    index = GetPairIndex(numMarkers, markerA, markerB);
    
    distancesToPlot(:,2) = dltData(:, index);

    numGenuine = size(find(distancesToPlot(:,2)-ones(numFrames,1)*-1),1);
    plot(handles.axes_main, distancesToPlot(:,1), distancesToPlot(:,2),...
            's','LineWidth',2,'MarkerEdgeColor','k', ...
            'MarkerFaceColor','g', 'MarkerSize',6);
        
    set(handles.axes_main, 'XLim', [0, size(dltData,1)]);
    ymax=max(0,max(distancesToPlot(:,2))); %10Feb2009 insure ymax not= -1.
    set(handles.axes_main, 'YLim', [-1 ymax * 1.2]); 
    set(handles.axes_main, 'XMinorTick', 'on');
    set(handles.axes_main, 'XMinorGrid', 'on');
    
    zoom on;
 
    % Display the mean and standard deviation of the distances plotted.
    set(handles.text_mean, 'String',...
        num2str(mean(distancesToPlot((distancesToPlot(:,2)>-1),2))));
    set(handles.text_deviation, 'String',...
        num2str(std(distancesToPlot((distancesToPlot(:,2)>-1),2))));
    set(handles.text_genuinepts, 'String', num2str(numGenuine,'%d'));
    set(handles.text_totalpts, 'String', num2str(numFrames,'%d'));
    guidata(hObject, handles);
% --- Executes on button press in button_close.
function button_close_Callback(hObject, eventdata, handles)
    
    close;


%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%  Function for computing proper index into our distance data for a given
%  point pair.
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function index = GetPairIndex(numMarkers, a, b)

    % For our purposes, let's make sure a < b. [or a==b]
    if(a > b)
        temp = a;
        a = b;
        b = temp;
    end

    % Now compute our point pair index.
    index = b + numMarkers*(a - 1) - (0.5*a^2 - 0.5*a);

