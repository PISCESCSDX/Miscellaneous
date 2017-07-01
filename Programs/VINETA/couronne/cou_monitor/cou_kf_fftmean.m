function [freq kfspectrum]= cou_kf_fftmean(mat, courdt, win_length, win_olap)
%function [freq kfspectrum]= cou_kf_fftmean(mat, courdt, win_length,
%win_olap)
% Loads the complete couronne matrix (2e16x64) and calculates the mean
% fft2d. The frequency resolution decreases with the amount of mean steps.
% 
% NEEDS     fft2d
%
% input     mat         matrix [2e16 x 64] 2e16 samples, 64 channels (2pi)
%           courdt      time for one couronne sample /s (usally 800ns)
%           win_length  length of the window (in percent of the original data)
%           winolap     overlapping of windows (0<x<1)
%
% output    freq        frequency scale
%           kfspectrum  mean complex kf values
%20070110 C. Brandt

if nargin<4
    win_olap=0.5;
end;

if nargin<3
    win_length=30;
end;

    [m n]= size(mat);    
    % calculate percent in points    
    win_length = floor(m/100*win_length);
    int = ceil(win_length*win_olap);
    steps = ceil(m-win_length)/int;
    
    kfspectrum=0; freq=0;
    for i=1:steps
        sig=mat((i-1)*int+1:(i-1)*int+win_length, :);
        % first arg of fft2d: rows-time, col-probes
        [freq1 kfspectrum1] = fft2d(sig', 1/courdt, 1);    
        % correct the hanning window back --> factor 2, because the 
        % integral of the hanning window [0 1] is 0.5 ...
        kfspectrum = 2*kfspectrum1 + kfspectrum;
        freq = freq1+freq;
    end;
    
    kfspectrum = kfspectrum/steps;
    freq = freq/steps;
    
%     size(kfspectrum);
    
end