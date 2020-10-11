classdef SOLVER
  %------------------------------------------------------------------------
  properties(Constant)
    TOLL = 0.0001;
  end
  properties
    gl = GLOBAL;
    el = ELTRUSS2D;
  end
  %------------------------------------------------------------------------
  methods
    %----------------------------------------------------------------------
    function this=SOLVER
    end
    %----------------------------------------------------------------------
    %Stiffness matrix assembly
    %K global stiffness matrix
    %elK local stiffness matrix relate to the global r.s.
    function [K]=assembly(this,nodes,elements,materials)
        K   = zeros(0);
        dimEl = size(elements,1);
        if dimEl==0
            return;
        end
        nElnode = this.el.TOTNODES; %numero di nodi per elemento
        dimNode = size(nodes,1);
        if dimNode==0
            return;
        end
        NDOF = this.gl.NDOF;
        K = zeros(dimNode*NDOF,dimNode*NDOF);
        for e=1:dimEl
            n1   = elements(e,1);%primo nodo
            n2   = elements(e,2);%secondo nodo
            m    = elements(e,3);%indice del materiale
            X1   = [nodes(n1,1) nodes(n1,2);];
            X2   = [nodes(n2,1) nodes(n2,2);];
            L    = this.gl.getDistance(X1,X2);
            E    = materials(m,1);
            Area = materials(m,2);
            %matrice di rigidezza dell'elemento
            elK = this.el.localStiffness(E,Area,L,X1,X2);
            %assemblaggio
            for nodeRow=1:nElnode
                posRow = elements(e,nodeRow);
                for nodeCol=1:nElnode
                    posCol = elements(e,nodeCol);
                    for i=1:NDOF
                        row   = NDOF*(posRow -1)+i;
                        rowEl = NDOF*(nodeRow-1)+i;
                        for m=1:NDOF
                            col   = NDOF*(posCol -1)+m;
                            colEl = NDOF*(nodeCol-1)+m;
                            K(row,col)=K(row,col)+elK(rowEl,colEl);
                        end
                    end
                end
            end
        end
    end
    %----------------------------------------------------------------------
    %assemblaggio dei carichi
    function [F]=loadAssembly(this,K,nodes,loads,boundary)
        dimNode = size(nodes   ,1);
        dimLoad = size(loads   ,1);
        dimBound= size(boundary,1); 
        NDOF = this.gl.NDOF;
        dimComp = NDOF;
        if dimNode==0
            return;
        end
        F=zeros(dimNode*NDOF,1);
        %assegnazione dei carichi
        for l=1:dimLoad
            indexNode = loads(l,1);
            for i=1:dimComp
                F(NDOF*(indexNode-1)+i) = loads(l,i+1);
            end
        end
        %assegnazione dei carichi dovuti alla bc
        for bc=1:dimBound
            indexNode = boundary(bc,1);
            for dof=1:NDOF
                if boundary(bc,1+dof)==1
                    col = this.gl.NDOF*(indexNode-1)+dof;
                    for row=1:dimNode*dimComp
                        F(row)=F(row)-K(row,col)*boundary(bc,1+NDOF+dof);
                    end
                end
            end
        end
    end
    %----------------------------------------------------------------------
    function [dbU,dbF]=LinearStatic(this,elements, nodes, materials,...
                                    loads, boundary                 )
        NDOF        = this.gl.NDOF;
        dimNode     = size(nodes,1);
        dimProblem  = dimNode*NDOF;
        dbU         = zeros(dimProblem,1);
        u           = zeros(dimProblem,1);
        %pause
        fprintf('STATIC SOLVER\n');
        K        = this.assembly(nodes,elements,materials);
        %pause
        F        = this.loadAssembly(K,nodes,loads,boundary);
        u        = this.solver(K,F,boundary);
        %
        dbU      = this.updateDisp(u,boundary);
        dbF      = this.getReactions(K,u,F);
    end
    %----------------------------------------------------------------------
    %linear static solver
    function [u]=solver(this,K,F,boundary)
        dimProblem   = size(K,1);
        dimBound     = size(boundary,1);
        dimComp      = size(boundary,2);
        bcCont       = 0;
        indexNodeOld = 0;
        u            = ones(dimProblem,1);
        NDOF         = this.gl.NDOF;
        for b=1:dimBound
            indexNode = boundary(b,1);
            if indexNode<indexNodeOld 
                fprintf('ERROR: la numerazione delle bc deve essere sequenziale');
                fprintf('ERROR: progeramma terminato');
                abort
            end
            for i=2:dimComp %il primo valore è l'indice di nodo
                if boundary(b,i)==1 
                    indexPos = NDOF*(indexNode-1)+(i-1);
                    u(indexPos)=0.0; %assegno le condizioni di vincolo
                    indexPos = indexPos-bcCont; %tengo conto della
                                                %riduzione della matrice
                    K(:,indexPos)=[];
                    K(indexPos,:)=[];
                    F(indexPos)  =[];
                    bcCont = bcCont+1;
                end
            end
        end
        x = K\F;
        cont=1;
        for i=1:dimProblem
            if u(i)~=0.0
                u(i)=x(cont);
                cont = cont+1;
            end
        end
    end
    %----------------------------------------------------------------------
    function [vF]=getReactions(this,K,u,F)
        dim = size(K,1);
        vF   = zeros(dim,1);
        for i=1:dim
            for j=1:dim
                vF(i)=vF(i)+K(i,j)*u(j);
            end
            vF(i) = vF(i)-F(i);
        end
    end
    %----------------------------------------------------------------------
    function [var]=updateDisp(this,u,boundary)
        NDOF    = this.gl.NDOF;
        dimBound= size(boundary,1);
        var = u;
        for bc=1:dimBound
            indexNode = boundary(bc,1);
            for dof=1:NDOF
                if boundary(bc,1+dof)==1
                    var(NDOF*(indexNode-1)+dof)=boundary(bc,1+NDOF+dof);
                end
            end
        end
    end
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