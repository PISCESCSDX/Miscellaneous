function [map]=pastell(anz)
% Colormap from blue - bright blue - white - rose - red - yellow

if nargin < 1, anz = size(get(gcf,'colormap'),1); end

Y=[0.05  0.05  1.00; 0.05  0.13  1.00; 0.06  0.20  1.00; ...
   0.07  0.27  0.99; 0.09  0.35  0.99; 0.10  0.42  0.98; ...
   0.11  0.49  0.98; 0.13  0.55  0.97; 0.15  0.62  0.96; ...
   0.17  0.68  0.95; 0.19  0.74  0.95; 0.21  0.79  0.94; ...
   0.23  0.84  0.94; 0.25  0.89  0.93; 0.28  0.93  0.92; ...
   0.30  0.93  0.87; 0.33  0.93  0.83; 0.35  0.93  0.80; ...
   0.38  0.93  0.76; 0.42  0.92  0.73; 0.46  0.92  0.71; ...
   0.51  0.91  0.70; 0.55  0.91  0.70; 0.60  0.91  0.71; ...
   0.65  0.91  0.72; 0.71  0.92  0.75; 0.76  0.93  0.78; ...
   0.83  0.94  0.83; 0.89  0.96  0.89; 0.96  0.98  0.96; ...
   0.98  0.96  0.98; 0.96  0.89  0.96; 0.94  0.83  0.93; ...
   0.93  0.76  0.91; 0.92  0.71  0.88; 0.91  0.65  0.84; ...
   0.91  0.60  0.80; 0.91  0.55  0.76; 0.91  0.51  0.72; ...
   0.92  0.46  0.66; 0.92  0.42  0.61; 0.93  0.38  0.55; ...
   0.93  0.35  0.48; 0.93  0.33  0.42; 0.93  0.30  0.35; ...
   0.93  0.28  0.29; 0.93  0.29  0.25; 0.94  0.33  0.23; ...
   0.94  0.36  0.21; 0.95  0.40  0.19; 0.95  0.44  0.17; ...
   0.96  0.49  0.15; 0.97  0.55  0.13; 0.98  0.60  0.11; ...
   0.98  0.66  0.10; 0.99  0.73  0.09; 0.99  0.79  0.07; ...
   1.00  0.86  0.06; 1.00  0.93  0.05; 1.00  1.00  0.05];
   
    ind = (1:60)';
    indd= linspace(1, 60, anz)';
    map = interp1(ind, Y, indd, 'spline');
    map(map > 1)= 1;
    map(map < 0)= 0;
end