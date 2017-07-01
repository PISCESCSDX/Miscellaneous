function [] = fct_mdfcalc_fft(defect_channels, fft_probe, xfft)

%function [] = fct_mdfcalc_fft(defect_channels, fft_probe, xfft)
%
% Calculates the fft-spectra in the current
% directory and saves all results in the 'fft_kf_calc.mat'-file.
%
% m-files NEEDED:   mdf_list
%                   mdf_read8
%                   cou_fft64mean
%                   su_fft_nmean_spectrum
%
% input     defect_channels vector containing numbers of the defect ch.s
%           fft_probe       set the number of the probe-signal which should
%                           be used for the fft
%                           '-1' mean over all 64 probes!
%           zebra_start     start point of the zebra plot
%           zebra_dt        time width of the zebra plot
%           xfft            set x-fft-plot limits /kHz
%
% output    file 'fft_calc.mat' containing for every mdf-cluster the
%           fft-spectrum
%
% EXAMPLE: fct_mdfcalc_fft([], -1, [0 25])

if nargin < 3
    xfft=[0 25]
end;

if nargin < 2
    fft_probe=-1;
end;

if nargin < 1
    defect_channels=[];
end;

% Couronne dt
dt=800e-9;

% MDF-file handling
%==================
% make filenamelist of current directory
[filenamelist error_mat error_status] = mdf_list;
i_end=length(filenamelist(1,:));
%-- automatically set the start index
%   MDF-files must have the name structur: BA000000.MDF
%   Board 1-8: BA-BH; 6 digit number; '.MDF'
b=dir('*.MDF');
start_index = str2num( b(1).name(3:8) );    


kfmax=0;
for i=1:i_end
    % load data matrix
    [A tt] = mdf_read8(i, filenamelist, defect_channels);
    A=A';
    disp(['calculate fft-spectrum ' num2str(i) '/'  num2str(i_end)]);    
    if fft_probe==-1
        [freq ampl mphases] = cou_fft64mean(A, dt, defect_channels, 99, 0.1);
    else
        [freq ampl phases]=su_fft_nmean_spectrum(tt, A(:, fft_probe), 95, 0.1);
    end;
    d=find(freq<xfft(2)*1000);
    fft_freq{i}=freq(d); fft_ampl{i}=ampl(d);
end; %for

save('fft_calc.mat', 'xfft', 'fft_freq', 'fft_ampl');
