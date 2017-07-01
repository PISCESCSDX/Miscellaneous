function cameva(fn, cp, fs, r, np, wc, kmax, ipic, rvec)
%==========================================================================
%function cameva(fn, cp, fs, r, np, wc, kmax, ipic, rvec)
%--------------------------------------------------------------------------
% CAMEVA is a m-file for evaluation of camera data.
% 1. It extracts the space-time-data of the "pixel probe" array at the 
%    radius 'r' and stores it in 'data_phi-time-rxx.mat'.
% 2. It calculates the k-Wavelet spectrum at the radial position 'r' and 
%    saves it in 'KSpecWavXXX.mat'.
% 3. It extracts the r-phi data and saves it in 'data_r-phi.mat'.
%--------------------------------------------------------------------------
% IN: fn: string for camera files
%     cp: centerpixel (if not known, use centerpixeltest.m)
%     fs: sample frequency
%      r: radius where the m-wavelet-transform is calculated
%     np: number of pixel probes
%     wc: wavelet coefficients
%   kmax: maximum k for wavelet transform
%   ipic: time frames for extraction of the r-phi-data
%   rvec: r-values for extraction of the r-phi data
%--------------------------------------------------------------------------
% EX: fn = 'sym4*.tif'; cp = [90 85]; fs = 90000; r = 30; np = 64; 
%     wc = 64; kmax = 10; ipic = 1:2001; rvec = 10:70;
%==========================================================================

% Load the shift data (light fluctuations around zero)
load shift.mat

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Extraction of the whole space time matrix
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('extract space-time data ...')
[A, phi, tt, ~] = camextractcoumat(fn, fs, ipic, r, np, cp);
phit.A   = A;
phit.phi = phi;
phit.tt  = tt';
save(['data_phi-time-r' num2str(r) '.mat'], 'phit')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculate the k-wavelet-spectrogram (data stored automatically)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('calculate wavelet k-spectrum ...')
KSpecWav(A, 1, wc, phit.tt(2)-phit.tt(1), kmax);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Extract the r-phi-data for each time
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('extract r-phi-data ...')
% define camera files
a = dir(fn);
% Preallocate variables
op.B = zeros(length(ipic), np, length(rvec));

% Extraction loop
%=================
for fnum = ipic
  disp_num(fnum, ipic(end));
ctr=0;
for r = rvec
  ctr = ctr+1;
  pic = double( imread(a( fnum ).name) );
  [phi, Avec, ~ ] = camextractcou(pic, r, np, cp);
  op.B(fnum, :, ctr) = Avec;
end
end

% Save the data
%===============
rphi.r = rvec;
rphi.phi = phi;
rphi.B = op.B; %#ok<STRNU>
save('data_r-phi.mat','rphi');

end