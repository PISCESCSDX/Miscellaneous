function[inter,proba] = pdf(sig, n, autosave)
% computes and plots the pdf of a signal 'sig'
% the number of intervalles is n+1

if nargin<3, autosave = 0; end
if nargin<2, n = 150; end

[len,nsig]=size(sig);

% --- normalization ---
for i=1:nsig
    sig(:,i)=sig(:,i)/std(sig(:,i));
end
% ---------------------

if nsig>1
    
    l=nsig*len;
    s(1:l)=0;
    
    for i=1:nsig
        stemp=sig(:,i);
        s=[s stemp'];
    end
    
else
    s=sig;l=len;
    
end

[pos,ord]=sort(s);
maxi=max(s);mini=min(s);

step=(maxi-mini)/n;
inter=(mini:step:maxi);
proba(1:n+1)=0;

length(inter);
for t=1:l
    for i=1:n
        if (sig(t)>inter(i)) && (sig(t)<inter(i+1))
            proba(i)=proba(i)+1;
        end
    end
end

% --- normalization of the PDF ---
aire=sum(proba)/(maxi-mini);
proba=proba/aire;

k=kurtosis(proba);
sk=skewness(proba);

%save pdf.mat inter;

figure;set(gcf,'color','w');
plot(inter,proba);
title(['PDF   - Skewness: ' num2str(sk) '   - Kurtosis: ' num2str(k)]);

if autosave == 1
    PDF.pdf=proba;
    PDF.xaxis=inter;
    PDF.kurto=k;
    PDF.skew=sk;
    save PDF.mat PDF;
    disp('Data were successfully stored in file PDF.mat')
end

% ---- Basic fitting ----
%gaussian = fittype('exp(-(x-mu)*(x-mu)/(2*sigma*sigma))/(sigma*sqrt(2*pi))','dependent',{'mu','sigma'});
    %gaussian = fittype('exp(-(x-mu)*(x-mu)/(2*sigma*sigma))/(sigma*sqrt(2*pi))');
    %gfit=fit(inter',proba',gaussian)
    %hold on;plot(gfit);

%lognorm = fittype('exp(-(log(x)-mu)*(log(x-mu))/(2*sigma*sigma))/(sigma*x*sqrt(2*pi))');
%lnfit=fit(inter',proba',lognorm)
%plot(lnfit,'g');

%gammadist = fittype('1/(power(b,a)*gamma(a))*power(x,a-1)*exp(-x/b)');
%gamfit=fit(inter',proba',gammadist)
%seriehold on;plot(gamfit,'g');