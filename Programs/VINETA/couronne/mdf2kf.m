function [] = mdf2kf(num, flim, mlim, wl, defch)
%function [] = mdf2kf(num, flim, mlim, wl, defch)
%
% m-files needed:   readmdf, mat2kf, plotkf
% input:    num     xxxx number of "couxxxx.MDF" file
%           flim    limits of freq-axis: [fmin fmax] /Hz
%           mlim    limits of m-axis: [mmin mmax]
%           defch   vector with defect channels
% output:   plot of the kf-spectrum
%
% EXAMPLE:  mdf2kf(151, [0 25e3], [0 8], 80, []);

fonts = 14;

if nargin<5
    defch = [];
end;

if nargin<4
    wl = 50;
end;

if nargin<3
    mlim=[0 8];
end;

if nargin<2
    flim=[0 25e3];
end;


    fname = my_filename(num, 4, 'cou', '.MDF');
    [A tt] = readmdf(fname); A=A';

    A = normmat_std(A, tt, 700, 0);

    [freq, mvec, kfmat, kfaxis] = mat2kf(A, tt, flim, mlim, wl, defch);

    plotkf(freq, mvec, kfmat, kfaxis);

end