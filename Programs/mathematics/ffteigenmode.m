function [fre amp pha phi S] = ffteigenmode(theta, s, N)
%==========================================================================
%function [fre amp pha] = ffteigenmode(theta, s, N)
% 08.08.2012 12:27 C. Brandt, San Diego
%--------------------------------------------------------------------------
% FFTEIGENMODE replicates the signal s by N and calculates the FFT.
% Makes sense if the signal s is a full period along the vector theta.
%--------------------------------------------------------------------------
% theta: colum vector E [0, 1[ of the period
%     s: colum vector
%     N: single number, number of replications
%   phi: new phase vector
%     S: new amplitude vector
%==========================================================================

Ltheta = length(theta);

% Replicate period vector
phi = zeros(N*Ltheta,1);
for i=0:N-1
  phi(i*Ltheta+1:(i+1)*Ltheta) = theta+i;
end
% Replicate data vector
S = repmat(s,N,1);

% Calculate FFT
[f a p] = fftspec(phi, S);

fre = f(1:N:end);
amp = a(1:N:end);
pha = p(1:N:end);

end

% TEST EXAMPLE
% % 2012-08-08_11:46 C. Brandt, San Diego
% % This is a test file for looking at the FFT for the decomposition of
% % azimuthal eigenmodes.
% % Up to now I used only the period from phi=0 to 2pi to calculate the FFT.
% % However, looking at the amplitudes of the test function, especially of 
% % neighboring modes, the amplitudes are influences by them.
% % This is the problem of the short signal trace put into the FFT.
% % ==> NEW IDEA: By simple replicating the azimuthal array the signal is
% % artificially extended. The new FFT spectrum looks more discrete and the
% % amplitudes are well separated.
% %
% T = 32;
% phi = ((1:T)'-1)/T;
% 
% % Amplitudes of m=0, m=1 and m=3
% a0 = 0.9;
% a1 = 0.8;  ph1=  1.0*pi;
% a2 = 0.2;  ph2=  0.4*pi;
% a3 = 0.5;  ph3=  0.2*pi;
% a4 = 0.1;  ph4= -0.7*pi;
% 
% % Noise level
% noise = eps;
% 
% % Test signal
% s1 = a4*cos(4* 2*pi*phi + ph4) + a3*cos(3* 2*pi*phi + ph3) + ...
%   a2*cos(2* 2*pi*phi + ph2) + ...
%   a1*cos(2*pi*phi + ph1) + a0 + noise*randn(numel(phi),1);
% [fre amp pha] = fftspec(phi, s1);
% 
% % Replicated Signals
% N = 10;
% [fre2 amp2 pha2 theta S] = ffteigenmode(phi, s1, N);
% 
% figure
% subplot(3,2,1); plot(s1,'bo-','MarkerSize',1.7);
%   title('single trace','FontSize',12)
%   set(gca, 'xlim', [0 T],'FontSize',12)
% subplot(3,2,3); stem(fre, amp);
%   title('FFT mode spectrum','FontSize',12)
%   set(gca, 'xlim', [-1 10],'FontSize',12)
% subplot(3,2,5); stem(fre, pha/pi);
%   title('FFT phase spectrum','FontSize',12)
%   set(gca, 'xlim', [-1 10],'FontSize',12)
% subplot(3,2,2); plot(S,'r-o','MarkerSize',1.7);
%   title('replicated trace','FontSize',12)
%   set(gca, 'xlim', [0 N*T],'FontSize',12)
% subplot(3,2,4); stem(fre2, amp2,'r');
%   title('FFT mode spectrum','FontSize',12)
%   set(gca, 'xlim', [-1 10],'FontSize',12)
% subplot(3,2,6); stem(fre2, pha2/pi, 'r');
%   title('FFT phase spectrum','FontSize',12)
%   set(gca, 'xlim', [-1 10],'FontSize',12)
% print -depsc2 newdecomp_test.eps