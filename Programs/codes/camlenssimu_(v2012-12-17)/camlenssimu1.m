% Simulation of the camera measurement in MIRABELLE
% Final figure:
% Case A: driftwave with parallel wavelength lz
% (a) picture of azimuthal plane of the simulated density
% (b) picture of azimuthal plane of the camera measurement (focused, f/1.2)
% (c) picture of azimuthal plane of the camera measurement (focused, f/32)
% Case B: flute mode with parallel wavelength lz=inf
% (a) picture of azimuthal plane of the simulated density
% (b) picture of azimuthal plane of the camera measurement (focused, f/1.2)
% (c) picture of azimuthal plane of the camera measurement (focused, f/32)
%
% 1. Calculate in a 3D cylindrical grid the plasma column
% 2. Calculate the camera picture


a = dir('plcart_*.mat');
load(a(1).name)
% OLD: load plcart_Lz1400_m3_x0.5y0.5z50_zgrad0.mat

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 2D Plot of the mode
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% figeps(12,10,1);
% pcolor(plas.X,plas.Y,plas.d3d(:,:,1)-plas.d3d0(:,:,1))
% shading interp
% axis square
% colormap pastell
% mkplotnice('x (mm)', 'y (mm)', 12, -30);
% print_adv([1], '-r300', 'd3d-d3d0_z0_tau0.eps', 50, 4);

% Create Test signals
%=====================
% z = 29;
% % letter thickness
% d = 4;
% plas.d3d = zeros(281,281,29);
% plas.d3d(  139:139+d, 60:220  , z) = 10;
% plas.d3d(   80:210  ,220:220+d, z) = 10;
% plas.d3d(  120:180  ,140:140+d, z) = 10;
% plas.d3d(   80:80+d ,210:220  , z) = 10;
% plas.d3d(210-d:210,  220:230  , z) = 10;
% plas.d3d(  130:152, 60-d:60   , z) = 10;
% % two small "dots"
% plas.d3d(  120:120+d,150:150+d, z) = 10;
% plas.d3d(  150:150+d,130:130+d, z) = 10;

close all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculation of the camera picture
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('calculation of the camera picture:')

%==========================================================================
% Check for already saved calculated files
%==========================================================================

% Resolution reduction factor:
% larger fac increases pixelsize, decreases pixels
fac = 1;
% Pixel size (mm)
ca.pixelsize = fac*20e-3;
ca.pixelarea = ca.pixelsize^2;
% Camera position (objective lens) in z-coordinates
% 0.70m + 1.50m
ca.pos = [0; 0; 2200];
% Camera view direction (vector from center of lens) [x,y,z] [units]
ca.view  = [0, 0, -1]';
% Focal length (mm)
ca.f = 50;
% Apperture parameter Kappa (=f/D) D...apperture diameter
ca.kappa = 1.2;
ca.D = ca.f/ca.kappa;

% Object distance (mm) (Gegenstandsweite)
ca.g = 1500;
% Distance objective - projection (picture)
ca.p = ca.g*ca.f/(ca.g-ca.f);

% Camera chip pixels [pixx pixy]
ca.pix = 1/fac*[200 200];
% Camera chip size (mmx x mmy)
ca.chip = ca.pix*ca.pixelsize;
% Info: Maximum resolution: ca.pix = [1024 1024]; ca.chip = [20.48 20.48];
ca.chiploc = [-ca.chip(1)/2 +ca.chip(1)/2 -ca.chip(2)/2 +ca.chip(2)/2];



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Preamble A: ### INPUT: Activate for normal or continuing automatically
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Definition of main string saved data files
fnmain = 'ccd_';
% Data files
a = dir([fnmain '*.mat']);
la= length(a);

if la>0 && la<length(plas.zvec)
  disp('...  continue calculation with saved files');
  % Load the last saved file
  load(a(la).name);
  iz = la;
else
  iz = 0;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Preamble B: ### INPUT: Activate this for continuing manually
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% j = 14;
% iz = j;
% currz = plas.zvec(j+1);  plas.zvec = [];  plas.zvec(j+1) = currz;
% fnmain = 'test_ccd_';

% % # Use the background profile
% plas.d3d = plas.d3d0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%==========================================================================
% Calculate camera picture according to lens formula
%==========================================================================
% 1. Loop of all points in plasma matrix d3d
% 2. Calculate the intersection of the current light ray with the CCD chip
% 3. Calculate the size of the circle of confusion
% 4. Procedure to find the pixels hit by the circle of confusion
% 5. Sum up the light fraction for each pixel

% 1. Loop of all points in plasma matrix d3d
%--------------------------------------------
% x_i = r_i*cos(theta_i);
% y_i = r_i*sin(theta_i);
% z_i = ca.pos(3) - z_i;

