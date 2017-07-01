% 2012-08-08_11:46 C. Brandt, San Diego
% This is a test file for looking at the FFT for the decomposition of
% azimuthal eigenmodes.
% Up to now I used only the period from phi=0 to 2pi to calculate the FFT.
% However, looking at the amplitudes of the test function, especially of 
% neighboring modes, the amplitudes are influences by them.
% This is the problem of the short signal trace put into the FFT.
% ==> NEW IDEA: By simple replicating the azimuthal array the signal is
% artificially extended. The new FFT spectrum looks more discrete and the
% amplitudes are well separated.

T = 64;
phi = ((1:T)'-1)/T;

% Amplitudes of m=0, m=1 and m=3
% a0 = 0.9;
% a1 = 0.8;  ph1=  1.0*pi;
% a2 = 0.2;  ph2=  0.4*pi;
% a3 = 0.5;  ph3=  0.2*pi;
% a4 = 0.1;  ph4= -0.7*pi;
a0 = 0.2;
a1 = 0.8;  ph1=  1.0*pi;
a2 = 0.5;  ph2=  0.4*pi;
a3 = 0.3;  ph3=  0.2*pi;
a4 = 0.1;  ph4= -0.7*pi;

% Noise level
noise = eps;

% Test signal
s1 = a4*cos(4* 2*pi*phi + ph4) + a3*cos(3* 2*pi*phi + ph3) + ...
  a2*cos(2* 2*pi*phi + ph2) + ...
  a1*cos(2*pi*phi + ph1) + a0 + noise*randn(numel(phi),1);
[fre amp pha] = fftspec(phi, s1);

% Replicated Signals
N = 10;
[fre2 amp2 pha2 theta S] = ffteigenmode(phi, s1, N);

figure
subplot(3,2,1); plot(s1); title('single trace')
  set(gca, 'xlim', [0 T])
subplot(3,2,3); stem(fre, amp); title('FFT mode spectrum')
  set(gca, 'xlim', [-1 10])
subplot(3,2,5); stem(fre, pha/pi); title('FFT phase spectrum')
  set(gca, 'xlim', [-1 10])
subplot(3,2,2); plot(S,'r'); title('replicated traces')
   set(gca, 'xlim', [0 N*T])
subplot(3,2,4); stem(fre2, amp2,'r'); title('FFT mode spectrum')
  set(gca, 'xlim', [-1 10])
subplot(3,2,6); stem(fre2, pha2/pi, 'r'); title('FFT phase spectrum')
  set(gca, 'xlim', [-1 10])
print -depsc2 newdecomp_test.eps