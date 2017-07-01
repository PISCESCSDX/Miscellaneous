function [pdf_x, pdf_y, sk, ku] = pdf(sig, n, figon)
%function [pdf_x, pdf_y, sk, ku] = pdf(sig, n, figon)
% Computes the pdf of a signal 'sig'.
% The number of intervalles is n+1.
%OUT: pdf_x: x-axis of probability distribution
%     pdf_y: y-values of the probability-distribution
%     sk: skewness
%     ku: kurtosis

if nargin<3, figon = 0; end
if nargin<2, n = 150; end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET LENGTH, STD
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  sigl   = length(sig);
  sigstd = std(sig);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NORMALIZATION to STD
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  sig = sig/sigstd;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MAKE HISTOGRAM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  [pdf_y pdf_x] = hist(sig, n);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % NORMALIZATION of the PDF
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  S = int_discrete(pdf_x, pdf_y);
  pdf_y = pdf_y ./ S;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CALCULATE SKEWNESS and KURTOSIS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  sk = skewness(sig);
  ku  = kurtosis(sig);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PLOT PDF
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if figon==1
  figure; set(gcf,'color','w');
  plotpdf(pdf_x, pdf_y, [-10 10], [0.0001 1]);
  title(['pdf   skewness: ' num2str(sk) '   kurtosis: ' num2str(k)]);
  xh = xlabel('n [\sigma]');
end