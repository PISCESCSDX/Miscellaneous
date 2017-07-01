function plotcou(num, ch, xlb, numlist, tint);
%function plotcou(num, ch, xlb, numlist, tint);
% Plot in one line: timerow, fft-spectrum, zebra-plot, kf-spectrum.
% You can chose wether the xlabels in the time, fft and zebra-plot
% are plotted.
%
% needs:    cnm*.BIN files of measurement (create with mdf2bin.m)
%           kf.mat-file produced by cnmeva
%           fft.mat-file produced by cnmeva
% input:    num     number of measurement
%           ch      channel
%           xlb (opt)   1: xlabels on, 0: xlabels off
%           numlist (opt) vector of numbers of measurements which should be
%                   taken into account for normalizing the y-axis of
%           tint    time interval of time- and zebra-plot
% output:   One plot with: time-, fft-, zebra-, kf-plot
%
% EXAMPLE: plotcou(num, ch, xlb, numlist, tint);
% EXAMPLE: plotcou(1, 1, 1, [1 2 3], 4);

if nargin < 5; tint = -1; end;
if nargin < 4; numlist = []; end;
if nargin < 3; xlb = 1; end;
if nargin < 2; ch = 1; end;
if nargin < 1; error('Number of measurement is missing!'); end;


fonts = 14;

set(gcf,'PaperUnits','centimeters','PaperType','a4letter', ...
        'PaperPosition',[0 0 34 7], 'Color', [1.0 1.0 1.0]);
%-- make pictures look the same on printer and on screen
    wysiwyg;

% load data evaluated from "cnmxxxx.BIN" files with "cnmeva.m"
    load 1____tt.mat
    load 2___fft.mat
    % calculate the power spectrum and smooth
    for i=1:length(ampl)
        ampl{i} = smooth(20*log10(10*ampl{i}), 5);
    end;
    load 3_zebra.mat
    load 4____kf.mat

    % find the plot limits for the tt-, fft-, kf-plot from the numlist
    if ~isempty(numlist)
        for i=1:length(numlist)
            kfzlim(i) = kfaxis{numlist(i)}(6);
            a(i,:) = ampl{numlist(i)};
            ttamp(i,:) = tsig{numlist(i)};
        end;
    else
        kfzlim = kfaxis{num}(6);
        a = ampl{num};
        ttamp = tsig{num};
    end;
    kfaxis{num}(6) = max(kfzlim);
    fftlim = [min(min(a)) max(max(a))]; 
    ttlim = [min(min(ttamp)) max(max(ttamp))]; 

% plot all into one diagram & plot graphs which have more axes
% e.g. waterfall plots at the end for print_adv
% print with cb: print_adv([0 0 1 0 0], 100, 'test.eps')
% print without cb: print_adv([0 1 0 0], 100, 'test.eps')
% for jpeg-export: print -djpeg -r400 j01.jpeg
    axes('Position', [0.06 0.20 0.15 0.65]);
        subplottt(ttrace, tsig{num}, xlb, tint, ttlim);
    axes('Position', [0.275 0.20 0.17 0.65]);
        subplotfft(freq, ampl{num}, xlb, fftlim);
    axes('Position', [0.50 0.20 0.21 0.65]);
        subplotzebra(zt, phi, zA{num}, xlb, tint);
%        subplotzebra(zt, phi, zA{num}, xlb, tint);        
    axes('Position', [0.77 0.17 0.2 0.87]);
        subplotkf(kff, kfm, kfmat{num}, kfaxis{num});

end