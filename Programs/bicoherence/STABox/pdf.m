function [pdf_x, pdf_y, sk, k] = pdf(sig, n, smoo, figon)
%function [pdf_x, pdf_y, sk, k] = pdf(sig, n, smoo, figon)
% Computes the pdf of a signal 'sig'.
% The number of intervalles is n+1.
%IN:
%     smoo: 1: smooth, 0: no smooth
%OUT: pdf_x: x-axis of probability distribution
%     pdf_y: y-values of the probability-distribution
%     sk: skewness
%     k: kurtosis

if nargin<4, figon = 0; end
if nargin<3, smoo = 0; end
if nargin<2, n = 150; end


% GET SIZE of sig
  [len, nsig] = size(sig);

% NORMALIZATION to standard deviation
for i=1:nsig
  sig(:,i) = sig(:,i)/std(sig(:,i));
end

if nsig>1
  l=nsig*len;
  s(1:l)=0;
  for i=1:nsig
    stemp=sig(:,i);
    s=[s stemp'];
  end
else
  s=sig; l=len;
end

% SORT TIME TRACE
  [pos, ord] = sort(s);
  maxi=max(s); mini=min(s);

% make histogramm
  [pdf_y pdf_x] = hist(s,n);

% % NORMALIZATION of the PDF
  pdfint = sum(pdf_y); % equal with sample-number
  xdiff = maxi-mini;
  pdfdens = pdfint/xdiff;
  pdf_y = pdf_y/pdfdens;

% SMOOTHING
if smoo == 1
  pdf_y = smooth(pdf_y', 4);
end

% REMOVE ZEROs
  ind = find(pdf_y>0);
  pdf_x=pdf_x(ind);
  pdf_y=pdf_y(ind);  

  
% CALCULATE SKEWNESS and KURTOSIS
  sk = skewness(s);
  k  = kurtosis(s);

% PLOT PDF
if figon==1
  figure;set(gcf,'color','w');
  plot(pdf_x,pdf_y);
  title(['pdf   skewness: ' num2str(sk) '   kurtosis: ' num2str(k)]);
  xh = xlabel('n [\sigma]');
end