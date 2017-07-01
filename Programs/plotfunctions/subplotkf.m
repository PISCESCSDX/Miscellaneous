function [l1, l2] = subplotkf(freq,mvec,kfmat,kfaxis,z_max,...
  vw,coltri,ylb,fonts)
%==========================================================================
% function [l1, l2] = subplotkf(freq,mvec,kfmat,kfaxis,z_max,...
%   vw,coltri,ylb,fonts)
%--------------------------------------------------------------------------
% IN: freq: frequency vector
%     mvec: m-vector
%     kfmat: 2d kf-data 
%     kfaxis: [fa fb ma mb 0 kfmax]
%     z_max: 0 off; 1 on .. show the max on the zaxis
%     vw(opt): 0, 1 (default: 0)
%     coltri: 0: only black; 1: max red, +blue +black
%OUT: subplot of the kf-spectrum
%     l1: handle of freq label
%--------------------------------------------------------------------------
% EX: subplotkf(freq, mvec, kfmat, kfaxis, [-50, 30]);
%==========================================================================

if nargin<9; fonts=12; end
if nargin<8; ylb = 'mode #'; end
if nargin<7; coltri=0; end
if nargin<6; vw=0; end
if nargin<5; z_max=0 ; end
if nargin<4; error('Input arguments are missing!'); end


w = waterfall(freq, mvec, kfmat);
  if coltri == 1
    colormap colortri;
    hmat = kfmat;
    % find the maximum peak and color the m-color red
    [maxh maxi1] = max(max(hmat'));
    hmat(maxi1,:)=-Inf;
    [maxh maxi2] = max(max(hmat'));
    cda = get(w,'cdata');
    cda(:,:) = 0;
    cda(:, maxi1) = 1;
    cda(:, maxi2) = 0.5;
    set(w,'cdata', cda);
  else
    set(w,'EdgeColor','k');
  end
    
    set(gca, 'Fontsize', fonts)
    axis(kfaxis);
    set(gca,'ytick',[-8 -4 0 4 8]);
    if z_max == 1
        zcapt = decupdown(kfaxis(6), 0, 1, 0);
        set(gca,'ztick', [0 zcapt]);
    else
        set(gca,'ztick', []);
    end
    grid off;
    ma=kfaxis(3); mb=kfaxis(4);
    fa=kfaxis(1); fb=kfaxis(2);    
    % set labels - use this for "plotcou.m"
    l1 = text(0, 0, 'f (kHz)', 'fontsize', fonts);
    l2 = text(0, 0, ylb, 'fontsize', fonts);
    zlabel('S (arb.u.)');
    switch vw
      case 0
        set(l1, 'Position', [(fa-0.05*(fb-fa))  (ma-0.65*(mb-ma))]);
        set(l2, 'Position', [(fa-0.45*(fb-fa)) (ma +0.25*(mb-ma))]);
        view(-50,30); set(l1,'Rotation',24); set(l2,'Rotation',-16);
      case 1  
        set(l1, 'Position', [(fa-0.05*(fb-fa))  (ma-0.65*(mb-ma))]);
        set(l2, 'Position', [(fa-0.45*(fb-fa)) (ma +0.25*(mb-ma))]);
        view(-30,30); set(l1,'Rotation',10); set(l2,'Rotation',-30);
      case 2
        view(-10,30); set(l1,'Rotation',5); set(l2,'Rotation',-60);
        set(l1, 'Position', [(fb-0.2*(fb-fa))  (ma-0.5*(mb-ma))]);
        set(l2, 'Position', [(fa-0.30*(fb-fa)) (ma +0.4*(mb-ma))]);
    end

end