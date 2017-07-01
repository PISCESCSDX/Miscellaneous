% Set the pathes from which functions should be loaded.

addpath J:\lxcbra_cbra\matlab\m-others\_ullrich
addpath J:\lxcbra_cbra\matlab\m-others\_ullrich\matlab_general
addpath J:\lxcbra_cbra\matlab\m-others\_ullrich\matlab_general\scan_eval
addpath J:\lxcbra_cbra\matlab\m-others\_ullrich\matlab_general\Bcal
addpath J:\lxcbra_cbra\matlab\m-others\_ullrich\mdf_tools

addpath J:\lxcbra_cbra\matlab\
addpath J:\lxcbra_cbra\matlab\m-files
addpath J:\lxcbra_cbra\matlab\m-files\bicoherence\STABox
addpath J:\lxcbra_cbra\matlab\m-files\colormaps
addpath J:\lxcbra_cbra\matlab\m-files\couronne_tools
addpath J:\lxcbra_cbra\matlab\m-files\downloaded
addpath J:\lxcbra_cbra\matlab\m-files\evaluation
addpath J:\lxcbra_cbra\matlab\m-files\evaluation\kennlinien
addpath J:\lxcbra_cbra\matlab\m-files\evaluation\bdot_probe_cal
addpath J:\lxcbra_cbra\matlab\m-files\exciter_tools
addpath J:\lxcbra_cbra\matlab\m-files\interferometer
addpath J:\lxcbra_cbra\matlab\m-files\mathematics
addpath J:\lxcbra_cbra\matlab\m-files\physics
addpath J:\lxcbra_cbra\matlab\m-files\spectrum_tools
addpath J:\lxcbra_cbra\matlab\m-files\technics
addpath J:\lxcbra_cbra\matlab\m-files\vineta
addpath J:\lxcbra_cbra\matlab\m-files\downloaded\ChaoticSystems



% addpath \afs\ipp\w7x\vineta\usr\program\matlab
% addpath \afs\ipp\w7x\vineta\usr\program\matlab\instrument
% addpath \afs\ipp\w7x\vineta\usr\program\matlab\plasma
% addpath \afs\ipp\w7x\vineta\usr\program\matlab\interferometer

%finde factory defaults mit get(0,'factory') und ersetze factory durch
%default um eigenen Default zu waehlen
set(0,'DefaultTextFontSize',16)
set(0,'DefaultAxesFontSize',16)
set(0,'DefaultFigurePaperType','a4letter')
set(0,'DefaultFigurePaperUnits','centimeters')
