function [BSour BMain BTrim] = fct_bfield_PISCES(P, cs, cm, ct, N)
%==========================================================================
%function [BSour BMain BTrim] = fct_bfield_PISCES(P, cs, cm, ct, N)
% Last change: 06.03.2012, San Diego, C. Brandt
% 03.03.2012, San Diego, C. Brandt
%--------------------------------------------------------------------------
% FCT_BFIELD_PISCES calculates the B-field-components Bx, By, Bz in every
% point pgrid{i,j,k} = [x,y,z].
%--------------------------------------------------------------------------
% IN:     P: 3D meshgrid where B should be calculated
%        cs: source coil parameters:
%            cs.z z-positions, cs.curr current (A)
%        cm: main coil parameters:
%            cm.z z-positions, cm.curr current (A)
%        ct: trim coil parameters:
%            ct.z z-positions, ct.curr current (A), ct.N number of wires
%             per circumference of one single loop
%         N: number of finite elements per wire loop
%OUT: BSour: all components Bx, By, Bz on the grid P of the source coils
%     BMain: all components Bx, By, Bz on the grid P of the main coils
%     BTrim: all components Bx, By, Bz on the grid P of the trim coils
%     File containing P, BMain, BTrim, cm, ct.
%--------------------------------------------------------------------------
% EXAMPLES: [BSour BMain BTrim] = fct_bfield_PISCES(P, cs, cm, ct, N)
%==========================================================================


info{1} = 'P is the spatial grid where the Bfield is calculated';
info{2} = 'BSour is the magnetic field in Tesla of the source field coils';
info{3} = 'BMain is the magnetic field in Tesla of the main field coils';
info{4} = 'BTrim is the magnetic field in Tesla of the trim field coils';
info{5} = 'cm and ct contain the z-positions and currents of the coils';
info{6} = [num2str(N) ' wire elements are used per coil']; %#ok<NASGU>

% Save data file
fn = ['Bfield_PiscesA_Sour1A_Main1A_Trim1A_N' num2str(N) '.mat'];



% 2.1: Calculate wire structure of: Main Coils (cm)
ws = fct_PISCES_CoilMainElements(cs.zpos, cs.curr, N);

% 2.2: Calculate wire structure of: Main Coils (cm)
wm = fct_PISCES_CoilMainElements(cm.zpos, cm.curr, N);

% 2.3: Calculate wire structure of: Trim Coils (ct)
wt = fct_PISCES_CoilTrimElements(ct.zpos, ct.curr, N);


%==========================================================================
[dimx,dimy,dimz] = size(P.x);    % Same size as P.y and P.z

% Source field
Bsx = zeros(dimx, dimy, dimz);
Bsy = zeros(dimx, dimy, dimz);
Bsz = zeros(dimx, dimy, dimz);

% Main field
Bmx = zeros(dimx, dimy, dimz);
Bmy = zeros(dimx, dimy, dimz);
Bmz = zeros(dimx, dimy, dimz);

% Trim field
Btx = zeros(dimx, dimy, dimz);
Bty = zeros(dimx, dimy, dimz);
Btz = zeros(dimx, dimy, dimz);

%-----------------------------------------------
% Go through all wires of the source field coils
%-----------------------------------------------
disp('Calculating Source Magnetic Field ...')
for iw = 1:length(ws.S1)
  disp_num(iw,length(ws.S1))
%--------------------------------------------------------------------------
for ii = 1:dimx
  for jj = 1:dimy
    for kk = 1:dimz
      % Current position vector R (change from mm to m)
      R  = 1e-3 * [P.x(ii,jj,kk) P.y(ii,jj,kk) P.z(ii,jj,kk)];
      S1 = 1e-3 * ws.S1{iw};
      S2 = 1e-3 * ws.S2{iw};
      
      % Calculate Source Bfield in R
      B = fct_bfield_wire_short(S1, S2, ws.Cu{iw}, 1, R);
      % Add Bfield to Bsx Bsy Bsz
      Bsx(ii,jj,kk) = Bsx(ii,jj,kk) + B(1);
      Bsy(ii,jj,kk) = Bsy(ii,jj,kk) + B(2);
      Bsz(ii,jj,kk) = Bsz(ii,jj,kk) + B(3);
    end
  end
end
%
end     % for iw

% Store variables
BSour.Bx = Bsx;
BSour.By = Bsy;
BSour.Bz = Bsz;
save(fn, 'P','BSour','cs','cm','ct','info')

%---------------------------------------------
% Go through all wires of the main field coils
%---------------------------------------------
disp('Calculating Main Magnetic Field ...')
for iw = 1:length(wm.S1)
  disp_num(iw,length(wm.S1))
%--------------------------------------------------------------------------
for ii = 1:dimx
  for jj = 1:dimy
    for kk = 1:dimz
      % Current position vector R (change from mm to m)
      R  = 1e-3 * [P.x(ii,jj,kk) P.y(ii,jj,kk) P.z(ii,jj,kk)];
      S1 = 1e-3 * wm.S1{iw};
      S2 = 1e-3 * wm.S2{iw};
      
      % Calculate Main Bfield in R
      B = fct_bfield_wire_short(S1, S2, wm.Cu{iw}, 1, R);
      % Add Bfield to Bmx Bmy Bmz
      Bmx(ii,jj,kk) = Bmx(ii,jj,kk) + B(1);
      Bmy(ii,jj,kk) = Bmy(ii,jj,kk) + B(2);
      Bmz(ii,jj,kk) = Bmz(ii,jj,kk) + B(3);
    end
  end
end
%
end     % for iw

% Store variables
BMain.Bx = Bmx;
BMain.By = Bmy;
BMain.Bz = Bmz;
save(fn, '-append', 'BMain')


%-----------------------------------
% Go through all wires of trim field
%-----------------------------------
disp('Calculating Trim Magnetic Field ...')
for iw = 1:length(wt.S1)
  disp_num(iw,length(wt.S1))
%--------------------------------------------------------------------------
for ii = 1:dimx
  for jj = 1:dimy
    for kk = 1:dimz
      % Current position vector R (change from mm to m)
      R  = 1e-3 * [P.x(ii,jj,kk) P.y(ii,jj,kk) P.z(ii,jj,kk)];
      S1 = 1e-3 * wt.S1{iw};
      S2 = 1e-3 * wt.S2{iw};

      % Calculate Trim Bfield in R
      B = fct_bfield_wire_short(S1, S2, wt.Cu{iw}, 1, R);
      % Add Bfield to Btx Bty Btz
      Btx(ii,jj,kk) = Btx(ii,jj,kk) + B(1);
      Bty(ii,jj,kk) = Bty(ii,jj,kk) + B(2);
      Btz(ii,jj,kk) = Btz(ii,jj,kk) + B(3);
    end
  end
end
%
end     % for iw
%==========================================================================

% Store variables
BTrim.Bx = Btx;
BTrim.By = Bty;
BTrim.Bz = Btz;
save(fn, '-append', 'BTrim')

end