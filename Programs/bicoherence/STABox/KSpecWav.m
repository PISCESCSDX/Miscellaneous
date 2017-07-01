function [wks] = KSpecWav(sig,r,nf,dt,kmax,wname)
%==========================================================================
%function [wks] = KSpecWav(sig,r,nf,dt,kmax,wname,displ)
%--------------------------------------------------------------------------
% KSpecWav calculates the k-power wavelet spectrum.
% Brochard (01.09.2006), Brandt (revised 20.09.2010)
%--------------------------------------------------------------------------
% IN: sig: space series [ntime, nprobes]
%       r: radius of the couronne (cm), r=1 yields the mode spectrum
%          [ r=1 yields k=m, because:
%            k = 2*pi/lambda, U=2*pi*r, lambda=U/m
%            k = 2*pi/(2*pi*r/m) = m/r ]
%      nf: # of wavelet-coefficients (default is 32)
%      dt: time interval between two consecutive samples
%    kmax: maximum wavenumber of the spectrum
%          (default: half of the Nyquist wavenumber)
%   wname: name of the wavelet used (default is Morlet)
%OUT: wks: structure array (kvec)
%--------------------------------------------------------------------------
% EX: wks = KSpecWav(sig, 1, 64, tt(2)-tt(1));
%==========================================================================

if nargin<6; wname='cmor1-1.5'; end
if nargin<5; kmax=-1;           end
if nargin<4; disp('4 input parameters necessary.'); return;  end

sig = sig';
[n, ntime] = size(sig);
tvec = (0:ntime-1)*dt;
% duplicate space (due to periodic boundary conditions)
sig = [sig; sig];

% guarantee that nf is even
nf = 2*ceil(nf/2);

% ds = 2*pi*r/n = distance between 2 consecutive probes
% lambda min = 2*ds = 2*pi/kmax
% => 1/k = 2*pi*r /(2*pi*n) = r / n
dx = r/n;
         
% set the correspondence coeff/scale
sigma = scal2frq(1,wname);

%==========================================================================
% Scales for the axis
%==========================================================================
% Nyquist wavenumber
kNyq = 1/dx/2;
if kmax<0
  % Maximum wavenumber for accurate analysis
  kmax = kNyq;
end

% wavenumber axis (skip k=0)
kvec = (1:nf)'/nf*kmax;
% scale axis for wavelets
scale = sigma ./ (kvec*dx);

%==========================================================================
% Calculate wavelet coefficientts (Wavelet transform)
%==========================================================================
kspec = zeros(ntime,nf);
disp('** computing k-wavelet transform **')
for i=1:ntime
  disp_num(i,ntime)
  coefs = cwt(detrend(sig(:,i)),scale,wname);
  wxj = coefs';
  % dimension of wy : ntime * nprobes * ncoefs
  % for removing edge eKSpecWavffects use: mat = wxj(33:96:,1:nf);
  mat = wxj(:,1:nf);
  % Summed < Y*(k) Y(k)> at a given time
  kspec(i,:) = sum(mat.*conj(mat));
end

if ntime>1
  % k-spectrum averaged over time
  wks.avgspec = mean(kspec);
else
  wks.avgspec = kspec(1,:);
end

%==========================================================================
% Allocate data to structures wks, int, interpolation of wks
%==========================================================================
wks.info = 'wks: wavelet calculation, int: interp. of wks';
wks.kspec  = kspec;
wks.kvec   = kvec;
wks.tvec   = tvec;
% Interpolate data
[int.tvec,int.kvec,int.kspec] = ...
  interp_matrix(wks.tvec,wks.kvec,wks.kspec',[400 400]);

%==========================================================================
% Save data
%==========================================================================
  % Check for already saved calculations
  fnbase = 'KSpecWav'; fnend = '.mat'; a = dir([fnbase '*' fnend]);
  if isempty(a)
    nfn = mkstring(fnbase,'0',1,999,fnend);
  else
    % next number
    num = str2double(a(end).name( length(fnbase)+1:end-length(fnend) ))+1;
    nfn = mkstring(fnbase,'0',num,999,fnend);    
  end
  save(nfn, 'wks', 'int');
  disp(['wavelet-k-spectrum data stored in: ' nfn])
end