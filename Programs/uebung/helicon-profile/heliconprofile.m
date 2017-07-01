% This is a normalized radial helicon profile in Vineta.
% The data of the fitted helicon-profile is in the variables
% xvec and yvec

load helicon-profile.mat
load density-profile.mat

hold on;
plot(xvec, yvec, 'r-');
plot(dens_x,dens_y/max(dens_y),'bo')
xlabel('radial position /m');
ylabel('density /a.u.');
hold off;