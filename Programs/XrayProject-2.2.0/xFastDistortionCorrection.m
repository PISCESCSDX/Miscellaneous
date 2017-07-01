%! \file xFastDistortionCorrection.m
%! \brief  Given a pixel lookup table created from
%! SetupDistortionCorrection and a distorted image, this function quickly
%! transforms and resamples the image, yielding the corrected result which
%! is stored in <newImage>.

function newImage = xFastDistortionCorrection(lookupTable, image)
%      Author:  Trevor O'Brien, trevor@cs.brown.edu
%      Date:    October 30, 2007
%      
%      Using a pixel lookup table created from a spatial transformation
%      with bi-linear interpolation, transform the given image.
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% Create a resampler structure with the desired interpolation
% method.
resampler = makeresampler('cubic', 'fill');

% Determine the original size of our image.
origWidth = size(image, 2);
origHeight = size(image, 1);

% Resample and interpolate the distorted image using the
% pixel lookup table and the resampling method.
newImage = feval(resampler.resamp_fcn, image, lookupTable,...
                 [2 1], [2 1], [origHeight, origWidth, 1], [origHeight, origWidth 1],...
                 0, resampler);
             
% Determine the new size of our rotated image.
% newWidth = size(newImage, 2);
% newHeight = size(newImage, 1);
    
% Set the bottom left corner of the rectangular region to be cropped
% from the rotated image.
% xMin = newWidth/2 - origWidth/2;
% yMin = newHeight/2 - origHeight/2;
    
% Crop the appropriate region to be returned.
% newImage = imcrop(newImage, [xMin, yMin, origWidth, origHeight]);
 
end