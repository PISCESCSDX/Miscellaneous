function [rfData,rfCords] = rigidFormat

% [rfData,rfCords] = rigidFormat
%
% Associates markers with appropriate rigid bodies
% Input: *.xyzpts.csv file and ctmarker.csv coordinate file
%
% The user inputs are used to reshape the data in the appropriate format
% for rigidFilter.m written by Ty Hedrick
% The bone-marker relationship data is saved after the first pass so the
% user has to assign the relationship only once.

% Marker number corresponds to the marker number set in DLTdataviewer


% get the xyz data
[fdata,pdata]=uigetfile('*xyzpts.csv','Select the [prefix]xyzpts.csv file');
data = dlmread([pdata,fdata],',',1,0);

%change directory
cd(pdata);

% get the number of markers and create a list for markers
markerNum = size(data,2)/3;
mList = num2str((1:markerNum)','%g\n');

[fcord,pcord]=uigetfile('*.csv','Select the [prefix]xyzpts.csv file');
ctcords = dlmread([pcord,fcord],',',1,0);

% get number of rigid objects from the user
boneNum = inputdlg('How many bones?','Bone Number',1,{'1'});
boneNum = str2num(boneNum{1});

% get markers associated with each bone
for i = 1:boneNum
    [bMarkers,ok] = listdlg('PromptString',...
        sprintf('Select the markers for bone %d',i),...
        'name','Marker Selection','ListSize',[160 17*markerNum],...
        'SelectionMode','multiple','ListString',mList);
    bones{i} = bMarkers;
end

for i = 1:boneNum
    bMarkers = bones{i};
    for j = 1:size(bMarkers,2)
        rfData{i}(:,j*3-2:j*3) = data(:,bMarkers(j)*3-2:bMarkers(j)*3);
    end
end


for i = 1:boneNum
    bMarkers = bones{i};
    for j = 1:size(bMarkers,2)
        rfCords{i}(:,j*3-2:j*3) = ctcords(:,bMarkers(j)*3-2:bMarkers(j)*3);
    end
end


