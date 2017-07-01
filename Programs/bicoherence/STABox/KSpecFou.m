function[] = KSpecFou(sig, r, npts, over, kmax, autosave, param, displ)

% k-Fourier spectrum
% sig   [nprobes,ntime] spatiotemporal data
% r     radius of the COURONNE (cm)
% npts  # of fft points.
% over  overlapping between Fourier Windows
% kmax      maximum wavenumber of the spectrum.
%           Default is the Nyquist wavenumber.
% autosave  data are saved if equal to 1
%
% if sig is a 2D matrix, spectra are computed for each element
% of the second column, and then averaged.
%
% F. Brochard   - revised 09/2006
%
% this programme uses the wft function written by ThDW
% for computing the Windowed Fourier Transform

if nargin<8,	displ = 1;	end
if nargin<7,	param = [0 0 0 0];end
if nargin<6,    autosave = 0;   end
if nargin<5,    kmax = -1;  end
if nargin<4,    over = 0;   end
if nargin<3,	npts = 64;	end
if nargin<2,	r = 3;		end
if npts<=0,	npts = 64;	end
if r<=0,	r = 1;		end
if length(param)==1,	param = [param 0 0 0];	end
if length(param)==2,	param = [param(1) param(2) 0 0];	end
if length(param)==3,	param = [param(1) param(2) param(3) 0];	end

sig=sig';

if nargin > 5
    overlap = param(3);
    if overlap<0,    overlap = 0; end
    if overlap>=100, overlap = 0; end
else
    overlap = over;
end

if r==1
    lab=['m'];lab1=['m_{1}'];lab2=['m_{2}'];
else
    lab=['k (cm^{-1})'];
    lab1=['k_{1} (cm^{-1})'];
    lab2=['k_{2} (cm^{-1})'];
end

%---- expanding the series (using periodic boundary conditions) ----
x=[sig; sig; sig; sig; sig; sig; sig; sig; sig; sig; sig; sig; sig; sig; sig; sig];
[n,ntime] = size(x);

dx=r/64;
nf = npts/2;nk2=ceil(nf/2);
kmin = 1/n/dx;			% min allowed wavenumber
kNyq = 1/dx/2;			% Nyquist wavenumber

if kmax<0,	kmax = kNyq;	end
nsmo = param(2);	if nsmo<0,	nsmo = 0;	end

kaxe = 2*(1:nf)'/nf*kmax;
kaxe2 = kaxe(1:nk2);

% ********************************************************
% ************ beginning of the temporal loop ************
% ********************************************************

for tim=1:ntime
    xtim=x(:,tim);
    [fx,waven] = wft(xtim,npts,dx,overlap,0,0);
    auto=0;
    fx(:,1) = [];
    %fy = fx;
    waven(1) = [];

    nwind = size(fx,1);				% # of ensembles
    neff = round(n/npts);			% # of independent ens.
    if nwind<2,
        error('** there are not enough spectra to average **');
    end

    waven = waven(waven<=kmax);
    nk = length(waven);
    fx = fx(:,1:nk);

    spec_tim(tim,:) = sum(fx.*conj(fx))/nwind;		% power spectral density
end

if ntime>1
    spec=mean(spec_tim);
else
    spec=spec_tim(1,:);
end

% *****************   GraphX   ****************
if displ

    figure;set(gcf,'color','w');
    semilogy(waven,spec,'r','linewidth',2)
    title('Fourier k spectrum');
    xlabel(lab,'fontsize',14); ylabel('S(k) (a.u.)','fontsize',14);
    grid;

end

% ******** autosave ? *********
if autosave == 1
    foukspec.spec = spec;
    foukspec.kaxe = waven;
    save foukspec.mat foukspec;
    disp('Data were successfully stored in file foukspec.mat')
end