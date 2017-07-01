function [new] = coordFlipxy(orig)

%change calibration points to get a left handed coordinate system to a
%right handed system
%
% INPUT: orig = xy clicks from calibration cube
% OUTPUT: new = renumbers the calibration cube points
%
% for example: points 1:4 are moved to 49 to 52

new(1:4,:) = orig(1:4,:);
new(5:8,:) = orig(17:20,:);
new(9:12,:) = orig(33:36,:);
new(13:16,:) = orig(49:52,:);
new(17:20,:) = orig(5:8,:);
new(21:24,:) = orig(21:24,:);
new(25:28,:) = orig(37:40,:);
new(29:32,:) = orig(53:56,:);
new(33:36,:) = orig(9:12,:);
new(37:40,:) = orig(25:28,:);
new(41:44,:) = orig(41:44,:);
new(45:48,:) = orig(57:60,:);
new(49:52,:) = orig(13:16,:);
new(53:56,:) = orig(29:32,:);
new(57:60,:) = orig(45:48,:);
new(61:64,:) = orig(61:64,:);