% Initialize variables
%   Counters: location
ix = 0; iy = 0;
%   Pixel lines (boundaries)
Li.p1 = zeros(4,1);
Li.p2 = zeros(4,1);
Li.int = zeros(4,1);
lx = length(plas.xvec);
ly = length(plas.yvec);
lxy = lx*ly;
lz = length(plas.zvec);


%for zi = plas.zvec; iz = iz+1;
  
while iz < length(plas.zvec)
  iz = iz + 1;
  zi = plas.zvec(iz);
  
  disp(' ');
  disp_num(iz,lz)
  currccd = zeros(ca.pix(1), ca.pix(2));
  % Remaining light counter and variable
  restlight_ctr = 0;
  restlight     = 0;
for yi = plas.yvec; iy = iy+1;
  disp_num(iy ,ly)
for xi = plas.xvec; ix = ix+1;
  % If the current lightpoint is zero (= dark = no light)
  if plas.d3d(ix,iy,iz) ~= 0
    
  %  Cartesian coordinates of the current density point
  x = xi;
  y = yi;
  z = ca.pos(3) - zi;
  
  % 2. Calculate the intersection of the current light ray with CCD chip
  %----------------------------------------------------------------------
  int_x = (ca.p/z)*x;
  int_y = (ca.p/z)*y;
  
  % 3. Calculate the radius of the circle of confusion (COC) r_cc
  %---------------------------------------------------------------
  b = z*ca.f/(z-ca.f);
  r_cc = abs(b-ca.p)/b*(ca.D/2);
  if r_cc==0
    r_cc = eps;
  end
  % Area of the COC
  Acoc = pi*r_cc^2;
    %---------------------------------------------------------------
    % Reduce Light intensity due to distance between point and camera
    % (1) Light energy decreases proport. 4*pi*R^2 (sperical wave)
    % (2) Effective lense area depends on 
    %     angle between lense axis and current point (x,y,z)
    % (3) Light flux density on the chip depends on area of COC
    %---------------------------------------------------------------
    % Total Light Energy in current matrix point
    LightEnTot = plas.d3d(ix,iy,iz);
    % Amount of incident light depends on angle to camera lens
       % effective lense diameter     D_eff = ca.D * cos(gamma)
       % with gamma being the angle between current point and lens axis
    r_dist = sqrt((x^2)+(y^2)+(z^2)); % distance point<->lense center
    D_eff = ca.D * z/r_dist;
    % Effective Lense area (ellipse formula)
    ALensEff = pi*(ca.D/2)*(D_eff/2);
    % Light Energy decreases with 4*pi*r^2: LEff = L0 * Aeff/A(r_i)
    LightEn = LightEnTot * ALensEff / (4*pi*(r_dist)^2);
    % Light flux density (light per per area)
    Gamma_A = LightEn/Acoc;
    %---------------------------------------------------------------
  
  % 4. Procedure to find the pixels hit by the circle of confusion
  %----------------------------------------------------------------
  % Case A: Whole COC inside one pixel
  % Case B: COC vertically cut, and between two horiz. adjacent pixels
  % Case C: COC horizontally cut, and between two vertic. adjacent pixels
  % Case D: COC 1x horiz. and 1x vert. cut, between 4 squared adj. pixels
  % Case E: COC more than 1x horiz and vert. cut
  %
  % 4.1 determine left, right, upper, lower boundaries of the COC
  bo_le = int_x-r_cc;
  bo_ri = int_x+r_cc;
  bo_lo = int_y-r_cc;
  bo_up = int_y+r_cc;
    % 4.1.1 If all is out of range of the chip -> next data point
  if not( bo_le>=ca.chiploc(2) ) && not( bo_ri<=ca.chiploc(1) ) ... 
      &&  not( bo_up<=ca.chiploc(3) ) &&  not( bo_lo>=ca.chiploc(4) )
    %
    % 4.2 Find boundary parallel horizontal and vertical pixel lines
    % 4.2.1 --- Horizontal ---
    % Definition: Regard all caskets above the line
    % Find first line above bo_up or first pixel line 
    hor.first = floor(bo_up/ca.pixelsize);
    hor.last  = floor(bo_lo/ca.pixelsize);
    % 4.2.2 --- Vertical ---
    % Definition: Regard all caskets to the right of the line
    ver.first = floor(bo_ri/ca.pixelsize);
    ver.last  = floor(bo_le/ca.pixelsize);

    % 4.2.3 --- Check Outer limits of the chip ---
    %       --- and redefine if out of range   ---
    if hor.first>(ca.pix(2)/2)-1; hor.first=(ca.pix(2)/2)-1; end
    if hor.last <(-ca.pix(2)/2);  hor.last =(-ca.pix(2)/2);  end
    if ver.first>(ca.pix(1)/2)-1; ver.first=(ca.pix(2)/2)-1; end
    if ver.last <(-ca.pix(1)/2);  ver.last =(-ca.pix(2)/2);  end
    
    % 4.3. Go through all pixels in the illuminated chip area
    for i_px = ver.last:ver.first
      xpix = i_px + ca.pix(1)/2 + 1;
    for i_py = hor.last:hor.first
      ypix = i_py + ca.pix(2)/2 + 1;
      
      % 5. Sum up the light fraction for each pixel
      %---------------------------------------------
      % 5.1 Check all 4 corner points of the current pixel, whether they
      %     are inside or outside
      x_A = i_px*ca.pixelsize;     V(1).p1 = x_A;
      y_A = (i_py+1)*ca.pixelsize; V(4).p2 = y_A;
      %
      x_B = (i_px+1)*ca.pixelsize; V(1).p2 = x_B;
      y_B = (i_py+1)*ca.pixelsize; V(2).p1 = y_B;
      %
      x_C = (i_px+1)*ca.pixelsize; V(3).p1 = x_C;
      y_C = i_py*ca.pixelsize;     V(2).p2 = y_C;
      %
      x_D = i_px*ca.pixelsize;     V(3).p2 = x_D;
      y_D = i_py*ca.pixelsize;     V(4).p1 = y_D;
      %
      % Define variables again (always the more negative value first!)
      V(1).p1 = x_A;  V(1).p2 = x_B;
      V(2).p1 = y_C;  V(2).p2 = y_B;
      V(3).p1 = x_D;  V(3).p2 = x_C;
      V(4).p1 = y_D;  V(4).p2 = y_A;


      % Check whether intersection point is within the current pixel
      if (int_x>=x_A && int_x<x_B) && (int_y>=y_C && int_y<y_B)
        COCincurrpix = 1;
      else
        COCincurrpix = 0;        
      end
      
      
      % A inside?  -> A_in
      if sqrt( (x_A-int_x)^2 + (y_A-int_y)^2 ) <= r_cc
        A_in = 1; else A_in = 0; end
      % B inside?  -> B_in
      if sqrt( (x_B-int_x)^2 + (y_B-int_y)^2 ) <= r_cc
        B_in = 1; else B_in = 0; end
      % C inside?  -> C_in
      if sqrt( (x_C-int_x)^2 + (y_C-int_y)^2 ) <= r_cc
        C_in = 1; else C_in = 0; end
      % D inside?  -> D_in
      if sqrt( (x_D-int_x)^2 + (y_D-int_y)^2 ) <= r_cc
        D_in = 1; else D_in = 0; end

      % "Check Corners" ChCo
        ChCo = [A_in B_in C_in D_in];
      % -------------------------------------------------------------------
      % If all 4 corner points are inside COC -> fill CCD pixel
      if sum(ChCo)==4
        % The whole pixel is illuminated -> fill CCD-pixel
        currccd(xpix,ypix) = currccd(xpix,ypix) + Gamma_A*ca.pixelarea;
      else
        
        % 5.2 Check all 4 edge lines for intersection points with COC: AB
        % 5.2.1 --- Line AB --- x1, x2                               : DC
        Li.p1(1) = -sqrt(r_cc^2 - (y_A-int_y)^2) + int_x; %ok
        Li.p2(1) = +sqrt(r_cc^2 - (y_A-int_y)^2) + int_x; %ok
        % 5.2.2 --- Line BC --- y1, y2
        Li.p1(2) = -sqrt(r_cc^2 - (x_B-int_x)^2) + int_y; %ok
        Li.p2(2) = +sqrt(r_cc^2 - (x_B-int_x)^2) + int_y; %ok
        % 5.2.3 --- Line CD --- x1, x2
        Li.p1(3) = -sqrt(r_cc^2 - (y_C-int_y)^2) + int_x; %ok
        Li.p2(3) = +sqrt(r_cc^2 - (y_C-int_y)^2) + int_x; %ok
        % 5.2.4 --- Line DA --- y1, y2
        Li.p1(4) = -sqrt(r_cc^2 - (x_D-int_x)^2) + int_y; %ok
        Li.p2(4) = +sqrt(r_cc^2 - (x_D-int_x)^2) + int_y; %ok
        %
        % 5.2.5 Find out how many intersection points are on the edge lines
        for iLi=1:4
        if isreal(Li.p1(iLi))
          if Li.p1(iLi) >= V(iLi).p1 && Li.p1(iLi) <= V(iLi).p2
            if Li.p2(iLi) >= V(iLi).p1 && Li.p2(iLi) <= V(iLi).p2
              % Pixel boundary is crossed 2x by COC
              Li.int(iLi) = 3;
            else
              % Pixel boundary crossed 1x by the "left" side of COC
              Li.int(iLi) = 1;
            end
          else
            if Li.p2(iLi) >= V(iLi).p1 && Li.p2(iLi) <= V(iLi).p2
              % Pixel boundary crossed 1x by the "right" side of COC
              Li.int(iLi) = 2;
            else
              % Pixel boundary not crossed by COC
              Li.int(iLi) = 0;
            end
          end
        else % if isreal
          Li.int(iLi) = 0;
        end % if isreal
        end
        

        %=================================================
        % Calculate illuminated area on the current pixel
        %=================================================
        % If COC does not cross any pixel boundaries, but is inside
        
        % Pcc completely inside.
        % The second part includes the case: r_cc=0 and sits exactly on
        % one pixel boundary (Li.int(x)=3
        if COCincurrpix==1 && (sum(Li.int)==0 || (Li.int(3)==3 || Li.int(4)==3))
          % testen:
          % if r_cc < ca.pixelsize/2
          % dann pro pixel nur einmal!
          if r_cc < ca.pixelsize/2 && currccd(xpix,ypix)==0
            currccd(xpix,ypix) = currccd(xpix,ypix) + LightEn;
          else
            % If r_cc shines twice on one pixel count the light on the
            % pixel one time, but count the dismissed light to multiply
            % it at the end to the whole pixel
            restlight = restlight + LightEn;
            restlight_ctr = restlight_ctr + 1;
          end
        else
          % Pcc not completely inside

          % Distance center of the pixel to P_cc (COC)
          x = (x_B+x_A)/2;
          y = (y_B+y_C)/2;
          dist_cc = sqrt( (x-int_x)^2 + (y-int_y)^2 );
        
          % Numerical integration
          if dist_cc < 2*ca.pixelsize
          % fine integration (more steps) if Pcc is close
            numI = 20;
          else
            numI = 10;
          end

          % Integration loop (check vertical lines cutting the COC)
          % Integration width
          dx = ca.pixelsize/numI;
          % Initialize variables
          A=0;
          sumL = zeros(numI,1); sumR = zeros(numI,1);
          for i_i=1:numI+1
            % find intersections with current line
            cy1 = -sqrt(r_cc^2 - (x_A+(i_i-1)*dx-int_x)^2) + int_y;
            cy2 = +sqrt(r_cc^2 - (x_A+(i_i-1)*dx-int_x)^2) + int_y;
            if isreal(cy1) % if cy1 is real, than cy2 is real too!
              % Check boundaries              
              % Wenn de größere von beiden Werten schon kleiner ist als die
              % untere Grenze, dann NaN.
              if cy2 < y_C  ||  cy1 > y_A
                sumL(i_i) = NaN;
                sumR(i_i) = NaN;
              else

                % --- lower boundary ---
                if cy1 < y_C
                  sumL(i_i) = y_C;
                else
                  sumL(i_i) = cy1;
                end
                % --- upper boundary ---
                if cy2 > y_A
                  sumR(i_i) = y_A;
                else
                  sumR(i_i) = cy2;
                end                
              end

            else % imaginary values -> NaN, no intersection
             sumL(i_i) = NaN;
             sumR(i_i) = NaN;
            end
          end

          % Sum up! -> Area
          for i_i=1:numI
            % if intervall is ok

            if ~isnan(sumL(i_i)) && ~isnan(sumL(i_i+1))
              a = sumR(i_i  ) - sumL(i_i  );
              c = sumR(i_i+1) - sumL(i_i+1);
              % Trapez area:
              A_li = 0.5*(a+c)*dx;
              % Sum up
              A = A + A_li;
            end
          end
          % Calculate the amount of light to the current pixel
          currccd(xpix,ypix) = currccd(xpix,ypix) + Gamma_A*A;
        end
        
      % -------------------------------------------------------------------
      end % if sum(ChCo)==4
    end % i_py
    % Plot circle of confusion and pcolor plot of pixel caskets (ccd)
    end % i_px
  end % if: all out of the chips sight
  end % if plas.d3d ~= 0
end; ix = 0;
end; iy = 0;

% Add the restlight (disregarded twice or more hit pixel)
% *** This procedure is a quick and dirty "solution".
  if restlight_ctr > 0
    restlight_fac = restlight/sum(sum(currccd));
    currccd = currccd*(1+restlight_fac);
  end
% Put currccd into ca variable container
ca.currccd = currccd;
% Sum up
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SAVE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fn = mkstring(fnmain,'0',iz,1000,'.mat');
save(fn, 'ca')
end % zi

% if isnan(Gamma_A*A); disp('error 359'); return; end
% i=14; figeps(10,10,1);pcolor(ca.currccd{i});shading flat;axis square;
% figeps(10,10,2);pcolor(ca.ccd);shading flat;axis square;