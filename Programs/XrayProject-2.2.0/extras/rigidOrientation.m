function [rigidYPR,vertPos,centPos] = rigidOrientation(data)

% [rigidYPR,vertPos,centPos] = rigidOrientation(data)
%
% Computs centroid (x,y,z) and yaw-pitch-roll angles for any number of 
% rigid objects
%
% Inputs:
%   data: A cell array where each cell contains the xyz coordinates of the
%    points on the rigid object.  Each object must have a minimum of 3 
%    points, or 9 data columns.  Objects may have different numbers of 
%    points.
%
% Outputs: Also returned as cell arrays, with one entry for each entry in
%    data and within each entry one row for each row in the corresponding
%    data entry.
%   rigidYPR: yaw-pitch-roll angles for each object
%   vertPos: vertex positions of the rotated object
%   centPos: centroid position of each object
%
% Ty Hedrick, April 3, 2007
%
% Modified version by Dave Baier, May 23, 2007
%   negative of YPR are used
%

%% main function body

numR=numel(data); % number of objects in the input

for i=1:numR
  tdata=data{i}; % extract vertices for the current object

  np=size(tdata,2)/3; % number of 3D points

  if np < 3 || mod(size(tdata,2),3)~=0
    disp('Bad input!')
    rigidYPR{i}=NaN;
    vertPos{i}=NaN;
    centPos{i}=NaN;
  else
    idx=[1:3:np*3]; % index of X columns

    dCent=[]; % determine centroid
    dCent(:,1)=mean(tdata(:,idx),2); % x
    dCent(:,2)=mean(tdata(:,idx+1),2); % y
    dCent(:,3)=mean(tdata(:,idx+2),2); % z
    centPos{i}=dCent;

    % subtract centroid
    tdata=tdata-repmat(dCent,1,np);

    % compute yaw-pitch-roll angles for each object.  Need to go frame by
    % frame in a loop
    yaw=0;
    pitch=0;
    roll=0;
    for j=1:size(tdata,1)

            adata=reshape(tdata(j,:),3,np)'; % reshape to stack the time slice
            idx = isnan(adata);
            % report NaN if there are any NaNs in adata
            if idx > 0               
                vertPos{i}(j,:)=reshape(adata',1,np*3);
                rigidYPR{i}(j,:)=[NaN,NaN,NaN];
            else             

            % yaw(Z) such that point #1 lies along the X axis
            yaw=contAng(atan2(adata(1,2),adata(1,1)),yaw);
            rotm=[cos(yaw),-sin(yaw),0;sin(yaw),cos(yaw),0;0,0,1];
            adata=applyRotationMatrix(adata,rotm);

            % pitch(Y) such that point #1 lies in the X=0, Y=0 plane
            pitch=-contAng(atan2(adata(1,3),adata(1,1)),pitch);
            rotm=[cos(pitch),0,sin(pitch);0,1,0;-sin(pitch),0,cos(pitch)];
            adata=applyRotationMatrix(adata,(rotm));

            % roll(X) such that point #2 lies in the X=0, Y=0 plane
            roll=contAng(atan2(adata(2,3),adata(2,2)),roll);
            rotm=[1,0,0;0,cos(roll),-sin(roll);0,sin(roll),cos(roll)];
            adata=applyRotationMatrix(adata,rotm);

            % back to one data row
            vertPos{i}(j,:)=reshape(adata',1,np*3);

            % store the outputs
            rigidYPR{i}(j,:)=[yaw,pitch,roll];
            end

    end

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
