function [fvec ampl phas] = fft64mean(A, tt, wl, ol)
%function [fvec ampl phas] = fft64mean(A, tt, wl, ol)
% fft64mean calculates the mean spectrum of all working couronne
% probes. Defect ones will be neglected.
% NEEDS     su_fftmean
% input     A       matrix [m probes x n samples] n sample, 64 channels
%                   (normal: 64 rows, ttsamples columns)
%           tt      time row
%           wl      length of the window in percent of main matrix
%           ol      value between 0 and 1
%           (interval_length = win_olap*win_length)
% output    fvec    
%           ampl
%           phas
%
% EXAMPLE:  [fvec ampl phas] = fft64mean(A, tt, 50, 0.5);

if nargin<4; ol = 0.5; end;
if nargin<3; wl = 50; end;
if nargin<2; error('Input of A and tt is missing!'); end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DISPLAY Spectrum Data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dt = tt(2)-tt(1);
TL = tt(end)-tt(1);
 T = wl/100 .* TL;
disp(['fmax: ' num2str(1/dt) ' Hz'])
disp([' D_f: ' num2str(1/T)  ' Hz'])
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculate FFT MEAN
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ctr = 0; ampl = 0; phas = 0;
for i=1:size(A,1)
  disp_num(i,size(A,1))
    if isnan(A(i, :))
    else
        Ai = A(i, :);
        [fvec i_ampl i_phas] = su_fftmean(tt, Ai', wl, ol);
        ampl = ampl + i_ampl;
        phas = phas + i_phas;
        ctr = ctr+1;
    end;
end;
ampl = ampl/ctr;
phas = phas/ctr;

end