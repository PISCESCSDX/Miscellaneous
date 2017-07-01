function wm = fct_PISCES_CoilMainElements(zpos, curr, N)
%==========================================================================
%function wm = fct_PISCES_CoilMainElements(zpos, curr, N)
% Last change: 05.03.2012, San Diego, C. Brandt
% 03.03.2012, San Diego, C. Brandt
%--------------------------------------------------------------------------
% FCT_PISCES_COILMAINELEMENTS calculates the wire structure of the main
% coils.
%--------------------------------------------------------------------------
% IN: zpos: vector with z position of coils (z=0 is the source position)
%     curr: vector of currents (same numel as zpos)
%        N: number of finite elements per wire loop
%OUT: wm.S1{i} Start point of wire i 
%     wm.S2{i}   End point of wire i
%     wm.Cu{i}   Current in wire i
%     wm.rminmax rmin and rmax for each coil
%     wm.zminmax zmin and zmax for each coil
%--------------------------------------------------------------------------
% EXAMPLES:
%==========================================================================

% Geomtric parameters of the main coils
%---------------------------------------
% Number of equidistanced winding circles (in radial direction)
Nwr = 14;
% Radius of most inner winding (center of wire)
  %   Inner radius of coil rci = 155.575mm
  rci = 155.575;
  %   Outer radius of coil rco = 374.65mm
  rco = 374.65;
  %   Empty space between inner boundary and first winding dsi = 5mm
  dsi =  5;
  %   Empty space between outer boundary and last winding dso = 10mm
  dso = 10;
  %   Diameter of radial package (inner r to outer r)
  dpackr = rco-dso - (rci+dsi);
  %   Radial diameter of one single winding
  dwindr = dpackr/Nwr;
r_1 = rci + dsi + dwindr/2;

% Number of equidistanced winding circles (in axial direction, parallel z)
Nwz = 4;
  %   Left side of coil 0mm
  zcl = 0;
  %   Right side of coil 62mm
  zcr = 63;
  %   Empty space between left boundary and winding
  dzl =  1;
  %   Empty space between right boundary and winding
  dzr =  1;
  %   Diameter of radial package (inner r to outer r)
  dpackz = zcr - dzr - (zcl+dzl);
  %   Axial diameter of one single winding
  dwindz = dpackz/Nwz;


% Delta alpha
dalpha = 2*pi/N;

% Calculation of wire elements for all circles
%----------------------------------------------
ctr = 0;
for ic = 1:numel(zpos)
  % Save the coils boundaries
  wm.rminmax{ic} = [r_1-10 r_1+(Nwr-1)*dwindr+10];
  wm.zminmax{ic} = zpos(ic)-dpackz/2+dwindz/2 + [-10 (Nwz-1)*dwindz+10];
  for iz = 1:Nwz    % winding z-position
    % Calculate z-position of current wire circle
    z = zpos(ic) - dpackz/2 + dwindz/2 + (iz-1)*dwindz;
    
    for ir = 1:Nwr  % winding r-position
      % Calculate r-position of current wire circle
      r = r_1 + (ir-1)*dwindr;
      
      for iN = 1:N  % number of wire elements per circle
        ctr = ctr+1;
        wm.S1{ctr} = [r*cos((iN-1)*dalpha) r*sin((iN-1)*dalpha) z];
        wm.S2{ctr} = [r*cos(iN*dalpha)     r*sin(iN*dalpha)     z];
        wm.Cu{ctr} = curr(ic);
      end           % number of elements per circle
    end           % winding r-position
  end           % winding z-position
end

% XXX --->>> Check wire structure
% for j=1:N*Nwz*Nwr
%   hold on
%   plot3(wm.S1{j}(1),wm.S1{j}(2),wm.S1{j}(3), 'o')
%   hold off
% end
% XXX <<<--- Check wire structure

end