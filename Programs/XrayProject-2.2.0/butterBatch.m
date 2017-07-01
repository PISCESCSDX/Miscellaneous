function [] = butterBatch(varargin); % butterworth filter function
% runs a butterworth filter on data based on user input data
% select a single or multiple files from a single directory.
%  
% Inputs:   Cutoff frequency 
%           recording frequency
%           Filter type = 'low', 'high', 'stop' or 'pass' for a low-pass, 
%             high-pass, band stop or band pass filter (default = low).  
%             If you wish to use the bandstop or bandpass filters filter you 
%             need to give f as [low high]
%           Smooth over NaN gaps of size
% Output:   File with in the same directory with same name and
%           BUTTER##_sm##, where the first ## is the cutoff frequency and
%           the second ## is the Smooth over gaps of size.
% support added for XrayProject default directory, L Reiss, 15 Oct 2009

defaultdir = cd; % initialize
xrayprojectdirhandle = 0; % initialize
if nargin==0 % no inputs, just run the gui
  % go create the GUI if we didn't get any input arguments

elseif nargin==1 % assume call from XrayProject
      xrayprojhandles = varargin{1};
      defaultdir = get(xrayprojhandles.defaultdir,'String');
      xrayprojectdirhandle = xrayprojhandles.defaultdir;
else
  disp('butterBatch: incorrect number of input arguments')
  return
end

% get the directory with the image files
[fname,pname]=uigetfile({'*.csv',}, ...
    'Select one or more files to filter', defaultdir,'MultiSelect','on');

% cancel if no file was chosen
if pname == 0
    disp(sprintf('\n No file chosen \n'))
    return
end

defaultdir = pname; %update default directory
if(xrayprojectdirhandle~=0)
    set(xrayprojectdirhandle,'String',pname);
end

[filtFr, recFr, filtType, smoothOver, answer] = getButterInputs;
if size(filtFr) == 0
    return
end

% filter frequency has to be less than 1/2 of recording frequency
if filtFr >= 0.5*recFr
    msg = msgbox('Cutoff frequency must be less than 1/2 of recording frequency','modal');
    uiwait(msg);
    [filtFr, recFr, filtType, smoothOver,answer] = getButterInputs;
    if size(filtFr) == 0
        return
    end
end
    
% multiFileCheck = 1 if more than 1 file selected
multiFileCheck = iscellstr(fname);

if multiFileCheck == 0
    fname = {fname};
end

bdwidth = 30;
topbdwidth = 30;

set(0,'Units','pixels'); 
scnsize = get(0,'ScreenSize');
pos  = [bdwidth,... 
	0.5*scnsize(4) - bdwidth,...
	scnsize(3)/2 - 2*bdwidth,...
	scnsize(4)/2 - (topbdwidth + bdwidth)];

for i = 1:size(fname,2)
    %load current data

    data = dlmread([pname,fname{i}],',',1,0);
    dataOut = data;

    %get the headers
    fid = fopen([pname,fname{i}],'r');
    tline = fgets(fid);
    headers = textscan(tline,'%s',size(data,2),'delimiter',',');
    colheaders = headers{1}';
    fidclose = fclose(fid);

    % loop through columns of current file
    for j = 1:size(data,2)
        
        clear sequences;
        
        curColumn = data(:,j);
        nonnan = find(~isnan(curColumn));
        
        % only process if we have at least 20 nonnan frames
        if size(nonnan,1)>20
            
            % separate non-consecutive sequences
            [sequences, gapAfter, startend] = indexNonNan(curColumn,smoothOver);                    

            for k = 1:size(sequences,2)
                curIdx = sequences{1,k};
                if size(curIdx,1) > 20
                    curSequence = curColumn(curIdx);
                    dataOut(curIdx,j) = tybutter(splineinterp_v2(curSequence,'spline'),filtFr,recFr,filtType);
                end
            end
        end
    end

    %save to csv with headers and hardcoded ty butter
    [pout, fout, ext, version] = fileparts([pname,fname{i}]);
    % avoid overwriting existing file
    suffix = ''; seqnum = 1;
    while(exist([pout,filesep,fout,'BUTTER',answer{1},'_sm',answer{2},suffix,ext]))
        suffix = ['_' int2str(seqnum)];
        seqnum = seqnum + 1;
    end
           
    SaveToCSVWithHeaders(...
        [pout,filesep,fout,'BUTTER',answer{1},'_sm',answer{2},suffix,ext],...
        dataOut,colheaders);

        figtitle = sprintf('%s Raw and Filtered Data',fout);
        figure('Name',figtitle,'Position',pos);
        plot(data);
        hold on
        plot(dataOut);
        pos(1) = pos(1) + 15;
        pos(2) = pos(2) - 15;
end

msgbox('Data Saved')
disp(sprintf('Number of Files processed:\t%d',size(fname,2)));
disp(sprintf('Saved to:\t%s',pname));
disp(sprintf('Saved files have the original filename with BUTTER%s_sm%s appended to the end\n\n',...
    answer{1},answer{4}));
disp('Existing files are not overwritten.');
disp('If filename already existed, _# was appended to create a unique filename.');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [filtFr, recFr, filtType, smoothOver, answer] = getButterInputs

%user info
prompt = {'Cutoff frequency:','Recording frequency:','Filter Type:', 'Smooth over NaN gaps of size:'};
dlg_title = 'Butterworth Filter Parameters';
num_lines = 1;
def = {'25','250','low','20'};
answer = inputdlg(prompt,dlg_title,num_lines,def,'on');

% cancel if cancel button was clicked
if numel(answer) == 0
    disp(sprintf('\n Canceled butterBatch \n'))
    filtFr = [];
    recFr = [];
    filtType = [];
    smoothOver = []; 
    return
end

filtFr = str2num(answer{1});
recFr = str2num(answer{2});
filtType = answer{3};
smoothOver = str2num(answer{4});
