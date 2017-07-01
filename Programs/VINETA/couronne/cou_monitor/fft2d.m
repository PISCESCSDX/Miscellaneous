function [freq, kfsp] = fft2d(data, sf, mw);
%function [freq, kfsp] = fft2d(data, sf, mw);
% 2dim FFT for spatiotemporal data.
%
% input     data    2dim matrix .. data(positions, timerow);
%                   ex. data(x, :) .. timerow of position x
%           sf      sample frequency /Hz
%           mw      1: make data meanfree; 0: don't mean
% output    freq        
%           kfsp  	(half of frequency above Niquist-limit removed)
% 20070110 C.Brandt

if nargin<2
   sf = 600000;
end

if nargin<3
   mw = 0;
end

%-- m rows, n columns
    [m, n] = size(data);
 
% remove mean value
if mw==1
   meandata = mean(data);
   for i=1:m
       data(i,:) = data(i,:) - meandata;
   end
end

% important: hanning window along the time rows!
    z = hanning(n)*ones(1,m);
% apply hanning window on data
    data = data.*z';
% fast Fourier transformation
    data = fft2(data);

% remove the half of the modes & frequencies above the Nyquist-limit
% ceil...make integer
    kfsp = data(1:m, 1:n);
% create the frequency axis
    freq = sf*(0:n-1)/n;
end