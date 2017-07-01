function [f1v, f2v, bv] = wbicw(x, fs, npts, autosave, fmax, wname, param, displ)
%function [f1v, f2v, bv] = wbicw(x, fs, npts, autosave, fmax, wname, param, displ)
% WBICW calculates the wavelet f-bicoherence and the summed f-bicoherence by
% averaging wavelet frequency spectra obtained from measurements maded with
% the 64 probes of the couronne.
% x   : [ntime,nprobes] = data
% fs  :	sampling frequency [kHz], default (0) is 100000
% npts:	# of wavelet coefficients
% autosave:  data are saved if equal to 1
% fmax      maximum freq of the spectrum. 
%           Default is half of the Nyquist frequency
% wname: name of the wavelet used (default is Morlet Wavelet)
% param	param=[fmax nsmo overlap wind] where fmax is the maximum 
%		frequency, nsmo the smoothing width, overlap the degree
%		of overlapping between adjacent periodograms,and wind
%		the type of window : 0 for Hanning, 1 for none. Default
%		([0 0 0 0]) is param = [fNyquist 0 0 0]
% displ	no display if displ=0, default is with display
%
%	b	bicoherence  0<=b<=1		size [nf/2, nf]
%	B	bispectrum			size [nf/2, nf]
%   sum2bic     summed bicoherence      size [nf, 1]
%   sum2err     sum of the statistical noise    size [nf, 1]
%	freq	horiz frequency axis [Hz]	size [nf, 1]
%	freq2	vertic frequency axis [Hz]	size [nf/2, 1]
%	db	bias on b			size [nf/2, nf]
%	dB	standard deviation of B		size [nf/2, nf]
%				ThDdW 12/93  -  FB 06/06
%   
% ex: wbicw(data(1:10:44850,:),fs/10,128,0,30000,'cgau6',[30000 4 50 0])
%     wbicw(data(1:10:44850,1),fs/10,128,0,15000,'cmor1-1.5')


if nargin<8, displ = 1;         end
if nargin<7, param = [0 0 0 0]; end
if nargin<6, wname='cmor1-1.5'; end
if nargin<5, fmax = -1;         end
if nargin<4, autosave = 0;      end
if nargin<3, npts = 128;        end
if nargin<2, fs = 100000;       end
if npts<=0,	 npts = 64;         end
if fs<=0,	   fs = 1;            end
if length(param)==1,	param = [param 0 0 0];	end
if length(param)==2,	param = [param(1) param(2) 0 0];	end
if length(param)==3,	param = [param(1) param(2) param(3) 0];	end

[ntime,nsig] = size(x);
n=ntime; dt=1/fs;
nf = npts/2;nf2=ceil(nf/2);
auto = 1; 
sigma= scal2frq(1,wname);

% ---- scale axis ----
fmin = 2/n/dt;			% min allowed frequency
fNyq = 1/dt/2;			% Nyquist frequency
if fmax<0,  fmax = fNyq/2;  end
freq = (1:nf)'/nf*(fmax-fmin);	% frequency axis (skip f=0)
freq=freq+fmin;
freq2 = freq(1:nf2);            % half frequency axis
scale = sigma ./ (freq*dt);		% scale axis for wavelets

% ---- wavelet coefficients ----
for j=1:nsig
	disp(['data set ',int2str(nsig-j+1)])
	coefs = cwt(detrend(x(:,j)),scale,wname);   % wavelet coefficients
    wxj=coefs';     % transposed matrix
	%size(wxj) = ntime * ncoeffs (= neff * nf)
    fx(1+(j-1)*ntime:j*ntime,:)=wxj;
end

freq1 = freq;
fx(:,1) = [];				% remove DC component
fy = fx;
freq1(1) = [];

%--------------------------

nwind = size(fx,1);				% # of ensembles
neff = round(n/npts);				% # of independent ens.
if nwind<2,
        error('** there are not enough spectra to average **');
end

fmax = param(1);	if fmax<=0,	fmax = fNyq;	end
nsmo = param(2);	if nsmo<0,	nsmo = 0;	end
freq1 = freq1(freq1<=fmax);
nf = length(freq1);
nf2 = fix(nf/2);
nf3 = nf + nf2;
fx = fx(:,1:nf);
fy = fy(:,1:nf);
freq2 = freq1(1:nf2);
if nf2<1, error('** frequency range is too small **');	end

B = zeros(nf3,nf+1);
Pxx = B;  Py = B;  Pyy = B;
sub_Pxx = zeros(nf,1);
sub_B = zeros(nf,1);
yy  = zeros(nf,1);
spec = sum(fx.*conj(fx))/nwind;		% power spectral density

%------------------------------
%--- bispectrum calculation ---
%------------------------------

