function [x,y,t_integration] = readOceanOptics(filename)
%==========================================================================
%function [x,y] = readOceanOptics(filename)
%--------------------------------------------------------------------------
% READOCEANOPTICS reads data from filename assuming it is from OceanOptics
% Spectrometer.
% Oct-08-2013 09:47, Christian Brandt, San Diego
%---------------------------------------------------------------------INPUT
% IN: filename: string of the filename, e.g. '01.Master.Sample'
%--------------------------------------------------------------------OUTPUT
% x: trace of wavelength
% y: intensity counts
% t_integration: time of integration (msec)
%--------------------------------------------------------------------------
% Ex: [x,y] = readOceanOptics('01.Master.Sample');
%==========================================================================


% Read Integration time (msec)
[~, ln_string] = find_ascii_token(filename, 'Integration Time (msec): ');
t_integration = sscanf(ln_string, '%f' );

% Read number of pixels
[~, ln_string] = find_ascii_token(filename, 'Number of Pixels in File: ');
num_pixels = sscanf(ln_string, '%f' );

% Jump over the first lines (only info lines)
row_1 = 19;

row_end = num_pixels + row_1 -1;
range = [row_1 0  row_end 1];

% Given by Hiden Data structure
% Use '\t' to specify a tab delimiter.
delimiter_string = '\t';

A = dlmread(filename, delimiter_string, range);

x = A(:,1);
y = A(:,2);


end