function [c,Bound,Wijp,Wijm] = MaxAgree2Approx(A)
% Returns the trivial 1/2 approximation for a max-agree correlation
% clustering problem

A = A - diag(diag(A));
B = triu(A);
Bound = sum(sum(abs(B)))/2;
n = size(A,1);


Wijp = sum(sum((B > 0).*B));
Wijm = abs(sum(sum((B < 0).*B)));

if Wijp > Wijm
    c = ones(n,1);
else
    c = (1:n)';
end
    
end