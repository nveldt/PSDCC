function c = connectedcomps(A)
% Given an adjacency matrix, very slowly calculates the connected
% components. Code is not optimized.

n = size(A,1);
e1 = zeros(n,1);
e1(1) = 1;
eLabelled = zeros(n,1);

comps = 1:n; %each node is in it's own component

for i = 1:n
   e1 = e1|A'*e1;
end

eLabelled = eLabelled + e1;
eUnlabeled = ones(n,1) - eLabelled;
count = 0;
Components = e1;

while nnz(eUnlabeled) > 0 && count < n
    Un = find(eUnlabeled);
    m = min(Un);
    eNext = zeros(n,1);
    eNext(m) = 1;
    
    for i = 1:n
        eNext = eNext|A'*eNext;
    end

    eLabelled = eLabelled + eNext;
    eUnlabeled = ones(n,1) - eLabelled;
    Components = [Components eNext];
    count = count+1;
end

c = Components;
end