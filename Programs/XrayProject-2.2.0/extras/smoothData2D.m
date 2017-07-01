function [rigidTR] = smoothData2D

% A GUI where the user defines the number of bones in a dataset and which
% markers go with which bones.
%
% The user inputs are used to reshape the data in the appropriate format
% for rigidFilter.m written by Ty Hedrick
% The bone-marker relationship data is saved after the first pass so the
% user has to assign the relationship only once.

%Outputs:   rigidYPR = rigid body rotations relative to the origin
%           rigidCent = rigid body translations relative to the origin
%           rigidPose = marker xyz coordinates after smoothing - markers on
%                       the same bone should maintain a constant distance after
%                       smoothing
%           idealPos = ideal position of markers (imported from CT data
%                       and reshaped to match naming convention for bones
%           
%           boneYPR = rigidYPR described in terms of the CT data
%                       orientation
%           boneCent = rigidCent described relative to the average position
%                       of the CT markers
%           C = score of fit

% Marker number corresponds to the marker number set in DLTdataviewer


% get the xyz data
[fdata,pdata]=uigetfile('*xyzpts.csv','Select the [prefix]xyzpts.csv file');
data = dlmread([pdata,fdata],',',1,0);

%change directory
cd(pdata);

% Specifically for Nick's single run animation using the first frame as
% zero
firstRow = data(1,:);
rawdata = data; % to be used for angles
data = data - repmat(firstRow,length(data),1);

% get the number of markers and create a list for markers
markerNum = size(data,2)/3;
mList = num2str((1:markerNum)','%g\n');

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
        reshapeData{i}(:,j*3-2:j*3) = data(:,bMarkers(j)*3-2:bMarkers(j)*3);
    end
end

% rigid translations and rotations in the format that maya will save it
rigidTR = rigid2d(reshapeData,rawdata);

% get video frequency
videohZ = inputdlg('What is the video frequency?','FPS',1,{'125'});
videohZ = str2num(videohZ{1});

rigidTR = tybutter(rigidTR,50,videohZ);


%get a rotation matrix for each bone
for i = 1:boneNum

    % create headers
    h{i*6-5}=sprintf('bone%s_tx',num2str(i));
    h{i*6-4}=sprintf('bone%s_ty',num2str(i));
    h{i*6-3}=sprintf('bone%s_tz',num2str(i));
    h{i*6-2}=sprintf('bone%s_rx',num2str(i));
    h{i*6-1}=sprintf('bone%s_ry',num2str(i));
    h{i*6-0}=sprintf('bone%s_rz',num2str(i));

end

%save path and file name
[pout, fout, ext, version] = fileparts([pdata,fdata]);
[fdata,pdata] = uiputfile('*.csv','Save Bone Data As',...
    [pout,filesep,fout,'Bones',ext]);


f1 = fopen([pdata,fdata],'w');

% headers
for i = 1:prod(size(h)) - 1
    fprintf(f1,'%s,',h{i});
end
fprintf(f1,'%s\n',h{end});

%data
for i = 1:size(rigidTR,1)
    tempdata = squeeze(rigidTR(i,:));
    for j = 1:prod(size(tempdata,2))-1
        fprintf(f1,'%.6f,',tempdata(j));
    end
    fprintf(f1,'%.6f\n',tempdata(end));
end

fclose(f1);

%dlmwrite([pdata,fdata],bonedata,',',1,0);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [rigidTR] = rigid2d(dataArray,rawdata);

numR=numel(dataArray); % number of objects in the input

for i=1:numR
    tdata=dataArray{i}; % extract vertices for the current object

    np=size(tdata,2)/3; % number of 3D points

    idx=[1:3:np*3]; % index of X columns

    dCent=[]; % determine centroid
    dCent(:,1)=mean(tdata(:,idx),2); % x
    dCent(:,2)=mean(tdata(:,idx+1),2); % y
    dCent(:,3)=mean(tdata(:,idx+2),2); % z
    centPos{i}=dCent;

    % determine rotations
    tmarker = rawdata(:,1:2) - rawdata(:,end-2:end-1);
    rotZ = zeros(length(tdata),3);
    rotZ(:,3) = rad2deg(atan2(tmarker(:,1),tmarker(:,2)));

    rigidTR(:,i*6-5:i*6-3) = dCent;
    rigidTR(:,i*6-2:i*6) = rotZ;
end
    
    
   
        
