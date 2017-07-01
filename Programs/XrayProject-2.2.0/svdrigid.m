function [R t res] = svdrigid(data)

% function [R t] = svdrigid(data): Determination of rotation and translation for a 
% bone containing n markers from one frame to the next.  Algo uses singular 
% value decomposition a la Soderkvist and Wedin, J. of Biomechanics, 1993.

% Input parameters:
% data: xyzpts data row are time, ct data should have already been prepended
%       as the first non-nan frame. All points are assumed to be on the
%       same rigid body
% 
% Returns:
% R: an array of 3x3 rotation matrices indexed by frame number from 1 to
%    numFrames - 1
% t: an array of 1x3 translation vectors indexed by frame number from 1 to
%    numFrames - 1

% last changed 27 May 2010 LReiss 
numFrames = size(data,1);
lastFrame = 1;
curRow = data(1,:);
nonNan = sum(~isnan(data)');
ctFrame = find(nonNan >= 9, 1, 'first');
firstFrame = ctFrame+1;

% fill output data with NaNs if the first frame is not 1
if ctFrame ~= 1
    for i = 1:ctFrame
        R(i,:,:) = [NaN NaN NaN;NaN NaN NaN;NaN NaN NaN];
        t(i,:) = [NaN;NaN;NaN];
        res(i) = NaN;
    end
end

for i = firstFrame:numFrames

    % only replace curRow if the last frame is not NaN
    if lastFrame == 1
        curRow = data(i-1,:);
    end
    nextRow = data(i,:);

    curNonNan = ~isnan(curRow);
    nextNonNan = ~isnan(nextRow);

    sharedNonNan = curNonNan.*nextNonNan;
    sharedNonNan = logical(sharedNonNan);
      
    % can only create the transform if both timesteps share the same 3+ pts
    if sum(sharedNonNan) >= 9
       
        curUsable = curRow(sharedNonNan);
        nextUsable = nextRow(sharedNonNan);
        
        numCols = size(curUsable,2);
        numPts = numCols/3;
        
        curUsableStack = reshape(curUsable,3,numPts)';
        nextUsableStack = reshape(nextUsable,3,numPts)';
        
        curMean = nanmean(curUsableStack);
        nextMean = nanmean(nextUsableStack);
        
        A = curUsableStack-repmat(curMean,numPts,1); A = A';
        B = nextUsableStack-repmat(nextMean,numPts,1); B = B';

        C = B*A';

        [P,T,Q] = svd(C);

        Rot = P * diag([1, 1, det(P*Q')])*Q';
        d =  nextMean' - Rot*curMean';

        R(i,:,:) = Rot;
        t(i,:) = d;
        lastFrame = 1;
%
        % Calculating the norm of residuals
        a = curUsableStack';
        a(4,:) = ones(1,size(a,2));
        b = nextUsableStack';
        Tf = [Rot,d;0 0 0 1];
        bcalc = Tf*a;
        bcalc(4,:)=[];
        Diff = b-bcalc;
        Diffsquare = Diff.^2;
        DOF = size(b,1)*size(b,2)-6;
        res(i) = (sum(Diffsquare(:))/DOF).^0.5;

    else

        R(i,:,:) = [NaN NaN NaN;NaN NaN NaN;NaN NaN NaN];
        t(i,:) = [NaN;NaN;NaN];
        res(i) = NaN;
        lastFrame = 0;
    end    
end
% R and T are offset in time
% from the original data. The first position of R and T will be zero and
% need to be cut to align the first transformation to the original marker
% data

    R(1,:,:) = [];
    t(1,:,:) = [];
    res(1) = [];

    
