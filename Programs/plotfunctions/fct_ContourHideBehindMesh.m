function fct_ContourHideBehindMesh(hc, A)
%==========================================================================
%function fct_ContourHideBehindMesh(hc, A)
% May 19 (2012), Christian Brandt, San Diego (UCSD, CER)
%--------------------------------------------------------------------------
% FCT_CONTOURHIDEBEHINDMESH can be helpful by overlayed contour plots with
% surface plots. It hides the part of the contour lines, which are not
% visible, because they are behind the surface.
%
% This is a time consuming procedure!
%
% To change/improve: The criterion for cond1 and cond2 (see very below) need to
% be adapted for each case. This may be automated, by (a) looking at the
% histogram of yd and deciding the maximal allowed distance bewteen a 
% contour vertex and the surface vertex, or (b) by defining a maximal
% allowed distance by looking at a ratio to a typical distance in the
% diagram (e.g. 1% the diagonal of the box).
%--------------------------------------------------------------------------
% hm: handle of surface plot (e.g. surfl)
% hc: handle of contour3 plot
% A: structure: A.X x-vec, A.Y y-vec, A.Z z-data (size(x,1),size(y,2))
%==========================================================================

% Make all contour lines visible, even thos behind the surface
% (if not, usually plot looks messed up, i.e. the surface mesh and the
% contour lines look ok in the matlab figure, but not in the eps-file
% since the 3D data for the lines and the surface is not saved well)
hp1 = findobj('Type','patch');
set(hp1, 'EraseMode', 'XOR')

if length(hc) ~= length(hp1)
  disp('The length of the patch objects (the contour lines) and the')
  disp('length of the Countourobjects are not equal. Debug: Check why!')
end


%=================================
% Calculate camera view vector ViewV
%---------------------------------
camera_position = get (gca, 'CameraPosition');
  % Get the current camera target
  camera_target = get (gca, 'CameraTarget');
  % The camera view vector points from the camera position 
  % to the camera target
  camera_view = camera_target - camera_position;
