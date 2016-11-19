function V = LRapprox(A,r)

assert(min(eig(A) >= -1e-6));
[U,S,V] = svd(A,'econ');
V = V(:,1:r)*diag(sqrt(diag(S(1:r,1:r))));
end