function [sb, bic, bicv, lgB, appz] = fbicFou(auto, A, dt, npts, param, displ)
%function [sb, bic, bicv, lgB, appz] = fbicFou(auto, A, dt, npts,
% param, displ)
% fbicFou calculates the Auto-Fourier-bicoherence and summed bicoherence of a 
% signal array A. The data are divided into windows of npts data points 
% whose spectra are summed.
% x[n,1] array for autobicoherence or [n,2] matrix for cross-bicoherence.
%
%IN: auto: 1: auto-bicoherence
%          0: cross bicoherence -> A can be a timerow matrix
%    A     signal array
%    dt    sampling period [s] (=1/fsample)
%    npts  data points per window (power of 2, default (0) is 32)
%    param = [fmax nsmo overlap wind] (default [0 0 0 0]=[fNyquist 0 0 0])
%           fmax:    maximum frequency
%           nsmo:    smoothing width
%           overlap: % of overlap between adjacent periodograms
%           wind:    window type: 0 Hanning, 1 none
%    displ default(1): display; 0: no display
%
%OUT:mat-file containing the diagrams: bicoherence, summed bicoherence
%    sb (struct array): summed bicoherence
%       freq (1d-vec):
%       sumb (1d-vec):
%       sumerr (1d-vec):
%    bic (struct array): bicoherence
%       f1 (1d-vec):
%       f2 (1d-vec):
%       b (2d-mat):
%    bicv (struct array): vertex-bicoherence
%       f1v (1d-vec):
%       f2v (1d-vec):
%       bv (2d-mat):
%    lgB (struct array): logarithmic bicoherence
%       f1 (1d-vec):
%       f2 (1d-vec):
%       logB (2d-mat):
%    appz (struct array): mean fspectrum
%       fmax (1d-double-value):
%       fvec (1d-vec):
%       spec (1d-vec):
%
%EX:[sb,bic,bicv,lgB,appz]=fbicFou(1,A(1:1:65e3,1),dt,2^13,[30e3 4 50 0],0);
%
%OLD:fbicFou(x, dt, npts, param, displ);
%OLD:fbicFou(B(1:20:44850,2), 8e-7, 512, [30000 4 50 0], 1);
%OLD:bicoh(data(1:20:44850,2),2/123500,512,[30000 4 50 0])
%
%ThDdW 12/1993, F.Brochard 03/2006, C. Brandt 08/2007
%   ??? Warum sind die Maxima in der logar. Darstellung nicht gleich mit
%   denen in der linearen Bikohärenz-Darstellung ???
%SOME CODE DETAILS:
%=============
%	b     bicoherence: E [0,1], size: [nf/2, nf]
%	B     bispectrum: size: [nf/2, nf]
%	freq	horiz frequency axis [Hz]: size: [nf, 1]
%	freq2	vertic frequency axis [Hz]: size: [nf/2, 1]
%	db    bias on b: size: [nf/2, nf]
%	dB    standard deviation of B: size [nf/2, nf]
%	br,bi	real and imaginary bicoherence

if nargin<6; displ=1; end;
if nargin<5; param=[0 0 0 0]; end;
if nargin<4; npts=64;	end;
if nargin<3; dt=1; end;
if nargin<2; error('Intput arguments are missing'); end;
if npts<=0; npts=64; end;
if dt<=0; dt=1; end;
if length(param)==1; param=[param 0 0 0]; end;
if length(param)==2; param=[param(1) param(2) 0 0]; end;
if length(param)==3; param=[param(1) param(2) param(3) 0]; end;

% FONTSIZE
  fs = 14;
% SIZE of DATA ARRAY
  [n,m] = size(A); % n: time samples; m: time rows
% SET NYQUIST LIMIT
  nf = npts/2;
  

% SET OUTPUT variables to mean
  sb.sumb   = 0;
  sb.sumerr = 0;
  bic.b     = 0;
  bicv.bv   = 0;
  lgB.logB  = 0;
  appz.spec = 0;
% BEGIN of the "BIG FOR-LOOP"
%=========================================  
for iarray=1:m
  iarray; % *** show iarray
% CHECK for AUTO- or CROSS-BICOHERENCE and SET
% auto -> 1: autobicoherence, or 0: cross-bicoherence
  if auto == 0; y=A(:,2); x=A(:,1); end;
  if auto == 1; x=A(:,iarray); y=A(:,iarray); end;
  
% test wether overlap is between [0,100] %
  overlap = param(3);
  if overlap<0; overlap=0; end;
  if overlap>=100; overlap=0; end;

