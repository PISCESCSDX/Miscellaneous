function Zsm = smooth2dBrandt(Z, smrow, smcol)
%==========================================================================
%function Zsm = smooth2dBrandt(Z, smrow, smcol)
%--------------------------------------------------------------------------
% SMOOTH2DBRANDT smoothes a 2D array.
% Aug-25-2013, Christian Brandt, La Jolla, UCSD
%--------------------------------------------------------------------------
%INPUT
%  Z: 2D array (monotonic spaced in both directions)
%  smrow: number of smoothing points for columns (vertical)
%  smcol: number of smoothing points for columns (horizontal)
%OUTPUT
%  Zsm: smoothed array
%--------------------------------------------------------------------------
%EXAMPLE
%  
%==========================================================================

Zsm = zeros(size(Z,1),size(Z,2));
for i=1:size(Z,1)
  Zsm(i,:) = smooth(Z(i,:),smcol);
end

for i=1:size(Z,2)
  Zsm(:,i) = smooth(Zsm(:,i),smrow);
end

end