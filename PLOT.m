classdef PLOT
  %------------------------------------------------------------------------
  properties
  end
  %------------------------------------------------------------------------
  methods
    %----------------------------------------------------------------------
    function this=PLOT
      clf; %chiudo le figure
    end
    %----------------------------------------------------------------------
    function plotGeometry(this,ID,edge,nodes,elements)
      totEl = size(elements,1);
      m = min(nodes);
      M = max(nodes);
      mx = -edge+m(1);
      my = -edge+m(2);
      MX =  edge+M(1);
      MY =  edge+M(2);
      %
      edge_x(1) =  mx;
      edge_x(2) =  MX;
      edge_x(3) =  MX;
      edge_x(4) =  mx;
      edge_y(1) =  my;
      edge_y(2) =  my;
      edge_y(3) =  MY;
      edge_y(4) =  MY;
      hold on
      figure(ID);
      plot(edge_x,edge_y,'w-');
      %
      for iEl=1:totEl
        node1 = elements(iEl,1);
        node2 = elements(iEl,2);
        x(1)= nodes(node1,1);
        x(2)= nodes(node2,1);
        y(1)= nodes(node1,2);
        y(2)= nodes(node2,2);
        plot(x,y,'k-o');
      end
      hold off
    end
    %----------------------------------------------------------------------
    function plotDisplacements(this,ID,scale,edge,nodes,elements,...
                                                             displacements)
      totEl = size(elements,1);
      gl   = GLOBAL;
      NDOF = gl.NDOF;
      m = min(nodes);
      M = max(nodes);
      mx = -edge+m(1);
      my = -edge+m(2);
      MX =  edge+M(1);
      MY =  edge+M(2);
      %
      edge_x(1) =  mx;
      edge_x(2) =  MX;
      edge_x(3) =  MX;
      edge_x(4) =  mx;
      edge_y(1) =  my;
      edge_y(2) =  my;
      edge_y(3) =  MY;
      edge_y(4) =  MY;
      %
      figure(ID);
      plot(edge_x,edge_y,'w-');
      %
      for iEl=1:totEl
        node1 = elements(iEl,1);
        node2 = elements(iEl,2);
        x(1)= nodes(node1,1);
        x(2)= nodes(node2,1);
        y(1)= nodes(node1,2);
        y(2)= nodes(node2,2);
        hold on  %----
        plot(x,y,'k-o');
      end
      for iEl=1:totEl
        node1 = elements(iEl,1);
        node2 = elements(iEl,2);
        x(1)= nodes(node1,1)+scale*displacements((node1-1)*NDOF+1);
        x(2)= nodes(node2,1)+scale*displacements((node2-1)*NDOF+1);
        y(1)= nodes(node1,2)+scale*displacements((node1-1)*NDOF+2);
        y(2)= nodes(node2,2)+scale*displacements((node2-1)*NDOF+2);
        hold on  %----
        plot(x,y,'r-');
      end
    end
    %----------------------------------------------------------------------
    %----------------------------------------------------------------------
    %----------------------------------------------------------------------
    %----------------------------------------------------------------------
    %----------------------------------------------------------------------
    %----------------------------------------------------------------------
    %----------------------------------------------------------------------
    %----------------------------------------------------------------------
    %----------------------------------------------------------------------
  end
  %------------------------------------------------------------------------
end