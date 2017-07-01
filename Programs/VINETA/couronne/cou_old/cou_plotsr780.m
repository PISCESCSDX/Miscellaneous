function [] = cou_plotsr780(freq, ampl, fs, freq_dw, freq_ex)
%
%
%function [] = cou_plotsr780(freq, ampl, fs, freq_dw, freq_ex)
%
% cou_plotsr780 plots the spectrum measured with the SR780 spectrum
% analyzer.
%
% input     freq        frequency axis
%           ampl        amplitudes
%           fs          (optional) font size
%           freq_dw     (optional) double: f of the drift wave (kHz)
%           freq_ex     (optional) double: f of the exciter (kHz)
%
% output    figure with plot of the fft-spectrum
%
% EXAMPLE:  cou_plotsr780(freq, ampl, 18)

    if nargin < 5
        freq_ex= NaN;
    end
    if nargin < 4
        freq_dw= '';
    end
    if nargin < 3
        fs= 18;
    end

%-- plot fft-spectrum
%-- set position    
    ah= gca();
    set(ah, 'position', [0.15, 0.15, 0.80, 0.80]);
%-- frequency axis in kHz
    freq=freq/1e3;
%-- plot fft-spectrum    
    ph=plot(freq, ampl, 'k');
    box on;
    set(gca,'Fontsize',fs)
%-- set labels    
    xlabel('f /kHz');
    ylabel('S /dB')
%-- set frequency axis limits - ends at a multiple of 5 kHz
    fmax=floor(freq(length(freq))/5)*5;
    xlim([0, fmax]);
%-- get the axis limits
    xpos=get(gca, 'xlim');
        xwidth=xpos(2)-xpos(1);
    ypos=get(gca, 'ylim');    
        ywidth=ypos(2)-ypos(1);
%-- optionally puts the drift wave frequency to the graph
    if isempty(freq_dw)
    else
        if isnan(freq_ex)
        else        
            text(0.6*xwidth+xpos(1) , 0.7*ywidth+ypos(1) , ['f_{ex}=' num2str(freq_ex, '%.2f') ' kHz'], 'Fontsize', fs);
        end;
        text(0.6*xwidth+xpos(1) , 0.8*ywidth+ypos(1) , freq_dw, 'Fontsize', fs);        
    end;
%-- optionally puts a line of the exciter frequency to the graph
    if isnan(freq_ex)
    else
        line([abs(freq_ex) abs(freq_ex)] ,[ypos(1) 0.25*ywidth+ypos(1)], 'LineWidth', 1, 'Color' ,'k');
        text(abs(freq_ex)+0.1 , 0.1*ywidth+ypos(1) , 'f_{ex}', 'Fontsize', fs);                
    end;

end