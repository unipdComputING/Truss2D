%TRUSS2D
clear;
%si impone la work directory
stDir = pwd();
fprintf('\n');
fprintf('*****************************************************\n');
fprintf('*****************************************************\n');
fprintf('*********************************************TRUSS 2D\n');
fprintf('*****************************************Corso di ASM\n');
fprintf('*****************************************************\n');
fprintf('*****************************************************\n');
%vengono chiamati tutti i moduli con all'interno le funzioni che
%serviranno in questo file
%inizializzazione
%--------------------------------------------------------------------
%--------------------------------------------------------------------
%---------------------------------------------------------------INPUT
b = 1500.0;
h = 1000.0;

%nodes è l'array che contiene le coordinate nodali di ogni nodo
%nodes = [Xi Yi;];
nodes=[
0.00*b 0.00*h;  %n_1
1.00*b 0.00*h;  %n_2
2.00*b 0.00*h;  %n_3
3.00*b 0.00*h;  %n_4
0.00*b 1.00*h;  %n_5
1.00*b 1.00*h;  %n_6
2.00*b 1.00*h;  %n_7
3.00*b 1.00*h;  %n_8
];
%elements contiene le incidenze cehli elementi e l'indice 
%di materiale elements[n_i, n_j, mat_k;];
elements=[
1 2 1; %elem_1 elemento tra il nodo 1 e 2 con l'indice di materiale 1
2 3 1; %elem_2
3 4 1; %elem_3
5 6 1; %elem_4
6 7 1; %elem_5
7 8 1; %elem_6
1 5 1; %elem_7
2 6 1; %elem_8
3 7 1; %elem_9
4 8 1; %elem_10
2 5 1; %elem_11
3 6 1; %elem_12
4 7 1; %elem_13
];
%materials contiene le caratteristiche geometriche e costitutive
%materials = [E A;]; con E = modulo elastico; A = area della sezione
% del truss
materials=[
210000.00 2842.00;
210000.00 1000.00;
];
%boundary contiene le condizioni al contorno
%boundary[n_i fix_x fix_y ux uy;]; 
%dove: n_i è l'indice del nodo vincolato;
% fix_j = 0 se il grado di libertà (gdl) è libero; 
%       = 1 se il gdl è bloccato.
% j=x,y (x = direzione x; y = direzione y)
% ux = spostamento impresso in direzione x;
% uy = spostamento im presso in direzione y;
boundary=[
1 1 1 0.0 0.0;
3 1 1 0.0 0.0;
]; 
%loads è l'array dei carichi 
%loads[n_i Fx Fy] dove: n_i l'indice di nodo a cui si applica il
%carico; Fx carico concentrato in direzione x; Fy carico
%concentrato in direzione y.
loads=[
4 0.0 -13000.0;
];
%---------------------------------------------------------------INPUT
solver=SOLVER;
[dbU,dbF] = solver.LinearStatic(elements, nodes   , materials,...
                                loads   , boundary                );
fprintf('END\n');
fprintf('*****************************************************\n');
fprintf('*****************************************************\n');
fprintf('*****************************************************\n');
%--------------------------------------------------------------------
edge = 10;
pl   = PLOT; 
pl.plotGeometry(1,edge,nodes,elements);
scale = 1000.0;
pl.plotDisplacements(2,scale,edge,nodes,elements,dbU);
%--------------------------------------------------------------------
%--------------------------------------------------------------------
