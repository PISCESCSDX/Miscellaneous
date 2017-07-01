function [wfs] = FSpecWav(sig, nf, dt, fmax, wname)
%==========================================================================
%function [wfs] = FSpecWav(sig, nf, dt, fmax, wname)
%--------------------------------------------------------------------------
% FSpecWav calculates the f-power wavelet spectrum.
% Brochard (2006), Brandt (revised 01.10.2010)
%--------------------------------------------------------------------------
% IN: sig: space series [ntime, nprobes]
%      nf: # of wavelet-coefficients
%      dt: time interval between two consecutive samples
%    fmax: maximum frequency of the spectrum
%          (default: half of the Nyquist frequency)
%   wname: name of the wavelet used (default is Morlet)
%OUT: wfs: structure array (fvec,spec)
%--------------------------------------------------------------------------
% EX: wfs = FSpecWav(sig, 64, tt(2)-tt(1), 30e3);
%==========================================================================

%function [wsp] = wspec(sig, fs, nf, fmax, wname, display)

if nargin<5; wname = 'cmor1-1.5'; end
if nargin<4; fmax = -1;           end
if nargin<3; disp('3 input parameters necessary.'); return;  end

[ntime, nsig] = size(sig);
n = ntime;

% set the correspondence coeff/scale
sigma = scal2frq(1,wname);

% calculate sample frequency
fs = 1/dt;

% min allowed frequency
fmin = 2/ntime/dt;
% Nyquist frequency
fNyq = fs/2;
if fmax<0; fmax = fNyq/2; end

% frequency axis (skip f=0)
freq = (1:nf)'/nf*(fmax-fmin);
freq=freq+fmin;
% scale axis for wavelets
scale = sigma ./ (freq*dt);
timscale = dt:dt:ntime*dt;   timscale = timscale-timscale(1);

disp('** computing f-wavelet transform **')
% ---------- performing spectra calculation ------------
for j=1:nsig
	disp(['data set ',int2str(nsig-j+1)])
  % Calculate wavelet coefficients
	coefs = cwt(detrend(sig(:,j)),scale,wname);
  % transposed matrix
    wxj=coefs';     
	% size(wxj) = ntime * ncoeffs (= neff * nf)
    fx(1+(j-1)*ntime:j*ntime,:)=wxj;


freq1 = freq;
% remove DC component
fx(:,1) = [];
freq1(1) = [];

%--------------------------

% # number of ensembles
nwind = size(fx,1);
if nwind<2,
  error('** there are not enough spectra to average **');
end

freq1 = freq1(freq1<=fmax);
nf = length(freq1);
nf2 = fix(nf/2);
fx = fx(:,1:nf);

if nf2<1; error('** frequency range is too small **'); end

clear fx
end

%==========================================================================
% Allocate data to structures wfs, int, interpolation of wfs
%==========================================================================
wfs.info = 'wfs: wavelet calculation, int: interp. of wks';
wfs.tvec = timscale;
wfs.fvec = freq;
wfs.fspec= abs(coefs);
wfs.avgsp = mean(abs(coefs),2);

% Interpolate data
[int.tvec,int.fvec,int.fspec] = ...
  interp_matrix(wfs.tvec,wfs.fvec,wfs.fspec,[400 400]);

%==========================================================================
% Save data
%==========================================================================
  % Check for already saved calculations
  fnbase = 'FSpecWav'; fnend = '.mat'; a = dir([fnbase '*' fnend]);
  if isempty(a)
    nfn = mkstring(fnbase,'0',1,999,fnend);
  else
    % next number
    num = str2double(a(end).name( length(fnbase)+1:end-length(fnend) ))+1;
    nfn = mkstring(fnbase,'0',num,999,fnend);    
  end
  save(nfn, 'wfs', 'int');
  disp(['wavelet-f-spectrum data stored in: ' nfn])


end