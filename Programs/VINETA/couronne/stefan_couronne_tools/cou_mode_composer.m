function [mat, time]= cou_mode_composer(modes)
%
% input:    modes   matrix with information about modes
%                   to include:
%                   [m, f, strength; ... ]
    if nargin < 1
        modes= [1, 800, 1; ...
                2, 800, 1];
    end
    
    mat= zeros(5e3, 64);
    
    for i1= 1:size(modes, 1)
        [mat_1mode, time]= cou_art_signal(modes(i1, 3), ...
                                          5e3, ...
                                          1.25e6, ...
                                          modes(i1, 2), ...
                                          modes(i1, 1) ...
                                          );
        mat= mat + mat_1mode;
    end
    
end