% FOURIER-TRANSFORMATION of signal array x
% dependent on the auto- or cross-bicoherence
% ! fx and fy are complex vectors !
switch auto
  case 0 % cross-bicoherence
    [fx,freq1] = wft(x(:,1),npts,dt,overlap,0,0);
    [fy,freq1] = wft(y(:,1),npts,dt,overlap,0,0);
    % remove DC component
    fx(:,1) = [];
    % remove DC component  
    fy(:,1) = [];
    freq1(1) = [];
  case 1 % auto-bicoherence
    [fx,freq1] = wft(x,npts,dt,overlap,0,0);
    % remove DC component  
    fx(:,1) = [];
    fy = fx;
    freq1(1) = [];
  otherwise
    error('Wrong input value in parameter <auto>!');
end


% SPECTRA AVERAGE BUSINESS
  % number of ensembles
  nwind = size(fx,1);
  % number of independent ensembles
  neff = round(n/npts);
  if nwind<2,
    error('** there are not enough spectra to average **');
  end
  % Nyquist frequency
  fNyq = 1/dt/2;

% FREQUENCY BUSINESS
  fmax = param(1); if fmax<=0; fmax = fNyq; end;
  nsmo = param(2); if nsmo<0;  nsmo = 0; end;
  freq1 = freq1(freq1<=fmax);
  nf = length(freq1);
  nf2 = fix(nf/2);
  nf3 = nf + nf2;
  fx = fx(:,1:nf);
  fy = fy(:,1:nf);
  freq2 = freq1(1:nf2);
  if nf2<1; error('** frequency range is too small **'); end;

% CALCULATE the POWER SPECTRAL DENSITY of fx
  B = zeros(nf3,nf+1);
  Pxx = B;  Py = B;  Pyy = B;
  sub_Pxx = zeros(nf,1);
  sub_B = zeros(nf,1);
  yy  = zeros(nf,1);
% power spectral density
  spec = sum(fx.*conj(fx))/nwind;

