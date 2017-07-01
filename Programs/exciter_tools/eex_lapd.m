% 13.08.2012-09:05 C. Brandt, San Diego
% This script is a simple code to calculate the potential of an exciter 
% consisting of electrodes.
% This script assumes electrodes in form of a mathemtical point for
% simplification of the calculation.

%==========================================================================
% Exciter Settings (at z=0)
%--------------------------------------------------------------------------
% Number of xciter electrodes
ex.N = 21;
% Exciter amplitudes (arb.u.)
ex.A(1:ex.N) = 1;
% Radial position of electrodes (m)
ex.r = 30/1e3;
% Lentgh of electrodes (m)
ex.L = 7/1e3;
% Exciter frequency (Hz)
ex.f = 1e4;
% mode vector
ex.m = 8:12;
% Calculation of the electrode positions
ex.x = ex.r.*cos(2*pi./ex.N .* (0:ex.N-1)');
ex.y = ex.r.*sin(2*pi./ex.N .* (0:ex.N-1)');

% Number of points per electrode
ex.elpts = 3;

% 1st edge of electrode
% Angle electrode center to edge
phi = atan( (ex.L/2)/ex.r );
% Distance center to electrode edge
cedge = sqrt((ex.L/2)^2 + ex.r^2);
for j=1:ex.N
  xA = cedge .* cos(2*pi./ex.N.*(j-1)' - phi);
  yA = cedge .* sin(2*pi./ex.N.*(j-1)' - phi);
  xB = cedge .* cos(2*pi./ex.N.*(j-1)' + phi);
  yB = cedge .* sin(2*pi./ex.N.*(j-1)' + phi);
  ex.x(j,1:ex.elpts) = linspace(xA,xB,ex.elpts);
  ex.y(j,1:ex.elpts) = linspace(yA,yB,ex.elpts);
end


%==========================================================================
% Spatial Resolution
%--------------------------------------------------------------------------
limx = [-32 32]/1e3;   dx = 1/1e3;  xv = limx(1):dx:limx(2);
limy = [-32 32]/1e3;   dy =dx;      yv = limy(1):dy:limy(2);
limz = [  0  0]/1e3;   dz =dx;      zv = limz(1):dz:limz(2);

%==========================================================================
% Temporal Resolution
%--------------------------------------------------------------------------
limt = [0 1e-4];  dt = 1e-6; tv = limt(1):dt:limt(2); 


%==========================================================================
% Calculate the Field
%--------------------------------------------------------------------------
Nt = floor((limt(2)-limt(1))/dt) +1;
Nz = (limz(2)-limz(1))/dz +1;
Ny = (limy(2)-limy(1))/dy +1;
Nx = (limx(2)-limx(1))/dx +1;


V{length(ex.m),Nt} = zeros(Nx,Ny,Nz);

% Mode loop
for im=1:length(ex.m)
disp_num(im,length(ex.m))
% electrode-loop
for it = 1:Nt
  [im length(ex.m) it Nt]
  % Preallocate field matrix
  V{im,it} = zeros(Nx,Ny,Nz);
  
  % phase difference between electrodes
  alpha = 2*pi*ex.m(im) / ex.N;
  
  % electrode-loop
  for ie = 1:ex.N
    % Amplitude of the electrode at time it
    amp = ex.A(ie) * cos(2*pi*ex.f*tv(it) + (ie-1)*alpha);
    % z-loop  
    for iz = 1:Nz
    % y-loop
    for iy = 1:Ny
    % x-loop
    for ix = 1:Nx
      % points per electrode  
      for iepts = 1:ex.elpts
      r = sqrt( (ex.x(ie,iepts)-xv(ix))^2 +...
                                    (ex.y(ie,iepts)-yv(iy))^2 + zv(iz)^2 );
      % Add the current value to the total potential
      if r>0.0001
        V{im,it}(ix,iy,iz) = V{im,it}(ix,iy,iz) + amp/r;
      end
      end
      
    end %ix
    end %iy
    end %iz
    
  end %ie
  V{im,it} = V{im,it}/ex.elpts;
end %it

end %im

% pcolor( V{1,1} )
% return
  
save eex_lapd_21electodes.mat V xv yv zv ex tv