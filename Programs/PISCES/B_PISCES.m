function Bz = B_PISCES(ISource, ITrim, IMain)
%==========================================================================
%function Bz = B_PISCES(ISource, ITrim, IMain)
%--------------------------------------------------------------------------
% B_PISCES calculates the Bz-field at the position z=1.00 m.
% The values for the linear dependence on source, trim and main field
% current are taken from the calculation in
% /home/data/matlab/m-files/experiments/PISCES/Bfield_small-range/
% 'B_PISCES_centervalue.m'
%--------------------------------------------------------------------------
% IN:
% ISource: source field current (A)
% ITrim:   trim field current (A)
% IMain:   main field current (A)
%OUT:
% Bz: z-field component of B at r=0, z=1.00m
%--------------------------------------------------------------------------
% EX: Bz = B_PISCES(100, 0, 250)
%     yields: Bz = 63 mT
%==========================================================================


% Source field: mT/A
parS = 4.964e-03;
% Trim field: mT/A
parT = 1.042e-02;
% Main field: mT/A
parM = 2.499e-01;

% Calculate Bz at r=0 and z=1m in Tesla
Bz = 1e-3*(ISource*parS + ITrim*parT + IMain*parM);

end