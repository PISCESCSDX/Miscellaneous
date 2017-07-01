function []= cou_kfplot(mat, time, t_ind_st, delta_t, mean2exp, fs, z_ampl, viewangle)
%
%function []= cou_kfplot(mat, time, t_ind_st, delta_t, fs)
%
% Plots kf-spectrum, assuming it is data from the Couronne.
%
% NEEDS     cou_kf_fftmean
%           normmat_std
%
% input     mat         matrix [n x 64] n sample, 64 channels (2pi)
%           time        vector [n x 1] time in s
%           t_ind_st    start point of tseries (between 0 and 65000)
%           delta_t     amount of regarded time points
%           mean2exp    exponent of 2 for mean the fft
%           fs          (optional) font size
%           z_ampl      max of z-scale for kf-plot (default: 0.3)
%           view        view angle integer: default: 0, 1
%                       0: weak rotation
%                       1: rotation strong
%
% output    figure with plot of the kf-spectrum
%
% EXAMPLE:  cou_kfplot(A,tt,30000,5000,2,18)

   if nargin < 8
       viewangle= 0;
   end
   if nargin < 7
       z_ampl= 0.3;
   end
   if nargin < 6
       fs= 18;
   end
   if nargin < 5
       mean2exp= 2;
   end      
   if nargin < 4
       delta_t= 5000;
   end   
   if nargin < 3
       t_ind_st= 30000;
   end      
   t_ind_en= t_ind_st + delta_t;   
   pnt = 300;      
   
   phivec= linspace(0, 2, 64)';

   %kill not sampled/bad channels
   kill_ind= isnan(mat);
   phivec= phivec(~kill_ind(1, :));
   time  = time(~kill_ind(:, 1));
   mat= reshape(mat(~kill_ind), ...
                size(time, 1),  ...
                size(phivec, 1));
   
    % rescue whole mat
   fullmat=mat;
   %raw reduction of data
   mat = mat(t_ind_st:t_ind_en, :);
   time= time(t_ind_st:t_ind_en) .* 1000;
   dt= time(end) - time(1);
   
   %normalize data not called by cou_plot_zebrakf
   [S,I] = dbstack;
   [path,c_name] = fileparts(S(min(I+1,length(S))).name);
   if ~strcmp(c_name, 'cou_plot_zebrakf')
       mat= normmat_std(mat);
       [U,S,V]= svds(mat, 5);
       mat= U*S*V';
   end
   
   
   
   %interpolation to grid [pnt x pnt]
   [time_I, phi_I, mat_I]= interp_matrix(time, phivec, mat', 500);
   time_I = time_I(20:(end-20)) - time_I(20);
   mat_I= mat_I(:, 20:(end-20));
   
   %remove offset
   mat_I= mat_I - mean(mean(mat_I));
   

    % plot kf-spektrum
    % couronne measurement - delta t (we always take 800 ns)
    courdt = 800*10^(-9);
    % time vector
    tt = (0:1:delta_t)*courdt;

    % create mode number vector
    m=((1:1:9)-1);
    % shrink mat to make columns even (necessary for fft2d)
    mat=mat(1:delta_t,:);

    % 
    [f, freq]=cou_kf_fftmean(fullmat, mean2exp, courdt);
    % calculate the frequency axis
    % end frequency on plot /kHz
    fend = 20000;
    fend_ind=min(find(freq>fend));
    freq=freq(1:fend_ind);     
    % calculate the absolute value (amplitudes) of the complex f
    f=abs(f(1:fend_ind, 1:9)');
 
    ah= gca();
    set(ah, 'position', [0.12, 0.18, 0.70, 0.79]);
    % make kHz; freq, fend
    freq=freq/1e3;
    fend=fend/1e3;
    %
    w = waterfall(freq, m, f);
    set(gca,'Fontsize',fs)
    % detect maximum of plot
    max_kf=max(max(f));
    axis([0 fend 0 8 0 z_ampl]);
    set(w,'EdgeColor','k');
    set(gca,'ytick',[0 4 8]);
    set(gca,'ztick',[]);
    grid off;
    % set labels
    l1=xlabel('f /kHz');
    l2=ylabel('mode #');        
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