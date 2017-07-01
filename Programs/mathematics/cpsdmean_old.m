function [Amean,phmean,fspli,phstd] = cpsdmean(s1,s2,fs,n,olap,fend,k)
%==========================================================================
%function [Amean,phmean,fspli,phstd] = cpsdmean(s1,s2,fs,n,olap,fend,k)
%--------------------------------------------------------------------------
% May-27-2010, C. Brandt, Universit� Nancy
% Calculation of the cross-power- and cross-phase-spectral density. 
% The deviation of the phase is included as vector 'phstd'.
% If s1 is before s2 a positive phase shift is the result.
%--------------------------------------------------------------------------
% IN: s1, s2: signals (same length)
%     fs: sample frequency (Hz)
%     n: amount of windows for windowing
%     olap: overlap between windows [0..1]
%     fend: end frequency (Hz)
%     k: histogram parameter (amount of bars in the phase histogram)
%OUT: Amean: averaged cpsd-amplitude
%     phmean: averaged phase (Pi)
%     fspli: frequency axis (Hz)
%     stdph: standard deviation from windowed FFT of the cross-phase
%--------------------------------------------------------------------------
%EX1: s1 ~ sin(2*pi*f1*t       ) (s1 is pi/2 before s2!)
%     s2 ~ sin(2*pi*f1*t - pi/2)
%     yields a cross-phase of +pi/2 at frequency f1!
%EX2: [A,ph,frq,phstd] = cpsdmean(s1,s2,fs,n,olap,fend)
%
% EX3:
% t=(0:10e3)/100e3; fs=1/(t(2)-t(1));
% s1=sin(2*pi*3e3*t)+0.1*randn(1,length(t));
% s2=sin(2*pi*3e3*t -pi/2) + 0.1*randn(1,length(t));
% [A,ph,frq,phstd] = cpsdmean(s1,s2,fs,5,0.5,10e3);
% clf; hold on; ind=1:500;
% plot(t(ind),s1(ind),'b'); plot(t(ind),s2(ind),'r');
% figure(2);
% subplot(2,1,1); plot(frq,A)
% xlabel('frequency'); ylabel('CPSD(s1,s2)');
% subplot(2,1,2); hold on; plot(frq,ph); plot(frq,phstd,'r');
% xlabel('frequency'); ylabel('phase(s1,s2)');
%==========================================================================

if nargin < 6; fend = 30e3; end
% histogram parameter k (amount of bars in the histogram)
if nargin < 7; k    = 20;   end


% length of data
datl = length(s1);

% window length
winL = round(datl/n);
if n>1
  delta = round(winL*olap);
else
  delta = 0;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CALCULATE CPSD for n WINDOWS ("cpsd" is a MatLab-function)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
win  = []; nfft = []; ovlp = [];
for i=1:n
  ind = (1 + (i-1)*delta: winL + (i-1)*delta);
  S1 = s1(ind);
  S2 = s2(ind);
  [Pxy,frq] = cpsd(S1, S2, win, ovlp, nfft, fs);
  i_f = find(frq<fend);
  f = frq(i_f);
  A(:,i)  = abs(Pxy(i_f));
  ph(:,i) = angle(Pxy(i_f)) / pi;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OUTPUT AVERAGE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  fspli = interp(f,10);
  if size(A,2)>1
    Amean = mean(A');
    phmean = mean(ph');
  else
    Amean = A;
    phmean = ph;
  end
  Aspli = spline(f, Amean, fspli);
  % "Spline" procedure can result in negative values
  % Remove these values: Find Amean<0 and set to min(Amean)
  ind = find(Aspli<=0);
  Aspli(ind) = min(Amean);
  Amean = Aspli;
  phmean = spline(f,phmean,fspli);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculation of the phase error
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The standard deviation of the phase is used as a measure of the error.
% But since the phase is periodic [-pi, pi] the error can't be calculated 
% as for linear paramters. - A problem arises when the phase is fluctuating
% close to pi or -pi. Then it jumps between pi and -pi.
% Solution: A histogram of the phases will be plottet, the maximum will be
% detected and the phase vector will be shifted by this value.

% length of phase spectrum (=length of frequency spectrum)
N = size(ph,1);
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  

% INFO: minimum standard-deviation is "0" (points at only one value)
%phstd = (sigmamax - ph_par)./sigmamax;
phstd = ph_par;
phstd = spline(f, phstd, fspli);

end