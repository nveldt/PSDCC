function V = LaplacianEmbedding(A,r,eigFlag)
% V = LaplacianEmbedding(A): given a network A (unweighted adjacency
% matrix), return an embedding V into r-space for each node
% The parameter r is the desired rank of the output, i.e. the number of
% eigenvalues/eigenvectors to use.
% eigFlag == 0 means just take the eigenvectors, but eigFlag == 1 means we
% want to include the effect of the eigenvalues (which act as weights on
% the eigenvectors, making certain columns more "important" than others.

L = nlaplacian(A);      % get the normalized laplacian for A;

[V,S] = eigs(L+speye(size(L,1)),r+1,'SM');    % get the smallest r eigenvalue/eigenvector pairs
%10*eps*speye(size(L,1))
V = V(:,1:r);
S = S(:,1:r);

if eigFlag
    V = V*sqrtm(S);
end

K = V;
columnAverage = mean(K,1);
[n,~] = size(K);
V = K - ones(n,1)*columnAverage; 

end