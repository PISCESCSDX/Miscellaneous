function [wkb] = kbictot(displ, sig, r, nk, kmax, nsmo)
%==========================================================================
%function [wkb] = kbictot(displ, sig, r, nk, kmax, nsmo)
%--------------------------------------------------------------------------
% KBICTOT calculates the k-autobicoherence and the summed k-bicoherence 
% from data recorded with equispaced probes from a circular array.
% k-spectra are calculated for each probe, and then are summed.
% Space is duplicated in order to decrease the noise (64 => 128 pts ==> 
% noise reduced by a factor sqrt(2))and to avoid the edge effect due to the 
% wavelet decomposition.
% KBICTOT uses the vertex function written by ThDdw.
%--------------------------------------------------------------------------
% IN:
% displ: figure on/off (1/0)
%   sig: 2D data; [ntime,nprobes]
%     r: radius of the probe array (cm); if r=1 k-spectra in mode # units
%    nk: # of wavelet coefficients
%  kmax: maximum wavenumber of the spectrum (default: Nyquist wavenumber)
%  nsmo: smoothing width
%
%OUT:
%	      b: [nk/2, nk] bicoherence  0<=b<=1
%	      B: [nk/2, nk] bispectrum
%     err: [nk/2, nk] maximum statistical error on the bicoherence
% sum2bic: [nk, 1]    summed bicoherence
% sum2err: [nk, 1]    summed error
%    spec: [nk, 1]    k-spectrum averaged over the 64 probes
%  bictot: [ntime, 1] total bicoherence
% suffix _tim ==> this quantity at time tim
%	kaxe	horiz  wavenumber axis [/cm]  size [nk  , 1]
%	kaxe2	vertic wavenumber axis [/cm]	size [nk/2, 1]
%--------------------------------------------------------------------------
% EX: [wkb] = kbictot(1, data(1:10:2000,:), 1, 128)
%     [pspec, tbic, abic, sbic] = kbictot(0, 0, A, r, 128, 16, 0)
%--------------------------------------------------------------------------
% 12.01.2011 C.Brandt
%   - added always save file: 'kbictot<num>.mat'
%   - detailed checked and clearly arranged this m-file
% xx.06.2006 F. Brochard
%==========================================================================

if nargin<6;  nsmo = 0;   end
if nargin<5;  kmax = -1;  end
if nargin<4;    nk = 128; end
if nargin<3;     r = 1;	  end

% Mode number or Wavenumber display
if r==1
  lab='m'; lab1='m_{1}'; lab2='m_{2}';
else
  lab='k (cm^{-1})'; lab1='k_{1} (cm^{-1})'; lab2='k_{2} (cm^{-1})';
end


%==========================================================================
% Prepare data
%==========================================================================
% Duplicate space (periodic boundary conditions)
  data = [sig'; sig'];                                           clear sig;
% number of repeats of 'sig' in 'data'
  L = 2;
% dim_N: theta dimension, dim_t: time dimension
  [dim_N, dim_t] = size(data);
% k-distance between two samples
  dx = L/dim_N;

%--------------------------------------------------------------------------
% Scales for the axes
%--------------------------------------------------------------------------
% Definition of minimum k
  kmin = 0.5;
% Nyquist wavenumber
  kNyq = 0.5*(1/dx);
% If input kmax<0 it should be the Nyquist k, kNyq
  if kmax<0; kmax=kNyq; end
% In order to have a k-scale with integer mode numbers kmax must be an
% integer with kmax=2^n (n E N)  ***test what happens if left
  ratio = log2(nk/kmax);
  if isequal(ratio-floor(ratio),0)==0
    kmax = nk/2.^(floor(ratio));
  end
% kmax depends on L(?) ***test what happens if left
  kmax = L*kmax;

%--------------------------------------------------------------------------
% k-axis business
%--------------------------------------------------------------------------
% wavenumber axis (skip k=0)
  kaxein = (1:nk)'/nk*kmax;
  kaxein = kaxein(kaxein>=kmin);
% scale of k scales
   % Morlet Wavelet parameter (???)
      kpsi = 6; % the smaller kpsi gets, the smaller the kscale for the 
                % wavelet coefficients gets
   kwscale = kpsi./(2*pi*kaxein);
      kaxe = kaxein/L;

% *** Beschriftung
 nk = length(kaxe);
nk2 = fix(nk/2);
nk3 = nk + nk2;

% *** Beschriftung
kaxe2 = kaxe(1:nk2);
if nk2<1, error('** space range is too small **');	end

% *** Beschriftung
bictot(1:dim_t) = 0;
errtot(1:dim_t) = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Temporal loop starts
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Allocate wavelet coefficient matrix 'wxj'
wxj = zeros(nk,size(data,1));
for tim = 1:dim_t
%--------------------------------------------------------------------------
% Calculation of Wavelet Coefficients
%--------------------------------------------------------------------------
for i = 1:nk;
  % Calculate wavelet coefficients (wc) for all the scales 'kwscale(i)'
  [wc, ~] = cwt1d(detrend(data(:,tim)), kwscale(i), 'cmorl', 'f');
  % Save wavelet coefficients in matrix 'wxj'
  wxj(i,:) = wc;
