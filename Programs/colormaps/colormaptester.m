A = (0:1:200)./200;
C=A;
A=A.^10;

figure(1)
B = [C; C; C];
pcolor(B)
shading flat
colormap(pastelliceglow(128))

figure(2)
B = [C; C; C];
pcolor(B)
shading flat
colormap(pastellice(128))