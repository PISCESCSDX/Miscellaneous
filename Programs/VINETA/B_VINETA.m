function B = B_VINETA(current)
%==========================================================================
%function B = B_VINETA(current)
%--------------------------------------------------------------------------
% B_VINETA calculates VINETA B-field on the z-axis from coil current.
%--------------------------------------------------------------------------
%INPUT
% 1: current [A]
%OUTPUT
% 1: B [T]
%--------------------------------------------------------------------------
% Source of the calibration factor: Brandt taken from Zegenhagen program.
%==========================================================================

% Old values: calculated by Christian Franck
% bf = current.*.0003664+.00145;

B = current.*.0003945; 

end
