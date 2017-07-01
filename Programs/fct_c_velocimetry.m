function fct_c_velocimetry(filebase)
% Jun-07-2013, C. Brandt, San Diego

filename = [filebase '.cine'];

%==========================================================================
% Calculate Velocity (Triangle Method)
%--------------------------------------------------------------------------
d = 5; % !!! only odd positive integers make sense, in units of pixels
crco.winrat = 1/1; % window ratio (1 for high resolution, 0 for 0 resolution) 
crco.fend = 30e3; % Max. cut off freq.
pix2r = 1.333e-3;
indtime = 1:500;
calcphstd = 0;
Velocimetry2D_TriangleMethod(filename, indtime, d, crco, pix2r, calcphstd);
%==========================================================================

end