% BISPECTRUM BUSINESS
%--------------------------------------------------
for i=1:nf
	npos = fix(i/2);
	nneg = nf-i;
  % # of columns in M
	ncol = npos+nneg+1;
	wpos = 1+(1:npos)';
	wneg = npos+1+(1:nneg)';

  % the matrix for the linear syst
	M = zeros(nwind,ncol);
	M(:,1) = fx(:,i);
  % fill the part with positive freq  
	for j=1:npos
		M(:,j+1) = fx(:,j).*fx(:,i-j);
    % < |X(k1) X(k2)|^2 >
      sub_Pxx(j) = real(M(:,j+1)'*M(:,j+1));
    % < Y(k)* X(k1) X(k2) >
  		sub_B(j) = fy(:,i)'*M(:,j+1);
  end;
  % now fill with negative freq
	for j=1:nneg
		jM = j + npos + 1;
		M(:,jM) = fx(:,i+j).*conj(fx(:,j));
    % < |X(k1) X(k2)|^2 >
  		sub_Pxx(j+npos) = real(M(:,jM)'*M(:,jM));
    % < Y(k)* X(k1) X(k2) >      
    	sub_B(j+npos) = fy(:,i)'*M(:,jM);
  end;
  % < Y(k) Y(k)* >
	yy(i) = real(fy(:,i)'*fy(:,i));
	if npos>0
		ind1 = nf+(1:npos)';
		ind2 = nf+1+i-ind1;
		w = ind1 + (ind2-1)*nf3;
		Pxx(w) = sub_Pxx(wpos-1);
		B(w) = sub_B(wpos-1);
		Py(w) = yy(i)*ones(npos,1);
  end;
	if nneg>0
		ind1 = nf-(1:nneg)';
		ind2 = nf+1+i-ind1;
		w = ind1 + (ind2-1)*nf3;
		Pxx(w) = sub_Pxx(wneg-1);
		B(w) = sub_B(wneg-1);
		Py(w) = yy(i)*ones(nneg,1);
  end;
end;
% END BISPECTRUM BUSINESS
%--------------------------------------------------


% NORMALIZE BISPECTRUM B
  B = B/nwind;
  Pxx = Pxx/nwind;
  Py = Py/nwind;
% create frequency vectors
  f2 = [-freq1(nf-1:-1:1); 0; freq2];
  f1 = [0; freq1];

% smooth spectra B, ... ?
  % is zero: iz .. index where B is zero before smoothing
  iz = find(B==0);
  if nsmo>1,
    B = smooth(smooth(B,nsmo).',nsmo).';
    Pxx = smooth(smooth(Pxx,nsmo).',nsmo).';
    Py = smooth(smooth(Py,nsmo).',nsmo).';
  end

% CALULATE BICOHERENCE from bispectrum
  b = (B.*conj(B)) ./ (Pxx.*Py + eps);
  %br = (real(B).^2) ./ (Pxx.*Py + eps);
  %bi = (imag(B).^2) ./ (Pxx.*Py + eps);
% % bias on b
% db = 4*sqrt(3)/neff*fNyq./(ones(nf2,1)*freq1' + freq2*ones(1,nf));
% bias on b
  db = 4*ones(size(b))*sqrt(3) / neff / (2*nsmo+1)^2;
% stdev of B
  dB = sqrt(Pxx.*Py.*(4*sqrt(3)-b)/neff/(2*nsmo+1)^2);


% CALCULATE SUMMED BICOHERENCE
  sumb(1:nf2)=0;
  sumerr(1:nf2)=0;
for i=1:nf2
    sumb(i)=sum(b(:,i));
    sumerr(i)=sum(db(:,i));
end;


% REMOVE BAD DATA POINTS smaller than 0
  b(b<=0) = 0;
% % Hide Nyquist - Business
% % do not show the zero values (iz=iszero) in the pcolor-plots
  b(iz)  = NaN;
  br(iz) = NaN;
  bi(iz) = NaN;
  B(iz)  = NaN;
  db(iz) = NaN;
  dB(iz) = NaN;

% CORRECT BICOHERENCE MATRIX for missing vertexes (=Spitzen)
%*** vertex produces double values .. not good for interpolation!
  % f1v,f2v,bv] = vertex(f1,f2,b);
  % INTERPOLATE BICOHERENCE MATRIX
  [f1v, f2v, bv] = interpbicmat(f1, f2, b, 4);
  %***[f1v, f2v, bv] = interpbicmat(f1, f2, b, 4);  
  % with vertex interp did not work, because not monotonic increasing values  [f1v, f2v, bv] = interpbicmat(f1v, f2v, bv, 2);  

% CALCULATION for LOGARITHMIC PLOT (B=Bispectrum)
  absB = abs(B);
  % +eps to avoid log10 from zero
  logB = real(log10(absB+eps));
  % INTERPOLATE Logarithmic BICOHERENCE MATRIX
  [lgBf1, lgBf2, logB] = interpbicmat(f1, f2, logB, 4);

% --------------------------------------------------
% MEAN and OUTPUT BUSINESS
% --------------------------------------------------
% save summed bicoherence
  sb.freq = freq2;
  sb.sumb = sb.sumb + sumb;
  sb.sumerr = sb.sumerr + sumerr;
% save not interpolated bicoherence
  bic.f1 = f1;
  bic.f2 = f2;
  bic.b  = bic.b + b;
% save clipped bicoherence (vertex *** but vertex doesn't work till now)
  bicv.f1v = f1v;
  bicv.f2v = f2v;
  bicv.bv  = bicv.bv + bv;
% save logarithmic bicoherence
  lgB.f1 = lgBf1;
  lgB.f2 = lgBf2;
  lgB.logB = lgB.logB + logB;  
% save other stuff ...
  appz.fmax = fmax;
  appz.freq = freq1;
  appz.spec = appz.spec + spec;
end;
% END of the "BIG FOR-LOOP"
%=========================================
% MEAN all variables
  sb.sumb   = sb.sumb/m;
  sb.sumerr = sb.sumerr/m;
  bic.b     = bic.b/m;
  bicv.bv   = bicv.bv/m;
  lgB.logB  = lgB.logB/m;
  appz.fmax = appz.fmax/m;
  appz.spec = appz.spec/m;
%=========================================


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SAVE to FILE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nfn = filenamenext('fbic', '.mat', 4);
save(nfn, 'sb', 'bic', 'bicv', 'lgB', 'appz');
  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PLOT BUSINESS --- SHOW DIAGRAMS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if displ
% PLOT - SUMMED BICOHERENCE
  plotsumfbic(1, sb.freq, sb.sumb, sb.sumerr);
% PLOT BICOHERENCE & POWER SPECTRUM
  plotfbicpsd(2, bicv.f1v, bicv.f2v, bicv.bv, appz.freq, appz.spec);  
      % PLOT f-BICOHERENCE (not interpolated)
      %  plotfbic(3, bic.f1, bic.f2, bic.b);
% PLOT f-BICOHERENCE (interpolated)
  plotfbic(4, bicv.f1v, bicv.f2v, bicv.bv);
% PLOT LOGARITHMIC BISPECTRUM
  plotfbic(5, lgB.f1, lgB.f2, lgB.logB);
end

end