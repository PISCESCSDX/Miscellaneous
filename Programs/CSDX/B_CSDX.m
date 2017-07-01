function Bz = B_CSDX(Bcurr)
%==========================================================================
%function Bz = B_CSDX(Bcurr)
%--------------------------------------------------------------------------
% May-16-2013, C. Brandt, San Diego
% B_CSDX calculates the Bz-field on the center axis of the Controlled Shear
% De-correlation eXperiment (CSDX) in San Diego.
% The values fit function are taken from a formula in the laboratory.
%--------------------------------------------------------------------------
% IN:
% Bcurr: source field current (A)
%OUT:
% Bz: z-field component of B at r=0 (in Tesla)
%--------------------------------------------------------------------------
% EX: Bz = B_CSDX(100)
%     yields: Bz = 0.0316 T
%==========================================================================

% Calculate Bz at r=0
Bz = 1e-4* (3.0515*Bcurr + 10.452);

end