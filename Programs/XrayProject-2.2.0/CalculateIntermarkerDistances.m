function distances = CalculateIntermarkerDistances(markerPoints)
% Author:  Trevor O'Brien  trevor@cs.brown.edu
% Date:    November 2, 2007
% 
%          Compute pairwise inter-marker distances over all frames in a
%          motion sequence.
% 14 Feb 2009 add support for cases where MarkerA = MarkerB LJReiss
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    % Note: Markerpoint data should arrive in the following format:
    %
    %           numFrames * [x,y,z] * numMarkers
    %
    %  (This is the format specified by DLTDataViewer from XrayProject)
    %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    numMarkers = size(markerPoints, 3);
    numFrames = size(markerPoints, 1);
    
    if numMarkers >= 2
        numCombinations = nchoosek(numMarkers, 2) + numMarkers;
    else
        numCombinations = 1;
    end
    
    distances = ones(numFrames, numCombinations, 'double') * -1;

    for i = 1:numFrames
       comboCount = 1; 
       for j = 1:numMarkers
            for k = j:numMarkers
                
                dx = markerPoints(i, 1, j) - markerPoints(i, 1, k);
                dy = markerPoints(i, 2, j) - markerPoints(i, 2, k);
                dz = markerPoints(i, 3, j) - markerPoints(i, 3, k);

                % And Euclidean distances between points.
                % Make sure we don't have gaps in our data.
                if(~isnan(dx) && ~isnan(dy) && ~isnan(dz))
                    distances(i, comboCount) = sqrt(dx*dx + dy*dy + dz*dz);
                else
                    % If we have any NaNs in our data, map their intermarker
                    % distances to -1.
                    distances(i, comboCount) = -1;
                end
            
                comboCount = comboCount + 1;
            end
       end
    end


end