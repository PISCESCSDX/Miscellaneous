function [h1, h2] = plotfftpdf(fftvar, pdfvar)
%function [] = plotfftpdf(fftvar, pdfvar)
% m-files needed:
% IN: frq: freq axis [kHz]
%     Axy:  CPSD amplitude
%     Phxy: CPSD phase
%OUT: plot of the cpsd-spectrum and cpsdphase-spectrum
% EX: plotfftphase(frq, Axy, Phxy)

if nargin<2; error('Input arguments are missing!'); end


figeps(10,9,1); clf
    axes('Position', [0.22 0.60 0.70 0.36]);
    h1 = subplotfft(fftvar.f, fftvar.A, '', 'S [dB]');
    
    axes('Position', [0.22 0.15 0.70 0.36]);
    h2 = subplotpdf(pdfvar.x, pdfvar.y, pdfvar.xlim, pdfvar.ylim);

end