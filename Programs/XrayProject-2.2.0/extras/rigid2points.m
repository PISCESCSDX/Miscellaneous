function [newPositions] = rigid2points(rigidYPR,rigidCent,idealPos)

% [c,newPos] = rigidScore(rSpec,idealPos,rawRigid,weights);
%
% comparison and scoring function for rigid object filtering
% rigidYPR = rotation per bone per frame

numR=numel(rigidYPR); % number of objects in the input

for i=1:numR
    
    tdata=idealPos{i}; % get the base ideal pos
    np=size(tdata,2)/3; % number of 3D points    
    idealPosI=reshape(idealPos{i},3,np)';
        
        % for each row in this rigid object...
        for j=1:size(rigidYPR{1},1)
            
            % check for NaNs due to missing points, output NaNs when
            % detected
            if isnan(rigidYPR{i}(j,1))
                [newPositions{i}(j,:)] = NaN;
            else
            
            % get the final filtered vertex positions
            [newPositions{i}(j,:)] = rigidScore(rigidYPR{i}(j,:), ...
                rigidCent{i}(j,:),idealPosI);
            end
        end
end


function [newPos] = rigidScore(rigidYPR,rigidCent,idealPos);

% apply roll
roll=rigidYPR(3);
rotm=[1,0,0;0,cos(roll),-sin(roll);0,sin(roll),cos(roll)];
idealPos=applyRotationMatrix(idealPos,inv(rotm));

% apply pitch
pitch=rigidYPR(2);
rotm=[cos(pitch),0,sin(pitch);0,1,0;-sin(pitch),0,cos(pitch)];
idealPos=applyRotationMatrix(idealPos,inv(rotm));

% apply yaw
yaw=rigidYPR(1);
rotm=[cos(yaw),-sin(yaw),0;sin(yaw),cos(yaw),0;0,0,1];
idealPos=applyRotationMatrix(idealPos,inv(rotm));

% add centroid
idealPos=idealPos+repmat(rigidCent,numel(idealPos)/3,1);

% export ideal triangle vertex positions
newPos=reshape(idealPos',1,numel(idealPos));