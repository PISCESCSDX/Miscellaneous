inp = input('Load data? (No: Enter, Yes: 1)');
if inp
  load phasedata
end

i0 = 18;
d  =  3;
t0 = 0001;
m = 2;

for i0=10:3:45
  disp(['pixel 1: ' num2str(i0)])

  i=i0; j=i+d; 

s1 = unwrap(phase.pha{i}(:,m+1))/(2*pi);
s2 = unwrap(phase.pha{j}(:,m+1))/(2*pi);

figure(1); clf
plot( s2-s1, '.-')


ind = t0+(1:500);
figure(2); clf
hold on
plot(s1(ind)-s1(ind(1)), '.b-')
plot(s2(ind)-s2(ind(1)), '.r-')

input('Press Any Key to Continue')

end