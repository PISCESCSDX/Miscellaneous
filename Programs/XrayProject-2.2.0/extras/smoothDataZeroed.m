function [rigidYPR,rigidCent,rigidPos,idealPos,boneYPR,boneCent,C] = smoothDataZeroed

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

%get ct cord data
[fcord,pcord]=uigetfile('*.csv','Select the CT marker coordinate file');
ctcords = dlmread([pcord,fcord],',',1,0);

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


for i = 1:boneNum
    bMarkers = bones{i};
    for j = 1:size(bMarkers,2)
        reshapeCords{i}(:,j*3-2:j*3) = ctcords(:,bMarkers(j)*3-2:bMarkers(j)*3);
    end
end

% get the centroid from the ct data
[ctYPR,idealPos,ctCent] = rigidOrientation2(reshapeCords);

% add centroid to the base positions so that rotations are based on the
% bones rather than the centroid of the markers
for i = 1:boneNum
    reshapeCords{i} = reshapeCords{i}+repmat(ctCent{i},1,size(reshapeCords{i},2));
end

%add the centroid to all of the markers so that rotations are about the
%origin in Maya
for i = 1:boneNum
    reshapeData{i} = reshapeData{i}+repmat(ctCent{i},size(reshapeData{i},1),...
        size(reshapeData{i},2));
end

% recalculate rotations for ct data
[ctYPR,idealPos,ctCent] = rigidOrientation2(reshapeCords);


% First pass smoothing
[rigidYPR,rigidCent,rigidPos,C] = rigidFilter2(reshapeData,reshapeCords);

% intiialize boneYPR variable
boneYPR = [];
boneCent = [];

%get a rotation matrix for each bone
for i = 1:boneNum

    % create headers
    h{i*6-5}=sprintf('bone%s_tx',num2str(i));
    h{i*6-4}=sprintf('bone%s_ty',num2str(i));
    h{i*6-3}=sprintf('bone%s_tz',num2str(i));
    h{i*6-2}=sprintf('bone%s_rx',num2str(i));
    h{i*6-1}=sprintf('bone%s_ry',num2str(i));
    h{i*6-0}=sprintf('bone%s_rz',num2str(i));
    
    % extract current ct and raw rotations
    ctdata = ctYPR{i};
    rawdata = rigidYPR{i};
    % get rotations relative to base ctposition
    boneYPR{i} = rad2deg(convOrient(rawdata,ctdata));
    
    % extract current ct and raw translations
    ctdata = ctCent{i};
    rawdata = rigidCent{i};
    dCent(:,1) = rawdata(:,1)-ctdata(1);
    dCent(:,2) = rawdata(:,2)-ctdata(2);
    dCent(:,3) = rawdata(:,3)-ctdata(3);
    boneCent{i} = dCent;

    bonedata(:,i*6-5:i*6-3) = dCent;
    bonedata(:,i*6-2:i*6) = boneYPR{i};
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
for i = 1:size(bonedata,1)
    tempdata = squeeze(bonedata(i,:));
    for j = 1:prod(size(tempdata,2))-1
        fprintf(f1,'%.6f,',tempdata(j));
    end
    fprintf(f1,'%.6f\n',tempdata(end));
end

fclose(f1);

%dlmwrite([pdata,fdata],bonedata,',',1,0);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [outYPR] = convOrient(childYPR,parentYPR)

% describe rotation of one object in term of another orientation

yaw = parentYPR(1);
pitch = parentYPR(2);
roll = parentYPR(3);
rotm.x=[1,0,0;0,cos(roll),-sin(roll);0,sin(roll),cos(roll)];
rotm.y=[cos(pitch),0,sin(pitch);0,1,0;-sin(pitch),0,cos(pitch)];
rotm.z=[cos(yaw),-sin(yaw),0;sin(yaw),cos(yaw),0;0,0,1];

protm = (rotm.x'*rotm.y')*rotm.z';

outpitch = 0; outroll = 0; outyaw = 0;

for i = 1:length(childYPR)
    if isnan(childYPR(i,1))
        outYPR(i,1:3) = NaN;
    else

        yaw = childYPR(i,1);
        pitch = childYPR(i,2);
        roll = childYPR(i,3);
        rotm.x=[1,0,0;0,cos(roll),-sin(roll);0,sin(roll),cos(roll)];
        rotm.y=[cos(pitch),0,sin(pitch);0,1,0;-sin(pitch),0,cos(pitch)];
        rotm.z=[cos(yaw),-sin(yaw),0;sin(yaw),cos(yaw),0;0,0,1];

        crotm = (rotm.x'*rotm.y')*rotm.z';
        crotm = protm'*crotm;

        %for xyz rot order
        outpitch = contAng(asin(-crotm(1,3)),outpitch);
        outroll = contAng(atan2(crotm(2,3),crotm(3,3)),outroll);
        outyaw = contAng(atan2(crotm(1,2),crotm(1,1)),outyaw);

        outYPR(i,1:3) = [outroll outpitch outyaw];
    end
end

%% continuous angles subfuction
function [newAng]=contAng(ang,priorAng)

% try and ensure continuous orientations

if abs(ang-priorAng)<pi
    newAng=ang;
elseif ang-priorAng>pi
    newAng=ang-2*pi;
else
    newAng=ang+2*pi;
end


% Use bootstrap to determine Confidence Interval

% function bootScript
%
% for i=1:100
%   disp(sprintf('Starting run %s',num2str(i)))
%   newPos=idealPos+randn(size(idealPos)).*0.004;
%   [triDataFiltNew,c,ip] = triangleFilter(newPos(:,1:9));
%   roll(:,i)=triDataFiltNew(:,6);
%   pitch(:,i)=triDataFiltNew(:,5);
%   yaw(:,i)=triDataFiltNew(:,4);
% end
