% load Nancy-data
  load profile.mat

  x = prof.r'/100;
  y = prof.n';
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FIT GAUSS: ne
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ymax = max(y);
ynorm = y/(ymax);
fitgauss = fittype('a*exp(-abs((x-b)./c).^d)+e');
opts = fitoptions(fitgauss);
set(opts,'start',[1  +0.000   +0.01  3.1  0.0]);
opts.Upper =     [1  +0.0001  +1.10  3.5  0.10];
opts.Lower =     [0  -0.0001  -1.10  2.0  0.00];
fit = fit(x, ynorm, fitgauss, opts);
yfit = ymax*fit(x);

% figeps(15,8,1,5,5);
% hold on
%   plot(x, y, 'o')
%   plot(x, yfit, 'r-')
% hold off

save