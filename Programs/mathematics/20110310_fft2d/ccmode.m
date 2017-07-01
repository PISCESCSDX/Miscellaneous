% Hi Stella .. hier ein kurzes Test-Programm

% Create artificial space-time data
dt = 1e-5;
tt = (0:2^10-1)*dt;
f  = 10000;
m  = -9;
n  = 64;
% Phase and amplitude
ph = 2*pi*m/n;
A0 = 1;

% second mode number (other direction)
m2 = +4;
f2 = 10000;
% Phase and amplitude
ph2 = 2*pi*m2/n;
A02 = 0.3;


A = zeros(length(tt) ,n);
for i=1:n
  phn = ph*(1+0.01*pi*rand(1));
  A0n = A0*(1+0.50*rand(1));
  phn2 = ph2*(1+0.01*pi*rand(1));
  A0n2 = A02*(1+0.50*rand(1));
  A(:, i) = A0n*sin(2*pi*f*tt + (i-1)*phn) + ...
            A0n2*sin(2*pi*f2*tt + (i-1)*phn2);
end

% Plot spatiotemporal matrix
pcolor(A(1:0.3e3,:)');
shading flat


% Calculate kf-spectrum
avg = 1;
fs  = 1 / (tt(2)-tt(1));
[freq, kfsp] = fft2d(A', dt, avg);

figure(2)
% Take absolute value of complex spectrum
kspec = abs(kfsp);
pcolor(kspec)
shading flat

% Zu der Moden-Frequenz mal nur das Modenspektrum plotten:
figure(3)
plot(kspec(:,103))