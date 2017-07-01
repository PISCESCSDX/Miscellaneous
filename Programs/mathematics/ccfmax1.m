function [dtau] = ccfmax1(sigccf, tau, d)
% PROBLEM: Cross correlation functions can look very differently!
% So it isn't easy to determine the maximum of the function and the 
% associated time shift.
% This simple function CCFMAX1 determines the nearest maximum to the time
% shift dtau = 0.
% EX: [sigccf, tau] = ccf(sig1, sig2, fsample);


  it = find(tau>=0);
  ind = it(1)-d:it(1)+d;

  fp = findpeakind(sigccf(ind));
  centerp = fp(2);
  dtau = tau(ind(centerp));
end