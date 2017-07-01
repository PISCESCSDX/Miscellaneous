function []=cou_subplotkf(freq, mode_vec, kfspectrum, fs, z_ampl, viewangle);
%
%
%function []=cou_subplotkf(freq, mode_vec, kfspectrum, fs, kfmax,
%viewangle);
%
% plots kf-spectrum, assuming 
% it is data from the couronne
%
% input     freq
%           mode_vec
%           kfspectrum
%           fs          (optional) font size
%           z_ampl      max of z-scale for kf-plot (default: 0.3)
%           view        view angle integer: default: 0, 1
%                       0: weak rotation
%                       1: rotation strong
%
% output    figure with plot of the kf-spectrum
%
% EXAMPLE: cou_subplotkf(kf_freq, kf_mode_vec, kfspectrum{2}, 18, kfmax);


   if nargin < 6
       viewangle= 0;
   end
   if nargin < 5
       z_ampl= 0.3;
   end
   if nargin < 4
       fs= 18;
   end

   fend=freq(end);
    % make kHz; freq, fend
    freq=freq/1e3;
    fend=fend/1e3;
    %
    fa=freq(1); fb=fend; ma=mode_vec(1); mb=mode_vec(end);
    w = waterfall(freq, mode_vec, kfspectrum);
    
    % find max and corresponding mmax and fmax
    [fmax, fmax] = max(max(kfspectrum));
    [mmax, mmax] = max(max(kfspectrum'));
    disp(['dominant mode: ' num2str(mode_vec(mmax))]);
    disp(['at frequency: ' num2str(freq(fmax)) ' kHz']);        
    disp(' ');
    
    set(gca,'Fontsize',fs)
    % detect maximum of plot
    axis([fa fb ma mb 0 z_ampl]);
    set(w,'EdgeColor','k');
    set(gca,'ytick',[-8 -4 0 4 8]);
    set(gca,'ztick',[]);
    grid off;
    % set labels
    l1=text(0, 0, 'f /kHz', 'fontsize', fs);
    % set: , 1/3 behind mb
    set(l1, 'Position', [3 (ma-(mb-ma)/2) 0]);
%    OLD set(l1, 'Position', [-5 -6 0]);    
    l2=text(0, 0, 'mode #', 'fontsize', fs);
    set(l2, 'Position', [-10 0 0]);
%    OLD set(l2, 'Position', [-14 3 0]);    
%    l1=xlabel('f /kHz');
%    [x]=get(l1, 'Position'),
%    set(l1, 'Position', [x(1) x(2) x(3)]);
%    l2=ylabel('mode #');     
%    [x]=get(l2, 'Position'),
%    set(l2, 'Position', [x(1) 1.01*x(2) x(3)]);
%    [x]=get(l2, 'Position'),
   zlabel('S(m,f)');    
    % set the view angle
   if viewangle == 0
        view(-40,25);
        set(l1,'Rotation',12)     
        set(l2,'Rotation',-22)               
   else
        view(-70,20);
        set(l1,'Rotation',35)     
        set(l2,'Rotation',-5)                          
   end;

end