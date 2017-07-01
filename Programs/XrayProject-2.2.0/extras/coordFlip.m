function [new] = coordFlip(orig)

% function [new] = coordFlip(orig)
% flips left-handed/right-handed for 64point XrayProject calibration 
%
% INPUT: orig = xy clicks from calibration cube
% OUTPUT: new = renumbers the calibration cube points
%
% for example: points 1:4 are moved to 49 to 52
%
% created by:   David Baier 11/6/2008
% last updated: 6/11/2008

new(1:4,:) = orig(49:52,:);
new(5:8,:) = orig(53:56,:);
new(9:12,:) = orig(57:60,:);
new(13:16,:) = orig(61:64,:);
new(17:20,:) = orig(33:36,:);
new(21:24,:) = orig(37:40,:);
new(25:28,:) = orig(41:44,:);
new(29:32,:) = orig(45:48,:);
new(33:36,:) = orig(17:20,:);
new(37:40,:) = orig(21:24,:);
new(41:44,:) = orig(25:28,:);
new(45:48,:) = orig(29:32,:);
new(49:52,:) = orig(1:4,:);
new(53:56,:) = orig(5:8,:);
new(57:60,:) = orig(9:12,:);
new(61:64,:) = orig(13:16,:);