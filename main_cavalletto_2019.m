%TRUSS2D
clear;
clc;
clf;
fprintf('\n');
fprintf('*****************************************************\n');
fprintf('*****************************************************\n');
fprintf('*********************************************TRUSS 2D\n');
fprintf('**************************************************ASM\n');
fprintf('*****************************************************\n');
fprintf('*****************************************************\n');
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%---------------------------------------------------------------------INPUT
%the nodals coordinate have to be add in the nodes array
%
%nodes = [Xi Yi;];
%
%the node index is the number of row in the nodes array
nodes=[
   0.00    0.00;  %n_1
   3.00    3.00;  %n_2
   5.00    0.00;  %n_3
];
%-------------
%The connectivity matrix and the material index
%
%elements[n_i, n_j, id_mat;];
%
%where: n_i    global node index for first  node in the element
%       n_j    global node index for second node in the element 
%       id_mat material index
%
%the element index is the number of row in the elements array
elements=[
1 2 1 %elem_1 
2 3 1 %elem_2 
];
%-------------
%materials array contain the element properties
%
%materials = [E A;]; 
%
%where: E  elastic modulus; 
%       A  cross section area
%
%the material index is the number of row in the material array
materials=[
150000000.00 0.01; %mat_1
];
%-------------
%in the boundary array the boundary conditions have to be added
%
%boundary[n_i fix_x fix_y ux uy;]; 
%
%where: n_i     is the constrained nodes;
%       fix_j = 0 if the dof is free; 
%             = 1 if the dof is locked.
%           j = x,y directions
%       ux      impose displacements in direction x;
%       uy      impose displacements in direction y;
%
%the boundary index is the number of row in the boundary array
boundary=[
1 1 1 0.0 0.0;
3 1 1 0.0 0.0;
]; 
%-------------
%external loads applied in the nodes
%
%loads[n_i Fx Fy] 
%
%where: n_i node index where the load is applied
%       Fx  load component in direction x
%       Fy  load component in direction y
%
%the load index is the number of row in the loads array
loads=[
2 0.0 -15.0;
];
%-----------------------------------------------------------------END INPUT
solver=SOLVER;
[dbU,dbF] = solver.LinearStatic(elements, nodes   , materials,...
                                loads   , boundary                );
fprintf('END\n');
fprintf('*****************************************************\n');
fprintf('*****************************************************\n');
fprintf('*****************************************************\n');
%--------------------------------------------------------------------
edge = 1;
pl   = PLOT; 
pl.plotGeometry(1,edge,nodes,elements);
scale = 1000.0;
pl.plotDisplacements(2,scale,edge,nodes,elements,dbU);
%--------------------------------------------------------------------
%--------------------------------------------------------------------
