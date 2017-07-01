function [A, phi, tt, piccou] = camextractcoumat(fn, fs, ipic, r, num, cp)
%==========================================================================
%function [A, phi, tt, piccou] = camextractcoumat(fn, fs, ipic, r, num, cp)
%--------------------------------------------------------------------------
% CAMEXTRACTCOUMAT exctracts an azimuthal vector (from 0..2*pi) with "num" 
% steps at a pixel radius "r" of the camera image "pic".
%--------------------------------------------------------------------------
% IN: fn: string of filenames
%     fs: sampling frequency (Hz)
%     ipic: indices of frames
%     r: radius in units of pixels
%     num: steps on the circle
%     cp: position of the central pixel cp = [xc yc]
%OUT: A: time-azimuthal date matrix (artificial probe array)
%     phi: azimuthal angle vector [0..2*pi*(num-1)/num]
%     tt: time vector
%     piccou: image with taken couronne and central pixel
%--------------------------------------------------------------------------
% EX: fn='a12*.tif'; fs = 90e3; ipic = 1:400; r=40; num=64; cp=[95 95];
%     [A, phi, tt, piccou] = camextractcoumat(fn, fs, ipic, r, num, cp);
%==========================================================================

% find files
a = dir(fn);
% pre allocate A
A = zeros(length(ipic), num);

ctr = 0;
for i=ipic
  ctr = ctr+1;
  pic = double(imread(a(i).name));
  [phi, Avec, piccou] = camextractcou(pic, r, num, cp);
  A(ctr,:) = Avec;
end

tt = ((1:length(ipic))-1)/fs;

end