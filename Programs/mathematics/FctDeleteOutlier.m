function [xnew,ynew,irem] = FctDeleteOutlier(x,y,lev)
%==========================================================================
%function [xnew,ynew,irem] = FctDeleteOutlier(x,y,lev)
%--------------------------------------------------------------------------
% FCTDELETEOUTLIER removes points from vector y which lie beyound the 
% outlier level, which is defined as follows:
%               ndi = abs(y-<y>) / std(y-<y>)
%     outlier level = lev*( max(ndi) - <ndi> )
% <y>: spline-smoothed y-vector
%
% Help: If some outlier are still inside reduce 'lev'. If too much points
%       are excluded increase 'lev'
%--------------------------------------------------------------------------
% IN: x: x-vector (monotoneously ascending, not necessarily equally spaced)
%     y: y-vector
%   lev: outlier level E [0,1] (default: 0.5)
%OUT: xnew: new x-vector without outliers
%     ynew: new y-vector without outliers
%     irem: indices of removed outliers
%--------------------------------------------------------------------------
% EX:
% x=(1:100); y=rand(1,100); y(20)=-10;y(25)=20;y(80)=-30;
% [xnew,ynew,irem] = FctDeleteOutlier(x,y,0.15);
% hold on; plot(x,y,'ok-'); plot(xnew,ynew,'rx'), hold off
%==========================================================================

if nargin<3; lev=0.15; end

[li,~] = size(x); if li==1; x=x'; end
[li,~] = size(y); if li==1; y=y'; end

% Calculate smoothed y-vector
%ys = smooth(y,pts);
ys = csaps(x, y, 0.0001, x);

% Difference between y-vector and smoothed y-vector
di = y-ys;

% Standard deviation of 'diff'
stddi = std(di);

% Calculate normalized difference vector
ndi = abs(di/stddi);
ndiavg = mean(ndi);
ndimax = max(ndi);

% Find points beyond outlier level
irem = ndi>lev*(ndimax-ndiavg);

% Remove outlier
x(irem) = NaN;

% Assign new x- and y-vector
inew = ~isnan(x);
xnew = x(inew);
ynew = y(inew);

end