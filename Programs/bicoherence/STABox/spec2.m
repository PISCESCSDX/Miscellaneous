function [] = spec2(s, fe, autosave)
% k-f spectra using 2D FFT for nx=128 probe array data
% s : signal = ntime*nprobes
% fe: sampling frequency
% autosave  data are saved if equal to 1
% F.B. 12/2005, changement en 128 01/09
% ex : spec2(data,fs,3.5)

if nargin<3, autosave=0;    end
%sig=[s; s];r=2*r;nx=128;

fe=fe*1000;
nx=128;sig=s;

s=std(s);
nt = length(sig);
nt2=ceil(nt/2);nx2=ceil(nx/2);
nx4=ceil(nx/4);nt4=ceil(nt/4);
nx8=ceil(nx/8);nt8=ceil(nt/8);
nx16=ceil(nx/16);nt16=ceil(nt/16);
dt=1/fe;
%dx=2*pi*r/nx;

tf=fft2(sig); %transfo de fourier
t=(1:nt)/fe;
w=(0:nt-1)/nt*fe;

f=w(1:nt2);
m=(0:nx2-1)/nx2/(2/nx);
%m=pi*r*(1:nx2-1)/nx2/dx;

spectr=abs(tf.*conj(tf)); %spectre de puissance

xlim=nx8;flim=nt8;
%xlim=nx4;flim=nt4;

specdb=log10(abs(spectr(1:flim,1:xlim+1)));
maxdb=max(max(specdb));mindb=min(min(specdb));
maxi=max(max(spectr(1:flim,1:xlim+1)));
mini=min(min(spectr(1:flim,1:xlim+1)));
%spectr=spectr/maxi;

%lvlcontour=[0.1 0.3 0.5:0.05:0.95];
%figure;contourf(m,f,spectr(1:nt2,1:nx2),lvlcontour);
%set(gca,'ZScale','log')
%axis([1 10000 0 8 1 maxi])
%title(['Fourier Spectrum // max =' num2str(freq1) ' Hz']);
figure;

for i=1:xlim
    mtemp(1:flim)=m(i+1);
    %line(f(1:flim),mtemp(1:flim),specdb(1:flim,i+1)');
    line(f(1:flim),mtemp(1:flim),spectr(1:flim,i+1));
    % i+1 is used to avoid m=0
    hold on
end

view(3),grid
zlabel('spectral density (a.u.)','fontsize',14);
xlabel('frequency (Hz)','fontsize',14)
ylabel('mode #','fontsize',14)
axis([1 f(flim) 0 m(xlim)+1 mini maxi]);
hold off

% ******** autosave ? *********
if autosave == 1
    fkspec.spec = spectr;
    fkspec.freq = f;
    fkspec.m    = mtemp;
    save fkspec.mat fkspec;
    disp('Data were successfully stored in file fkspec.mat')
end