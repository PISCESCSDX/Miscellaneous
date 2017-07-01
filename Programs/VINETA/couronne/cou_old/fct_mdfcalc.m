function [] = fct_mdfcalc(defch, fft_probe, zebra_start, zebra_dt, xfft, ilim)
%function [] = fct_mdfcalc(defch, fft_probe, zebra_start,
%zebra_dt, xfft, ilim)
%
% Calculates the fft-spectra, zebra-plots and kf-spectra in the current
% directory and saves all results in the 'fft_kf_calc.mat'-file.
%
% m-files NEEDED:   cou_fft64mean
%                   su_fft_nmean_spectrum
%                   cou_calc_zebra
%                   cou_kfspec
%
% input     defch           vector containing numbers of the defect ch.s
%           fft_probe       set the number of the probe-signal which should
%                           be used for the fft
%                           '-1' mean over all 64 probes!
%           zebra_start     start point of the zebra plot
%           zebra_dt        time width of the zebra plot
%           xfft            set x-fft-plot limits /kHz
%           ilim (opt)      evaluate only this MDF-files, e.g. [1 9] 
%                           (1 to 9), and not all!
%
% output    file 'fft_kf_calc.mat' containing for every mdf-cluster the
%           fft-spectrum
%
% EXAMPLE: fct_mdfcalc([36 45:47], 11, 30000, 2500, [0 25], [3 3])

if nargin < 5
    xfft=[0 25]
end;

if nargin < 4
    zebra_dt=2500;
end;

if nargin < 3
    zebra_start=30000;
end;

% sample time of couronne /s
    dt=800*1e-9;

% MDF-file handling
%==================
% make filenamelist of current directory
fn = dir('*.MDF');
if nargin < 6
    ilim(1) = 1;
    ilim(2) = length(fn);
end;
%-- automatically set the start index
start_index = str2num( fn(1).name(4:7) );


kfmax=-Inf;
% boundaries for the fft-plots
fftmax=-Inf;
fftmin=+Inf;
ctr=1;
for i=ilim(1):ilim(2)
    % load data matrix
    [A tt] = readmdf(fn(i).name);
    disp(['calculate fft-spectrum ' num2str(i) '/'  num2str(ilim(2))]);
    if fft_probe==-1
        [freq ampl mphases] = cou_fft64mean(A, dt, defch, 30, 0.5);
    else
        [freq ampl phases]=su_fft_nmean_spectrum(tt, A(:, fft_probe), 30, 0.5);
    end;
    d=find(freq<xfft(2)*1000);
    fft_freq{ctr}=freq(d);
    fft_ampl{ctr}=ampl(d);
    fft_ampl{ctr}=20*log(10*fft_ampl{ctr});
    % find min and max of all fft-plots
        if min(fft_ampl{ctr})<fftmin
            fftmin=min(fft_ampl{ctr});
        end;
        if max(fft_ampl{ctr})>fftmax
            fftmax=max(fft_ampl{ctr});
        end;

    disp(['calculate zebraplot ' num2str(i) '/'  num2str(ilim(2))]);
    %-- set defect couronne channels
    A(:, defch) = NaN;
    [zebra_time{ctr} zebra_phi{ctr} zebra_mat{ctr}] = cou_calc_zebra(A, tt, zebra_start, zebra_dt);

    disp(['calculate kf-spectrum ' num2str(i) '/'  num2str(ilim(2))]);
    mlim=[-6 6];
    fend=xfft(2)*1000; % fend in Hz!
    [kf_freq kf_mode_vec kfspectrum{ctr}] = cou_kfspec(A', tt, mlim, fend, 80, 0.5);    
    if max(max(kfspectrum{ctr}))>kfmax
        kfmax=max(max(kfspectrum{ctr}));
    end;
    ctr = ctr+1;
end;

% calculate min and maximum of the fftplot-y-axis
fftmin = floor(fftmin/10)*10;
fftmax = ceil(fftmax/10)*10;
fft_tickwdth = floor((((fftmax-10)-(fftmin+10))/3)/10)*10;
fftlimits = [fftmin fftmax fft_tickwdth];

% save all to a mat-file
save('fft_kf_calc.mat', 'xfft', 'fft_freq', 'fft_ampl', 'zebra_time', ...
    'zebra_phi', 'zebra_mat', 'kf_freq', 'kf_mode_vec', 'kfspectrum', ...
    'kfmax', 'fftlimits');

disp('Data saved to fft_kf_calc.mat');
disp('Plot with "fct_showall"!');