%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1. Calculate in a 3D cylindrical grid the plasma column
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% m=3;
% lz=1400;
% ntilde = 0.2;
% plL = 1400;
% plr = 69.75;
% xres = 5;
% yres = 5;
% zres = 100;
% infwhm = 30;
% zgrad  = 0.85;
function mkplasdat(m,lz,ntilde,plL,plr,xres,yres,zres,infwhm,zgrad)
% m: azimuthal drift wave mode number
% lz: parallel length of drift wave
% ntilde: fluctuation level in maximal density gradient region)
% Wave parameters 
%=================
% mode number
plas.m = m;
% parallel wavelength (m)
plas.lz = lz;
% frequency (approximatively)
plas.f = 3000*plas.m;
% zero phase
plas.phi0 = 0;
% fluctuation level in maximal density gradient region
plas.fluclev = ntilde;

% Geometric parameters
%======================
% axial length of plasma (mm)
plas.L = plL;
% radius of tube or limiter (mm)
plas.r =  plr;
% resolution of grid (mm): x, y, z
plas.xres =   xres;
plas.yres =   yres;
plas.zres =   zres;

% Plasma parameters
%===================
% width of density profile (sigma)
fwhm = infwhm;
% density in centrum
dens0 = 1e3;
% maximal value of density gradient
rvec = (0:plas.r/100:plas.r)';
densgrad = abs(diff_discrete(rvec, dens0*gaussfct(rvec, 0, fwhm)));
densgradmax = max(densgrad);
densgradspline = spline(rvec, densgrad/densgradmax);


disp('Calculation of the plasma data ...')
% FOR loops
%===========
ix = 0; iy = 0; iz = 0;
plas.xvec = -plas.r:plas.xres:plas.r;        lx = length(plas.xvec);
plas.yvec = -plas.r:plas.yres:plas.r;        ly = length(plas.yvec);
plas.zvec = 0: plas.zres :plas.L;            lz = length(plas.zvec);
% FOR loops
%===========
plas.d3d = zeros(lx, ly, lz);
plas.X = zeros(lx,ly);
plas.Y = zeros(lx,ly);

% time loop: tau
for tau = 0:1:0
  phi_tau = 2*pi*plas.f*tau;
for zi = plas.zvec; iz = iz+1;
  disp_num(iz,lz)
  % Axial profile: assumption: after plas.L dens0 drops linearly to 20%
  zfac = -(1.0-zgrad)/plas.L*zi + 1;
  %zfac = 1;
  % z-phase
  phi_z = 2*pi*zi/plas.lz;
for yi = plas.yvec; iy = iy+1;
for xi = plas.xvec; ix = ix+1;
  % radial profile
  ri = sqrt(xi^2+yi^2);
  dens = dens0*gaussfct(ri, 0, fwhm);
  % normalized density gradient, squared yields more realistic m-pattern
  graddens = ppval(densgradspline, ri)^2;
  
  % azimuthal wave phase theta (hat complicated for unwrapping)
  if xi>=0 && yi>=0    %(+ * + = +)
    ti = atan(yi/xi);
  end
  if xi<0 && yi>=0     %(- * + = -)
    ti = atan(yi/xi) + pi;
  end
  if xi<0 && yi<0      %(- * - = +)
    ti = atan(yi/xi) + pi;
  end
  if xi>=0 && yi<0     %(+ * - = -)
    ti = atan(yi/xi) + 2*pi;
  end
  if xi==0 && yi==0    %(+ * - = -)
    ti = 0;
  end  
  phi_theta = ti*plas.m;
  % alltogether phase
  phi = phi_tau + phi_z + phi_theta + plas.phi0;
  % fluctuations = amplitude*sin(phase)*graddens;
  fluc = plas.fluclev*sin(phi)*graddens;
  % fluctuations = amplitude*sin(phase)*graddens;
  plas.d3d(ix,iy,iz) = zfac*(dens + fluc*dens);
  plas.d3d0(ix,iy,iz) = zfac*dens;
  plas.X(ix,iy) = xi;
  plas.Y(ix,iy) = yi;
end; ix = 0;
end; iy = 0;
end

end %time tau

strgrad = round( (1-zgrad)*100/(plas.L/1000) );

fn = ['plcart_Lz' num2str(plas.lz) '_m' num2str(plas.m) '_x' ...
  num2str(plas.xres) 'y' num2str(plas.yres) 'z' num2str(plas.zres) ...
  '_zgrad' num2str(strgrad) '.mat'];
save(fn,'plas');

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%