function [angle] = xcamAngle(framespec,c1xypts,c2xypts)

% function [angle] = xcamAngle(framespec,c1xypts,c2xypts)
%
% calculates the angle between two camera views based on Xray project
% calibrations
%
% INPUTS:   (if none are specified, the user will be asked for the files)
%           framespec = n x 3 xyz coordinates of the calibration frame
%           c*xypts =   xy pixel coordinates of the calibration points 
%                       on the calibration images
% OUTPUT:   angle in degrees between the two cameras
%
% Created by:   David Baier 5/1/2008     
% Last Updated: 6/11/2008


if (exist('framespec') == 0)
    [fname,pname]=uigetfile({'*.csv','comma separated values'}, ...
    'Please select your frame specification file');

    framespec = dlmread([pname,fname],',',1,0);
    cd(pname);
end

if (exist('c1xypts') == 0)
    [fname,pname]=uigetfile({'*.csv','comma separated values'}, ...
    'Please select camera1 _xypts.csv file from the DLT calibration');

    c1xypts = dlmread([pname,fname],',',1,0);
    cd(pname);
end

if (exist('c2xypts') == 0)
    [fname,pname]=uigetfile({'*.csv','comma separated values'}, ...
    'Please select camera1 _xypts.csv file from the DLT calibration');

    c2xypts = dlmread([pname,fname],',',1,0);
end

[coefs1, avgres1] = mdlt1(framespec,c1xypts);
[coefs2, avgres2] = mdlt1(framespec,c2xypts);

[c1R,c1t] = camPositionFromDLT(coefs1);
[c2R,c2t] = camPositionFromDLT(coefs2);

v1 = c1t+([0,0,-1]*c1R');
v2 = c2t+([0,0,-1]*c2R');

c1t = c1t-v1;
c2t = c2t-v2;

angle = acosd(dot(c1t,c2t));


