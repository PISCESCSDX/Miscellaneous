function wm = fct_PISCES_CoilTrimElements(zpos, curr, N)
%==========================================================================
%function wm = fct_PISCES_CoilTrimElements(zpos, curr, N)
% Last change: 05.03.2012, San Diego, C. Brandt
% 03.03.2012, San Diego, C. Brandt
%--------------------------------------------------------------------------
% FCT_PISCES_COILTRIMELEMENTS calculates the wire structure of the trim
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

% Geomtric parameters of the trim coils
%---------------------------------------

  
% Width of the water cooling pipes (copper + insulating sleeves 1mm)
  dpipes = 0.2305*25.4  +  1;
% Measured outer (radial) package diameter (Brandt 5.3.2012 in Lab)
  dpackr_out = 127;
  % substract outer and innter margin
  dpackr = dpackr_out - 2;
% Number of equidistanced winding circles (in radial direction)
  Nwr = round(dpackr/dpipes);
% Winding diameter 
  dwindr = dpackr/Nwr;
  % (Brandt 5.3.2012 in Lab)
  dia_out = 20.5*25.4;
  % Inner radius of coil rci = 155.575mm
  rci = dia_out/2 - dpackr_out;
  % Empty space between inner boundary and first winding (estimated)
  dsi =  1;
% Radius of first winding
r_1 = rci + dsi + dwindr/2;

% Axial outer diameter of coil package
dz = 34;
% Number of equidistanced winding circles (in axial direction, parallel z)
Nwz = round(dz/dpipes);
  % Left side of coil (mm)
  zcl = 0;
  % Right side of coil (mm)
  zcr = 34;
  % Empty space between left boundary and winding
  dzl =  1;
  % Empty space between right boundary and winding
  dzr =  1;
  % Diameter of radial package (inner r to outer r)
  dpackz = zcr - dzr - (zcl+dzl);
  % Axial diameter of one single winding
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


% for j=1:N*Nwz*Nwr
%   hold on
%   plot3(wm.S1{j}(1),wm.S1{j}(2),wm.S1{j}(3), 'o')
%   hold off
% end




% Changes:
% 05.03.2012, San Diego, C. Brandt