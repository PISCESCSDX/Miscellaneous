function [fx,freq] = wft(x,npts,dt,overlap,window,trend);
%function [fx,freq] = wft(x,npts,dt,overlap,window,trend);
% DO not confuse with WFTPIECES! WFTPIECES is a wavelet transform.
%
% WFT computes the windowed Fourier transform of x using
% windows with npts data points each and a variable overlapping
% factor.
%
%IN:  x   input data (array)
%	npts	# of data per window, must be an integer power of 2
%		If npts exceeds the array length, the latter is 
%		padded with zeros. Default (0) is maximum allowed value
%	dt	Sampling period, default (0) is 1
%	overlap	Specifies overlapping (in %) between windows
%		Default (0) is 0%
%	window	Specifies type of windowing
%		0 -> Hanning window (default)
%		1 -> no window
%		2 -> Welch window
%	trend	Specifies detrending of the data
%		0 -> offset subtraction (default)
%		1 -> no correction
%		2 -> linear trend subtraction
%
%	fx	matrix with different estimates of the Fourier
%		transform (positive frequencies only). Each column
%		corresponds to a frequency
%	freq	associated frequency axis, ranging from 0 to fNyq



if nargin<6,	trend = 0;	end
if nargin<5,	overlap = 0;	end
if nargin<4,	window = 0;	end
if nargin<3,	dt = 1;		end
if nargin<2,	npts = 0;	end
if dt<=0,	dt = 1;		end

nx = length(x);
if npts<=0,	npts = 2^fix(log(nx)/log(2));	end


ratio = log(npts)/log(2);
if ratio~=fix(ratio), error('** npts must be a power of 2 **');	end

if npts>nx    					% padd x with zeros
	dnx = (npts-nx)/2;
	wind = hanning(nx);  			% apply Hanning filter
	corr = (nx/npts)*norm(wind)^2;
	wind = wind / corr;
	x = [zeros(ceil(dnx),1); x.*wind; zeros(floor(dnx),ncol)];
	nx = npts;
end


noverlap = fix(overlap/100*npts);			% overlapping in # of pts
nens = fix((nx-noverlap)/(npts-noverlap));	% number of ensembles


if window==2,					% specify the window
	wind = welch(npts);
elseif window==1
	wind = ones(npts,1);
else
	wind = hanning(npts);
end
corr = sqrt(nens)*norm(wind);			% normalizing scale factor
x = x/corr;

index = (1:npts);
nfreq = npts/2;
fNyquist = 1/dt/2;
freq = (0:nfreq)'/nfreq*fNyquist;

fx = zeros(nens,nfreq+1);
if trend==2					% remove linear trend
	M = [ones(npts,1) (1:npts)'];
	for i=1:nens
		xw = x(index) - M*(M\x(index));
		fftx = fft(xw.*wind,npts);
		fx(i,:) = fftx(1:nfreq+1).';
		index = index + (npts-noverlap);
	end
elseif trend==1					% do no correction
	for i=1:nens
		fftx = fft(x(index).*wind,npts);
		fx(i,:) = fftx(1:nfreq+1).';
		index = index + (npts-noverlap);
	end
else						% subtract average
	for i=1:nens
		fftx = fft((x(index)-sum(x(index)/npts)).*wind,npts);
		fx(i,:) = fftx(1:nfreq+1).';
		index = index + (npts-noverlap);
	end
end