ViewV = camera_view / abs(camera_position(3));
%=================================


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check whether vertices are hidden behind the surface
%--------------------------------------------------------------------------
xd = nan(1000,1); yd = nan(1000,1);
for ic = 1:length(hp1)

  disp(num2str([ic length(hp1)]))
  V = get(hp1(ic), 'Vertices');
  % Go through all vertices, and hide (NaN) those behind the surface
  ctr = 0;
  ctr_del = 0;
  
  
  % Go only through not NaN vertices:
  ivec = 1:size(V,1);   ind = ~isnan(V(:,1));  ivec = ivec(ind);
  vec_del = nan(length(ivec),1);
  for iv=ivec
    
    ctr_v = 0; d_vertex = nan( max(size(A.z)) , 1);
   
    % Define the current Vertex-View vector
    vertex = V(iv,:);
    v0 = vertex - 200*ViewV;
    v1 = vertex;
    % Length between start of camera line and certex
    vnorm = norm(v1-v0);
    

    for ix = 1:size(A.x,2)-1
    for iy = 1:size(A.y,1)-1
      
      % % In case interested in the surface normals:
      % %   Compare scalar product between ViewV and VertexNormal:
      % vn = get(hm, 'VertexNormals');
      % kv = [vn(iy,ix,1) vn(iy,ix,2) vn(iy,ix,3)]';
      % % Scalar product between view and Vertex Normal
      % dot(kv, ViewV');
      
      % Define 2x within the rectangle: p012 q012
      delt = eps;
      p0 = [A.x(ix  )         A.y(iy  )         A.z(iy  ,ix  )];
      p1 = [A.x(ix+1)-2*delt  A.y(iy  )         A.z(iy  ,ix+1)];
      p2 = [A.x(ix  )         A.y(iy+1)-2*delt  A.z(iy+1,ix  )];
      
      q0 = [A.x(ix+1)-delt    A.y(iy+1)-delt    A.z(iy+1,ix+1)];
      q1 = [A.x(ix+1)-delt    A.y(iy  )         A.z(iy  ,ix+1)];
      q2 = [A.x(ix  )         A.y(iy+1)-delt    A.z(iy+1,ix  )];
      
      % XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX Start Check Plot
      % Check triangle planes, are they set correctly?
      % figure(3);hold on
      % P  = [p0' p1' p2' p0'];   Q  = [q0' q1' q2' q0'];
      % w0 = vertex - 0.2*ViewV;  w2 = vertex + 0.2*ViewV;
      % plot3(P(1,:),P(2,:),P(3,:),'k')
      % plot3(Q(1,:),Q(2,:),Q(3,:),'r')
      % % line([w0(1) w2(1)], [w0(2) w2(2)], [w0(3) w2(3)], 'Color', 'g')
      % % plot3(w0(1), w0(2), w0(3), 'g.')
      % grid on
      % set(gca, 'view', [-68,30])
      % XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX End Check Plot
      
      % Find intersection line data point triangles
      [~, P_int] = fct_intersect_line_plane(v0, v1, p0, p1, p2);
      [~, Q_int] = fct_intersect_line_plane(v0, v1, q0, q1, q2);
      
      % If intersection is found, find out whether contour vertex
      % is in front of triangle surface. If no, delete vertex.
      if ~isnan(P_int)
        % Compare intersection P_int and v0
        ctr = ctr+1;
         xd(ctr) = iv;
         yd(ctr) = norm(P_int'-v0) - vnorm;
        ctr_v = ctr_v + 1;
         d_vertex(ctr_v) = yd(ctr);
        % XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX Start Check Plot
        % figure(2);hold on
        % P  = [p0' p1' p2' p0'];
        % w0 = vertex - 0.2*ViewV;
        % w2 = vertex + 0.2*ViewV;
        % plot3(vertex(1), vertex(2), vertex(3), 'm*')
        % plot3(w0(1), w0(2), w0(3), 'g.')
        % plot3(P(1,:),P(2,:),P(3,:),'k')
        % %plot3(P_int_tria(1),P_int_tria(2),P_int_tria(3),'or')
        % plot3(P_plane(1),P_plane(2),P_plane(3),'or')
        % line([w0(1) w2(1)], [w0(2) w2(2)], [w0(3) w2(3)], 'Color', 'g')
        % grid on
        % set(gca, 'view', [-68,30])
        % XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX End Check Plot
        
      end
      
      if ~isnan(Q_int)
        ctr = ctr+1;
         xd(ctr) = iv;
         yd(ctr) = norm(Q_int'-v0) - vnorm;
        ctr_v = ctr_v + 1;
         d_vertex(ctr_v) = yd(ctr);
        % XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX Start Check Plot
        % figure(2);hold on
        % Q  = [q0' q1' q2' q0'];
        % w0 = vertex - 0.2*ViewV;
        % w2 = vertex + 0.2*ViewV;
        % plot3(vertex(1), vertex(2), vertex(3), 'm*')
        % plot3(w0(1), w0(2), w0(3), 'g.')
        % plot3(Q(1,:),Q(2,:),Q(3,:),'b')
        % %plot3(P_int_tria(1),P_int_tria(2),P_int_tria(3),'or')
        % plot3(P_plane(1),P_plane(2),P_plane(3),'or')
        % line([w0(1) w2(1)], [w0(2) w2(2)], [w0(3) w2(3)], 'Color', 'g')
        % grid on
        % set(gca, 'view', [-68,30])
        % XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX End Check Plot
      end
      
    end
    end

    %======================================================================
    % Criterion: Look along the line of sight: camera -> patch vertex
    % It may be that the patch vertex is not exactly on the surface, but
    % very close due to different plot characteristics of surface plots and
    % contour3 plots.
    % Hide a patch vertex if the patch vertex is once clearly behind a
    % surface (condition 1: cond1) or if the patch vertex is at least 
    % slightly behind two surfaces (condition 2: cond2).
    
    ind = ~isnan(d_vertex); d_vertex = d_vertex(ind);
    cond = d_vertex < 0-1e5*eps; cond = sum(cond);
    
    if cond>0
      ctr_del = ctr_del + 1;
      vec_del(ctr_del) = iv;
    end
    %======================================================================
    
  end

  %XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX Start Check Plot
  % Check Plot: current contour line vertices: distance of intersection
  % figure(2); clf
  % hold on
  % plot(xd, yd, 'or')
  % plot(vec_del,-5*ones(length(vec_del),1) ,'k*')
  % input('<<Press Any Key To Continue>>')
  %XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX End Check Plot 
  
  % Remove NaN from delete vector 'vec_del'
  ind = ~isnan(vec_del);  vec_del = vec_del(ind);
  
  % Fix MatLab bug: if vec_del is empty it runs the for loop nevertheless
  % Only if vec_del=[], it does"t nrun the loop if it is empty 
  if isempty(vec_del); vec_del=[]; end
  
  for u=vec_del'
    V(u,:,:) = [NaN NaN NaN];
  end
  % Set new Vertex-Matrix for current contour line
  set(hp1(ic), 'Vertices', V)
  
end % for loop: ic
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end