function [] = DLTcalibration5X(varargin)

% function [] = DLTcalibration5X()
%
% DLTdataviewer is a digitizing environment designed to acquire
% 3D coordinates from 2-3 video sources calibrated via a set of
% DLT coefficients.  It can also digitize only one video stream
% without DLT coefficients.
%
% Features:
%		*Simultaneous viewing of up to 3 video files
%		*Displays line of least residual given a point on one of the
%			images in 3D mode
%		*Change frame sync of the different video streams
%   *Change the gamma of the videos
%		*Load and modify previously digitized trials
%
%	See the associated RTF document for complete usage information
%
%
% Version 1 - Tyson Hedrick 8/1/04
% Version 2 - Tyson Hedrick 8/4/05
% Version 4x updated by Dave Baier for use with CTX at Brown University
% Added output of Maya camera file
% Added default directory support, L Reiss, October 2009
% 1/12/10 -- bug fix to support non-square images (In Ty's calibration code
% uda.movsizes variable, image height is first column and width is second
% column.  This has been corrected at line 942.) L Reiss 
% 2010 Nov 22 - use calimRead and getNextFrame to prepare for future Matlab
% versions without aviread and aviinfo.
% The MATLAB function aviinfo triggers this warning (as of Matlab 6.5), so
% we're going to turn it off.
warning off MATLAB:mir_warning_variable_used_as_function
defaultdir = cd; % initialize
xrayprojectdirhandle = 0; % initialize

if nargin==0 % no inputs, run the gui initialization routine
  call=99; % go create the GUI (see the Switch statement below)

elseif nargin==1 % assume a switchyard call but no data
  call=varargin{1};
  ud=get(gcbo,'Userdata'); % get simple userdata
  h=ud.handles; % get the handles
  uda=get(h(1),'Userdata'); % get complete userdata
  h=uda.handles; % get complete handles
  sp=get(h(32),'Value'); % get the selected point
  defaultdir = get(h(56),'String');
  xrayprojectdirhandle = h(57);

elseif nargin==2 % assume a switchyard call and data
  call=varargin{1};
  if (call==99) 
      xrayprojhandles = varargin{2};
      defaultdir = get(xrayprojhandles.defaultdir,'String');
      xrayprojectdirhandle = xrayprojhandles.defaultdir;
  else
    uda=varargin{2};
    h=uda.handles; % get complete handles
    sp=get(h(32),'Value'); % get the selected point
    defaultdir = get(h(56),'String');
    xrayprojectdirhandle = h(57);
  end;

elseif nargin==3 % switchyard call, data & subfunction specific data
  call=varargin{1};
  uda=varargin{2};
  h=uda.handles; % get complete handles
  sp=get(h(32),'Value'); % get the selected point
  defaultdir = get(h(56),'String');
  xrayprojectdirhandle = h(57);
  oData=varargin{3}; % store the misc. other variable in oData
else
  disp('DLTcalibration5X: incorrect number of input arguments')
  return
end


% switchyard to handle updating & processing tasks for the figure
switch call
  case {99} % Initialize the GUI

    disp(sprintf('\n'))
    disp('DLTcalibration5X (updated May 16, 2006)')
    disp(sprintf('\n'))
    disp('Visit http://faculty.washington.edu/thedrick/digitizing/ for')
    disp('more information and updates to this program.')
    disp(sprintf('\n'))
    
    top=20.7; % top of the controls layout

    h(1) = figure('Units','characters',... % control figure
      'Color',[0.831 0.815 0.784]','Doublebuffer','on', ...
      'IntegerHandle','off','MenuBar','none',...
      'Name','DLTcalibration5X controls','NumberTitle','off',...
      'Position',[18 10 58 36.23],'Resize','off',...
      'HandleVisibility','callback','Tag','figure1',...
      'UserData',[],'Visible','on','deletefcn','DLTcalibration5X(13)');

    h(29) = uicontrol('Parent',h(1),'Units','characters',... % Video frame
      'Position',[3 top+2.5 51.5 6],'Style','frame','BackgroundColor',[0.568 0.784 1], ...
      'string','Points and auto-tracking');

    h(30) = uicontrol('Parent',h(1),'Units','characters',... % Points frame part 1
      'Position',[3 top-5.7 51.5 7.3],'Style','frame','BackgroundColor',[0.788 1 0.576], ...
      'string','Points and auto-tracking');

    uicontrol('Parent',h(1),'Units','characters',... % Points frame part 2
      'Position',[3 top-19.7 30.5 14.1],'Style','frame','BackgroundColor',[0.788 1 0.576], ...
      'string','Points and auto-tracking');

    uicontrol('Parent',h(1),'Units','characters',... % blank string
      'Position',[3.1 top-8.6 30.3 4.6],'Style','text','BackgroundColor',[0.788 1 0.576], ...
      'string','');
    
    uicontrol('Parent',h(1),'Units','characters',... % Points frame part 3
      'Position',[10 top-19.7 44.5 7.5],'Style','frame','BackgroundColor',[0.788 1 0.576], ...
      'string','Points and auto-tracking');
    
    uicontrol('Parent',h(1),'Units','characters',... % blank string
      'Position',[3.1 top-19.6 30.3 14.6],'Style','text','BackgroundColor',[0.788 1 0.576], ...
      'string','');

    h(5) = uicontrol('Parent',h(1),'Units','characters',... % frame slider
      'Position',[7.2 top+3.4 44.2 1.2],'String',{  'frame' },...
      'Style','slider','Tag','slider2','Callback',...
      'DLTcalibration5X(1)','Enable','off','Value',1);

    h(6) = uicontrol('Parent',h(1),'Units','characters',... % initialize button
      'Position',[2.2 top+11.1 22 3],'String','Initialize',...
      'Callback','DLTcalibration5X(0)','ToolTipString', ...
      'Load the frame specification and calibration image files','Tag','pushbutton1');

    h(7) = uicontrol('Parent',h(1),'Units','characters',... % Save data button
      'Position',[27 top+12.8 14.4 1.8],'String','Save Data','Tag','pushbutton3',...
      'Callback','DLTcalibration5X(5)','Enable','off');
    
    %added by Dave Baier 5/4/2007
