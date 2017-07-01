function [] = mdf2fft(num, flim, wl, defch);
%function [] = mdf2fft(num, flim, wl, defch);
%
% m-files needed:   readmdf, mat2fft, plotfft, my_filename, plotfft
% input:    num     xxxx number of "couxxxx.MDF" file
%           flim    limits of freq-axis: [fmin fmax] /Hz
%           wl      window length
%           defch   vector with defect channels
% output:   plot of the fft-spectrum
%
% EXAMPLE:  mdf2fft(151, [0 25e3]);

if nargin<4
    defch = [];
end;

if nargin<3
    wl = 50;
end;

if nargin<2
    flim = [0 25e3];
end;


    fname = my_filename(num, 4, 'cou', '.MDF');
    [A tt] = readmdf(fname); A=A';

    [freq ampl] = mat2fft(A, tt, flim, wl, defch);
    
    plotfft(freq, ampl);
    
end