load wind
      daspect([1 1 1]); 
       [cx cy cz] = meshgrid(linspace(71,134,10),linspace(38,79,10),8:4:20);
       h2=coneplot(x,y,z,u,v,w,cx,cy,cz,v,2);
       set(h2, 'EdgeColor', 'none');

       axis tight; box on
       camproj p; camva(24); campos([185 2 102])
       camlight left; lighting phong
