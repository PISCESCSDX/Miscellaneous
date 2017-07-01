function [freq mode_vec kfsp] = cou_kfspec(mat, time, mlim, fend, win_length, win_olap)
%function [freq mode_vec kfsp] = cou_kfspec(mat, time, mlim, fend,
%win_length, win_olap)
%
% NEEDS     cou_kf_fftmean
%           interp_matrix
%           normmat_std
%
% input     mat         matrix [n x 64] n sample, 64 channels (2pi)
%           time        vector [n x 1] time in s
%           mlim        [mode_min mode_max]
%           fend        end of frequency axis
%           win_length  length of the window (in percent of the original data)
%           winolap     overlapping of windows (0<x<1)
%
% output    freq        frequency axis
%           mode_vec    vector with mode numbers
%           kfsp        real part of the kfsp
%
% EXAMPLE:  [kff kfm kfsp] = cou_kfspec(A, tt, mlim, fend, 30, 0.6)

% couronne measurement - delta t (we always take 800 ns)
courdt = 800e-9;

pnt = 500;

if nargin < 5
    win_olap= 0.5;
end
   
if nargin < 5
    win_length= 2;
end
   
phivec = linspace(0, 2, 64)';

% remove offset
mat = mat - mean(mean(mat));

% plot kf-spectrum
[freq kfsp] = cou_kf_fftmean(mat', courdt, win_length, win_olap);
% calculate the frequency axis
fend_ind = min(find(freq>fend));
freq = freq(1:fend_ind);
% create mode number vector
mode_vec = ((mlim(1)+1:1:mlim(2)+1)-1);
szkf = size(kfsp, 1)/2;
kfsp = circshift(kfsp, szkf);
kfsp = abs(kfsp(mlim(1)+szkf+1:mlim(2)+szkf+1, 1:fend_ind));

end