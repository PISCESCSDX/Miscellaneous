% load test-data
  load density-profile.mat

% plot the test data points
  plot(dens_x, dens_y, 'ko');

  dens_x=dens_x';
  dens_y=dens_y';
% create own fit-function

 offsetgauss = fittype('a*exp(-((x-b)/c)^2)');
%     opts = fitoptions(offsetgauss);
%     set(opts,'start',[1 0 1]);
   fresult1 = fit(dens_x, dens_y, offsetgauss);%, opts);    
    
  offsetlorentz = fittype('-0.07+(b/c)/((x-d)^2+b^2)');
     opts = fitoptions(offsetlorentz);
     set(opts,'start',[0.00 10 1]);  %
     fresult2 = fit(dens_x, dens_y, offsetlorentz, opts);
  

% plot the fit
  hold on;
  xvec = -0.2:0.001:0.2;
  plot(xvec, fresult1(xvec),'r-');
  plot(xvec, fresult2(xvec),'b-');
  hold off;
  
% legend
  legend('I_{sat}', 'Gaussian-Fit', 'Lorentz-Fit');

% save helicon-profile data to file (take Lorentz-profile)
  yvec = fresult2(xvec)./max(fresult2(xvec));
  
save helicon-profile.mat xvec yvec