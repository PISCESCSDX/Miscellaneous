%! /file MeasureAccuracy.m
%! /brief (Should be renamed MeasureAccuracy.m)  This function measure and
%! provides various accuracy statistics on a set of corresponding control
%! point pairs.  Mean error, max error, sum of squared errors, standard
%! deviation are all provided for both x and y individually, and their
%! combination as a Euclidean distance.

function [meanError, maxError, squaredDistances, stdDev, chiSquared, ...
          meanX, meanY, xSq, ySq, xDev, yDev] = ...
                                xMeasureAccuracy(InputPoints, BasePoints)

    % Keep track of three different error measurements between control
    % point pairs.
    %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
    % Sum of all squared distances.
    squaredDistances = 0;
    
    % Max error.  (Max straight line distance between any given control
    % point pair.)
    maxDistance = 0;
    
    % Sum of all straight line distances.
    distances = 0;
    
    squaredResiduals = zeros(size(BasePoints, 1), 1);
    residuals = zeros(size(BasePoints, 1), 1);
    
    xResidual = zeros(size(BasePoints, 1), 1);
    yResidual = zeros(size(BasePoints, 1), 1);
    
    % Let's loop through all of our control point pairs.
    for i= 1:size(BasePoints, 1)

        distanceSquared = (BasePoints(i, 1) - InputPoints(i, 1))^2 + ...
            (BasePoints(i, 2) - InputPoints(i, 2))^2;

        squaredResiduals(i) = distanceSquared;
        residuals(i) = sqrt(distanceSquared);
        
        squaredDistances = squaredDistances + distanceSquared;

        distances = distances + sqrt(distanceSquared);

        if(distanceSquared > maxDistance)
            maxDistance = distanceSquared;
        end
        
        xResidual(i) = BasePoints(i, 1) - InputPoints(i, 1);
        yResidual(i) = BasePoints(i, 2) - InputPoints(i, 2);
        
        xResSq(i) = xResidual(i) * xResidual(i);
        yResSq(i) = yResidual(i) * yResidual(i);
    end

    % For now, report back the mean, and max errors for the given control
    % points.
    meanError = mean(residuals);
    maxError = sqrt(maxDistance);
    
    xResidual = abs(xResidual);
    yResidual = abs(yResidual);
    
    meanX = mean(xResidual);
    meanY = mean(yResidual);
    
    xSq = sum(xResSq);
    ySq = sum(yResSq);
    
    xDev = std(xResidual);
    yDev = std(yResidual);
    
    stdDev = std(residuals');
    
    chiSquared = squaredDistances / (stdDev * stdDev);
   
    
end
