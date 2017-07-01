function [data_fft,varargout] = fftnorm(data,varargin);
%
%function [data_fft,varargout] = fftnorm(data,varargin);
%
% The function fftnorm.m calculates a fft of a dataset, and in addition it generate the
% frequency axis. 
% 
% data   : vector of data for FFT
% fs     : scalar sampling frequency
% n      : number of points for the FFT
%
% freq   : vector of frequencies
% fft    : absloute of FFT-transform
%
% EXAMPLE: [data_fft,freq] = fftnorm(data,n,fs);

if nargin == 0 
    help fftnorm
    return
elseif nargin == 1
  n	= 1024;
  fs	= 2;
elseif nargin == 2
  n	= varargin{1};
  fs	= 2;
elseif nargin == 3
  n	= varargin{1};
  fs	= varargin{2};
end;

for i = 1:size(data,2)
    tmp = abs(fft(data(:,i),n));
    data_fft(:,i) = tmp(1:length(tmp)/2);
end;

freq     = linspace(0,fs/2,length(data_fft));

if nargout == 2
  varargout{1} = freq;
end;