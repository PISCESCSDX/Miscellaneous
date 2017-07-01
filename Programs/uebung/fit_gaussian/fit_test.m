% load test-data
  load density-profile.mat

% plot the test data points
  plot(dens_x, dens_y, 'ko');

% fit a gaussian profile (libname=gauss1, others: cflibhelp)
% data must be a column-vector
  dens_x=dens_x';
  dens_y=dens_y';  
  fresult = fit(dens_x,dens_y,'gauss1');
% TIPP: get the result-fct, coefficients and so on simply with 'fresult'
  
% plot the fit
  hold on;
  plot(dens_x,fresult(dens_x),'r-');
  hold off;