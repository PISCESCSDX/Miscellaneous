function reduceTform(factor)

% script for reducing the undistortTform size (to reduce processing time for
% undistorting whole videos. You will lose some undistortion quality.
%
% INPUTS: factor = tform will be reduced by 1/factor
%
% factor is the amount of reduction to the number of points used

% get the UNDTFORM file
[fc1,pc1]=uigetfile('*.mat','Select Camera UNDTFORM File');
filevariables = {'BasePoints', 'InputPoints', 'dX', 'dY', 'dOffY'};
load([pc1,fc1],filevariables{:});

% reduce input and base points by factor (every 3 points if factor is 3)
numPoints = size(BasePoints,1)/factor;
BasePointsReduced = BasePoints(1,:);
for i = 1:numPoints
BasePointsReduced(i+1,:) = BasePoints(i*factor,:);
end

InputPointsReduced = InputPoints(1,:);
for i = 1:numPoints
    InputPointsReduced(i+1,:) = InputPoints(i*factor,:);
end
undistortTform = cp2tform(InputPointsReduced, BasePointsReduced, 'lwm');
BasePoints = BasePointsReduced;
InputPoints = InputPointsReduced;

% image coordinates flipped to read in upper right quadrant (like a
% graph. (format used by DLTdataviewer)
BasePointsflip(:,1)= BasePoints(:,1);
InputPointsflip(:,1)= InputPoints(:,1);
BasePointsflip(:,2)=1024-BasePoints(:,2);
InputPointsflip(:,2)=1024-InputPoints(:,2);

% variables that will be loaded by the digitizing program DLTdataviewer
camud=cp2tform(BasePointsflip,InputPointsflip,'lwm');
camud.xlim=[min(InputPointsflip(:,1)),max(InputPointsflip(:,1))];
camud.ylim=[min(InputPointsflip(:,2)),max(InputPointsflip(:,2))];
camd=cp2tform(InputPointsflip,BasePointsflip,'lwm');
camd.xlim=[min(BasePointsflip(:,1)),max(BasePointsflip(:,1))];
camd.ylim=[min(BasePointsflip(:,2)),max(BasePointsflip(:,2))];

% save file with the UNDReduced added to the original file name
[pathname, filename, ext, version] = fileparts([pc1,fc1]);
[file,path] = uiputfile('*.mat','Save Workspace As',...
    [pathname,filesep,filename,'R',num2str(factor)]);
save([path,file], 'InputPoints', 'BasePoints','undistortTform',...
    'dY','dX','dOffY','BasePointsflip','InputPointsflip','camud',...
    'camd');


