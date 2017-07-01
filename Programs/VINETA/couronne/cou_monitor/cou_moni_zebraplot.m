function []= cou_zebraplot(mat, tvec, bad_ch)
% function []= cou_zebraplot(mat, time [, fs])
%
% plots mat over time and 2pi as density plot, assuming 
% it is data from the couronne
%
% input     mat         matrix [n x 64] n sample, 64 channels (2pi)
%           time        vector [n x 1] time in s
%           fs          (optional) font size
    
   pnt = 300;
   fs= 18;
   
   tvec= tvec .* 1e3;
   dt= tvec(end) - tvec(1);
   phivec= linspace(0, 2, 64)';

   %kill not sampled/bad channels
   keep_ch= setdiff([1:64], bad_ch);
   mat= mat(:, keep_ch);
   phivec= phivec(keep_ch);
   mat= cou_moni_norm(mat);
   
   %interpolation to grid [pnt x pnt]
   [tvec_I, phi_I, mat_I]= cou_moni_interpolate(tvec, phivec, mat', 200);
   tvec_I = tvec_I(20:(end-20)) - tvec_I(20);
   mat_I= mat_I(:, 20:(end-20));
   
   mat_I= mat_I .* 0.5;
   
   %plot couronne
   clf
   pcolor(tvec_I, phi_I, mat_I);
   caxis([-1.5, 1.5]);
   shading flat
   
   ah= gca();
   %set(ah, 'position', [0.12, 0.17, 0.72, 0.7]);
   set(ah, 'fontsize', fs);
   xh= xlabel('t in ms', 'Fontsize', fs);
   
   colormap(pastell(128));
   drawnow
end