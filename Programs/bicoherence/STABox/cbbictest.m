% This script: Creates a artificial timerow to test the bicoherence.
% wbicw

% CREATE ARTIFICIAL SIGNAL
%==========================
% make time vector (signals at 5 and 6 kHz - so f_s=100kHz, length=100ms)
  f_s = 1e6;
  tl = 1;
  tt = (f_s^(-1))*(1:f_s*tl);

% set the parameters of the 2 waves
  fre1 = 10000; a1 = 0;
  fre2 = 12000; a2 = 0;
  fre3 = 6000; a3 = 1;
  fre4 = 9000; a4 = 1;
  
% set the coupling strength V12
  V12 = 0.00;
  V34 = 0.3;
  Vnoise = 0.1;
  
% create signal f(t) = f1 + f2 + f1*f2
  noise = randn(length(tt), 1);
  ff1 = a1*sin(2*pi*fre1*tt);
  ff2 = a2*sin(2*pi*fre2*tt);
  ff3 = a3*sin(2*pi*fre3*tt);
  ff4 = a4*sin(2*pi*fre4*tt);
  
%   fww = ff1 + ff2 + V12*ff1.*ff2 + ff3 + ff4 + ...
%         V34*ff3.*ff4 +  + Vnoise*noise';
  fww = ff3 + ff4 + V34*ff3.*ff4 +  + Vnoise*noise';      

% % Timerow Plot
%   tvec=1:300; fs=18;
%   axes('Position', [0.15 0.18 0.75 0.73]);    
%   plot(tt(tvec)*1e3, fww(tvec), 'k.', tt(tvec)*1e3, fww(tvec), 'k-');
%   xlabel('time [ms]', 'fontsize', fs);
%   ylabel('amplitude [V]', 'fontsize', fs);  
%   set(gca, 'fontsize', fs);
  
% MAKE BICOHERENCE PLOT
%=======================
fmax = 30000;
%  fbicFou(fww', 1/f_s, 2^8, [fmax 4 50 0], 1);
  fbicFou(fww', 1/f_s, 2^13, [fmax 4 50 0], 1);
  
% load coudata.mat
%   fbicFou(mm.a(:,1), mm.t(2)-mm.t(1), 2^12, [30000 4 50 0], 1);