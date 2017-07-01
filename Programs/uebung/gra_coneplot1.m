load wind
  [x y z] = meshgrid(0:1,0:1,0:1);
%  [cx cy cz] = meshgrid(0:0.1:0.1,0:1,0:1);  

  [cx cy cz] = meshgrid(,,);  
  h2=coneplot(x,y,z,cx,cy,cz,x,y,z);
  set(h2, 'FaceColor', 'blue', 'EdgeColor', 'none');
  axis tight; box on
  camproj p; camva(24);
  campos([6 0 2]);
  camlight left; 
  lighting phong;