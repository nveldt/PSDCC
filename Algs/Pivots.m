function [c,when,time] = Pivots(V,its)
% Returns the best of several instantiations of pivot, when tested on a low
% rank matrix.
A = V*V';
n = size(V,1);
tic
Best = 0;
for times = 1:its
cPiv = Pivot1(A);  
Obj = LRCCobjective(V,cPiv);

if Obj > Best
    when = times;   % tells which on which iteration we found the answer
    Best = Obj;
    cBest = cPiv;
end

end
time = toc;

c = zeros(n,1);
for t = 1:size(cPiv,2)
    c = c + t*cPiv(:,t);
end

end

function cPiv = Pivot1(A)
% Pivot Algorithm for correlation clustering, the algorithm developed by
% Ailon et. al.
% Also known as KwikCluster
%
% Reference:
% Nir Ailon, Moses Charikar, and Alantha Newman. 
% Aggregating inconsistent information: ranking and clustering. 
% Journal of the ACM (JACM), 55(5):23, 2008.

n = size(A,1);
c = ones(n,1);

Vinds = (1:n)';
C = [];

while numel(Vinds >0)
    i = randi(numel(Vinds));    % select random index from Vinds
    pivot = Vinds(i);           % index for pivot
    scores = A(pivot,Vinds);    % gives a list of similarities with pivot
    similar = find(scores >0);  % gives a list of those that are similar
    Similar = Vinds(similar);   % gets original indices
    
    NewCinds = [pivot; Similar];  % new cluster
    ci = zeros(n,1);
    ci(NewCinds) = 1;           % Forms a cluster indicator vector
    C = [C ci];
    Vinds = setdiff(Vinds,NewCinds);    % updates Vinds
end

cPiv = C;

end
