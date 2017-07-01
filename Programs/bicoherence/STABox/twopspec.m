function [] = twopspec(siga,sigb,fs,r)
%   compute the w/k-spectrum from two probes seperated by the distance dx
%   (cm), with the sample frequency fs (Hz), r being the distance to the
%   center of the column
%   siga and sig b are the 2 time series
%   F.B.    12/05

dx=2*pi*r/64;   % distance between consecutive probes, in cm
dk=0.1;         % k-resolution (in cm-1)

n = length(siga);nlim=ceil(n/4);
dt=1/fs;time=1:n;
fmin = 2/n/dt;			% min allowed frequency
fNyq = 1/dt/2;			% Nyquist frequency
fmax = fNyq/2;

t=(1:n)/fs;
w=(0:n-1)/n*fs;
f=w(1:nlim);

%siga=siga-mean(siga);sigb=sigb-mean(sigb);
siga=siga/std(siga);sigb=sigb/std(sigb);

disp('computing Fourier Cross-Spectrum')
tfa=fft(siga,n); %    FFT
tfb=fft(sigb,n);
Sa=tfa.*conj(tfa);  % autopower spectrum on probe a
Sb=tfb.*conj(tfb);

H=tfa.*conj(tfb);   % Cross spectrum
K=atan(imag(H)./real(H))/dx;

figure;set(gcf,'color','w');
semilogy(f(1:nlim),abs(H(1:nlim)));
title('Fourier Cross-Spectrum')
xlabel('F (Hz)')
%figure;semilogy(f(1:nlim),abs(H(1:nlim).*K(1:nlim)));

disp('computing f-k spectrum')
figure;set(gcf,'color','w');
plot(f(1:nlim),K(1:nlim));
xlabel('F (Hz)'),ylabel('k (/cm)');

[Kord,Kpos]=sort(K);
Kord=Kord;
%figure;plot(Kord)
%figure;plot(Kpos)
Smin=min(Sa);
for w=1:nlim
    for k=1:n
        difk=Kord(k)-K(w);
        if (difk<dk) && (difk>0)
            Skw(k,w)=abs(0.5*(Sa(w)+Sb(w)));
        else
            Skw(k,w)=Smin;
        end
    end
end

%figure;%stem3(f(1:nlim),Kord,Skw);
%mesh(f(1:nlim),Kord,Skw);
%set(gca,'ZScale','log')

kspec=sum(Skw,2);
figure;set(gcf,'color','w');
semilogy(Kord,kspec);
xlabel('k_{\theta} (/cm)'),ylabel('Power Spectrum (a.u.)');

%figure;semilogy(Kord,smooth(kspec,10,'rlowess'))

lk=length(Kord)

for i=1:lk
    f2(i,:)=abs(H(1:nlim));
end
size(f2)

for i=1:nlim
    k2(:,i)=kspec(:);
end

kfspec=log(f2.*k2);
figure; set(gcf,'color','w');
pcolor(Kord,f(1:nlim),kfspec'),shading('flat')
xlabel('k (m^{-1})','fontsize',14);
ylabel('f (Hz)','fontsize',14);