function [num_peak] = findpeaks(fvec, spec)
%20080225-Mo-16:15 Brandt
%function [pind pheight] = findpeaks(fvec, spec)
% Find all peaks in a (linearly plotted!) frequency spectrum.
% THIS IS ONLY A COARSE MEASURE FOR THE AMOUNT OF ALL PEAKS!

% Histogramm of Amount N of points with peakheight Y:
  [N Y] = hist(spec,100);
% COUNT ALL PEAKS OVER BACKGROUND
  num_peak = sum( N(30:100) );
  
end