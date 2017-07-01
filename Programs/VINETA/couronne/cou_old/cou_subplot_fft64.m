function [] = cou_subplot_fft64(freq, ampl, fs, xaxislimits, yaxislimits)
%
%function [] = cou_subplot_fft64(freq, ampl, fs, freq_dw, freq_ex,
%yaxislimits)
%
% Plots the spectrum calculated from Couronne.
%
% input     freq        frequency axis /Hz
%           ampl        amplitudes
%           fs          (optional) font size
%           axislimits  ex. [-80 -10]
%
% output    subfigure with plot of the fft-spectrum
%
% EXAMPLE:  cou_plotsr780(freq, ampl, 18)

    if nargin < 5
        yaxislimits= [-80 -10];
    end
    if nargin < 4
        xaxislimits= [0 30];    % 0-30 kHz
    end
    
    if nargin < 3
        fs= 18;
    end

%-- plot fft-spectrum
%-- frequency axis in kHz
    freq=freq/1e3;
%-- plot fft-spectrum    
    ph=plot(freq, ampl, 'k');
    box on;
    set(gca,'Fontsize',fs)
%-- set labels    
    xlabel('f /kHz');
    ylabel('S /dBV');
%-- set labels    
    set(gca, 'TickLength', [0.02 0.025]);
%-- set frequency axis limits - ends at a multiple of 5 kHz
    xlim([xaxislimits(1) xaxislimits(2)]);
    ylim([yaxislimits(1) yaxislimits(2)]);    
%-- get the axis limits
    xpos=get(gca, 'xlim');
        xwidth=xpos(2)-xpos(1);
    ypos=get(gca, 'ylim');    
        ywidth=ypos(2)-ypos(1);
end