function[] = FSpecFou(sig, fs, npts, over, fmax, autosave, param, displ)
% f-Fourier spectrum
% sig       [nprobes,ntime] spatiotemporal data
% fs        sampling frequency (Hz)
% npts      # of fft points
% over      overlapping between Fourier Windows
% fmax      maximum freq of the spectrum. 
%           Default is half of the Nyquist frequency
% autosave  data are saved if equal to 1
%
% if sig is a 2D matrix, spectra are computed for each element
% of the first column, and then averaged.
%
% F. Brochard   - revised 09/2006
%
% this programme uses the wft function written by ThDW
% for computing the Windowed Fourier Transform

if nargin<8,	displ = 1;	end
if nargin<7,	param = [0 0 0 0];end
if nargin<6,    autosave = 0;   end
if nargin<5,    fmax = -1;  end
if nargin<4,    over = 0;   end
if nargin<3,	npts = 128;	end
if nargin<2,	disp('error: no sampling frequency');		end
if npts<=0,	npts = 128;	end
if length(param)==1,	param = [param 0 0 0];	end
if length(param)==2,	param = [param(1) param(2) 0 0];	end
if length(param)==3,	param = [param(1) param(2) param(3) 0];	end

if nargin > 5
    overlap = param(3);
    if overlap<0,    overlap = 0; end
    if overlap>=100, overlap = 0; end
else
    overlap = over;
end

[ntime,nprobe] = size(sig);
nf = npts/2;nf2=ceil(nf/2);

dt=1/fs;
fNyq = 1/dt/2;              % Nyquist frequency
if fmax<0, fmax = fNyq/2;   end

% ********************************************************
% ************  beginning of the probe loop   ************
% ********************************************************

for p=1:nprobe
    sprob=sig(:,p);
    [fx,freq1] = wft(sprob,npts,dt,overlap,0,0);
    auto=0;
    fx(:,1) = [];
    freq1(1) = [];    
    
    nwind = size(fx,1);				% # of ensembles
    neff = round(ntime/npts);			% # of independent ens.
    if nwind<2,
        error('** there are not enough spectra to average **');
    end

    freq1 = freq1(freq1<=fmax);
    nk = length(freq1);
    fx = fx(:,1:nk);

    spec_p(p,:) = sum(fx.*conj(fx))/nwind;		% power spectral density
end

if nprobe>1
    spec=mean(spec_p);
else
    spec=spec_p(1,:);
end

% *****************   GraphX   ****************

if displ
    figure;set(gcf,'color','w');
    semilogy(freq1,spec,'linewidth',2)
    title('Fourier f spectrum');
    xlabel('F (kHz)','fontsize',14); ylabel('S(f) (a.u.)','fontsize',14);
    grid;
end    

% ******** autosave ? *********
% --------------------------------------------------
% SAVE to FILE
% --------------------------------------------------
if autosave == 1
  nfn = filenamenext('fspecFou', '.mat', 4);
  foufspec.spec = spec;
  foufspec.freq = freq1;
  save(nfn, 'foufspec');
  disp('Data were successfully stored in file foufspec.mat')
end;