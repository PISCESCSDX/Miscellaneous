%! /file   xCreateLookupTable.m
%! /brief  Given an image transformation and the image resolution (which is
%! currently expected to be square), a pixel lookup table is created to
%! facilitate fast distortion correction.


function lookupTable = xCreateLookupTable(transform, size)
%      Author:  Trevor O'Brien, trevor@cs.brown.edu
%      Date:    October 29, 2007
% Modified 21 Dec 2009 LJR -- error recovery for waitbar close box
%      
%      Create a pixel lookup table for a given spatial transformation.
%       version specific to XrayProject
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% Create grid of subscripts.
grid = zeros(size(1), size(2), 2, 'double');

lut = waitbar(0,'Creating Lookup Table...');

for i=1:size(1)
    for j = 1:size(2)
        grid(i, j, 1) = i;
        grid(i, j, 2) = j;
    end
    waitbar(i/(2*size(1)),lut);
end

waitbar(i/(2*size(1)),lut, 'This step usually takes 5 to 20 minutes');
pause(0.2);
lookupTable = tforminv(grid, transform);
if exist('lut','var') close(lut);

end