%     h(8) = uicontrol('Parent',h(1),'Units','characters',... % Save camera set data button
%       'Position',[27 top+11 14.4 1.8],'String','Save Camera Set','Tag','pushbutton3',...
%       'Callback','DLTcalibration5X(5)','Enable','off');
  
    % h(10) - unused

    % h(11) - unused

    % h(12) - unused

    h(13) = uicontrol('Parent',h(1),'Units','characters',... % video gamma slider
      'Position',[17 top+6.6 34 1.3],'String',{  'gamma' },...
      'Style','slider','Tag','slider1','Min',.1','Max',2,'Value',1,...
      'Callback','DLTcalibration5X(1)', ...
      'Enable','off', 'ToolTipString','Video Gamma slider');

    h(14) = uicontrol('Parent',h(1),'Units','characters',... % quit button
      'Position',[43.8 top+11.1 11.2 3],'String','Quit',...
      'Tag','pushbutton4','Callback','DLTcalibration5X(11)','enable','on');

    %     h(15) = uicontrol('Parent',h(1),'Units','characters',... % camera 2 offset
    %       'BackgroundColor',[1 1 1],'Position',[24.2 25.05 5 1.5],...
    %       'String','0','Style','edit','Tag','edit1', ...
    %       'Callback','DLTcalibration5X(8)','Enable','off');
    %
    %     h12 = uicontrol('Parent',h(1),'Units','characters',... % camera 2 offset label
    %       'BackgroundColor',[0.568 0.784 1],'HorizontalAlignment','right',...
    %       'Position',[20.6 24.9 3.2 1.3],'String','2','Style','text',...
    %       'Tag','text3');
    %
    %     h(16) = uicontrol('Parent',h(1),'Units','characters',... % camera 3 offset
    %       'BackgroundColor',[1 1 1],'Position',[34.4 25.05 5 1.5],...
    %       'String','0','Style','edit','Tag','edit2', ...
    %       'Callback','DLTcalibration5X(8)','enable','off');
    %
    %     h13 = uicontrol('Parent',h(1),'Units','characters',... % camera 3 offset label
    %       'BackgroundColor',[0.568 0.784 1],'HorizontalAlignment','right',...
    %       'Position',[30.6 24.9 3.2 1.3],'String','3','Style','text',...
    %       'Tag','text4');
    %
    %     h(17) = uicontrol('Parent',h(1),'Units','characters',... % camera 4 offset
    %       'BackgroundColor',[1 1 1],'Position',[44.8 25.05 5 1.5],'String','0',...
    %       'Style','edit','Tag','edit3','Callback','DLTcalibration5X(8)', ...
    %       'enable','off');
    %
    %     h14 = uicontrol('Parent',h(1),'Units','characters',... % camera 4 offset label
    %       'BackgroundColor',[0.568 0.784 1],'HorizontalAlignment','right',...
    %       'Position',[38.2+3 8.2+16.7 3.2 1.3],'String','4','Style','text','Tag','text5');

    h(18) = uicontrol('Parent',h(1),'Units','characters',... % gamma control label
      'BackgroundColor',[0.568 0.784 1],'HorizontalAlignment','left',...
      'Position',[7 top+7 10.4 1.3],'String','Gamma','Style','text','Tag', ...
      'text1');

    % h(19) - unused

    %     h(20) = uicontrol('Parent',h(1),'Units','characters',... % frame offsets label
    %       'BackgroundColor',[0.568 0.784 1],'HorizontalAlignment','left',...
    %       'Position',[7 8.3+16.7 14.2 1.3],'String','Frame offsets','Style','text',...
    %       'Tag','text2');

    h(21) = uicontrol('Parent',h(1),'Units','characters',... % frame slider label
      'BackgroundColor',[0.568 0.784 1],'HorizontalAlignment','left',...
      'Position',[7 top+5.0 24.6 1.1],'String','Frame number: NaN/NaN',...
      'Style','text','Tag','text6');

    h(22) = uicontrol('Parent',h(1),'Units','characters',... % load previous data button
      'Position',[27 top+9.3 14.4 1.7],'String','Load Data','Tag','pushbutton5',...
      'enable','off','Callback','DLTcalibration5X(6)');

    h(23) = uicontrol('Parent',h(1),... % Calibration type label
      'Units','characters','BackgroundColor',[0.788 1 0.576],...
      'HorizontalAlignment','left','Position',[7 top-8.0 20.6 1.3],...
      'String','DLT calibration type:','Style','text',...
      'Tag','text15');

    h(25) = uicontrol('Parent',h(1),... % Calibration type menu
      'Units','characters',...
      'HorizontalAlignment','left','Position',[7 top-9.7 24.6 1.3],...
      'String','11 parameter |16 parameter','Style','popupmenu',...
      'Value',1,'Tag','text16');

    h(27) = uicontrol('Parent',h(1),... % DLT average residuals
      'Units','characters','BackgroundColor',[0.788 1 0.576],...
      'HorizontalAlignment','left','Position',[34.5 top-15.5 19 2.6],...
      'String',sprintf('Calibration \nresidual: --'), ...
      'Style','text','Tag','text17');

    h(31) = uicontrol('Parent',h(1),... % Current point label
      'Units','characters','BackgroundColor',[0.788 1 0.576],...
      'HorizontalAlignment','left','Position',[7 top-0.5 14.2 1.3],...
      'String','Current point','Style','text','Tag','text13');

    h(32) = uicontrol(... % Current point pull-down menu
      'Parent',h(1),'Units','characters','Position',[7 top-2.3 12 1.6],...
      'String',' 1','Style','popupmenu','Value',1,'Tag','popupmenu1', ...
      'Enable','off','Callback','DLTcalibration5X(1)');

    h(33) = uicontrol('Parent',h(1),'Units','characters',... % compute coefficients button
      'Position',[7 top-16.3 24.6 2.2],'String','Compute coefficients',...
      'Callback','DLTcalibration5X(7)','ToolTipString', ...
      'Compute the DLT coefficients','Tag','pushbutton1', ...
      'enable','off','HorizontalAlignment','center');

    h(34) = uicontrol('Parent',h(1), ... % Advance on click label
      'Units','characters','Position',[28 top-3 24.2 3],'BackgroundColor', ...
      [0.788 1 0.576],'HorizontalAlignment','left','Style','text','String', ...
      sprintf('Auto-advance \non click:'));

    h(35) = uicontrol('Parent',h(1),'Units','characters',... % Advance on click checkbox
      'BackgroundColor',[0.788 1 0.576],'Position',[47 top-1.6 3 1.3],...
      'String','','Style','checkbox','Value',0,'Tag','AoC checkbox',...
      'enable','off');

    h(36) = uicontrol('Parent',h(1),'Units','characters',... % DLT error analysis
      'Position',[7 top-19.0 24.6 2.2],'String','Semi','Style', ...
      'pushbutton','Tag','radiobutton2','enable','off','Callback', ...
      'DLTcalibration5X(8)','String',sprintf('Error analysis'));
    
    h(37) = uicontrol('Parent',h(1),... % Optic center label
      'Units','characters','BackgroundColor',[0.788 1 0.576],...
      'HorizontalAlignment','left','Position',[7 top-12.0 14.2 1.3],...
      'String','Optical center:','Style','text','Tag','text13');

    h(38) = uicontrol('Parent',h(1),'Units','characters',... % optical center - X label
      'BackgroundColor',[1 1 1],'Position',[7 top-14.0 9.8 1.6],...
      'String','X:','Style','text','Tag','edit7','enable','on', ...
      'BackgroundColor',[0.788 1 0.576],'HorizontalAlignment','left');
    
    h(39) = uicontrol('Parent',h(1),'Units','characters',... % optical center - y label
      'BackgroundColor',[1 1 1],'Position',[19 top-14.0 9.8 1.6],...
      'String','Y:','Style','text','Tag','edit7','enable','on', ...
      'BackgroundColor',[0.788 1 0.576],'HorizontalAlignment','left');

    % h(40) movie axes in video figure
    
    h(41) = uicontrol('Parent',h(1),'Units','characters',... % optical center x box
      'BackgroundColor',[1 1 1],'Position',[10 top-13.7 7 1.6],...
      'String','-','Style','edit','Tag','edit8','enable','off');
    
    h(42) = uicontrol('Parent',h(1),'Units','characters',... % optical center y box
      'BackgroundColor',[1 1 1],'Position',[22 top-13.7 7 1.6],...
      'String','-','Style','edit','Tag','edit8','enable','off');

    h(50) = uicontrol('Parent',h(1),... % Magnified image label
      'Units','characters','BackgroundColor',[0.788 1 0.576],...
      'HorizontalAlignment','left','Position',[34 top-5.2 18.6 1.3],...
      'String','Magnified image:','Style','text','Tag','text18');

    h(51)=axes('Position',[.59 .24 .30 .165],'XTickLabel','', ...
      'YTickLabel','','Visible','on','Parent',h(1),'box','off'); % create zoomed image axis
    chex=checkerboard(1,21,21).*255;
    c=(repmat([0:1/254:1]',1,3)); % grayscale color map
    iH=image('Parent',h(51),'Cdata',chex,'CDataMapping','direct'); % display the default image
    colormap(h(51),c)
    xlim(h(51),[1 21]);
    ylim(h(51),[1 21]);

    %     h(52)=uicontrol('Parent',h(1), ... % DLT visual feedback label
    %       'Units','characters','Position',[7 3.6 24.2 1.3],'BackgroundColor', ...
    %       [0.788 1 0.576],'HorizontalAlignment','left','Style','text','String', ...
    %       'DLT visual feedback');
    %
    %     h(53)=uicontrol('Parent',h(1),'Units','characters',... % DLT visual feedback checkbox
    %       'BackgroundColor',[0.788 1 0.576],'Position',[29 3.9 4 1],...
    %       'Value',1,'Style','checkbox','Tag','DLTfeedbackbox',...
    %       'enable','off','Callback','DLTcalibration5X(1)');

    h(54)=uicontrol('Parent',h(1), ... % Centroid finding label
      'Units','characters','Position',[7 top-6.5 24.2 3],'BackgroundColor', ...
      [0.788 1 0.576],'HorizontalAlignment','left','Style','text','String', ...
      sprintf('Find marker \ncentroid:'));

    h(55)=uicontrol('Parent',h(1),'Units','characters',... % Centroid finding checkbox
      'BackgroundColor',[0.788 1 0.576],'Position',[22 top-5.0 4 1],...
      'Value',0,'Style','checkbox','Tag','findCentroidBox',...
      'enable','off','Callback','DLTcalibration5X(1)');

  
   h(56) = uicontrol('Parent',h(1),... % default directory field
      'Units','characters','BackgroundColor',[1 1 1],'Position', ...
      [3.0 top-21.1 50.4 2.0],'String',defaultdir,'Style','text','Tag','defdir',...
      'enable','off', 'Visible', 'off');

 % note: defaultdir is saved above
  h(57) = xrayprojectdirhandle; % save pointer back to XrayProject figure
                                % "default directory" control (if it
                                % exists)


    ud.handles=h; % simple userdata object

    % for each handle set all handle info in userdata
    for i=1:numel(h)
      set(h(i),'Userdata',ud);
    end

    return

    
    case {0} % Initialize button press from the GUI
        defaultdir = get(h(56),'String'); % if defaultdir was set in caller, it is here
        %      gdir = char(strcat(defaultdir(1), ''));% initialize default directory
        gdir = defaultdir;
        % get the calibration frame specification file
        [specfile,specpath]=uigetfile({'*.csv','comma separated values'}, ...
            'Please select your calibration object specification file', ...
            gdir);
        if (isequal(specfile,0))
            disp(sprintf('No calibration object file loaded.'));
            disp('Initialization failed.  Please try again.');
            return
        else
            % update default directory
            %          dir_list = regexp(specpath,'\\$|/$','split');
            %          defaultdir = dir_list(1);
            %          set(h(56),'String', defaultdir);
            set(h(56),'String',specpath);
            if(h(57))
                set(h(57),'String',specpath);
            end
            defaultdir = specpath;
            specdata=dlmread([specpath,specfile],',',1,0); % read in the calibration file
            if size(specdata,2)==3 % got a good spec file
                uda.specdata=specdata; % put it in userdata
                uda.specpath=specpath; % keep the path too
              
              % tell the user
 %             msg=sprintf('Loaded a %d point calibration object specification file.',size(specdata,1));
%              msgbox(msg,'Success');
              % write back any modifications to the main figure userdata
              set(h(1),'Userdata',uda);
              
              %       cd(specpath); % change to spec path directory
          else
              msg='The calibration object specification file must have 3 data columns. Aborting.';
              msgbox(msg,'Error','error');
              return
          end
      end
      
    % get the image files
    v=version;
    if str2num(v(1))<7
        disp('Need to implement multi-file select for MATLAB version < 7')
        %     % ask the user how many videos to load
        %     [uda.nvid,ok]=listdlg('PromptString','How many videos do you have?', ...
        %       'SelectionMode','single','ListString',{'1','2','3','4'}, 'Name', ...
        %       '# of videos','listsize',[160 80]);
        %     pause(0.1); % make sure that the listdlg executed (MATLAB bug workaround)
        %
        %     if ok==0
        %       disp('Initialization cancelled, please try again.')
        %       return
        %     end

        %     % attempt to load the De-Distortion transforms from a matfile
        %     load c:/tmp/xray/pigTrackDeDistort.mat
        %     uda.cam1ud=cam1ud;
        %     uda.cam2ud=cam2ud;
        %     disp('Loaded dedistortion transform matrices.')
        return
    else
%        gdir = char(strcat(defaultdir, '\Cal_cube_images\'));
        gdir = defaultdir;
        [uda.calfnames,uda.calpname]=uigetfile( {'*.tif;*.jpg;*.avi', ...
            'Image files (*.tif, *.jpg, *.avi)'}, ...
            'Select the calibration image file', gdir,'MultiSelect','off');
        if (isequal(uda.calfnames,0))
            disp(sprintf('No calibration image file(s) loaded.'));
            return
        else
            % update default directory
            % TODO: this may need to better handle multiselected files
            set(h(56),'String',uda.calpname);
            if(h(57))
                set(h(57),'String',uda.calpname);
            end
        end
        if iscell(uda.calfnames)==0 % convert strings to cells
            uda.calfnames={uda.calfnames};
        end
    end
    
    %added by Dave Baier to allow markerSize adjustment with 'o' and 'p'
    uda.markerSize = 6;

    % Create a new figure for movie display
    h(2) = figure('Units','characters',... % movie figure
      'Color',[0.831 0.815 0.784]','Doublebuffer','on', ...
      'KeyPressFcn','DLTcalibration5X(2)', ...
      'IntegerHandle','off','MenuBar','none',...
      'Name','DLTcalibration5X images','NumberTitle','off',...
      'HandleVisibility','callback','Tag','figure1',...
      'UserData',uda,'Visible','on','Units','Pixels', ...
      'deletefcn','DLTcalibration5X(13)','pointer','cross', ...
      'Tag','VideoFigure');

    h(40)=axes('Position',[.01 .01 .99 .95],'XTickLabel','', ...
      'YTickLabel','','ButtonDownFcn','DLTcalibration5X(3)', ...
      'Visible','off'); % create movie1 axis

    % Initialize the data arrays
    %
    % set the slider size
    if length(uda.calfnames)>1
      set(h(5),'Max',length(uda.calfnames),'Min',1,'Value',1,'SliderStep', ...
        [1/(length(uda.calfnames)-1) 1/(length(uda.calfnames)-1)]);
      set(h(5),'Enable','on'); % turn slider on
    else
      set(h(5),'Enable','off') % turn off the slider if we only have 1 image
    end
    
    uda.cNum=1; % initial camera # is 1 (first camera)
    uda.numpts=size(specdata,1); % number of points to digitize per camera
    uda.xypts(1:uda.numpts,1:2)=NaN; % digitized point
    uda.sp=1; % selected point
    uda.recentlysaved=true; % start the "saved" flag at true
    figure(h(2)) % make the video figure active
    
    % update the number of points settings
    ptstring='';
    for i=1:uda.numpts-1
      ptstring=[ptstring,sprintf('%2d|',i)];
    end
    ptstring=[ptstring,sprintf('%2d',uda.numpts)];
    set(h(32),'String',ptstring);

    % read & plot the first image
%    im=calimread([uda.calpname,uda.calfnames{1}]);
    [im] = calimread([uda.calpname,uda.calfnames{1}]);
    set(h(40),'Visible','on');
    set(h(2),'CurrentAxes',h(40));
    redlakeplot(flipud(im));
    uda.movsizes(1,1)=size(im,1);
    uda.movsizes(1,2)=size(im,2);
    
    set(h(40),'XTickLabel','');
    set(h(40),'YTickLabel','');
    set(get(h(40),'Children'),'ButtonDownFcn','DLTcalibration5X(3)');
    set(get(h(40),'Children'),'UserData',uda);
    set(h(40),'Userdata',uda);
    
    set(h(41),'String',uda.movsizes(1,2)/2);
    set(h(42),'String',uda.movsizes(1,1)/2);

    % turn on the other controls
    set(h(7),'enable','on'); % save button
    set(h(13),'enable','on'); % video gamma control
    set(h(22),'enable','on'); % load previous data button
    set(h(32),'enable','on'); % point # pulldown menu
    set(h(35),'enable','on'); % advance on click checkbox
    set(h(41),'enable','on'); % optic center (X)
    set(h(42),'enable','on'); % optic center (Y)


    % turn on Centroid finding & set value to "On" if the image analysis
    % toolbox functions that it depends on are available
    if exist('im2bw')==2 && exist('regionprops')==2 && exist('bwlabel')==2
      set(h(55),'enable','on','Value',0);
      disp('Detected Image Analysis toolbox, centroid localization is')
      disp('available, enable it via the checkbox in the Controls window.')
    else
      disp('The Image Analysis toolbox is not available, centroid ')
      disp('localization has been disabled.')
    end

    % turn off the Initialize button
    set(h(6),'enable','off');

    % write the userdata back
    uda.handles=h; % copy in new handles
    set(h(1),'Userdata',uda);

    % call self to update the string fields
    DLTcalibration5X(4,uda);


  case {1} % refresh the video frames
    %disp('case 1: full screen redraw')

    cfh=gcf; % handle to current figure
    
    fr=round(get(h(5),'Value')); % get the frame # from the slider
    %set(h(5),'Value',fr); % set the rounded value back
    %frmax=get(h(5),'Max'); % get the slider max
    
    figure(h(2)); % activate the video figure
    set(h(2),'CurrentAxes',h(40)); % activate the video axis
    
    xl=xlim; % current x & y axis limits
    yl=ylim;
    
%    im=calimread([uda.calpname,uda.calfnames{fr}]); % read the image
    [im]=calimread([uda.calpname,uda.calfnames{fr}]); % read the image
    % plot the new image data
    hold off
    redlakeplot(flipud(im(:,:,1)));
    set(h(40),'XTickLabel','');
    set(h(40),'YTickLabel','');
    set(h(40),'Userdata',uda);
    set(get(h(40),'Children'),'ButtonDownFcn','DLTcalibration5X(3)');
    set(get(h(40),'Children'),'UserData',uda);
    xlim(xl);, ylim(yl); % restore axis zoom
    hold on
    title(uda.calfnames{fr},'Interpreter','none');
    
    % plot any existing digitized points (in a loop, ick!)
    idx=find(isnan(uda.xypts(:,uda.cNum*2))==0);
    idx2=find(idx==sp);
    idx(idx2)=[];
    for i=1:length(idx)
      % red dot on the point
      plot(uda.xypts(idx(i),uda.cNum*2-1), ...
        uda.xypts(idx(i),uda.cNum*2),'r.','HitTest','off');
      
      % text label of point # slightly up & left
      text(uda.xypts(idx(i),uda.cNum*2-1)+2, ...
        uda.xypts(idx(i),uda.cNum*2)+2,num2str(idx(i)), ...
        'Color','r','HitTest','off');
    end
    
    % plot the selected point
    plot(uda.xypts(sp,uda.cNum*2-1), ...
      uda.xypts(sp,uda.cNum*2),'ro','MarkerFaceColor','r', ...
      'HitTest','off','MarkerSize',uda.markerSize);
    text(uda.xypts(sp,uda.cNum*2-1)+2,uda.xypts(sp,uda.cNum*2)+2, ...
      num2str(sp),'Color','r','FontSize',14,'HitTest','off');
    
    % set the figure gamma
    c=colormap(gray);
    cnew=c.^get(h(13),'Value');
    colormap(cnew);

    % write back any modifications to the main figure userdata
    set(h(1),'Userdata',uda);

    % restore the pre-existing top figure
    figure(cfh);

    % call self to update the text fields
    DLTcalibration5X(4,uda);
    
    % update the small plot
    [success]=updateSmallPlot(uda,h,1,sp,fr,uda.xypts(sp,uda.cNum*2-1:uda.cNum*2));
    

  case {2} % handle keypresses in the figure window - zoom & unzoom axes
    % disp('case 2: handle keypresses')
    cc=get(h(2),'CurrentCharacter'); % the key pressed
    cp=get(h(2),'CurrentPoint'); % last point clicked on
    pl=get(0,'PointerLocation'); % pointer location on the screen
    pos=get(h(2),'Position'); % get the figure position
    fr=round(get(h(5),'Value')); % get the current frame

    % calculate pointer location in normalized units
    plocal=[(pl(1)-pos(1,1)+1)/pos(1,3), (pl(2)-pos(1,2)+1)/pos(1,4)];
    
    % if the keypress is empty set it to some value
    if isempty(cc)
      cc='X'; % any value that we don't look for later would do
      axh=0; % set handle to active axis to zero
    else
      if plocal(1)<=0.99 & plocal(2)<=0.99, axh=h(40);, vnum=1;
      else disp('The mouse pointer is not over an image.'),return, axh=0;
      end
    end

    % process the key press
    if (cc=='=' || cc=='-' || cc=='r') & axh~=0; % check for valid zoom keys

      % zoom in or out as indicated
      if axh~=0
        set(h(2),'CurrentAxes',axh); % set the current axis
        axpos=get(axh,'Position'); % axis position in figure
        xl=xlim;, yl=ylim; % x & y limits on axis
        % calculate the normalized position within the axis
        plocal2=[(plocal(1)-axpos(1,1))/axpos(1,3) (plocal(2) ...
          -axpos(1,2))/axpos(1,4)];

        % calculate the actual pixel postion of the pointer
        pixpos=round([(xl(2)-xl(1))*plocal2(1)+xl(1) ...
          (yl(2)-yl(1))*plocal2(2)+yl(1)]);

        % axis location in pixels (idealized)
        axpix(3)=pos(3)*axpos(3);
        axpix(4)=pos(4)*axpos(4);

        % adjust pixels for distortion due to normalized axes
        xRatio=(axpix(3)/axpix(4))/(diff(xl)/diff(yl));
        yRatio=(axpix(4)/axpix(3))/(diff(yl)/diff(xl));
        if xRatio > 1
          xmp=xl(1)+(xl(2)-xl(1))/2;
          xmpd=pixpos(1)-xmp;
          pixpos(1)=pixpos(1)+xmpd*(xRatio-1);
        elseif yRatio > 1
          ymp=yl(1)+(yl(2)-yl(1))/2;
          ympd=pixpos(2)-ymp;
          pixpos(2)=pixpos(2)+ympd*(yRatio-1);
        end

        % set the figure xlimit and ylimit
        if cc=='=' % zoom in
          xlim([pixpos(1)-(xl(2)-xl(1))/3 pixpos(1)+(xl(2)-xl(1))/3]);
          ylim([pixpos(2)-(yl(2)-yl(1))/3 pixpos(2)+(yl(2)-yl(1))/3]);
        elseif cc=='-' % zoom out
          xlim([pixpos(1)-(xl(2)-xl(1))/1.5 pixpos(1)+(xl(2)-xl(1))/1.5]);
          ylim([pixpos(2)-(yl(2)-yl(1))/1.5 pixpos(2)+(yl(2)-yl(1))/1.5]);
        else % restore zoom
          xlim([0 uda.movsizes(vnum,2)]);
          ylim([0 uda.movsizes(vnum,1)]);
        end
        
        % update the zoomed plot
        cp=uda.xypts(sp,uda.cNum*2-1:uda.cNum*2);
        [success]=updateSmallPlot(uda,h,1,sp,fr,cp);

      end

    elseif cc=='f' || cc=='b' & axh~=0 % check for valid movement keys
      fr=round(get(h(5),'Value')); % get current slider value
      smax=get(h(5),'Max'); % max slider value
      smin=get(h(5),'Min'); % min slider value
      if smin==0, return, end % avoid edge case
      axn=find(h==axh)-39; % axis number
      if isnan(axn),
        disp('Error: The mouse pointer is not in an axis.')
        return
      end
      cp=uda.xypts(sp,uda.cNum*2-1:uda.cNum*2); % set current point to xy value
      if cc=='f' & fr+1 <= smax
        set(h(5),'Value',fr+1); % current frame + 1
        fr=fr+1;
      elseif cc=='b' & fr-1 >= smin
        set(h(5),'Value',fr-1); % current frame - 1
        fr=fr-1;
      end

      % full redraw of the screen
      DLTcalibration5X(1,uda);

      % update the control / zoom window
      % 1st retrieve the cp from the data file in case the autotracker
      % changed it
      cp=uda.xypts(sp,uda.cNum*2-1:uda.cNum*2);
      [success]=updateSmallPlot(uda,h,axn,sp,fr,cp);

    elseif cc=='.' || cc==',' % change point
      ptnum=str2num(get(h(32),'String')); % get current pull-down list (available points)
      ptval=get(h(32),'Value'); % selected point
      pdx=find(ptnum==ptval); % location of current point in the list
      if cc==',' & pdx~=1 % decrease point value if possible
        set(h(32),'Value',ptval-1);
        ptval=ptval-1;
      elseif cc=='.' & pdx~=prod(size(ptnum)) % increase point value if possible
        set(h(32),'Value',ptval+1);
        ptval=ptval+1;
      end

      pt=uda.xypts(ptval,uda.cNum*2-1:uda.cNum*2);

      % update the magnified point view
      [success]=updateSmallPlot(uda,h,vnum,ptval,fr,pt);

      % do a quick screen redraw
      % [success]=quickRedraw(uda,h,ptval,fr);
      DLTcalibration5X(1,uda);

    elseif cc=='i' || cc=='j' || cc=='k' || cc=='m' || cc=='4' || cc=='8' ...
        || cc=='6' || cc=='2' % nudge point
      % check and see if there is a point to nudge, get it's value if
      % possible
      if isnan(uda.xypts(sp,uda.cNum*2-1))
        return
      else
        pt=uda.xypts(sp,uda.cNum*2-1:uda.cNum*2);
      end

      % modify pt based on the 'nudge' value
      nudge=0.1; % 1/2 pixel nudge
      if cc=='i' || cc=='8'
        pt(1,2)=pt(1,2)+nudge; % up
      elseif cc=='j' || cc=='4'
        pt(1,1)=pt(1,1)-nudge; % left
      elseif cc=='k' || cc=='6'
        pt(1,1)=pt(1,1)+nudge; % right
      else
        pt(1,2)=pt(1,2)-nudge; % down
      end

      % set the modified point
      uda.xypts(sp,uda.cNum*2-1:uda.cNum*2)=pt;

      % update the magnified point view
      [success]=updateSmallPlot(uda,h,vnum,sp,fr,pt);

      % do a quick screen redraw
      % [success]=quickRedraw(uda,h,sp,fr);
      DLTcalibration5X(1,uda);

    elseif cc==' ' % space bar (digitize a point)
      set(h(2),'CurrentAxes',axh); % set the current axis
      axpos=get(axh,'Position'); % axis position in figure
      xl=xlim;, yl=ylim; % x & y limits on axis
      % calculate the normalized position within the axis
      plocal2=[(plocal(1)-axpos(1,1))/axpos(1,3) (plocal(2) ...
        -axpos(1,2))/axpos(1,4)];

      % calculate the actual pixel postion of the pointer
      pixpos=([(xl(2)-xl(1)+0)*plocal2(1)+xl(1) ...
        (yl(2)-yl(1)+0)*plocal2(2)+yl(1)]);

      % axis location in pixels (idealized)
      axpix(3)=pos(3)*axpos(3);
      axpix(4)=pos(4)*axpos(4);

      % adjust pixels for distortion due to normalized axes
      xRatio=(axpix(3)/axpix(4))/(diff(xl)/diff(yl));
      yRatio=(axpix(4)/axpix(3))/(diff(yl)/diff(xl));
      if xRatio > 1
        xmp=xl(1)+(xl(2)-xl(1))/2;
        xmpd=pixpos(1)-xmp;
        pixpos(1)=pixpos(1)+xmpd*(xRatio-1);
      elseif yRatio > 1
        ymp=yl(1)+(yl(2)-yl(1))/2;
        ympd=pixpos(2)-ymp;
        pixpos(2)=pixpos(2)+ympd*(yRatio-1);
      end

      % setup oData for the digitization routine
      oData.seltype='standard';
      oData.cp=pixpos;
      DLTcalibration5X(3,uda,oData); % digitize a point
      return

    elseif cc=='z' % delete the current point
      oData.seltype='alt';
      oData.cp=[NaN,NaN];
      DLTcalibration5X(3,uda,oData); % digitize a point
      return

    elseif cc=='p'
        uda.markerSize=uda.markerSize+6;
        % do a quick screen redraw
        DLTcalibration5X(1);
        
    elseif cc=='o'
        if uda.markerSize == 6
            uda.markerSize=uda.markerSize;
        else
            uda.markerSize=uda.markerSize-6;
        end
        % do a quick screen redraw
        DLTcalibration5X(1);

    end

    % write back any modifications to the main figure userdata
    set(h(1),'Userdata',uda);

  case {3} % handle button clicks in axes
    % disp('case 3: handle button clicks')

    if strcmp(get(gcbo,'Tag'),'VideoFigure')
      % entered the function via space bar, not mouse click
      seltype=oData.seltype;
      cp=oData.cp;
    else
      % entered via mouse click
      set(h(2),'CurrentAxes',get(gcbo,'Parent')); % set the current axis
      cp=get(get(gcbo,'Parent'),'CurrentPoint'); % get the xy coordinates
      seltype=cellstr(get(h(2),'SelectionType')); % selection type
      axn=1; % axis number (only 1 in the calibration program)
    end
    fr=round(get(h(5),'Value')); % get the current frame

    % if detect right button click, erase the point
    if strcmp(seltype,'alt'), cp(:,:)=NaN;
    end

    % Search for a marker centroid (if desired & possible)
    findCent=get(h(55),'Value'); % check the UI for permission
    if isnan(cp(1))==0 && findCent==1
      [cp]=click2centroid(h,cp);
    end

    % set the points for the current frame
    uda.xypts(sp,uda.cNum*2-1)=cp(1,1); % set x point
    uda.xypts(sp,uda.cNum*2)=cp(1,2); % set y point

    % new data available, change the recently saved parameter to false
    uda.recentlysaved=0;

    % zoomed window update
    [success]=updateSmallPlot(uda,h,1,sp,fr,cp);
    
    % auto-advance on click
    if(get(h(35),'Value')==1) 
      ptnum=str2num(get(h(32),'String')); % get current pull-down list (available points)
      ptval=get(h(32),'Value'); % selected point
      pdx=find(ptnum==ptval); % location of current point in the list
      if pdx~=length(ptnum) % increase point value if possible
        set(h(32),'Value',ptval+1);
        ptval=ptval+1;
      end
    end
    
    % enable computation buttons if appropriate
    goodpts=find(isnan(uda.xypts(:,uda.cNum*2))==0);
    if length(goodpts)>=9
      set(h(33),'Enable','on')
      set(h(36),'Enable','on')
    else
      set(h(33),'Enable','off')
      set(h(36),'Enable','off')
    end

    set(h(1),'Userdata',uda); % pass back complete user data

    % quick screen refresh to show the new point & possibly DLT info
    % [success]=quickRedraw(uda,h,sp,fr);
    DLTcalibration5X(1,uda)

  case {4}	% update the text fields
    % set the frame # string
    fr=round(get(h(5),'Value')); % get current frame and max frame from the slider
    frmax=get(h(5),'Max');
    set(h(21),'String',['Frame number: ' num2str(fr) '/' num2str(frmax)]);

  case {5} % save data
    % disp('case 5: save data')
    
    % get a place to save it
    defaultdir = get(h(56),'String');
%    ddir = char(strcat(defaultdir, '\DLTcoeffs\'));
ddir = defaultdir;
    %    pname=uigetdir(pwd,'Pick a directory to contain the output files');
    [fname,pname] = uiputfile(...
        '*.csv',sprintf('Select file to replace, or enter new filename prefix:'),...
        [ddir '']); % display the .csv files in folder, leave Filename blank
    pause(0.1); % make sure that the uigetdir executed (MATLAB bug)
    if isequal(fname,0)
        disp('Save cancelled by user.');
        return;
    end
    set(h(56),'String',pname); % update default directory
    if (h(57))
        set(h(57),'String',pname);
    end
    defaultdir = pname;
    
    % get prefix
    sfix_list = ['(xypts.csv)|(.csv)'];
    pfix_list = regexp(fname,sfix_list,'split');
    pfix = char(pfix_list(1));
    
    % test for existing files
    if (strcmp((char(strcat(pfix, '.csv'))),fname))
        % only prefix was given
        newfname = char(strcat(pfix, 'xypts.csv'));
        if (exist([pname newfname],'file'))
            
            %   if exist([pname,filesep,pfix,'xypts.csv'])~=0
            overwrite=questdlg('Overwrite existing data?', ...
                'Overwrite?','Yes','No','No');
        else
            overwrite='Yes';
        end
    else
        overwrite='Yes';
    end
if(strcmp(overwrite,'Yes'))

    % create headers (xypts)
    for i=1:uda.cNum
      xyh{uda.cNum*2-1}=sprintf('cam%s_X',num2str(i));
      xyh{uda.cNum*2}=sprintf('cam%s_Y',num2str(i));
    end

    if strcmp(overwrite,'Yes')==1
      % xypts
      f1=fopen([pname,filesep,pfix,'xypts.csv'],'w');
      % header
      for i=1:prod(size(xyh))-1
        fprintf(f1,'%s,',xyh{i});
      end
      fprintf(f1,'%s\n',xyh{end});
      % data
      for i=1:size(uda.xypts,1);
        tempData=squeeze(uda.xypts(i,:,:));
        for j=1:prod(size(tempData))-1
          fprintf(f1,'%.6f,',tempData(j));
        end
        fprintf(f1,'%.6f\n',tempData(end));
      end
      fclose(f1);
      
      % dltcoefs
      if isfield(uda,'coefs')
        dlmwrite([pname,filesep,pfix,'DLTcoefs.csv'],uda.coefs,',');
      end
      
      %maya camera (added Dave Baier 5/1/2007)
      if isfield(uda,'coefs')
          for i=1:uda.cNum
              orthcoefs = mdlt1(uda.specdata,uda.xypts);
              mcam = mayaCamspec(orthcoefs,uda.movsizes(1,2),uda.movsizes(1,1));
              dlmwrite([pname,filesep,pfix,'mayaCam.csv'],mcam,',');
          end
      end


      uda.recentlysaved=1;
      set(h(1),'Userdata',uda); % pass back complete user data

      msgbox('Data saved.');
    end
end

  case {6} % load previously saved points
    % disp('case 6: load previously saved points')
    % load the xy points file
    defaultdir = get(h(56),'String');
%    ddir = char(strcat(defaultdir, '\DLTcoeffs\'));
ddir = defaultdir;
    [fname1,pname1]=uigetfile('*.csv','Select the [prefix]xypts.csv file',...
        [ddir '']);
    pause(0.1); % make sure that the uigetfile executed (MATLAB bug workaround)
    if (isequal(fname1,0))
        return
    else
        set(h(56),'String',pname1); % update default directory
        if(h(57))
            set(h(57),'String',pname1);
        end
        defaultdir = pname1;
        
        pfix=[pname1,fname1];
        pfix(end-8:end)=[]; % remove the 'xypts.csv' portion
        
        % load the exported xy points
        tempData=dlmread([pfix,'xypts.csv'],',',1,0);
        
        % check for similarity with video data
        if size(tempData,1)~=size(uda.xypts,1)
            msgbox('WARNING - the digitized point file size does not match the frame, aborting.', ...
                'Warning','warn','modal')
            return
        else
            uda.xypts=tempData;
            
            % enable computation buttons if appropriate
            goodpts=find(isnan(tempData(:,1))==0);
            if length(goodpts)>=9
                set(h(33),'Enable','on')
                set(h(36),'Enable','on')
            else
                set(h(33),'Enable','off')
                set(h(36),'Enable','off')
            end
            
        end
        
        % call self to update the video fields
        DLTcalibration5X(1,uda);
    end

  case {7} % compute DLT coefficients
    if uda.cNum==1
      uda.coefs=[];
    end
    
    % get the computation type from the menu
		if get(h(25),'Value')==1 % 11 parameter DLT
			set(gcf,'Pointer','watch')
      data=uda.xypts(:,uda.cNum*2-1:uda.cNum*2);
      goodpts=find(isnan(data(:,1))==0);
      if length(goodpts)<9
        msgbox('You should use at least 9 digitized points for 11 parameter DLT')
        return
      end
			[uda.coefs(:,uda.cNum),uda.avgres(uda.cNum)]= ...
        dltfu(uda.specdata,data);
			set(gcf,'Pointer','arrow')
		else % modified DLT
			set(gcf,'Pointer','watch')
			[uda.coefs(:,uda.cNum),uda.avgres(uda.cNum)]= ...
        dltfu16_v2(uda.specdata,uda.xypts(:,uda.cNum*2-1:uda.cNum*2), ...
        [get(h(41),'Value'),get(h(42),'Value')]);
			set(gcf,'Pointer','arrow')
		end

		% update the user interface
    set(h(27),'String',sprintf('Calibration \nresidual: %0.3f',uda.avgres(uda.cNum)));
		
		% write back any modifications to the main figure userdata 
 		set(h(1),'Userdata',uda);

    set(h(6),'Enable','on'); % enable the "calibrate another camera" control
    set(h(6),'String','Add a camera')
    

  case {8} % DLT error analysis
    %disp('case 8: DLT error analysis')
    msg{1}='This function computes the DLT coefficients and residuals';
    msg{2}='with one of the calibration points removed.  Calibration';
    msg{3}='point # is shown on the X axis and DLT residual without that';
    msg{4}='point is on the Y axis.  A large drop in the residual';
    msg{5}='indicates that the calibration point in question may be';
    msg{6}='badly digitized or incorrectly specified in the calibration';
    msg{7}='object file.  This function does not modify any of the';
    msg{8}='existing calibration points, it only shows the outcome of';
    msg{9}='potential modifications.';

    uiwait(msgbox(msg,'Information','modal'));

    % start processing
    wh=waitbar(0,'Processing error values');
    for i=1:size(uda.specdata,1)
      waitbar(i/size(uda.xypts,1)); % update waitbar size
      ptstemp=uda.xypts(:,uda.cNum*2-1:uda.cNum*2);
      rescheck(i,1)=i; % build X axis column
      if isnan(ptstemp(i,1))==1 % no value anyway
        rescheck(i,2)=NaN; % no need to process
      else
        ptstemp(i,1:2)=NaN; % set to NaN and recalculate
        if get(h(25),'Value')==1 % standard DLT
          [coefs,rescheck(i,2)]=dltfu(uda.specdata,ptstemp);
        else % modified DLT
          [coefs,rescheck(i,2)]=dltfu(uda.specdata,ptstemp./1000, ...
            [get(h(41),'Value'),get(h(42),'Value')]./1000);
        end
      end
    end
    close(wh)
    eah=figure;
    plot(rescheck(:,1),rescheck(:,2),'rd','MarkerFaceColor','r')
    ylabel('DLT residual with 1 calibration point removed')
    xlabel('Calibration point')
    

  case {9} % validate autotrack search width
    % disp('case 9: validate the autotrack search width')
    atwidth=str2num(get(gcbo,'String'));
    if atwidth>0 & mod(atwidth,1)==0 & isempty(atwidth)==0
      % input okay
    else
      beep
      disp('Auto-track width should be a positive integer')
      set(gcbo,'String','9')
    end

  case {10} % validate autotrack threshold
    % disp('case 10: validate the autotrack threshold')
    thold=str2num(get(gcbo,'String'));
    if thold>=0
      % input okay
    else
      beep
      disp('Auto-track threshold should be a positive real number')
      set(gcbo,'String','10')
    end

  case {11} % Quit button
    reallyquit=questdlg('Are you sure you want to quit?','Quit?','yes','no','no');
    pause(0.1); % make sure that the questdlg executed (MATLAB bug workaround)
    if strcmp(reallyquit,'yes')==1
      eval('close(h(2));','');
      eval('close(h(1));','');
    end

  case {12} % add-a-point button
    uda.numpts=uda.numpts+1; % update number of points
    ptstring=get(h(32),'String'); % get current pull-down list
    % update pull-down list string
    if uda.numpts<3
      ptstring=[ptstring,'|',sprintf('%2d',uda.numpts)];
    else
      ptstring(end+1,:)=sprintf('%2d',uda.numpts);
    end
    set(h(32),'String',ptstring); % write updated list back
    set(h(32),'Value',uda.numpts(end)); % update value to the new point

    % update the data matrices by adding the new dimension
    uda.xypts(:,:,uda.numpts)=NaN;
    uda.dltpts(:,:,uda.numpts)=NaN;
    uda.dltres(:,:,uda.numpts)=NaN;

    set(h(1),'Userdata',uda); % write the new userdata back

    DLTcalibration5X(1,uda); % call self to update video frames

  case {13} % Window close via non-Matlab method
    % if initialization completed and there is data to save
    if h(2)~=0 & uda.recentlysaved==0;
      savefirst=questdlg('Would you like to save your data before you quit?', ...
        'Save first?','yes','no','yes');
      pause(0.1); % make sure that the questdlg executed (MATLAB bug workaround)
      if strcmp(savefirst,'yes')
        DLTcalibration5X(5,uda); % call self to save data
      else
        uda.recentlysaved=1; % consider the data saved anyway to avoid asking again
        set(h(1),'Userdata',uda); % write the new userdata back
      end
    end
    eval('delete(h(2));','');
    eval('delete(h(1));','');

  case {14} % Radio button one callback
    % manage other radio buttons and continue on
    set([h(36) h(37)],'Value',0);

    DLTcalibration5X(1,uda); % call self to continue with main update

  case {15} % Radio button one callback
    % manage other radio buttons and continue on
    set([h(35) h(37)],'Value',0);

    DLTcalibration5X(1,uda); % call self to continue with main update

  case {16} % Radio button one callback
    % manage other radio buttons and continue on
    set([h(35) h(36)],'Value',0);

    DLTcalibration5X(1,uda); % call self to continue with main update

end % end of switch / case statement

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Begin subfunctions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [h] = redlakeplot(varargin)

% function [h] = redlakeplot(rltiff,xy)
%
% Description:	Quick function to plot images from Redlake tiffs
% 	This function was formerly named birdplot
%
% Version history:
% 1.0 - Ty Hedrick 3/5/2002 - initial version

if nargin ~= 1 & nargin ~= 2
  disp('Incorrect number of inputs.')
  return
end

h=image(varargin{1},'CDataMapping','scaled');
set(h,'EraseMode','normal');
colormap(gray)
axis xy
axis equal
hold on
ha=get(h,'Parent');
set(ha,'XTick',[],'YTick',[],'XColor',[0.8314 0.8157 0.7843],'YColor', ...
  [0.8314 0.8157 0.7843],'Color',[0.8314 0.8157 0.7843]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [success]=updateSmallPlot(uda,h,vnum,sp,fr,cp,roi)

% update the magnified plot in the "Controls" window.  If the cp input is a
% NaN the function displays a checkerboard, if roi is not given the
% function grabs one from the appropriate plot using the other included
% information.

success=0;

if isnan(cp(1))
  roi=checkerboard(1,21,21).*255;
end

x=round(cp(1,1)); % get an integer X point
y=round(cp(1,2)); % get an integer Y point

if exist('roi')~=1 % don't have roi yet, go get it
  %psize=round(str2num(get(h(38),'String'))); % search area size
  psize=round(mean([abs(diff(get(h(40),'xlim'))),abs(diff(get(h(40),'ylim')))])/10);
  kids=get(h(vnum+39),'Children'); % children of current axis
  imdat=get(kids(end),'CData'); % read current image
  tcommand='roi=imdat(y-psize:y+psize,x-psize:x+psize);';
  eval(tcommand,'return'); % if tcommand fails return without adjusting cp
  if exist('roi')~=1, return, end
end

if isnan(roi(1)), return, end

% scale roi to gamma, assume 8bit grayscale
gamma=get(h(13),'Value');
roi2=(double(roi).^gamma).*(255/255^gamma);

% update the roi viewer in the controls frame
image('Parent',h(51),'Cdata',roi2,'CDataMapping','direct');

edgelen=size(roi,1);
xlim(h(51),[1 edgelen]);
ylim(h(51),[1 edgelen]);

% put a crosshair on the target image
iHold(h(51),'on')
xd=x-cp(1,1);
yd=y-cp(1,2);
iPlot(h(51),[1;edgelen],[edgelen/2;edgelen/2]-yd,'r-');
iPlot(h(51),[edgelen/2;edgelen/2]-xd,[1;edgelen],'r-');
iHold(h(51),'off')

success=1;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [m,b]=partialdlt(u,v,C1,C2)

% function [m,b]=partialdlt(u,v,C1,C2)
%
% partialdlt takes as inputs a set of X,Y coordinates from one camera view
% and the DLT coefficients for the view and one additional view.  It returns the
% line coefficients m & b for Y=mX+b in the 2nd camera view.  Under error-free
% DLT, the X,Y marker in the 2nd camera view must fall along the line given.
%
% Inputs:
%	u = X coordinate in camera 1
%	v = Y coordinate in camera 1
%	C1 = the 11 dlt coefficients for camera 1
%	C2 = the 11 dlt coefficients for camera 2
%
% Outputs:
%	m = slope of the line in camera 2
%	b = Y-intercept of the line in camera 2
%
% Initial version:
% Ty Hedrick, 11/25/03
%	6/14/04 - Ty Hedrick, updated to use the proper solution for x(i) - see below

% pick 2 random Z (actual values are not important)
z(1)=500;
z(2)=-500;

% for each Z predict x & y
for i=1:2
  Z=z(i);

  y(i)= -(u*C1(9)*C1(7)*Z + u*C1(9)*C1(8) - u*C1(11)*Z*C1(5) -u*C1(5) + ...
    C1(1)*v*C1(11)*Z + C1(1)*v - C1(1)*C1(7)*Z - C1(1)*C1(8) - ...
    C1(3)*Z*v*C1(9) + C1(3)*Z*C1(5) - C1(4)*v*C1(9) + C1(4)*C1(5)) / ...
    (u*C1(9)*C1(6) - u*C1(10)*C1(5) + C1(1)*v*C1(10) - C1(1)*C1(6) - ...
    C1(2)*v*C1(9) + C1(2)*C1(5));

  Y=y(i);

  x(i)= -(v*C1(10)*Y+v*C1(11)*Z+v-C1(6)*Y-C1(7)*Z-C1(8))/(v*C1(9)-C1(5));
end

% back the points into the cam2 X,Y domain
for i=1:2
  xy(i,:)=invdlt(C2(:),[x(i),y(i),z(i)]);
end

% get a line equation back, y=mx+b
m=(xy(2,2)-xy(1,2))/(xy(2,1)-xy(1,1));
b=xy(1,2)-m*xy(1,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [cp]=click2centroid(h,cp)

% version of centroid finding from Arnold Song
% Use the centroid locating tools in the MATLAB image analysis toolbox to
% pull the mouse click to the centroid of a putative marker


        % Set half window width/height in pixels
        window_dims = 20;
        threshold = 20; 
        axn = 1;
        
        % Round current point values to integer values
        cp = round(cp);

        % Grab the current image from axes
        kids = get(h(axn+39),'Children');
        imagedata = get(kids(end),'CData');
        [m,n] = size(imagedata);
   
        % Determine window edge coordinates centered about current point -- (cp) 
        left   = cp(1,1) - window_dims;
        if left < 1
            left = 1;
        end

        right  = cp(1,1) + window_dims;
        if right > n
            right = n;
        end

        bottom = cp(1,2) - window_dims;
        if bottom < 1
            bottom = 1;
        end
        
        top    = cp(1,2) + window_dims;
        if top > m
            top = m;
        end
       
        % Extract window from the image 
        window_box = imagedata(bottom:top, left:right);
        
        window_box=double(window_box(:,:,1)); % convert from uint8 to double
        % detrend the roibase to try and remove any image-wide edges
        window_box=rot90(detrend(rot90(detrend(window_box))),-1);        
        
        % invert image and stretch its grayscale to the extremes
        window_box = imcomplement(window_box);
        
        % detrend the roibase to try and remove any image-wide edges
        window_box=rot90(detrend(rot90(detrend(window_box))),-1);
        
        window_box = imadjust(window_box,stretchlim(window_box));
          
        [m,n] = size(window_box);

        bw = im2bw(window_box,0.4);
        [height,width] = size(bw);
        mask = poly2mask([3 m-3 m-3  3],[3 3 n-3 n-3],m,n);
        bw = bw.*mask;
%         figure, imshow(imresize(flipud(bw),10))
%         figure, imshow(imresize(flipud(window_box),10))
                
        % Count number of objects in image
        [labels num] = bwlabel(bw,4);
       
        % If there are multiple objects in the window, choose the object 
        % that is closest to the user mouse click as the marker
        if num > 1 
            markerdata = regionprops(labels,'basic');
            r_dist = zeros(num,1);
                for i = 1:num
                    dist = markerdata(i).Centroid;
                    r_dist(i) = sqrt((dist(1)-1+left-cp(1,1))^2 + (dist(2)-1+bottom-cp(1,2))^2);
                end
            [min_value min_index] = min(r_dist);
            bw = ismember(labels,min_index);
        end
               
               
        % Extract intensity data
        window_box = uint8(window_box).*uint8(bw);
%         figure, imshow(imresize(flipud(window_box),10))
        
        % Calculate the -centroid location 
        A = sum(sum(window_box));       % Total pixel intensity of marker
        
        x_temp = 0;
        y_temp = 0;
        
        for i = 1:n
            x_temp = x_temp + i*sum(window_box(:,i));
        end

        for j = 1:m
            y_temp = y_temp + j*sum(window_box(j,:));
        end 
        
        xc = x_temp/A;
        yc = y_temp/A;
        
        % Update current point location
        cp(1,1) = xc - 1 + left;
        cp(1,2) = yc - 1 + bottom;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [uda]=DLTautotrack2fun(uda,h,keyadvance,axn,cp,fr,sp)

% DLTautotrack2.m function
%
% This function handles the auto-tracking (both semi and auto mode)
% functions for the DLTcalibration5X.m
%
% Inputs:
%   uda = userdata structure
%   h = handles structure
%   keyadvance = whether or not the function was initiated by a key press
%   axn = axis number of the video in question
%   cp = [x,y] coordinates for the current point
%   fr = # of the current frame
%   sp = # of the selected point (for multi-point tracking)
%
% Version 1, Ty Hedrick, 8/1/04
% Version 2, Ty Hedrick, 9/27/2005

% get/set basic variables
frmax=get(h(5),'Max');
psize=round(str2num(get(h(38),'String'))); % search area size
thold=str2num(get(h(39),'String')); % threshold
if axn>1
  offset=str2num(get(h(axn+13),'String')); % video stream offset
else
  offset=0;
end
tag=get(h(axn+39),'Tag'); % tag holds the movie filename

% set more variables within the loop
kids=get(h(axn+39),'Children'); % children of current axis
imdat=get(kids(end),'CData'); % read current image
x=round(cp(1,1)); % get an integer X point
y=round(cp(1,2)); % get an integer Y point

% determine the base area around the mouse click to
% grab for comparison to the next frame
tcommand='roibase=imdat(y-psize:y+psize,x-psize:x+psize);';
eval(tcommand,'roibase=NaN;'); % if tcommand fails just set roi to NaN

% main auto-tracking loop
while fr < frmax-offset & isnan(cp(1))==0

  % quit if we've been turned off in the user interface
  if get(h(35),'Value')==1
    return
  end

  % load and process the next frame
%  mov=aviread(tag,fr+1+offset); % avi frame data structure
%  imdat=flipud(mov.cdata(:,:,1)); % grab and process the image data
  [pathstr,pName,fExt] = fileparts(tag);
  [im] = getNextFrame(fExt,pathstr,pName,fr+offset);
  imdat = flipud(im);
  % call the prediction function - it will use the other digitized point
  % locations to try and predict the location of the next point
  otherpts=uda.xypts(:,axn*2-1:axn*2,sp);
  [x,y]=AutoTrackPredictor(otherpts,fr);

  % constrain x & y to fit within imdat
  if x>size(imdat,2) | x<1
    x=round(otherpts(fr,1));
  end
  if y>size(imdat,1) | y<1
    y=round(otherpts(fr,2));
  end

  % search for a matching image in the next frame using the predicted x
  % & y coordinates
  gammaS=get(h(13),'Value');
  tcommand='[xnew,ynew,fitt]=regionID4(double(roibase),[x,y],double(imdat),gammaS);';
  eval(tcommand,'fitt=-1;'); % set fit to -1 if this command fails

  set(h(27),'String',['Autotrack fit: ',num2str(fitt)]);

  % decide whether the fit is good enough to continue auto-tracking
  if fitt < thold | isnan(fitt)
    set(h(5),'Value',fr+1); % advance a frame anyway
    DLTcalibration5X(1,uda); % call self for video refresh
    cp=uda.xypts(fr+1,axn*2-1:axn*2,sp); % get the point for the current frame
    [success]=updateSmallPlot(uda,h,axn,sp,fr,cp); % zoomed window refresh
    return; % fit not good enough, return to main program
  else
    fr=fr+1; % increment to the next frame
    set(h(5),'Value',fr); % update the slider
    cp=[xnew,ynew]; % update currentpoint

    % update uda.xypts
    uda.xypts(fr,axn*2-1,sp)=cp(1,1); % set x point
    uda.xypts(fr,axn*2,sp)=cp(1,2); % set y point
    uda.offset(fr,axn)=offset; % set offset

    % Shift the image display area to follow the point if we've tracked it
    % out of the screen
    axisdata=get(uda.handles(axn+39));
    % X axis
    if cp(1)>axisdata.XLim(2)     % right of current xlim
      delta=cp(1)-axisdata.XLim(2)+10;
      axisdata.XLim(2)=axisdata.XLim(2)+delta;
      axisdata.XLim(1)=axisdata.XLim(1)+delta;
      set(uda.handles(axn+39),'XLim',axisdata.XLim);
    elseif cp(1)<axisdata.XLim(1) % left of current xlim
      delta=cp(1)-axisdata.XLim(1)-10;
      axisdata.XLim(2)=axisdata.XLim(2)+delta;
      axisdata.XLim(1)=axisdata.XLim(1)+delta;
      set(uda.handles(axn+39),'XLim',axisdata.XLim);
    end
    % Y axis
    if cp(2)>axisdata.YLim(2)     % above of current ylim
      delta=cp(2)-axisdata.YLim(2)+10;
      axisdata.YLim(2)=axisdata.YLim(2)+delta;
      axisdata.YLim(1)=axisdata.YLim(1)+delta;
      set(uda.handles(axn+39),'YLim',axisdata.YLim);
    elseif cp(2)<axisdata.YLim(1) % below of current ylim
      delta=cp(2)-axisdata.YLim(1)-10;
      axisdata.YLim(1)=axisdata.YLim(1)+delta;
      axisdata.YLim(2)=axisdata.YLim(2)+delta;
      set(uda.handles(axn+39),'YLim',axisdata.YLim);
    end

    % DLT update
    if sum(isnan(uda.xypts(fr,:,sp))-1)<=-4 & uda.dlt==1 % 2 or more xy pts
      dltout=reconfu(uda.dltcoef,uda.xypts(fr,:,sp)); % DLT reconstruction
      uda.dltpts(fr,1:3,sp)=dltout(1:3); % get the DLT points
      uda.dltres(fr,1,sp)=dltout(4); % get the DLT residual
    else
      uda.dltpts(fr,1:3,sp)=NaN; % set DLT points to NaN
      uda.dltres(fr,1,sp)=NaN; % set DLT residuals to NaN
    end

    set(h(1),'Userdata',uda); % pass back complete user data

    if get(h(36),'Value')==1 % semiauto mode
      if keyadvance==0 %click advance in semiauto mode
        DLTcalibration5X(1,uda); % call self for video refresh
        [success]=updateSmallPlot(uda,h,axn,sp,fr,cp);
      else % advance via 'f' key
        % do nothing
      end
      return % semi-auto mode returns after one pass
    else
      DLTcalibration5X(1,uda); % call self for video refresh
    end

    pause(.01); % let the computer draw the figure
  end

end % end of main auto-track "while" loop


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [x,y,fit]=regionID4(prevRegion,prevXY,newData,gammaS)

% function [x,y,fit]=regionID4(prevRegion,prevXY,newData,gammaS)
%
% A cross-correlation based generalized image tracking program.
%
% Version history:
% 1.0 - Ty Hedrick, 3/5/2002 - initial release version
% 2.0 - Ty Hedrick, 10/02/2002 - updated to use the 2d correlation coefficient
% 3.0 - Ty Hedrick, 07/13/2004 - updated to use fft based cross-correlation
% 4.0 - Ty Hedrick, 12/10/2005 - updated to scale the image data by the
% gamma value specified in the UI and used to display the images

% gray-scale color map scaled by the gamma
cmap=[0:1/63:64].^gammaS;

% set some other preliminary variables
xy=prevXY; % base level xy
ssize=floor(size(prevRegion,1)/2); % search area deviation
Nfft=size(prevRegion,1)*2; % FFT cross-correlation output size

% grab a block of data from the newData image
eval('chunk=newData(xy(2)-ssize:xy(2)+ssize,xy(1)-ssize:xy(1)+ssize);', ...
  'chunk=NaN;');

% minimum value in newData
minND=min(min(newData));

% maximum value in newData
maxND=max(max(newData));

% scale the prevRegion and chunk images to 64 grays
prevRegion=prevRegion-minND;
chunk=chunk-minND;
prevRegion=prevRegion.*(63/maxND)+1;
chunk=chunk.*(63/maxND)+1;

% apply the gamma to the prevRegion
prevRegion=cmap(round(prevRegion));

% apply the gamma to the chunk
chunk=cmap(round(chunk));

% calculate the cross-correlation matrix
eval('fftout=cross_correlate(double(chunk),double(prevRegion),Nfft);', ...
  'fftout=(ones(Nfft,Nfft));');

% get the location of the peak
[I,J]=find(fftout==max(fftout(:)));

% do sub-pixel interpolation
[I,J] = sub_pixel_velocity(fftout,I,J);

% place in world coordinates
x=xy(1)+J-(Nfft/2);
y=xy(2)+I-(Nfft/2);

% give signal-to-noise ratio as fit
fit=max(fftout(:))/(mean2(abs(fftout))+0.1);

% set fit to -1 if it is a NaN
if isnan(fit)==1
  fit=-1;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [c] = cross_correlate(a2,b2,Nfft)
% CROSS_CORRELATE - calculates the cross-correlation
% matrix of two interrogation areas: 'a2' and 'b2' using
% IFFT(FFT.*Conj(FFT)) method.
% Modified version of 'xcorrf.m' function from ftp.mathworks.com
% site.
% Authors: Alex Liberzon & Roi Gurka
%
% Modified by Ty Hedrick for use in the auto-tracking digitizer

c = zeros(Nfft,Nfft);
% Remove Mean Intensity from each image
a2 = a2 - mean2(a2);
b2 = b2 - mean2(b2);
% Rotate the second image ( = conjugate FFT)
b2 = b2(end:-1:1,end:-1:1);
% FFT of both:
ffta=fft2(a2,Nfft,Nfft);
fftb=fft2(b2,Nfft,Nfft);
% Real part of an Inverse FFT of a conjugate multiplication:
c = real(ifft2(ffta.*fftb));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [peakx,peaky] = sub_pixel_velocity(c,pixi,pixj)
% SUB_PIXEL_VELOCITY - Calculates Signal-To-Noise Ratio, fits Gaussian
% bell, find sub-pixel displacement and scales it to the real velocity
% according the the time interval and real-world-to-image-scale.
%
% Authors: Alex Liberzon & Roi Gurka
% Date: Jul-20-99
% Last Modified:
%
% Modified by Ty Hedrick for use in the auto-tracking digitizer
% May 8, 2006

% Alex, 29.10.2004, for empty windows
if max(c(:)) < 1e-3
  peakx = NaN;
  peaky = NaN;
  return
end

% Sub-pixel displacement definition by means of
% Gaussian bell.
f0 = log(c(pixi,pixj));
f1 = log(c(pixi-1,pixj));
f2 = log(c(pixi+1,pixj));
peakx = pixi+ (f1-f2)/(2*f1-4*f0+2*f2);
f0 = log(c(pixi,pixj));
f1 = log(c(pixi,pixj-1));
f2 = log(c(pixi,pixj+1));
peaky = pixj+ (f1-f2)/(2*f1-4*f0+2*f2);

if ~isreal(peakx) | ~isreal(peaky)
  peakx = NaN;
  peaky = NaN;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function y = mean2(x)
%   mean2 Compute mean of matrix elements.
%   B = mean2(A) computes the mean of the values in the 2D matrix A.

y = sum(x(:))/prod(size(x));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [x,y]=AutoTrackPredictor(otherpts,fr)

% function [x,y]=AutoTrackPredictor(otherpts,fr)
%
% This function attempts to predict the [x,y] coordinates of the point in
% frame fr+1 based on it's location at other times.  This basic
% implementation returns the current location if no other points are
% available, does a linear interpolation if two points are available, and
% fits a 2nd order polynomial in other cases.  All fits are based on prior
% points only.  More advanced or situation-specific algorithms could be
% implemented here as desired.

x=otherpts(fr,1);
y=otherpts(fr,2);

% predictor functions
if fr<=1 % first frame, assume no prior data
  prevpts=otherpts(fr,:);
elseif fr==2 % 2nd frame, assume limited prior data
  prevpts=otherpts(fr-1:fr,:);
else % 3rd or greater frame, plenty of data, fit a 2nd order polynomial
  prevpts=otherpts(fr-2:fr,:);
end
idx=find(isnan(prevpts(:,1))==1);
prevpts(idx,:)=[];
pDeg=size(prevpts,1)-1;
p=polyfit([1:size(prevpts,1)]',prevpts(:,1),pDeg);
x=round(polyval(p,4));
p=polyfit([1:size(prevpts,1)]',prevpts(:,2),pDeg);
y=round(polyval(p,4));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [xy] = invdlt(A,XYZ)
% function [xy] = invdlt(A,XYZ)
% Description:	This program calculates the local (camera) xy coordinates
%		of a known point XYZ in space using the known DLT coefficients
%		of that specific camera.
%		This program can for instance be used to plot finite helical
%               axes into stereo x-rays. (similar procedure to Blankevoort
%		et al. (1990), J.Biomechanics 21, 705-720)
% Input:	- A:	11 DLT coefficients. A has to be 11x1 in size.
%		- XYZ:  three dimensional coordinates of point in space
%			XYZ can have several rows (different time/points)
%			XYZ must have 3 columns: X,Y,Z
% Output:	- xy:	camera coordinates ([x,y])
%			xy will have the same number of rows as XYZ
% Author:	Christoph Reinschmidt, HPL, The University of Calgary
% Date:		November, 1996
% Last changes: November 29, 1996
% Version:	1.0
% References:	e.g.: Nigg and Herzog (1995) Biomechanics of the musculo-
%		      skeletal system. Wiley and Son., p. 265.


% CHECKING PROPER SIZE OF INPUT MATRICES
if size(XYZ,2)~=3,
  disp('Try again! Your input matrix XYZ did not contain enough columns'),
  return
end

[s1,s2]=size(A);
if s1~=11 | s2~=1
  disp('Try again! Your input DLT matrix does not have the right size'), return
end

% RENAMING
X=XYZ(:,1); Y=XYZ(:,2); Z=XYZ(:,3);
for i=1:11, eval(['a' num2str(i) '=A(i,1);']), end

% Calculating the local coordinates.
x=(X.*a1+Y.*a2+Z.*a3+a4)./(X.*a9+Y.*a10+Z.*a11+1);
y=(X.*a5+Y.*a6+Z.*a7+a8)./(X.*a9+Y.*a10+Z.*a11+1);

xy=[x,y];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [H] = reconfu(A,L)
%function [H] = reconfu(A,L)
% Description:	Reconstruction of 3D coordinates with the use local (camera
%		coordinates and the DLT coefficients for the n cameras).
% Input:	- A  file containing DLT coefficients of the n cameras
%		     [a1cam1,a1cam2...;a2cam1...]
%		- L  camera coordinates of points
%		     [xcam1,ycam1,xcam2,ycam2...;same at time 2]
% Output:	- H  global coordinates, residuals, cameras used
%		     [Xt1,Yt1,Zt1,residt1,cams_used@t1...; same for t2]
% Author:	Christoph Reinschmidt, HPL, The University of Calgary
% Date:		September, 1994
% Last change:  November 29, 1996
% Version:	1.1

n=size(A,2);
% check whether the numbers of cameras agree for A and L
%if 2*n~=size(L,2); disp('the # of cameras given in A and L do not agree')
%                   disp('hit any key and then "try" again'); pause; return
%end


H(size(L,1),5)=[0];         % initialize H

% ________Building L1, L2:       L1 * G (X,Y,Z) = L2________________________

for k=1:size(L,1)  %number of time points
  q=[0]; L1=[]; L2=[];  % initialize L1,L2, q(counter of 'valid' cameras)
  for  i=1:n       %number of cameras
    x=L(k,2*i-1); y=L(k,2*i);
    if ~(isnan(x) | isnan(y))  % do not construct l1,l2 if camx,y=NaN
      q=q+1;
      L1([q*2-1:q*2],:)=[A(1,i)-x*A(9,i), A(2,i)-x*A(10,i), A(3,i)-x*A(11,i); ...
        A(5,i)-y*A(9,i), A(6,i)-y*A(10,i), A(7,i)-y*A(11,i)];
      L2([q*2-1:q*2],:)=[x-A(4,i);y-A(8,i)];
    end
  end

  if (size(L2,1)/2)>1  %check whether enough cameras available (at least 2)
    g=L1\L2; h=L1*g; DOF=(size(L2,1)-3);
    avgres=sqrt(sum([L2-h].^2)/DOF);
  else
    g=[NaN;NaN;NaN]; avgres=[NaN];
  end

  %find out which cameras were used for the 3d reconstruction
  b=fliplr(find(sum(reshape(isnan(L(k,:)),2,size(L(k,:),2)/2))==0));
  if size(b,2)<2; camsused=[NaN];
  else,    for w=1:size(b,2), b(1,w)=b(1,w)*10^(w-1); end
    camsused=sum(b');
  end

  H(k,:)=[g',avgres,camsused];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [success]=quickRedraw(uda,h,sp,fr)

cfh=gcf; % handle to current figure
success=0; % output status

% loop through each axes and update it
for i=1:uda.cNum
  % make the video figure active
  figure(h(2));

  % make the axis of interest active
  set(h(2),'CurrentAxes',h(40));
  xl=xlim;
  yl=ylim;

  % get the kids & delete everything but the image
  kids=get(h(40),'Children');
  if length(kids)>1
    delete(kids(1:end-1)); % assume the bottom of the stack is the image
  end

  % plot any XY points (selected point)

  if isnan(uda.xypts(i*2,sp))==0
    plot(uda.xypts((i)*2-1,sp),uda.xypts(i*2,sp),'ro', ...
      'HitTest','off');
  end

%   % get the user settings for plotting the extended DLT information
%   dltvf=get(h(53),'Value');
% 
%   % plot any DLT points (selected point) if desired
%   if isnan(uda.dltpts(fr,1,sp))==0 & dltvf==1
%     xy=invdlt(uda.dltcoef(:,i),uda.dltpts(fr,:,sp));
%     plot(xy(1),xy(2),'gd','HitTest','off');
%   end

%   % if no XY points & no DLT points plot partialDLT line if possible
%   % & desired
%   if isnan(uda.xypts(fr,i*2,sp)) & isnan(uda.dltpts(fr,1,sp)) ...
%       & sum(isnan(uda.xypts(fr,:,sp))-1)==-2 & uda.dlt==1 & dltvf==1
% 
%     idx=find(isnan(uda.xypts(fr,:,sp))==0);
%     dltcoef1=uda.dltcoef(:,idx(2)/2);
%     dltcoef2=uda.dltcoef(:,i);
%     u=uda.xypts(fr,idx(1),sp);
%     v=uda.xypts(fr,idx(2),sp);
%     [m,b]=partialdlt(u,v,dltcoef1,dltcoef2);
%     xpts=xl';
%     ypts=m.*xpts+b;
%     plot(xpts,ypts,'b-','HitTest','off');


  % plot non-selected points
  if uda.numpts>1
    ptarray=[1:uda.numpts]; % array of all the points
    ptarray(sp)=[]; % remove the selected point
    % XY
    xyPts=shiftdim(uda.xypts(fr,i*2-1:i*2,ptarray))';
    xyPts(find(isnan(xyPts(:,1))==1),:)=[];
    plot(xyPts(:,1),xyPts(:,2),'co','HitTest','off');

    % XYZ
    if uda.dlt
      xyzPts=shiftdim(uda.dltpts(fr,:,ptarray))';
      xyzPts(find(isnan(xyzPts(:,1))==1),:)=[];
      xyPts=invdlt(uda.dltcoef(:,i),xyzPts);
      plot(xyPts(:,1),xyPts(:,2),'cd','HitTest','off');
    end
  end

end % end for loop through the video axes

% restore the pre-existing top figure
figure(cfh);

% set output status
success=1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function iHold(ax,state)

% ihold(axis,state)
%
% Limited version of hold that supports only two inputs, works with both
% MATLAB 6.5 & 7.X

v=version;
vnum=str2num(v(1:3));

fig = get(ax,'Parent');
if ~strcmp(get(fig,'Type'),'figure')
  fig = ancestor(fig,'figure');
end

if(strcmp(state, 'on'))
  set(fig,'NextPlot','add');
  set(ax,'NextPlot','add');
  if vnum>=7, setappdata(ax,'PlotHoldStyle',false);, end
elseif(strcmp(state, 'off'))
  set(fig,'NextPlot','replace');
  set(ax,'NextPlot','replace');
  if vnum>=7, setappdata(ax,'PlotHoldStyle',false);, end
else
  error('iHold: Unknown command option.');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function iPlot(varargin)

% iplot(axis,plot_arguments)
%
% A dummy function to transparently support plot(axis,...) formulations for
% MATLAB 6.X

v=version;
vnum=str2num(v(1:3));

if(vnum<7)
  currentAxis=gca;
  axes(varargin{1});
  plot(varargin{2:end});
  axes(currentAxis);
  pause(.01); % avoid MATLAB 6.X race between function & figure...
else
  plot(varargin{:});
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% replace with call to new, external calimread function 2010 Nov 22 LJR
%function [image]=calimread(fpathname)

% function [image]=calimread(fpathname)
%
% Reads and returns a calibration image

% check the file extension
%if strcmp('avi',lower(fpathname(end-2:end)))
%  mov=aviread(fpathname,1);
%  image=mov.cdata(:,:,1);
%else
%  image=imread(fpathname);
%  image=image(:,:,1);
%end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [A,avgres,rawres] = dltfu(F,L,Cut)
% Description:	Program to calculate DLT coefficient for one camera
%               Note that at least 6 (valid) calibration points are needed
%               function [A,avgres] = dltfu(F,L,Cut)
% Input:	- F      matrix containing the global coordinates (X,Y,Z)
%                        of the calibration frame
%			 e.g.: [0 0 20;0 0 50;0 0 100;0 60 20 ...]
%		- L      matrix containing 2d coordinates of calibration 
%                        points seen in camera (same sequence as in F)
%                        e.g.: [1200 1040; 1200 1360; ...]
%               - Cut    points that are not visible in camera;
%                        not being used to calculate DLT coefficient
%                        e.g.: [1 7] -> calibration point 1 and 7 
%			 will be discarded.
%		      	 This input is optional (default Cut=[]) 
% Output:	- A      11 DLT coefficients
%               - avgres average residuals (measure for fit of dlt)
%			 given in units of camera coordinates
%
% Author:	Christoph Reinschmidt, HPL, The University of Calgary
% Date:		January, 1994
% Last changes: November 29, 1996
% 		July 7, 2000 - Ty Hedick - NaN points automatically
%                 added to cut.
%		August 8, 2000 - Ty Hedrick - added raw_res output
% Version:	1.1
% References:	Woltring and Huiskes (1990) Stereophotogrammetry. In
%               Biomechanics of Human Movement (Edited by Berme and
%               Cappozzo). pp. 108-127.

if nargin==2; Cut=[]; end;

if size(F,1) ~= size(L,1)
disp('# of calibration points entered and seen in camera do not agree'), return
end

% find the NaN points and add them to the cut matrix
for i=1:size(L,1)
  if isnan(L(i,1))==1
    Cut(1,size(Cut,2)+1)=i;
  end
end

m=size(F,1); Lt=L'; C=Lt(:);

for i=1:m
  B(2*i-1,1)  = F(i,1); 
  B(2*i-1,2)  = F(i,2); 
  B(2*i-1,3)  = F(i,3);
  B(2*i-1,4)  = 1;
  B(2*i-1,9)  =-F(i,1)*L(i,1);
  B(2*i-1,10) =-F(i,2)*L(i,1);
  B(2*i-1,11) =-F(i,3)*L(i,1);
  B(2*i,5)    = F(i,1);
  B(2*i,6)    = F(i,2);
  B(2*i,7)    = F(i,3);
  B(2*i,8)    = 1;
  B(2*i,9)  =-F(i,1)*L(i,2);
  B(2*i,10) =-F(i,2)*L(i,2);
  B(2*i,11) =-F(i,3)*L(i,2);
end

% Cut the lines out of B and C including the control points to be discarded
Cutlines=[Cut.*2-1, Cut.*2];
B([Cutlines],:)=[];
C([Cutlines],:)=[];

% Solution for the coefficients
A=B\C; % note that \ is a left matrix divide
D=B*A;
R=C-D;
res=norm(R); avgres=res/size(R,1)^0.5;
rawres=R;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [A,avgres,rawres] = dltfu16(F,L,cc)

% function [A,avgres,rawres] = dltfu16(F,L,cc)
% 
% Description:	Program to calculate DLT coefficient for one camera
%               Note that at least 6 (valid) calibration points are needed
%               function [A,avgres] = dltfu(F,L,Cut)
%
% Input:	- F   matrix containing the global coordinates (X,Y,Z)
%               of the calibration frame
%               e.g.: [0 0 20;0 0 50;0 0 100;0 60 20 ...]
%         - L   matrix containing 2d coordinates of calibration 
%               points seen in camera (same sequence as in F)
%               e.g.: [1200 1040; 1200 1360; ...]
%         - cc  Image center coordinates (in pixels)
%		      	  
% Output:	- A   16 DLT coefficients
%         - avgres Average residuals (measure for fit of dlt)
%           given in units of camera coordinates (pixels)
%         - rawres Raw residuals
%
% Author:	Christoph Reinschmidt, HPL, The University of Calgary
% Date:		January, 1994
% Last changes: November 29, 1996
% 		July 7, 2000 - Ty Hedick - NaN points automatically
%                 added to cut.
%		August 8, 2000 - Ty Hedrick - added raw_res output
% Version:	1.1
% References:	Woltring and Huiskes (1990) Stereophotogrammetry. In
%               Biomechanics of Human Movement (Edited by Berme and
%               Cappozzo). pp. 108-127.

if nargin==3; Cut=[]; end;

if size(F,1) ~= size(L,1)
disp('# of calibration points entered and seen in camera do not agree'), return
end

% find the NaN points and add them to the cut matrix
for i=1:size(L,1)
  if isnan(L(i,1))==1
    Cut(1,size(Cut,2)+1)=i;
  end
end

m=size(F,1); Lt=L'; C=Lt(:);

for i=1:m
  g=L(i,1)-cc(1);
  n=L(i,2)-cc(2);
  r=(g^2+n^2)^.5;
  
  B(2*i-1,1)  = F(i,1); 
  B(2*i-1,2)  = F(i,2); 
  B(2*i-1,3)  = F(i,3);
  B(2*i-1,4)  = 1;
  B(2*i-1,9)  =-F(i,1)*L(i,1);
  B(2*i-1,10) =-F(i,2)*L(i,1);
  B(2*i-1,11) =-F(i,3)*L(i,1);
  B(2*i-1,12) = g*r^2;
  B(2*i-1,13) = g*r^4;
  B(2*i-1,14) = g*r^6;
  B(2*i-1,15) = (r^2+2*g^2);
  B(2*i-1,16) = g*n;
  B(2*i,5)    = F(i,1);
  B(2*i,6)    = F(i,2);
  B(2*i,7)    = F(i,3);
  B(2*i,8)    = 1;
  B(2*i,9)  =-F(i,1)*L(i,2);
  B(2*i,10) =-F(i,2)*L(i,2);
  B(2*i,11) =-F(i,3)*L(i,2);
  B(2*i,12) = n*r^2;
  B(2*i,13) = n*r^4;
  B(2*i,14) = n*r^6;
  B(2*i,15) = g*n;
  B(2*i,16) = (r^2+2*n^2);
end

% Cut the lines out of B and C including the control points to be discarded
Cutlines=[Cut.*2-1, Cut.*2];
B([Cutlines],:)=[];
C([Cutlines],:)=[];

% Solution for the coefficients
A=B\C; % note that \ is a left matrix divide
D=B*A;
R=C-D;
res=norm(R); avgres=res/size(R,1)^0.5;
rawres=R;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [mcam] = mayaCamspec(coefs,imageWidth,imageHeight)

m1=[coefs(1),coefs(2),coefs(3);coefs(5),coefs(6),coefs(7); ...
    coefs(9),coefs(10),coefs(11)];
m2=[-coefs(4);-coefs(8);-1];

xyz=inv(m1)*m2;

D=(1/(coefs(9)^2+coefs(10)^2+coefs(11)^2))^0.5;
D=D(1); % + solution

Uo=(D^2)*(coefs(1)*coefs(9)+coefs(2)*coefs(10)+coefs(3)*coefs(11));
Vo=(D^2)*(coefs(5)*coefs(9)+coefs(6)*coefs(10)+coefs(7)*coefs(11));

du = (((Uo*coefs(9)-coefs(1))^2 + (Uo*coefs(10)-coefs(2))^2 + (Uo*coefs(11)-coefs(3))^2)*D^2)^0.5;
dv = (((Vo*coefs(9)-coefs(5))^2 + (Vo*coefs(10)-coefs(6))^2 + (Vo*coefs(11)-coefs(7))^2)*D^2)^0.5;

du=du(1); % + values
dv=dv(1);
Z=-1*mean([du,dv]); % there should be only a tiny difference between du & dv

T3=D*[(Uo*coefs(9)-coefs(1))/du ,(Uo*coefs(10)-coefs(2))/du ,(Uo*coefs(11)-coefs(3))/du ; ...
    (Vo*coefs(9)-coefs(5))/dv ,(Vo*coefs(10)-coefs(6))/dv ,(Vo*coefs(11)-coefs(7))/dv ; ...
    coefs(9) , coefs(10), coefs(11)];

dT3=det(T3);

if dT3 < 0
    T3=-1*T3;
end

T=inv(T3);
T(:,4)=[0;0;0];
T(4,:)=[xyz(1),xyz(2),xyz(3),1];

% compute YPR from T3
%
% Note that the axes of the DLT based transformation matrix are rarely
% orthogonal, so these angles are only an approximation of the correct
% transformation matrix
alpha=atan2(T(2,1),T(1,1));
beta=atan2(-T(3,1), (T(3,2)^2+T(3,3)^2)^0.5);
gamma=atan2(T(3,2),T(3,3));

% check for orthogonal transforms by back-calculating one of the matrix
% elements. This step should be unecessary since mdlt1 is forcing
% orthogonality
if abs(cos(alpha)*cos(beta)-T(1,1)) > 1e-8
    disp('Warning - the transformation matrix represents transformation about')
    disp('non-orthogonal axes and cannot be represented as a roll, pitch & yaw')
    disp('series with 100% accuracy.')
end

ypr= (180/pi) * [gamma,beta,alpha]; % rad2deg replaced with constant --LJR
                                    % June 4, 2010.
scale = .1;

planeX = ((imageWidth)/2 - Uo)*scale;
planeY = ((imageHeight)/2 - Vo)*scale;
planeZ = scale*Z;


mcam = [xyz'; ypr; planeX,planeY,planeZ; Uo,Vo,Z; scale,imageWidth,imageHeight];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [b,avgres]=mdlt1(pk,sk)

% function [b,avgres]=mdlt1(pk,sk)
%
%Input:		pk-matrix containing global coordinates (X,Y,Z) of the ith point
%				e.g. pk(i,1), pk(i,2), pk(i,3)
%				sk-matrix containing image coordinates (u,v) of the ith point
%    			e.g. sk(i,1), sk(i,2)
%Output:		sets of 11 DLT parameters for all iterations
%				The code is far from being optimal and many improvements are to come.
%
%Author: 	Tomislav Pribanic, University of Zagreb, Croatia
%e-mail:		Tomislav.Pribanic@zesoi.fer.hr
%				Any comments and suggestions would be more than welcome.
%Date:		September 1999
%Version: 	1.0
%
%Function uses MDLT method adding non-linear constraint:
%(L1*L5+L2*L6+L3*L7)*(L9^2+L10^2+L11^2)=(L1*L9+L2*L10+L3*L11)*(L5*L9+L6*L10+L7*L11) (1)
%(assuring orthogonality of transformation matrix and eliminating redundant parametar) to the
%linear system of DLT represented by basic DLT equations:
%							u=(L1*X+L2*Y+L3*Z+L4)/(L9*X+L10*Y+L11*Z+1);	(2)
%							v=(L5*X+L6*Y+L7*Z+L8)/(L9*X+L10*Y+L11*Z+1);	(3).
%(u,v)	image coordinates in digitizer units
%L1...L11 	DLT parameters
%(X,Y,Z)	object space coordinates
%Once the non-linear equation (1) was solved for the L1 parameter, it was substituted
% for L1 in the equation (2) and now only 10 DLT parameters appear.
%
%The obtained non-linear system was solved with the following algorithm (Newton's method):
%equations u=f(L2-L11) (2) and v=g(L2-L11) (3) were expressed using truncated Taylor
%series expansion (up to the first derivative) resulting again with 
%the set of linearized equations (for particular point we have):
%	u=fo+pd(fo)/pd(L2)*d(L2)+...+pd(fo)/pd(L11)*d(L11)		(4)
%	v=go+pd(go)/pd(L2)*d(L2)+...+pd(go)/pd(L11)*d(L11)		(5)
%pd- partial derivative
%d-differential
%fo, go, pd(fo)/pd(L2)...pd(fo)/pd(L11)*d(L11) and  pd(go)/pd(L2)...pd(go)/pd(L11) are
%current estimates acquired by previous iteration.
%Initial estimates are provided by conventional 11 DLT parameter method.
%
%Therefore standard linear least square technique can be applied to calculate d(L2)...d(L11)
%elements.
%Each element is in fact d(Li)=Li(current iteration)-Li(previous iteration, known from before).
%Li's of current iteration can be than substituted for a new estimates in (4) and (5) until
%all elements of d(Li's) are satisfactory small.

%REFERENCES:

%1. The paper explains linear and non-linear MDLT.
%	 The function reflects only the linear MDLT (no symmetrical or
%	 asymmetrical lens distortion parameters included).

%   Hatze H. HIGH-PRECISION THREE-DIMENSIONAL PHOTOGRAMMETRIC CALIBRATION
%   AND OBJECT SPACE RECONSTRUCTION USING A MODIFIED DLT-APPROACH.
%   J. Biomechanics, 1988, 21, 533-538

%2. The paper shows the particular mathematical linearization technique for 
%	 solving non-linear nature of equations due to adding non-linear constrain.

%	 Miller N. R., Shapiro R., and McLaughlin T. M. A TECHNIQUE FOR OBTAINING
%	 SPATIAL KINEMATIC PARAMETERS OF SEGMENTS OF BIOMECHANICAL SYSTEMS 
%	 FROM CINEMATOGRAPHIC DATA. J. Biomechanics, 1980, 13, 535-547




%Input:		pk-matrix containing global coordinates (X,Y,Z) of the ith point
%				e.g. pk(i,1), pk(i,2), pk(i,3)
%				sk-matrix containing image coordinates (u,v) of the ith point
%    			e.g. sk(i,1), sk(i,2)
%Output:		sets of 11 DLT parameters for all iterations
%				The code is far from being optimal and many improvements are to come.

%[a]*[b]=[c]

% automatic removal of NaN points added by Ty Hedrick 9/14/00
Cut=[];
for i=1:size(sk,1)
  if isnan(sk(i,1))==1
    Cut(1,size(Cut,2)+1)=i;
  end
end
%Cutlines=[Cut.*2-1, Cut.*2]
pk([Cut],:)=[];
sk([Cut],:)=[];

m=size(pk,1);	% number of calibration points
c=sk';c=c(:);	% re-grouping image coordinates in one column
ite=10; 			%number of iterations

% Solve 'ortogonality' equation (1) for L1
L1=solve('(L1*L5+L2*L6+L3*L7)*(L9^2+L10^2+L11^2)=(L1*L9+L2*L10+L3*L11)*(L5*L9+L6*L10+L7*L11)','L1');
%initialize basic DLT equations (2) and (3)
u=sym('(L1*X+L2*Y+L3*Z+L4)/(L9*X+L10*Y+L11*Z+1)');
v=sym('(L5*X+L6*Y+L7*Z+L8)/(L9*X+L10*Y+L11*Z+1)');
%elimenate L1 out of equation (2)using the (1)
jed1=[ char(L1) '=L1'];
jed2=[ char(u) '=u'];
[L1,u]=solve( jed1, jed2,'L1,u');

%Find the first partial derivatives of (4) and (5)
%f(1)=diff(u,'L1');g(1)=diff(v,'L1'); 
%L1 was chosen to be eliminated. In case other parameter (for example L2) is chosen
%the above line should become active and the appropriate one passive instead.
f(1)=diff(u,'L2');g(1)=diff(v,'L2');
f(2)=diff(u,'L3');g(2)=diff(v,'L3');
f(3)=diff(u,'L4');g(3)=diff(v,'L4');
f(4)=diff(u,'L5');g(4)=diff(v,'L5');
f(5)=diff(u,'L6');g(5)=diff(v,'L6');
f(6)=diff(u,'L7');g(6)=diff(v,'L7');
f(7)=diff(u,'L8');g(7)=diff(v,'L8');
f(8)=diff(u,'L9');g(8)=diff(v,'L9');
f(9)=diff(u,'L10');g(9)=diff(v,'L10');
f(10)=diff(u,'L11');g(10)=diff(v,'L11');

%Find the inital estimates using conventional DLT method
for i=1:m
   a(2*i-1,1)=pk(i,1);
   a(2*i-1,2)=pk(i,2);
   a(2*i-1,3)=pk(i,3);
   a(2*i-1,4)=1;
   a(2*i-1,9)=-pk(i,1)*sk(i,1);
   a(2*i-1,10)=-pk(i,2)*sk(i,1);
   a(2*i-1,11)=-pk(i,3)*sk(i,1);
   a(2*i,5)=pk(i,1);
   a(2*i,6)=pk(i,2);
   a(2*i,7)=pk(i,3);
   a(2*i,8)=1;
   a(2*i,9)=-pk(i,1)*sk(i,2);
   a(2*i,10)=-pk(i,2)*sk(i,2);
   a(2*i,11)=-pk(i,3)*sk(i,2);
end
%Conventional DLT parameters
b=a\c;
%Take the intial estimates for parameters
%L1=b(1); L1 is excluded.
L2=b(2);L3=b(3);L4=b(4);L5=b(5);L6=b(6);
L7=b(7);L8=b(8);L9=b(9);L10=b(10);L11=b(11);

%Save a for use in generating residuals
a_init=a;
clear a b c

%Perform the linear least square technique on the system of equations made from (4) and (5)
%IMPORTANT NOTE:
%the elements of matrices a and c (see below) are expressions based on (4) and (5) and part
%of program which calculates the partial derivatives (from line %Find the first partial...
%to the line %Find the inital...)
%However the elements itself are computed outside the function since the computation itself
%(for instance via MATLAB eval function: a(2*i-1,1)=eval(f(1));a(2*i-1,2)=eval(f(2)); etc.
%c(2*i-1)=sk(i,1)-eval(u);c(2*i)=sk(i,2)-eval(v);)is only time consuming and unnecessary.
%Thus the mentioned part of the program has only educational/historical purpose and 
%can be excluded for practical purposes

for k=1:ite  %k-th iteartion
   %Form matrices a and c
   for i=1:m	%i-th point
      X=pk(i,1);Y=pk(i,2);Z=pk(i,3);
      %first row of the i-th point; contribution of (4) equation
      a(2*i-1,1)=(-X*L6*L9^2-X*L6*L11^2+X*L10*L5*L9+X*L10*L7*L11+Y*L5*L10^2+Y*L5*L11^2-Y*L9*L6*L10-Y*L9*L7*L11)/(L5*L11^2+L5*L10^2+L9*X*L5*L10^2+L9*X*L5*L11^2-L9^2*X*L6*L10-L9^2*X*L7*L11+L10^3*Y*L5+L10*Y*L5*L11^2-L10^2*Y*L9*L6-L10*Y*L9*L7*L11+L11*Z*L5*L10^2+L11^3*Z*L5-L11*Z*L9*L6*L10-L11^2*Z*L9*L7-L9*L6*L10-L9*L7*L11);
      a(2*i-1,2)=(-X*L7*L9^2-X*L7*L10^2+X*L11*L5*L9+X*L11*L6*L10+Z*L5*L10^2+Z*L5*L11^2-Z*L9*L6*L10-Z*L9*L7*L11)/(L5*L11^2+L5*L10^2+L9*X*L5*L10^2+L9*X*L5*L11^2-L9^2*X*L6*L10-L9^2*X*L7*L11+L10^3*Y*L5+L10*Y*L5*L11^2-L10^2*Y*L9*L6-L10*Y*L9*L7*L11+L11*Z*L5*L10^2+L11^3*Z*L5-L11*Z*L9*L6*L10-L11^2*Z*L9*L7-L9*L6*L10-L9*L7*L11);
      a(2*i-1,3)=(L5*L10^2+L5*L11^2-L9*L6*L10-L9*L7*L11)/(L5*L11^2+L5*L10^2+L9*X*L5*L10^2+L9*X*L5*L11^2-L9^2*X*L6*L10-L9^2*X*L7*L11+L10^3*Y*L5+L10*Y*L5*L11^2-L10^2*Y*L9*L6-L10*Y*L9*L7*L11+L11*Z*L5*L10^2+L11^3*Z*L5-L11*Z*L9*L6*L10-L11^2*Z*L9*L7-L9*L6*L10-L9*L7*L11);
      a(2*i-1,4)=(L4*L10^2+L4*L11^2+X*L2*L10*L9+X*L3*L11*L9+L2*Y*L10^2+L2*Y*L11^2+L3*Z*L10^2+L3*Z*L11^2)/(L5*L11^2+L5*L10^2+L9*X*L5*L10^2+L9*X*L5*L11^2-L9^2*X*L6*L10-L9^2*X*L7*L11+L10^3*Y*L5+L10*Y*L5*L11^2-L10^2*Y*L9*L6-L10*Y*L9*L7*L11+L11*Z*L5*L10^2+L11^3*Z*L5-L11*Z*L9*L6*L10-L11^2*Z*L9*L7-L9*L6*L10-L9*L7*L11)-(L4*L5*L10^2+L4*L5*L11^2-X*L2*L6*L9^2-X*L2*L6*L11^2-X*L3*L7*L9^2-X*L3*L7*L10^2+X*L2*L10*L5*L9+X*L2*L10*L7*L11+X*L3*L11*L5*L9+X*L3*L11*L6*L10+L2*Y*L5*L10^2+L2*Y*L5*L11^2-L2*Y*L9*L6*L10-L2*Y*L9*L7*L11+L3*Z*L5*L10^2+L3*Z*L5*L11^2-L3*Z*L9*L6*L10-L3*Z*L9*L7*L11-L4*L9*L6*L10-L4*L9*L7*L11)/(L5*L11^2+L5*L10^2+L9*X*L5*L10^2+L9*X*L5*L11^2-L9^2*X*L6*L10-L9^2*X*L7*L11+L10^3*Y*L5+L10*Y*L5*L11^2-L10^2*Y*L9*L6-L10*Y*L9*L7*L11+L11*Z*L5*L10^2+L11^3*Z*L5-L11*Z*L9*L6*L10-L11^2*Z*L9*L7-L9*L6*L10-L9*L7*L11)^2*(L11^2+L10^2+L9*X*L10^2+L9*X*L11^2+L10^3*Y+L10*Y*L11^2+L11*Z*L10^2+L11^3*Z);
      a(2*i-1,5)=(-X*L2*L9^2-X*L2*L11^2+X*L3*L11*L10-L2*Y*L9*L10-L3*Z*L9*L10-L4*L9*L10)/(L5*L11^2+L5*L10^2+L9*X*L5*L10^2+L9*X*L5*L11^2-L9^2*X*L6*L10-L9^2*X*L7*L11+L10^3*Y*L5+L10*Y*L5*L11^2-L10^2*Y*L9*L6-L10*Y*L9*L7*L11+L11*Z*L5*L10^2+L11^3*Z*L5-L11*Z*L9*L6*L10-L11^2*Z*L9*L7-L9*L6*L10-L9*L7*L11)-(L4*L5*L10^2+L4*L5*L11^2-X*L2*L6*L9^2-X*L2*L6*L11^2-X*L3*L7*L9^2-X*L3*L7*L10^2+X*L2*L10*L5*L9+X*L2*L10*L7*L11+X*L3*L11*L5*L9+X*L3*L11*L6*L10+L2*Y*L5*L10^2+L2*Y*L5*L11^2-L2*Y*L9*L6*L10-L2*Y*L9*L7*L11+L3*Z*L5*L10^2+L3*Z*L5*L11^2-L3*Z*L9*L6*L10-L3*Z*L9*L7*L11-L4*L9*L6*L10-L4*L9*L7*L11)/(L5*L11^2+L5*L10^2+L9*X*L5*L10^2+L9*X*L5*L11^2-L9^2*X*L6*L10-L9^2*X*L7*L11+L10^3*Y*L5+L10*Y*L5*L11^2-L10^2*Y*L9*L6-L10*Y*L9*L7*L11+L11*Z*L5*L10^2+L11^3*Z*L5-L11*Z*L9*L6*L10-L11^2*Z*L9*L7-L9*L6*L10-L9*L7*L11)^2*(-L9^2*X*L10-L10^2*Y*L9-L11*Z*L9*L10-L9*L10);
      a(2*i-1,6)=(-X*L3*L9^2-X*L3*L10^2+X*L2*L10*L11-L2*Y*L9*L11-L3*Z*L9*L11-L4*L9*L11)/(L5*L11^2+L5*L10^2+L9*X*L5*L10^2+L9*X*L5*L11^2-L9^2*X*L6*L10-L9^2*X*L7*L11+L10^3*Y*L5+L10*Y*L5*L11^2-L10^2*Y*L9*L6-L10*Y*L9*L7*L11+L11*Z*L5*L10^2+L11^3*Z*L5-L11*Z*L9*L6*L10-L11^2*Z*L9*L7-L9*L6*L10-L9*L7*L11)-(L4*L5*L10^2+L4*L5*L11^2-X*L2*L6*L9^2-X*L2*L6*L11^2-X*L3*L7*L9^2-X*L3*L7*L10^2+X*L2*L10*L5*L9+X*L2*L10*L7*L11+X*L3*L11*L5*L9+X*L3*L11*L6*L10+L2*Y*L5*L10^2+L2*Y*L5*L11^2-L2*Y*L9*L6*L10-L2*Y*L9*L7*L11+L3*Z*L5*L10^2+L3*Z*L5*L11^2-L3*Z*L9*L6*L10-L3*Z*L9*L7*L11-L4*L9*L6*L10-L4*L9*L7*L11)/(L5*L11^2+L5*L10^2+L9*X*L5*L10^2+L9*X*L5*L11^2-L9^2*X*L6*L10-L9^2*X*L7*L11+L10^3*Y*L5+L10*Y*L5*L11^2-L10^2*Y*L9*L6-L10*Y*L9*L7*L11+L11*Z*L5*L10^2+L11^3*Z*L5-L11*Z*L9*L6*L10-L11^2*Z*L9*L7-L9*L6*L10-L9*L7*L11)^2*(-L9^2*X*L11-L10*Y*L9*L11-L11^2*Z*L9-L9*L11);
      a(2*i-1,7)=0;
      a(2*i-1,8)=(-2*X*L2*L6*L9-2*X*L3*L7*L9+X*L2*L10*L5+X*L3*L11*L5-L2*Y*L6*L10-L2*Y*L7*L11-L3*Z*L6*L10-L3*Z*L7*L11-L4*L6*L10-L4*L7*L11)/(L5*L11^2+L5*L10^2+L9*X*L5*L10^2+L9*X*L5*L11^2-L9^2*X*L6*L10-L9^2*X*L7*L11+L10^3*Y*L5+L10*Y*L5*L11^2-L10^2*Y*L9*L6-L10*Y*L9*L7*L11+L11*Z*L5*L10^2+L11^3*Z*L5-L11*Z*L9*L6*L10-L11^2*Z*L9*L7-L9*L6*L10-L9*L7*L11)-(L4*L5*L10^2+L4*L5*L11^2-X*L2*L6*L9^2-X*L2*L6*L11^2-X*L3*L7*L9^2-X*L3*L7*L10^2+X*L2*L10*L5*L9+X*L2*L10*L7*L11+X*L3*L11*L5*L9+X*L3*L11*L6*L10+L2*Y*L5*L10^2+L2*Y*L5*L11^2-L2*Y*L9*L6*L10-L2*Y*L9*L7*L11+L3*Z*L5*L10^2+L3*Z*L5*L11^2-L3*Z*L9*L6*L10-L3*Z*L9*L7*L11-L4*L9*L6*L10-L4*L9*L7*L11)/(L5*L11^2+L5*L10^2+L9*X*L5*L10^2+L9*X*L5*L11^2-L9^2*X*L6*L10-L9^2*X*L7*L11+L10^3*Y*L5+L10*Y*L5*L11^2-L10^2*Y*L9*L6-L10*Y*L9*L7*L11+L11*Z*L5*L10^2+L11^3*Z*L5-L11*Z*L9*L6*L10-L11^2*Z*L9*L7-L9*L6*L10-L9*L7*L11)^2*(X*L5*L10^2+X*L5*L11^2-2*L9*X*L6*L10-2*L9*X*L7*L11-L10^2*Y*L6-L10*Y*L7*L11-L11*Z*L6*L10-L11^2*Z*L7-L6*L10-L7*L11);
      a(2*i-1,9)=(2*L4*L5*L10-2*X*L3*L7*L10+X*L2*L5*L9+X*L2*L7*L11+X*L3*L11*L6+2*L2*Y*L5*L10-L2*Y*L9*L6+2*L3*Z*L5*L10-L3*Z*L9*L6-L4*L9*L6)/(L5*L11^2+L5*L10^2+L9*X*L5*L10^2+L9*X*L5*L11^2-L9^2*X*L6*L10-L9^2*X*L7*L11+L10^3*Y*L5+L10*Y*L5*L11^2-L10^2*Y*L9*L6-L10*Y*L9*L7*L11+L11*Z*L5*L10^2+L11^3*Z*L5-L11*Z*L9*L6*L10-L11^2*Z*L9*L7-L9*L6*L10-L9*L7*L11)-(L4*L5*L10^2+L4*L5*L11^2-X*L2*L6*L9^2-X*L2*L6*L11^2-X*L3*L7*L9^2-X*L3*L7*L10^2+X*L2*L10*L5*L9+X*L2*L10*L7*L11+X*L3*L11*L5*L9+X*L3*L11*L6*L10+L2*Y*L5*L10^2+L2*Y*L5*L11^2-L2*Y*L9*L6*L10-L2*Y*L9*L7*L11+L3*Z*L5*L10^2+L3*Z*L5*L11^2-L3*Z*L9*L6*L10-L3*Z*L9*L7*L11-L4*L9*L6*L10-L4*L9*L7*L11)/(L5*L11^2+L5*L10^2+L9*X*L5*L10^2+L9*X*L5*L11^2-L9^2*X*L6*L10-L9^2*X*L7*L11+L10^3*Y*L5+L10*Y*L5*L11^2-L10^2*Y*L9*L6-L10*Y*L9*L7*L11+L11*Z*L5*L10^2+L11^3*Z*L5-L11*Z*L9*L6*L10-L11^2*Z*L9*L7-L9*L6*L10-L9*L7*L11)^2*(2*L5*L10+2*L9*X*L5*L10-L9^2*X*L6+3*L10^2*Y*L5+Y*L5*L11^2-2*L10*Y*L9*L6-Y*L9*L7*L11+2*L11*Z*L5*L10-L11*Z*L9*L6-L9*L6);
      a(2*i-1,10)=(2*L4*L5*L11-2*X*L2*L6*L11+X*L2*L10*L7+X*L3*L5*L9+X*L3*L6*L10+2*L2*Y*L5*L11-L2*Y*L9*L7+2*L3*Z*L5*L11-L3*Z*L9*L7-L4*L9*L7)/(L5*L11^2+L5*L10^2+L9*X*L5*L10^2+L9*X*L5*L11^2-L9^2*X*L6*L10-L9^2*X*L7*L11+L10^3*Y*L5+L10*Y*L5*L11^2-L10^2*Y*L9*L6-L10*Y*L9*L7*L11+L11*Z*L5*L10^2+L11^3*Z*L5-L11*Z*L9*L6*L10-L11^2*Z*L9*L7-L9*L6*L10-L9*L7*L11)-(L4*L5*L10^2+L4*L5*L11^2-X*L2*L6*L9^2-X*L2*L6*L11^2-X*L3*L7*L9^2-X*L3*L7*L10^2+X*L2*L10*L5*L9+X*L2*L10*L7*L11+X*L3*L11*L5*L9+X*L3*L11*L6*L10+L2*Y*L5*L10^2+L2*Y*L5*L11^2-L2*Y*L9*L6*L10-L2*Y*L9*L7*L11+L3*Z*L5*L10^2+L3*Z*L5*L11^2-L3*Z*L9*L6*L10-L3*Z*L9*L7*L11-L4*L9*L6*L10-L4*L9*L7*L11)/(L5*L11^2+L5*L10^2+L9*X*L5*L10^2+L9*X*L5*L11^2-L9^2*X*L6*L10-L9^2*X*L7*L11+L10^3*Y*L5+L10*Y*L5*L11^2-L10^2*Y*L9*L6-L10*Y*L9*L7*L11+L11*Z*L5*L10^2+L11^3*Z*L5-L11*Z*L9*L6*L10-L11^2*Z*L9*L7-L9*L6*L10-L9*L7*L11)^2*(2*L5*L11+2*L9*X*L5*L11-L9^2*X*L7+2*L10*Y*L5*L11-L10*Y*L9*L7+Z*L5*L10^2+3*L11^2*Z*L5-Z*L9*L6*L10-2*L11*Z*L9*L7-L9*L7);
      %second row of the i-th point; contribution of (5) equation
      a(2*i,1)=0;
      a(2*i,2)=0;
      a(2*i,3)=0;
      a(2*i,4)=X/(L9*X+L10*Y+L11*Z+1);
      a(2*i,5)=Y/(L9*X+L10*Y+L11*Z+1);
      a(2*i,6)=Z/(L9*X+L10*Y+L11*Z+1);
      a(2*i,7)=1/(L9*X+L10*Y+L11*Z+1);
      a(2*i,8)=-(L5*X+L6*Y+L7*Z+L8)/(L9*X+L10*Y+L11*Z+1)^2*X;
      a(2*i,9)=-(L5*X+L6*Y+L7*Z+L8)/(L9*X+L10*Y+L11*Z+1)^2*Y;
      a(2*i,10)=-(L5*X+L6*Y+L7*Z+L8)/(L9*X+L10*Y+L11*Z+1)^2*Z;
      %analogicaly for c matrice
      c(2*i-1)=sk(i,1)-(L4*L5*L10^2+L4*L5*L11^2-X*L2*L6*L9^2-X*L2*L6*L11^2-X*L3*L7*L9^2-X*L3*L7*L10^2+X*L2*L10*L5*L9+X*L2*L10*L7*L11+X*L3*L11*L5*L9+X*L3*L11*L6*L10+L2*Y*L5*L10^2+L2*Y*L5*L11^2-L2*Y*L9*L6*L10-L2*Y*L9*L7*L11+L3*Z*L5*L10^2+L3*Z*L5*L11^2-L3*Z*L9*L6*L10-L3*Z*L9*L7*L11-L4*L9*L6*L10-L4*L9*L7*L11)/(L5*L11^2+L5*L10^2+L9*X*L5*L10^2+L9*X*L5*L11^2-L9^2*X*L6*L10-L9^2*X*L7*L11+L10^3*Y*L5+L10*Y*L5*L11^2-L10^2*Y*L9*L6-L10*Y*L9*L7*L11+L11*Z*L5*L10^2+L11^3*Z*L5-L11*Z*L9*L6*L10-L11^2*Z*L9*L7-L9*L6*L10-L9*L7*L11);
      c(2*i)=sk(i,2)-(L5*X+L6*Y+L7*Z+L8)/(L9*X+L10*Y+L11*Z+1);
   end
   c=c';c=c(:); %regrouping in one column
   b=a\c; %10 MDLT parameters of the k-the iteration
   
   % Prepare the estimates for a new iteration
   L2=b(1)+L2;L3=b(2)+L3;L4=b(3)+L4;L5=b(4)+L5;L6=b(5)+L6;
   L7=b(6)+L7;L8=b(7)+L8;L9=b(8)+L9;L10=b(9)+L10;L11=b(10)+L11;
   % Calculate L1 based on equation (1)and 'save' the parameters of the k-th iteration
   dlt(k,:)=[eval(L1) L2 L3 L4 L5 L6 L7 L8 L9 L10 L11];
   %%disp('Number of iterations performed'),k
   clear a b c
end
%b=dlt;%return all sets of 11 DLT parameters for all iterations
b=dlt(k,:)';%return last DLT set in KineMat orientation


% calculate residuals - added by Ty Hedrick
% note that this currently uses the initial estimate of the DLT parameters rather than the final set
D=a_init*b;
sk_l=sk';
sk_l=sk_l(:); 
R=sk_l-D;
res=norm(R); avgres=res/size(R,1)^.5;
