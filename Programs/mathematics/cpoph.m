function [cpow cpha] = cpoph(s1,s2,fs,n,olap,fend,k)
%function [cpow cpha] = cpoph(sig1,sig2,fs)
% Calculates the cross power spectral density (CPSD) between the two
% signals s1 and s2 with the sample frequency fs. Signal 1 is before 
% signal 2 if the cross-phase is positive.
% IN: s1, s2: signals (same length)
%     fs: sample frequency (Hz)
%     n: amount of windows for windowing
%     olap: overlap between windows [0..1]                  (good: 0.5)
%     fend: end frequency (Hz)                              (default: 30e5)
%     k: histogram parameter (amount of bars in the phase histogram)
%OUT: cpow: cross power spectrum
%                    cpow.frq:  frequency axis
%                    cpow.spec: frequency spectrum
%     cpha: cross phase spectrum
%                    cpha.frq:  frequency axis (Hz)
%                    cpha.spec: phase spectrum [-1..1] (Pi)
%                    cpha.err:  error bars     (a.u.)
% EX: [cpow cpha] = cpoph(s1,s2,fs,n,olap,fend,k)

% Find optimal Smooth-n and n
[A, ph, f, phstd] = cpsdmean(s1, s2, fs, n, olap, fend, k);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Assign output variables
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% cross power spectrum
cpow.frq  = f;
cpow.spec = A;
  
% cross phase spectrum
cpha.frq  = f;
cpha.spec = ph;
cpha.err  = phstd;

end