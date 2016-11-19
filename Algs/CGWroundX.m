function [c,Obj] = CGWroundX(X)
% Given the solution to the SDP relaxation, this is what we run to round
% the relaxation into a cut. This can be done several times to obtain the
% best result.

[T,D] = eig(X);

Dsqrt = sqrtm(D);

V = T*Dsqrt;

% Get t = 2,3 random hyperplanes and split nodes

t = 2;
Hyperplanes = randn(n,t);       % each column is a hyperplane
ClusterID = zeros(n,t);         % Row i is the cluster ID for node i
for i = 1:n                     % iterate through all the nodes
    for h = 1:t                 % testing for each hyperplane
        ClusterID(i,h) = (sign(V(i,:)*Hyperplanes(:,h))+1)/2;
    end
end
w = [1; 2];
c2 = ClusterID*w;t = 2;

t = 3;
Hyperplanes = randn(n,t);        % each column is a hyperplane
ClusterID = zeros(n,t);         % Row i is the cluster ID for node i
for i = 1:n                     % iterate through all the nodes
    for h = 1:t                 % testing for each hyperplane
        ClusterID(i,h) = (sign(V(i,:)*Hyperplanes(:,h))+1)/2;
    end
end
w = [1; 2;4];
c3 = ClusterID*w;

Obj2 = CCmaxAgreeObj(A,c2);
Obj3 = CCmaxAgreeObj(A,c3);

if Obj2 > Obj3
    c = c2;
    Obj = Obj2;
else
    c = c3;
    Obj = Obj3;
end