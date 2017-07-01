% plotlorenz.m
% this file will plot the solution to the lorenz equations for
% the specified values of the parameters SIGMA, R, and B.
% The standard values of SIGMA and B are 10 and 8/3 respectively.
% Assumes a file named 'lorenzf.m' to define the Lorenz equations

global SIGMA R B
SIGMA=10.;  R=28.;    B=8./3.;

% initial data
x0=[10 10 10];

% initialize initial time and end time
t0=0; tf=40; 

% compute the solution using the built-in ode solver ode45
tic
[tout, xout] = ode45('lorenzf', [t0, tf], x0);     %%% Using build-in ode45.m
toc

% plot the solution curve and set various display options
figure(1);
hp=plot3(xout(:,1), xout(:,2), xout(:,3)); 
set(hp,'LineWidth',0.1);   
box on;   
xlabel('x','FontSize',14);
ylabel('y','FontSize',14);   
zlabel('z','FontSize',14);

axis([-20 20 -40 40 0 60]);

set(gca,'CameraPosition',[200 -200 200],'FontSize',14);