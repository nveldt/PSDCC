function [C,c,timeGurobi] = GeneralCC(A,C)
% [C,c,timeGurobi] = GeneralCC(A,C)
% GENERALCC: returns the optimal clustering c for an instance of
% correlationclustering
%
% Input: 
%       A = the adjacency matrix of a signed weighted graph to be used for
%       correlation clustering
%
% Output:
%       C = indicator matrix for the clusters
%       c = clustering vector
%       timeGurobi

n = size(A,1);
A = A - diag(diag(A));
tA = triu(A);

[rA,cA,vecA] = find(tA);

% Now that we have vectorized A, we can deal with this fixed ordering of
% the elements of A, with the mapping defined above.

wp = vecA.*(vecA > 0);
wn = -vecA.*(vecA < 0);

% The constraints matrix
if nargin <2
    C = Get_ConstraintsFastest(n);
end
N = n*(n-1)/2; %number of variables x_ij

clear model
model.obj = wn - wp; 


b = zeros(size(C,1),1);
sense = '<';

model.A = sparse(C);
model.rhs = b;
model.sense = sense;
model.vtype = [repmat('B',1,N)];
model.modelsense = 'max';

clear params;
params.preqlinearize = 1;
params.cuts = 2;
params.outputflag = 0;
fprintf('Running the ILP with Gurobi \n');
tic
result = gurobi(model, params);
timeGurobi = toc;
ExactClustering = result.x;
G = zeros(n,n);

for i = 1:N
    %connect = stats(i,1);
    %G(stats(i,3),stats(i,4)) = 1-connect;
     connect = ExactClustering(i);
     G(rA(i),cA(i)) = 1-connect;
end
G = G + G';

C = connectedcomps(G);
c = zeros(n,1);
for i = 1:size(C,2)
    c = c + i*C(:,i);
end

end