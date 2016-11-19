function [c,Obj,timeSDP] = CGW(A)
% [c,Obj,timeSDP] = CGW(A): 
% implementation of Charikar, Guruswami, and
% Wirth's SPD relaxation algorithm for MaxAgree correlation clustering.
% Returns a clustering vector c
% Input: A = matrix containing CC weights.
%
% Output: clustering c, objective Obj, and time it took to solve the
% semidefinite program
%
% Reference:
% Moses Charikar, Venkatesan Guruswami, and Anthony Wirth. 
% Clustering with qualitative information. 
% In Foundations of Computer Science, 2003. Proceedings. 
% 44th Annual IEEE Symposium on, pages 524?533. IEEE, 2003.

n = size(A,1);
% First solve the semidefinite program
fprintf('Solving the SDP with cvx \n');
tic
cvx_clear
cvx_begin sdp
    variable X(n,n) symmetric
    maximize (sum(sum(A.*X)))
    subject to

    for i = 1:n-1
        for j = i+1:n
            X(i,j) >= 0
        end
    end
    for i = 1:n
        X(i,i) == 1
    end
    X == semidefinite(n);
cvx_end

timeSDP = toc;

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

end