function  [phi, Avec, piccou] = camextractcou(pic, r, num, cp)
%==========================================================================
%function  [phi, Avec, piccou] = camextractcou(pic, r, num, cp)
%--------------------------------------------------------------------------
% CAMEXTRACTCOU exctracts an azimuthal vector (from 0..2*pi) with "num" 
% steps at a pixel radius 'r' of the camera image 'pic'.
%
% The array starts at 15 o'clock and goes around anti-clockwise, i.e., the 
% mathematical positive way.
%
% One full period will be extracted.
%--------------------------------------------------------------------------
% IN: pic: 2d data of a camera picture
%     r:   radius in units of pixels
%     num: steps on the circle
%     cp:  central pixel position = [vertical center, horizontal center]
%OUT: phi: azimuthal angle vector [0..2] (in units of pi)
%     Avec: azimuthal pixel vector (artificial probe array)
%     piccou: image with taken couronne and central pixel
%==========================================================================


% give original camera image to variable 'piccou'
piccou = pic;
% plot artificial pixel probes darker than the rest of the picture
minpic = min(min(piccou));
piccou(cp(1),cp(2)) = minpic-0.85*minpic;

% Step angle
phi_step = 2*pi/num;

% preallocate arrays
phi = zeros(1, num); Avec = zeros(1, num);
for i=1:num
  phi(i) = (i-1)*phi_step;
  ve = round(cp(1) + r*sin( phi(i) ));
  ho = round(cp(2) + r*cos( phi(i) ));
  Avec(i) = pic(ve,ho);
  piccou(ve,ho) = minpic-0.05*minpic;
end
phi = phi'/pi;

end