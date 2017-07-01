t1 = clock_int;

% camerastatistics;

% Define evaluation files
j = 0;

a = dir('*f650*.cine');
b = dir('*f450*.cine');
c = [a;b];

% Define raw files to use (avoid overexposed rawdata)
% for i=1:length(c); disp([num2str(i) '  ' c(i).name]); end
ivec = [1:34 36:41 43:44];
ivec = fliplr(ivec);

for i=1:length(ivec)
  filebase = c(ivec(i)).name(1:end-5);
  disp(['No ' num2str(i) ' of ' num2str(length(ivec))])
%   fct_a_moviestatistic(filebase);
  fct_b_playmovie_3pics(filebase);
  close all;
  fct_c_velocimetry(filebase);
end

t3 = clock_int; disp(clockdiff(t1,t3))