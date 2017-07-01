function [Aout,phout,fout,phstd] = ...
  cpsdmean(s1,s2,fs,winrat,olap,fend,k,calcphstd)
%==========================================================================
% function [Aout,phout,fout,phstd] = ...
%   cpsdmean(s1,s2,fs,winrat,olap,fend,k,calcphstd)
%--------------------------------------------------------------------------
% May-27-2010, C. Brandt, University Nancy
% Calculation of the cross-power- and cross-phase-spectral density. 
% The deviation of the phase is included as vector 'phstd'.
% If s1 is before s2 a positive phase shift is the result.
% Oct-10-2013, C. Brandt, UC San Diego
%   - added unwrap before phase averaging (when windowing is used)
%     (If this is not done, errors at phases close to +-pi may occur.)
% May-22-2013, C. Brandt, UC San Diego
%   - the calculation of the standard deviation of the phase is very time
%     consuming: introduced option 'calcphstd' to avoid it
% May-19-2013, C. Brandt, UC San Diego
%   - changed from nfft=[] to nfft=winL
%   - removed spline procedure (to artificially increase resolution)
%   - n is replaced by the window ratio [0..1] to length of s1,s2
%     (basically equal to 1/n)
%--------------------------------------------------------------------------
% IN: s1, s2: signals (same length)
%     fs: sample frequency (Hz)
% winrat: window ratio [0..1] (in ratio to ltime)
%     olap: overlap between windows [0..1] (default 0.5)
%     fend: end frequency (Hz)
%     k: histogram parameter (amount of bars in the phase histogram)
%     calcphstd: 1: yes, calculate standard deviation for phase
%                0: no std of phase (saves time!)
%OUT: Aout: averaged cpsd-amplitude
%     phout: averaged phase (Pi)
%     fout: frequency axis (Hz)
%     phstd: standard deviation from windowed FFT of the cross-phase
%--------------------------------------------------------------------------
%EX1: s1 ~ sin(2*pi*f1*t       ) (s1 is pi/2 before s2!)
%     s2 ~ sin(2*pi*f1*t - pi/2)
%     yields a cross-phase of +pi/2 at frequency f1!
%EX2: [A,ph,frq,phstd] = cpsdmean(s1,s2,fs,n,olap,fend)
%
% EX3:
% t=(0:10000)/210e3;
% fs=1/(t(2)-t(1));
% 
% f1 = 5000;
% f2 = 5000;
% 
% noise_off = 0.01;
% noise_frq = 0.000;
% noise_pha = 0.805;
% 
% s1 = sin(2*pi*(f2*(1+noise_frq*randn(1,length(t))) ).*t   ...
%   + noise_pha*randn(1,length(t)) + 0 )                    ...
%   + noise_off*randn(1,length(t))  ;
% 
% s2 = sin(2*pi*(f1*(1+noise_frq*randn(1,length(t))) ).*t   ...
%   + noise_pha*randn(1,length(t)) -pi/2 )                  ...
%   + noise_off*randn(1,length(t))  ;
% 
% ind = 0001:10000;
% [A,ph,frq,phstd] = cpsdmean(s1(ind),s2(ind),fs,1/5,0.5,30e3);
% 
% figure(1); clf; hold on; ind=1:500;
% plot(t(ind),s1(ind),'b'); plot(t(ind),s2(ind),'r');
% title('b: s_1; r: s_2')
% figure(2); clf;
% subplot(2,1,1); plot(frq,A)
% xlabel('frequency (Hz)'); ylabel('CPSD(s1,s2)');
% subplot(2,1,2); hold on; plot(frq,ph); plot(frq,phstd,'r');
% xlabel('frequency (Hz)'); ylabel('phase(s1,s2)');
% title('blue: cross phase, red: std')
%==========================================================================

if nargin < 5; olap = 0.5;  end
if nargin < 6; fend = 30e3; end
% histogram parameter k (amount of bars in the histogram)
if nargin < 7; k    = 20;   end
if nargin < 8; calcphstd    = 1;   end

[indwin,freq] = fftwindowparameter(length(s1),winrat,olap,fs,fend);
% Length of one window
winL = indwin(1,2)-indwin(1,1)+1;
% Number of windows
N = size(indwin,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CALCULATE CPSD for n WINDOWS ("cpsd" is a MatLab-function)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
win = []; nfft = winL; ovlp = [];

 A = NaN(length(freq.total),N); % Preallocation
ph = NaN(length(freq.total),N); % Preallocation
% nfft = [];

% NEW: take +-pi into account during averaging
for i=1:N
  ind = indwin(i,1):indwin(i,2);
  S1 = s1(ind);
  S2 = s2(ind);
  [Pxy,frq] = cpsd(S1, S2, win, ovlp, nfft, fs);
  A(:,i)  = abs(Pxy);
  ph(:,i) = angle(Pxy);
end

% Cut frequency range and average
i_f = find(frq<fend);
fout = frq(i_f);
 Aout = mean( A(i_f,:),2);
% Unwrap ph, to avoid sudden phase jumps
if N>1
  ph = unwrap(ph')';
end
phout = mean(ph(i_f,:),2) /pi;




%==========================================================================
% Calculation of the phase error
%--------------------------------------------------------------------------
% The standard deviation of the phase is used as a measure of the error.
% But since the phase is periodic [-pi, pi] the error can't be calculated 
% as for linear paramters. - A problem arises when the phase is fluctuating
% close to pi or -pi. Then it jumps between pi and -pi.
% Solution: A histogram of the phases will be plottet, the maximum will be
% detected and the phase vector will be shifted by this value.

if calcphstd
% length of phase spectrum (=length of frequency spectrum)
N = size(ph,1);
ph_par = NaN(1,N);
for i = 1:N
  % put all phases belonging to one frequency in one vector a
    a = ph(i,:);
  % 1: make an phase histogram for each frequency;
    [yh, xh] = hist(a, k);
  % 2: detect x-position xmax of the maximum of the histogram
    [~, imax] = max(yh);
    xmax = xh(imax);
  % 3: substract the xmax value from the phase vector
  %    (phases p > +1 will be changed to p-2,
  %     phases p < -1 will be changed to p+2)
    a = a - xmax;
      ic = find(a>1);  a(ic) = a(ic)-2;
      ic = find(a<-1); a(ic) = a(ic)+2;
% 4. from this phase vector the std will be calculated a a measure for the
%    standard deviation of the phase phase ;
    ph_par(i) = std(a);
end
%==========================================================================

% INFO: minimum standard-deviation is "0" (points at only one value)
%phstd = (sigmamax - ph_par)./sigmamax;
phstd = ph_par(1,i_f)';
else
  phstd = [];
end

end