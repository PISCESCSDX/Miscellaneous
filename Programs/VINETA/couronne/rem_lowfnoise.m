function [mat] = rem_lowfnoise(A, tt, fcut)
%function [mat] = rem_lowfnoise(A, tt, fcut)
%Smooth for removal of low frequencies.
% INPUT:    A       [64xSamples] matrix with measurement data
%           tt      time trace /s
%           fcut    cut frequency (cut freq below)
% OUTPUT:   mat     normalized matrix
% EXAMPLE: [mat] = rem_lowfnoise(A, tt, fcut)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TIME step
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dt = tt(2)-tt(1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MATRIX SIZE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[rows, cols] = size(A); % rows = 64 probes

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% avoid division by zero
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fcut(fcut<500) = 500;
pts_fcut = round(1/(dt*fcut));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REMOVE LOW FREQUENCIES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i = 1:rows
  tr_lf = smooth(A(i, :)', pts_fcut);
  A(i, :) = A(i, :) - tr_lf';
end

mat = A;

end