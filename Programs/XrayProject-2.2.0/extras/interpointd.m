function [ipDist,ipMean, ipStd] = interpointd(matrix)

% function for calculated mean distances of points
numMarkers = size(matrix,2)/3;
numRows = size(matrix,1);

for i = 1:numMarkers
    tmp = matrix(:,i*3-2:i*3);
    for j = 1:numMarkers
        ipDist{i}(:,j) = rnorm((tmp)-matrix(:,j*3-2:j*3)); 
    end
end

if numRows == 1
    ipMean = cat(1,ipDist{:});
    ipStd = [];
else
    for i = 1:numMarkers
        foo = ipDist{i};
        ipMean(i,:) = nanmean(foo);
        %ipStd(i,:) = nanstd(foo)./nanmean(foo);
        ipStd(i,:) = nanstd(foo);
    end
end
% while cp <= markerCount
% 
% foo=rnorm(matrix(:,cp*3-2:cp*3)-matrix(:,(cp+1)*3-2:(cp+1)*3));
% interpointmean = [interpointmean; nanmean(foo)];
% interpointstd = [interpointstd; nanstd(foo)/nanmean(foo)];
% 
% foo=rnorm(matrix(:,cp*3-2:cp*3)-matrix(:,(cp+2)*3-2:(cp+2)*3));
% interpointmean = [interpointmean; nanmean(foo)];
% interpointstd = [interpointstd; nanstd(foo)/nanmean(foo)];
% 
% foo=rnorm(matrix(:,(cp+2)*3-2:(cp+2)*3)-matrix(:,(cp+1)*3-2:(cp+1)*3));
% interpointmean = [interpointmean; nanmean(foo)];
% interpointstd = [interpointstd; nanstd(foo)/nanmean(foo)];
% 
% cp = cp +3;
% 
% end
% 
% interpointmean(1) = [];
% interpointstd(1) = [];