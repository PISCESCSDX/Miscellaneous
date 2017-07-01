addpath('E:\D620-01Janv2010\Vineta\20100510_vineta\matlab\m-files\Mirabelle\Photron')
addpath('E:\D620-01Janv2010\Vineta\20100510_vineta\matlab\m-files\technics')
addpath('E:\D620-01Janv2010\Vineta\20100510_vineta\matlab\m-files\colormaps')

info.dir{1} = 'E:\D620-01Janv2010\Vineta\20100510_vineta\20100511\10_C001H001S0001';
info.fi1{1} = 1;
info.fin{1} = 7000;
info.mov{1} = 1;
info.den{1} = 0;

improcess4l_auto(info);