for i=1:nf
	npos = fix(i/2);
	nneg = nf-i;
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
		ind1 = nf+(1:npos)';
		ind2 = nf+1+i-ind1;
		w = ind1 + (ind2-1)*nf3;
		Pxx(w) = sub_Pxx(wpos-1);
		B(w) = sub_B(wpos-1);
		Py(w) = yy(i)*ones(npos,1);
	end	
	if nneg>0
		ind1 = nf-(1:nneg)';
		ind2 = nf+1+i-ind1;
		w = ind1 + (ind2-1)*nf3;
		Pxx(w) = sub_Pxx(wneg-1);
		B(w) = sub_B(wneg-1);
		Py(w) = yy(i)*ones(nneg,1);
	end	
end

B = B/nwind;
Pxx = Pxx/nwind;
Py = Py/nwind;
f2 = [-freq1(nf-1:-1:1); 0; freq2];
f1 = [0; freq1];

iz = find(B==0);
if nsmo>1,
	Pxx = smooth(smooth(Pxx,nsmo).',nsmo).';	% smooth Pxx
	Py = smooth(smooth(Py,nsmo).',nsmo).';		% smooth Py
end

b = (B.*conj(B)) ./ (Pxx.*Py + eps);
b(iz)  = b(iz)+NaN;

if displ
    bispect = 0;

	df = mean(diff(f1))/2;
	ax1 = [0-df*1.1 fmax+df*1.1 -fmax fmax/2+df*1.1];
  
	maxb = max(b(~isnan(b)));

	[f1v,f2v,bv] = vertex(f1,f2,b);	% correct for missing vertexes	
    % full bicoherence with negative frequencies
    scrsz = get(0,'ScreenSize');    % size of the screen
    %figure('Position',[1 scrsz(4) scrsz(3)*.5 scrsz(4)*0.8]) %figure with aspect ratio
    %set(gcf,'color','w');
    %pcolor(f1v,f2v,bv),shading('interp');
    %title('b(f_{1},f_{2})^{2}'),colormap(pastell)
    %xlabel('F_{1} [kHz]','fontsize',14)
	%ylabel('F_{2} [kHz]','fontsize',14)
    %grid;

	%axes('Position',pos2)
	figure;set(gcf,'color','w');
    subplot(211)
    semilogy(freq1,spec)
    xlabel('Frequency [kHz]','fontsize',14)
    ylabel('S(f) (a.u)','fontsize',12)
	ax2 = axis;
    spmax=max(spec);spmin=min(spec);
	axis([0 fmax/2 0.5*spmin 2*spmax])
	grid
    
end

% --------- Summed bicoherence
% The sum is made over all frequencies satisfying the resonance condition
% f3 = f1 +/- f2 + eps, in the intervall [0 ; fNyq], where eps is defined
% as the frequency difference between two consecutive wavelet coefficients.
% samp is the # of triplets satisfying this relation

[lim2,lim1]=size(b);

sum2bic(1:lim1)=0;
sum2err(1:lim1)=0;
samp=0;

for i=2:lim1
    for j=2:lim1
        for k=2:lim2
            if b(k,j)>=0
                Fres=f1(i)-f1(i-1);
                if abs(f1(i)-f1(j)-f2(k))<Fres|abs(f1(i)-f1(j)+f2(k))<Fres
                    d1=abs(f1(j));d2=abs(f2(k));
                    d3=abs(f1(j)+f2(k));
                    
                    err(k,j) = (1/(min([d1 d2 d3])*2*n*dt+eps));%/sqrt(64);
                                   
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
bictot=sum(sum2bic)%/lim1
bictoterr=sum(sum2err)

% ----- removing values for k<kmin
ind=1;

while f1(ind)<freq1(1)+1
    sum2bic(ind)=NaN;sum2err(ind)=NaN;
    ind=ind+1;
end

if displ
    subplot(212)
    plot(f1,sum2bic,'b',f1,sum2err,':m')
    title(['summed bicoherence and noise level, \Sigma b_{f}^{2}=' num2str(bictot)])
    xlabel('F [kHz]','fontsize',14)
    ylabel('b^{2}(f)','fontsize',14)
    maxi=max([max(sum2bic(2:lim1)) sum2err(4:lim1)]);
    axis([0 fmax/2 0 maxi])
    grid
end

% ******** autosave ? *********
if autosave == 1
    wavfbic.b  = bv;
    wavfbic.f1 = f1v;
    wavfbic.f2 = f2v;
    wavfbic.sumb= sum2bic;
    wavfbic.serr= sum2err;
    wavfbic.fax = f1;
    save wavfbic.mat wavfbic;
    disp('Data were successfully stored in file wavfbic.mat')
end