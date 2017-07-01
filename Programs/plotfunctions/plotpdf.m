function [] = plotpdf(pdf_x, pdf_y, xlim, ylim)
%function [] = plotpdf(pdf_x, pdf_y, xlim, ylim)
%IN: pdf_x
%    pdf_y
%    xlim
%    ylim
%OUT:plot of PDF
% EX:  i=1; clf; plotpdf(pdf_x{i}, pdf_y{i}, [-6 6], [0.0001 1])

if nargin<4; ylim=[]; end
if nargin<3; xlim=[]; end
if nargin<2
  error('Input arguments are missing!');
end;

figeps(9,6,1);
  axes('Position', [0.19 0.22 0.72 0.7]);
  subplotpdf(pdf_x, pdf_y, xlim, ylim);
end
