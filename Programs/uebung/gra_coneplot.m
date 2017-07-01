load wind
       vel = sqrt(u.*u + v.*v + w.*w);
       p = patch(isosurface(x,y,z,vel, 40));
       isonormals(x,y,z,vel, p)
       set(p, 'FaceColor', 'red', 'EdgeColor', 'none');

       daspect([1 1 1]); %coneplot works best when DataAspectRatio set first
       [f verts] = reducepatch(isosurface(x,y,z,vel, 30), .2);
       h=coneplot(x,y,z,u,v,w,verts(:,1),verts(:,2),verts(:,3),2);
       set(h, 'FaceColor', 'blue', 'EdgeColor', 'none');
       [cx cy cz] = meshgrid(linspace(71,134,10),linspace(18,59,10),3:4:15);
       h2=coneplot(x,y,z,u,v,w,cx,cy,cz,v,2); %color by North/South velocity
       set(h2, 'EdgeColor', 'none');

       axis tight; box on
       camproj p; camva(24); campos([185 2 102])
       camlight left; lighting phong
