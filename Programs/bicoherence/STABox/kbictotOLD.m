function[] = kbictot(sig, r, nk, autosave, kmax, wname, param, displ)

% KBICWT calculates the k-autobicoherence and the summed k-bicoherence from
% data recorded with equispaced probes from a circular array.
%
% k-spectra are calculated for each probe, and then are summed.
% space is dupplicated in order to decrease the noise (64 => 128 pts ==> 
% noise reduced by a factor sqrt(2))and to avoid the edge effect due to the 
% wavelet decomposition.
%
% sig   : [ntime,nprobes] = data
% r     : radius of the probe array, in cm
%       (default, r=1, results in k-spectra expressed in mode # units
% nk    : # of wavelet coefficients (default = 64, better with 128)
% autosave:  data are saved if equal to 1
% kmax      maximum wavenumber of the spectrum. 
%           Default is the Nyquist wavenumber.
% wname: name of the wavelet used (default is Morlet Wavelet)
% param	: [kmax nsmo overlap wind] where kmax is the maximum 
%		wavenumber, nsmo the smoothing width, overlap the degree
%		of overlapping between adjacent periodograms,and wind
%		the type of window : 0 for Hanning, 1 for none. Default
%		([0 0 0 0]) is param = [fNyquist 0 0 0]
% displ	: no display, no movie if displ=0 (default is with display)
%
%	b	:   [nk/2, nk]  bicoherence  0<=b<=1
%	B	:   [nk/2, nk]  bispectrum
%   err :   [nk/2, nk]  maximum statistical error on the bicoherence
%   sum2bic : [nk, 1]   summed bicoherence
%   sum2err : [nk, 1]   summed error
%   spec :  [nk, 1]     k-spectrum averaged over the 64 probes
%       suffix _tim ==> this quantity at time tim
%   bictot  : [ntime, 1]  total bicoherence
%	kaxe	horiz wavenumber axis [/cm]     size [nk, 1]
%	kaxe2	vertic wavenumber axis [/cm]	size [nk/2, 1]
%
%   FB 06/06    - ThDdW 12/93
%   
% kbictot uses the vertex function written by ThDdw
%
% ex: kbictot(data(1:10:2000,:), 1, 128)

npts=nk;
if nargin<8,	displ = 1;	end
if nargin<7,	param = [0 0 0 0];end
if nargin<6,    wname='cmor1-1.5';end
if nargin<5,    kmax=-1;    end
if nargin<4,    autosave = 0;   end
if nargin<3,	nk = 64;	end
if nargin<2,	r = 1;		end
if npts<=0,	nk = 64;	end
if r<=0,	r = 1;		end
if length(param)==1,	param = [param 0 0 0];	end
if length(param)==2,	param = [param(1) param(2) 0 0];	end
if length(param)==3,	param = [param(1) param(2) param(3) 0];	end

if r==1
    lab=['m'];lab1=['m_{1}'];lab2=['m_{2}'];
else
    lab=['k (cm^{-1})'];
    lab1=['k_{1} (cm^{-1})'];
    lab2=['k_{2} (cm^{-1})'];
end

x=sig';
xxx=[x; x]; % space is dupplicated (periodic boundary conditions)

% ----- initialized values -----
[n,m] = size(x);
bictot(1:m)=0;errtot(1:m)=0;
dx=r/n;  % ds = 2*pi*r/64 = distance between 2 consecutive probes
                %lambda min = 2*ds = 2pi/kmax
                %=> 1/k = 2*pi*r /(2*pi*64) = r / 64
sigma=scal2frq(1,wname); % set the correspondence coeff/scale

% ---- scales for the axis ---- 
kmin = 1/n/dx;			% min allowed wavenumber
kNyq = 1/dx/2;			% Nyquist wavenumber
fNyq = kNyq;
if kmax<0,  kmax = kNyq;  end

kaxe = (1:nk)'/nk*kmax;     % wavenumber axis (skip k=0)
scale = sigma ./ (kaxe*dx);	% scale axis for wavelets
kaxe(1) = [];

kmax = param(1);	if kmax<=0,	kmax = kNyq;	end
nsmo = param(2);	if nsmo<0,	nsmo = 0;	end
kaxe = kaxe(kaxe<=kmax);

nk = length(kaxe);
nk2 = fix(nk/2);
nk3 = nk + nk2;

kaxe2 = kaxe(1:nk2);
if nk2<1, error('** frequency range is too small **');	end


% **********************************************
% ******* beginning of the temporal loop *******
% **********************************************
for tim=1:m

% ----- wavelet decomposition -----
coefs = cwt(detrend(xxx(:,tim)),scale,'cmor1-1.5');
wxj=coefs';
fx(:,:) = wxj(33:96,1:nk); % dimension of fx : nprobes * ncoefs
% considering the central interval [33:96] avoids edge effects
%fx(:,1) = [];				% remove DC component
fy = fx;
%--------------------------

nwind = size(fx,1);				% # of ensembles
neff = round(n/npts);			% # of independent ens.
if nwind<2,
        error('** there are not enough spectra to average **');
end

fx = fx(:,1:nk);
fy = fy(:,1:nk);

B = zeros(nk3,nk+1);
Pxx = B;  Py = B;  Pyy = B;
sub_Pxx = zeros(nk,1);
sub_B = zeros(nk,1);
yy  = zeros(nk,1);
spec = sum(fx.*conj(fx))/nwind;		% power spectral density

%--------------------------

for i=1:nk
	npos = fix(i/2);
	nneg = nk-i;
	ncol = npos+nneg+1;		% # of columns in M
	wpos = 1+(1:npos)';
	wneg = npos+1+(1:nneg)';

	M = zeros(nwind,ncol);		% the matrix for the linear syst
	M(:,1) = fx(:,i);
	for j=1:npos			% fill the part with positive freq
		M(:,j+1) = fx(:,j).*fx(:,i-j);
		sub_Pxx(j) = real(M(:,j+1)'*M(:,j+1));	% < |X(k1) X(k2)|^2 >
		sub_B(j) = fy(:,i)'*M(:,j+1);		% < Y(k)* X(k1) X(k2) >
	end
	for j=1:nneg			% now fill with negative freq
		jM = j + npos + 1;
		M(:,jM) = fx(:,i+j).*conj(fx(:,j));
		sub_Pxx(j+npos) = real(M(:,jM)'*M(:,jM));	% < |X(k1) X(k2)|^2 >
		sub_B(j+npos) = fy(:,i)'*M(:,jM);	% < Y(k)* X(k1) X(k2) >
	end

	yy(i) = real(fy(:,i)'*fy(:,i));			% < Y(k) Y(k)* >
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

B = B/nwind;
Pxx = Pxx/nwind;
Py = Py/nwind;
k2 = [-kaxe(nk-1:-1:1); 0; kaxe2];
k1 = [0; kaxe];

iz = find(B==0);
if nsmo>1,
	B = smooth(smooth(B,nsmo).',nsmo).';		% smooth B
	Pxx = smooth(smooth(Pxx,nsmo).',nsmo).';	% smooth Pxx
	Py = smooth(smooth(Py,nsmo).',nsmo).';		% smooth Py
end

b = (B.*conj(B)) ./ (Pxx.*Py + eps);
%dB = sqrt(Pxx.*Py.*(4*sqrt(3)-b)/neff/(2*nsmo+1)^2);	% stdev of B

b(iz)  = b(iz)+NaN;
%B(iz)  = B(iz)+NaN;

% --------- calculates summed bicoherence

[lim2,lim1]=size(b);
sum2bic(1:lim1)=0;
sum2err(1:lim1)=0;

% ------ Summed bicoherence ------
% The sum is made over all wavenumber satisfying the resonance condition
% k3 = k1 +/- k2, in the intervall [0 ; kNyq]
% samp is the # of triplets satisfying this relation

samp=0;
for i=1:lim1
    for j=1:lim1
        for k=1:lim2
            if b(k,j)>=0
                if k1(i)==k1(j)+k2(k)|k1(i)==k1(j)-k2(k)
                    d1=abs(k1(j));d2=abs(k2(k));
                    d3=abs(k1(j)+k2(k));
                    
                    err(k,j) = 1/(min([d1 d2 d3])*2*nk*dx+eps);
                    % error as estimated by van Milligen (PRL 74, 395
                    % (1995))
                                   
                    sum2bic(i)=sum2bic(i)+b(k,j);
                    sum2err(i)=sum2err(i)+min([err(k,j) 1]);
                    samp=samp+1;
                end
            end
        end
    end
end 

sum2bic=sum2bic/samp;   % normalization
sum2err=sum2err/samp;

% ----- total bicoherence
bictot(tim)=sum(sum2bic);
errtot(tim)=sum(sum2err);
disp(['work in progress: ' num2str(tim) '/' num2str(m)])

b_tim(tim,:,:)=b;
sum2bic_tim(tim,:)=sum2bic;
spec_tim(tim,:)=spec;

end
% ************************************************
% *********** end of the temporal loop ***********
% ************************************************

bictot=bictot;%/lim1;
errtot=errtot;%/lim1;

% --------------------
% ---     output   ---
% --------------------
% save b_tim.mat b_tim
%save sum2err.mat sum2err
%save bictot.mat bictot
%save errtot.mat errtot
%save spec_tim.mat spec_tim
%save sum2bic_tim sum2bic_tim
%save k1.mat k1

% ------  Graphx  ------

if displ==1
    bicmax=max([max(max(sum2bic_tim)) max(sum2err)]);
    specmax=max(max(spec_tim));
    specmin=min(min(spec_tim));
    
            
    % --- total bicoherence ---
    if m>9
        figure;set(gcf,'color','w');
        tscale=1:m;
        plot(tscale,bictot,'b',tscale,errtot,':m')
        xlabel('Time (a.u.)','fontsize',14)
        ylabel('(b^{k})^{2}','fontsize',14)
        title(['total k-bicoherence: \Sigma b_{k}^{2} = ', ...
            num2str(sum(bictot))])
        ax=axis; axis([1 m ax(3) ax(4)]);
    end
    
    if m>1
        spec=mean(spec_tim);
        sum2bic=mean(sum2bic_tim);
        b(:,:)=mean(b_tim);
    else
        spec=spec_tim(1,:);
    end
    
    % ---- mean power spectrum ----    
    %figure;set(gcf,'color','w');
    %semilogy(kaxe,spec,'r','linewidth',2)
    %xlabel(lab,'fontsize',14)
    %ylabel('S(k)','fontsize',14)
    %title('Mean Power Spectrum (a.u)')
    %ax2 = axis; axis([0 kmax/2 0.4*specmin 2*specmax]);
    %grid
    
    % --- autobicoherence ---
    figure;set(gcf,'color','w');
    [k1v,k2v,bv] = vertex(k1,k2,b);	% correct for missing vertexes	
    pcolor(k1v,k2v,bv),shading('interp');
    caxis([0 1]);colormap(pastell)
    colorbar; 
    xlabel(lab1,'fontsize',14)
    ylabel(lab2,'fontsize',14)
    title('k-autobicoherence')
    grid
    
    % ---- summed bicoherence ----
        
    % ----- removing values for k<kmin
    ind=1;
    while k1(ind)<kmin/2;
        sum2bic(ind)=NaN;
        sum2err(ind)=NaN;
        ind=ind+1;
    end
    
    figure;set(gcf,'color','w');
    plot(k1,sum2bic,'b',k1,sum2err,':m'),title('Summed bicoherence')
    xlabel(lab,'fontsize',14)
    ylabel('(b^{k}(a))^{2} (a.u)','fontsize',12)
    axis([0 kmax/2 0 1.1*bicmax])
    grid
    
end

% ******** autosave ? *********
if autosave == 1
    wavkbic.btot= bictot;
    wavkbic.t   = tscale;
    wavkbic.b2  = bv;
    wavkbic.k1ax= k1v;
    wavkbic.k2ax= k2v;
    wavkbic.sumb= sum2bic;
    wavkbic.serr= sum2err;
    wavkbic.kax = k1;
    wavkbic.btime   = b_tim;
    wavkbic.spectime= spec_tim;
    wavkbic.sumbtime= sum2bic_tim;
    
    save wavkbic.mat wavkbic;
    disp('Data were successfully stored in file wavkbic.mat')
end