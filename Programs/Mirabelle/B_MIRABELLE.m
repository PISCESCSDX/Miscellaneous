function B = B_Mirabelle(current)
%==========================================================================
% B_MIRABELLE calculates the magnetic field strength on the z-axis of the
% MIRABELLE device in Nancy.
%--------------------------------------------------------------------------
%INPUT
% 1: current [A]
%OUTPUT
% 1: B [T]
%==========================================================================

% Source for the calibration factor: Stella
B = current*114e-6;

end