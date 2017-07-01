function [rigidYPR,rigidCent,rigidPos,C] = rigidFilter(data,idealPos)

% [rigidYPR,rigidCent,rigidPos,C] = rigidFilter(data,idealPos)
%
% The rigid object filter for CTX or similar data
%
% Attempts to minimize the MSE between the measured vertex locations and
% the vertex locations based on centroid position and RPY angles of an
% ideal rigid object with at least 3 marked points.
%
% Inputs:
%  data: A cell array where each cell contains the xyz coordinates of the
%   points on the rigid object.  Each object must have a minimum of 3
%   points, or 9 data columns.  Objects may have different numbers of
%   points
%  idealPos: A cell array where each cell has the ideal coordinate
%   locations of all the points in the corresponding data array.  Each cell
%   entry in idealPos should be one row long, with 3 columns for each
%   object vertex.
%
% Outputs:
%  rigidYPR: A cell array with one entry per object.  Each row in an entry
%   gives the yaw, pitch & roll angles of the object at that time step (in
%   radians).
% rigidCent: A cell array with one entry per object.  Each row in an entry
%  gives the object's centroid location in global XYZ coordinates.
% rigidPos: A cell array with one entry per object.  Each row in an entry
%  gives the global position of each vertex following the filtering
%  operation.
% C: A cell array with one entry per object.  Each entry is a single column
%  matrix with one row for each timestep. The value is the residual between
%  the filtered position (rigidPos) and initial position (data).  Lower
%  values indicate a better match.
%
% Ty Hedrick: April 3, 2007.
%
% Modified version by Dave Baier: May 23, 2007
%

%% main function block
if exist('data') == 0
    % get input from the user to set data and idealPos if none in call to
    % function
    [data,idealPos] = rigidFormat;
end

if iscell(data)==0
    disp(sprintf('\n Input data has to be a cell array. \n'))
    rigidYPR = [];
    rigidCent = [];
    rigidPos = [];
    C = [];
    return
end
numR=numel(data); % number of objects in the input

% get initial estimate of position and orientation
[rigidYPRI,vertPos,rigidCent] = rigidOrientation2(data);
[ctYPR,idealPos,ctCent] = rigidOrientation2(idealPos);

for i=1:numR
    tdata=data{i}; % extract vertices for the current object

    np=size(tdata,2)/3; % number of 3D points

    % check inputs before continuing
    if np < 3 || mod(size(tdata,2),3)~=0
        disp('Bad input!')
        rigidCent{i}=NaN;
        C{i}=NaN;
        rigidYPR{i}=NaN;
        rigidPos{i}=NaN;
    else

        % create weight matrix - this is a simple one that gives equal weight
        % to every point, but many variations are possible.
        weights=ones(np,3);

        % seed fminsearch with the first non-NaN estimated angle
        nandx=find(isnan(rigidYPRI{i}(:,1))==false);
        angSeed=rigidYPRI{i}(nandx(1),:);
        
        % for each row in this rigid object...
        for j=1:size(tdata,1)

            rawRigid=reshape(tdata(j,:),3,np)'; % grab a row, put in matrix form
            idealPosI=reshape(idealPos{i},3,np)';
            
            % check for NaNs due to missing points, output NaNs when
            % detected
            if isnan(rigidYPRI{i}(j,1))
                C{i}(j,1)=NaN;
                rigidPos{i}(j,1:np*3)=NaN;
                rigidYPR{i}(j,1:3)=NaN;
            else

            % Define the anonymous function
            %
            % The anonymous function creates a 2nd function that only accepts one
            % input but then calls rigidScore with that input and all other
            % inputs that were defined when creating the anonymous function
            % handle.  This lets us "hide" these other inputs from the search
            % function, fminsearch, below.  See "doc function_handle" for more
            % information.
            anonFunc=@(rYPR)rigidScore(rYPR,rigidCent{i}(j,:),idealPosI, ...
                rawRigid,weights);

            % Search for the minimum residual between rigid and actual objects by
            % working through all possible Yaw-Pitch-Roll combinations.  The
            % optimal position always has the same centroid location as the raw
            % data, so it is not necessary to include centroid locations in the
            % search.
            
            % older version - seeded with estimated angles
            [rigidYPR{i}(j,:),c]=fminsearch(anonFunc,rigidYPRI{i}(j,:));
            
%             [rigidYPR{i}(j,:),c]=fminsearch(anonFunc,angSeed);
%             angSeed=rigidYPR{i}(j,:); % update the seed for the next row
            
            % get the final filtered vertex positions
            [C{i}(j,1),rigidPos{i}(j,:)] = rigidScore(rigidYPR{i}(j,:), ...
                rigidCent{i}(j,:),idealPosI,rawRigid,weights);
            end

        end
    end
end


%% Scoring subfuction
function [c,newPos] = rigidScore(rYPR,centPos,idealPos,rawRigid,weights);

% [c,newPos] = rigidScore(rSpec,idealPos,rawRigid,weights);
%
% comparison and scoring function for rigid object filtering

% apply roll
roll=rYPR(3);
rotm=[1,0,0;0,cos(roll),-sin(roll);0,sin(roll),cos(roll)];
idealPos=applyRotationMatrix(idealPos,inv(rotm));

% apply pitch
pitch=rYPR(2);
rotm=[cos(pitch),0,sin(pitch);0,1,0;-sin(pitch),0,cos(pitch)];
idealPos=applyRotationMatrix(idealPos,inv(rotm));

% apply yaw
yaw=rYPR(1);
rotm=[cos(yaw),-sin(yaw),0;sin(yaw),cos(yaw),0;0,0,1];
idealPos=applyRotationMatrix(idealPos,inv(rotm));

% add centroid
idealPos=idealPos+repmat(centPos,numel(idealPos)/3,1);

% compare to raw position
c=nansum(nansum( ((idealPos-rawRigid).*weights).^2));

% export ideal triangle vertex positions
newPos=reshape(idealPos',1,numel(idealPos));
