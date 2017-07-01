function Bz = magnetic_loop(current, r, zpos)
%==========================================================================
%function Bz = varnargout(current, radius, zpos)
%--------------------------------------------------------------------------
% MAGNETIC_LOOP(current, radius, zpos) calculates the magnetic z-field 
% component of a wire loop of the radius R in the loop axis in a distance 
% zpos from the loop center.
% Checked: Jan-15-2013, C. Brandt, Jülich
%--------------------------------------------------------------------------
% input:    current double /A
%           radius  double /m
%           zpos    double /m
% output:   Bz(zpos)    double /Tesla
%--------------------------------------------------------------------------
% EXAMPLE:  Bz = magnetic_loop(5.7, 0.03, 0.1) delivers:
%           the z-field in a distance of 10cm of a loop with
%           3cm radius and a current of 5.7A
%           Bz = 2.8324e-06 T = 2.83 µT
%==========================================================================

if nargout == 0
else
  % Bz = mu0 * current * r^2 /  ( (r^2 + z^2)^(3/2) )
  Bz = (4*pi*10^(-7))/2 .* current .* r.^2 ./((r.^2 + zpos^2)^(3/2));
end

end