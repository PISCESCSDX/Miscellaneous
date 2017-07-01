function MergeDLTcoeffFiles(handles)
% MergeDLTcoeffFiles.m
% Loretta Reiss 10/28/2008
% default directory support added 10/2009

defaultdir = get(handles.defaultdir,'String');

pause(0.01); % make sure uigetfile is executed (Matlab bug)
[fname1,pname1] = ...
    uigetfile('*.csv', 'Select DLT coefficients file for Camera 1',...
    defaultdir);
pause(0.01); % make sure uigetfile is executed (Matlab bug)
% if user hits "cancel", fname1 and pname1 are zero.
if (fname1 == 0)
    msgbox('Exiting Merge without making changes.');
    return
end
try
    C1dltcoeff=dlmread([pname1,fname1],',');
catch
    disp('File is not in expected format.  Exiting Merge without making changes.');
    return
end
set(handles.defaultdir,'String',pname1);
defaultdir = pname1;

pause(0.01); % make sure uigetfile is executed (Matlab bug)
[fname2,pname2] = ...
    uigetfile('*.csv', 'Select DLT coefficients file for Camera 2',...
    defaultdir);
pause(0.01); % make sure uigetfile is executed (Matlab bug)
% if user presses "cancel"
if (fname2 == 0)
    msgbox('Exiting Merge without making changes.');
    return
end
try
    C2dltcoeff=dlmread([pname2,fname2],',');
catch
    disp('File is not in expected format.  Exiting Merge without making changes.');
    return
end
set(handles.defaultdir,'String',pname2);
defaultdir = pname2;

%
dltcoeff = [C1dltcoeff, C2dltcoeff]; % combine into one table

% determine prefix on first DLT coefficients file
[pfix] = getFnamePrefix(fname1);

pause(0.01); % make sure uigetfile is executed (Matlab bug)
% prompt for output file with suggested default filespec:
[fname,pname] = uiputfile('*.csv', 'Combined DLT coefficients file:', ...
    [pname2,pfix,'Merged_DLTcoefs.csv']);
pause(0.01); % make sure uigetfile is executed (Matlab bug)

if (fname == 0) % if user presses 'cancel',
    msgbox('Cancelled by user.  Exiting Merge without making changes.',...
        'Merge');
    return
else
    if strcmp(fname, '') % if user entered null filename.
        msgbox('No output file specified.  Exiting Merge without making changes.',...
            'Merge');
        return;
    else
        dlmwrite([pname,filesep,fname], dltcoeff,','); % output
    end
end

set(handles.defaultdir,'String',pname);

msgbox('Merge completed.', 'Merge');

return
end