end

% Avoid edge effects by considering the central interval wxj(33:96)
fx = wxj';

% *** I think here fy is the second function. In Milligan f and g for the
% cross bi-spectrum. For the auto-bi-spectrum f=g, i.e. fy=fx.
fy = fx;

% Number of ensembles [Brandt: seems to be always equal to size(data,1)]
nwind = size(fx,1);
if nwind<2; error('** there are not enough spectra to average **'); end

%OLD fx = fx(:,1:nk); ***
%OLD fy = fy(:,1:nk); ***
% fx = fx(:,1:nk);
% fy = fy(:,1:nk);

%--------------------------------------------------------------------------
% Initialization of variables
%--------------------------------------------------------------------------
% The bispectrum 'B'
  B = zeros(nk3,nk+1);
% ***
  Pxx = zeros(nk3,nk+1);
% ***
  Py = zeros(nk3,nk+1);
% ***
  sub_Pxx = zeros(nk,1);
% ***
  sub_B = zeros(nk,1);
% ***
  yy  = zeros(nk,1);

% Power spectral density
spec = sum(fx.*conj(fx))/nwind;

%--------------------------

% Loop for all wavelet coefficients i = 1, ..., nk
for i=1:nk
	npos = fix(i/2);
	nneg = nk-i;
  % Number of columns in M
	ncol = npos+nneg+1;
	wpos = 1+(1:npos)';
	wneg = npos+1+(1:nneg)';

  % Matrix for the linear system
	M = zeros(nwind, ncol);
	M(:,1) = fx(:,i);
  % Fill the part with positive frequencies
	for j=1:npos
		M(:,j+1) = fx(:,j).*fx(:,i-j);
    % < |X(k1) X(k2)|^2 >
		sub_Pxx(j) = real(M(:,j+1)'*M(:,j+1));
    % < Y(k)* X(k1) X(k2) >
		sub_B(j) = fy(:,i)'*M(:,j+1);
  end
  % Fill with negative frequencies
	for j=1:nneg
		jM = j + npos + 1;
		M(:,jM) = fx(:,i+j).*conj(fx(:,j));
    % < |X(k1) X(k2)|^2 >
		sub_Pxx(j+npos) = real(M(:,jM)'*M(:,jM));
    % < Y(k)* X(k1) X(k2) >
		sub_B(j+npos) = fx(:,i)'*M(:,jM);
  end

  % < Y(k) Y(k)* >
	yy(i) = real(fy(:,i)'*fy(:,i));
	if npos>0
		ind1 = nk+(1:npos)';
		ind2 = nk+1+i-ind1;
		w = ind1 + (ind2-1)*nk3;
		Pxx(w) = sub_Pxx(wpos-1);
		B(w) = sub_B(wpos-1);
		Py(w) = yy(i)*ones(npos,1);
	end	
	if nneg>0
		ind1 = nk-(1:nneg)';
		ind2 = nk+1+i-ind1;
		w = ind1 + (ind2-1)*nk3;
		Pxx(w) = sub_Pxx(wneg-1);
		B(w) = sub_B(wneg-1);
		Py(w) = yy(i)*ones(nneg,1);
	end	
end

% Normalization
  B =   B/nwind;
Pxx = Pxx/nwind;
 Py =  Py/nwind;

k2 = [-kaxe(nk-1:-1:1); 0; kaxe2];
k1 = [0; kaxe];

iz = find(B==0);
% Smooth B, Pxx, and Py
if nsmo>1
	  B = smooth(smooth(B  ,nsmo).',nsmo).';
	Pxx = smooth(smooth(Pxx,nsmo).',nsmo).';
	 Py = smooth(smooth(Py ,nsmo).',nsmo).';
end

b = (B.*conj(B)) ./ (Pxx.*Py + eps);
%dB = sqrt(Pxx.*Py.*(4*sqrt(3)-b)/neff/(2*nsmo+1)^2);	% stdev of B

b(iz)  = b(iz)+NaN;
%B(iz)  = B(iz)+NaN;

%--------------------------------------------------------------------------
% Summed Bicoherence
%--------------------------------------------------------------------------
% The sum is made over all wavenumber satisfying the resonance condition
% k3 = k1 +/- k2, in the intervall [0; kNyq]
% samp is the # of triplets satisfying this relation

[lim2,lim1] = size(b);
sum2bic(1:lim1) = 0;
sum2err(1:lim1) = 0;

samp = zeros(1,lim1);
for i=1:lim1
  for j=1:lim1
    for k=1:lim2
      if b(k,j)>=0
        if k1(i)==k1(j)+k2(k) % |k1(i)==k1(j)-k2(k)
          d1 = abs(k1(j));
          d2 = abs(k2(k));
          d3 = abs(k1(j)+k2(k));
          err(k,j) = 1/(min([d1 d2 d3])*2*nk*dx + eps);
          % Error as estimated by Milligen, PRL 74, 395, (1995)
          sum2bic(i)=sum2bic(i)+b(k,j);
          sum2err(i)=sum2err(i)+min([err(k,j) 1]);
          samp(i)=samp(i)+1;
        end
      end
    end
  end
end 

% Normalization
sum2bic = sum2bic./samp;
sum2err = sum2err./samp;
% Cut below kmin
sum2err = sum2err(k1>=kmin);
sum2bic = sum2bic(k1>=kmin);

% Total bicoherence
bictot(tim) = sum(sum2bic);
errtot(tim) = sum(sum2err);

b_tim(tim,:,:) = b;
sum2bic_tim(tim,:) = sum2bic;
spec_tim(tim,:) = spec(kaxe>kmin);
sampl(tim,:)=samp;

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Temporal loop ends
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% *** Is this normalization ok?
bictot = bictot/lim1;
errtot = errtot/lim1;
kaxe = kaxe(kaxe>kmin);

% ------  Graphx  ------
tscale = 1:dim_t;
% correct for missing vertices
[k1v,k2v,bv] = vertex(k1,k2,b);
if displ==1

  figeps(20,16,2,50,50)
      
  if dim_t>1
    spec = mean(spec_tim);
    sum2bic = mean(sum2bic_tim);
    b(:,:) = mean(b_tim);
  else
    spec = spec_tim(1,:);
  end

  % ---- mean power spectrum ----    
  axes('position', [0.10 0.72 0.35 0.24])
  semilogy(kaxe,spec,'r','linewidth',2)
  set(gca, 'xlim', [kmin kmax/2])
  mkplotnice('-1', 'S(k) (arb.u.)', 12, '-20', '-30');
  te= 'average power spectrum';
  puttextonplot(gca, [0 0], 15, 105, te, 1, 12, 'k');
  %ax2 = axis; axis([0 kmax/2 0.4*specmin 2*specmax]);
  grid

  % ---- summed bicoherence ----
  k1 = k1(k1>=kmin);    
  axes('position', [0.10 0.43 0.35 0.24])
  plot(k1,sum2bic,'b',k1,sum2err,':m')
  set(gca, 'xlim', [kmin kmax/2])
  puttextonplot(gca, [0 0], 25, 105, 'summed bicoherence', 1, 12, 'k');
  mkplotnice(lab,'(b^{k}(a))^{2} (arb.u)',12,'-20','-30');
  %axis([0 kmax/2 0 1.1*bicmax])
  
  % --- total bicoherence ---
  axes('position', [0.10 0.09 0.35 0.24])
  plot(tscale,bictot,'b',tscale,errtot,':m')
  set(gca, 'ylim', [0 1]);
  mkplotnice('time (arb.u.)', '(b^{k})^{2}', 12, '-20', '-30');
  te = ['total k-bicoherence: \Sigma b_{k}^{2} = ',num2str(sum(bictot))];
  puttextonplot(gca,[0 0], 4, 80, te, 1, 12, 'k');
  grid
  
  % --- autobicoherence ---
  axes('position', [0.54 0.10 0.44 0.80])
  pcolor(k1v,k2v,bv),shading('interp');
  caxis([0 1]);colormap(pastell)
  colorbar; 
  mkplotnice(lab1,lab2,12,'-20','-30');
  title('k-autobicoherence')
  grid
end

%==========================================================================
% Output variables
%==========================================================================
tbic.t = tscale;
tbic.b = bictot;

% k-power spectrum
pspec.kax = kaxe;
pspec.spe = spec;

% bi-spectrum: auto-bicoherence
abic.k1 = k1v;
abic.k2 = k2v;
abic.b  = bv;

% summed bicoherence
     k1 = k1(k1>=kmin);
sbic.k1 = k1;
sbic.b  = sum2bic;
sbic.er = sum2err;

% Allocate Output Data to structure array wkb (wavelet-k-bicoherence)
wkb.tbic.t  = tbic.t;
wkb.tbic.b  = tbic.b;
wkb.abic.k1 = abic.k1;
wkb.abic.k2 = abic.k2;
wkb.abic.b  = abic.b;
wkb.sbic.k1 = sbic.k1;
wkb.sbic.b  = sbic.b;
wkb.sbic.er = sbic.er;
wkb.pspec.kax = pspec.kax;
wkb.pspec.spe = pspec.spe;

wkb.kax = k1;
wkb.axespec = kaxe;
wkb.btime   = b_tim;
wkb.spectime= spec_tim;
wkb.sumbtime= sum2bic_tim;

%==========================================================================
% Save data
%==========================================================================
  % Check for already saved calculations
  fnbase = 'kbictot'; fnend = '.mat'; a = dir([fnbase '*' fnend]);
  if isempty(a)
    nfn = mkstring(fnbase,'0',1,999,fnend);
  else
    % next number
    num = str2double(a(end).name( length(fnbase)+1:end-length(fnend) ))+1;
    nfn = mkstring(fnbase,'0',num,999,fnend);    
  end
  save(nfn, 'wkb');
  disp(['wavelet-k-bicoherence data stored in: ' nfn])
  
end