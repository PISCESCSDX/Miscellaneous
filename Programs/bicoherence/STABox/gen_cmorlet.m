function [w,xk] = gen_cmorlet(N,sc,type)
% Generation of a Complex Morlet wavelet
%
% Usage:
%   [w,xk] = gen_cmorlet(N,sc,type);
%
% Use the proper plane-wave modulated by a Gaussian form
%
% Returns either the wavelet in physical space or in
% Fourier space, depending upon the input 'type'
%
% Input:
%   N - number of points
%   sc - scale of the wavelet in terms of domain size (NOT dilation parameter)
%   type - 'p' for physical space, 'f' for Fourier space
%
% Output:
%   w - Complex Morlet wavelet
%   xk - positions or frequencies where wavelet is calculated
%
% See also: GEN_CMORLET2D

%     %% *** conversion between wavelet scale and dilation parameter, adjusted empirically
%     a = 0.1254*sc;
a=sc;

    % frequency of Morlet wavelet
    k_0 = 6; % default is 6 (!)
%    k_0 = 3;

switch type

    case 'p' % Generate Physical space wavelet
   
    x = [-N/2:N/2 - 1]*(1/N); % periodic domain size = 1 from -1/2 -> 1/2
    xk = x;
   
    xs = x/a;
    
    mo = ( exp(i*k_0*xs) - exp(-k_0^2/2) ) .* exp(-xs.^2/2);
    mo = (1/sqrt(a))*mo; % renormalize due to scale change
    
%     % generate a periodized physical-space wavelet
%         n = [-10:10];
%    x = [0:N - 1]*(1/N); % periodic domain size = 1 from [0,1)
%     
%             for I = 1:length(n);
%         
%                 xs = x/a;
%                 xs = xs + n(I);
%     
%                 mo = ( exp(sqrt(-1)*k_0*xs) - exp(-k_0^2/2) ) .* exp(-xs.^2/2);
%                 mo = (1/sqrt(a))*mo; % renormalize due to scale change
% 
%                 w(:,I) = mo;
%         
%         end %n
   
    
    w = mo; % assign output

    % modified 3/31/2006
    % shift the wavelet to make it appear to be centered at x = 0 for FFT
    % defined over interval 0 - 1
    w = fftshift(mo); % assign output

    
    case 'f' % Generate Fourier space wavelet

        % Frequencies (mode numbers) in wrap-around order
        k = [1:N/2-1];
%        k = [0 k N/2 -fliplr(k)]; % Note changed 6/1/2006, the middle element should be -N/2 ???
        k = [0 k -N/2 -fliplr(k)];
        delta = 1/N; % use dx from finer grid??
        fk = k/N/delta; % real frequencies
        k = fk;
        xk = k;
    
        % change scale
        k = a*k;
        
        %% uncorrected complex Morlet wavelet in Fourier space
%         fmo_uc = (1/sqrt(2*pi)) * exp(-(2*pi*k-k_0).^2/2);
         fmo_uc = (sqrt(2*pi)) * exp(-(2*pi*k-k_0).^2/2);
fmo=fmo_uc;
         
        % corrected complex Morlet wavelet in Fourier space
%        fmo = (1/sqrt(2*pi)) * ( exp(-(k-k_0).^2/2) - exp(-k_0^2/2)*exp(-k.^2/2) );
%        fmo = sqrt(2*pi)*( exp(-(2*pi*k-k_0).^2/2) - exp(-k_0^2/2)*exp(-(2*pi*k).^2/2) );

        % renormalize due to change in scale
        fmo = sqrt(a)*fmo;
        
        w = fmo;
        
    otherwise
        disp('Unknown type. Please input either p for physical space or f for Fourier space');
        return;
end

% Created 3/3/2006 Jori