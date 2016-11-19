function [c,ObjScores] = ZonoCCits(V,k,frequency,A)
% Print out a whole bunch of objective scores corresponding to the
% iterations you're at
% frequency is how many iterations you wait before sampling the Best
% Objective

% ZONOCC: returns the clustering from running the zonotope correlation
% clustering algorithm for k iterations on the n x d matrix V

[n,d] = size(V);            % n = number of elements to cluster
                            % d = dimension of the problem/ rank of the
                            % matrix
if nargin < 4
A = V*V';
end

% Step 1: Set up the matrix of generators G
% The generators of the signing zonotope
% are v_i' * (e_r - e_s) for r \neq s, see Onn & Schulman


NumPSigns = n*(d+1)*d/2;    % number of p-signings equals n*(d+1 choose 2)
G = zeros(d^2,NumPSigns);
next = 1;                   % placeholder for generator matrix

% There's probably a faster way to extract generators, but this will be
% called only once
for r = 1:d
    for s = (r+1):(d+1)
        er = zeros(d+1,1);
        es = zeros(d+1,1);
        er(r) = 1;
        es(s) = 1;
        eres = (er-es)';

        for i = 1:n
            a = V(i,:)';
            generator = a*eres;
            generator = reshape(generator,[(d+1)*d,1]);
            generator = generator(1:d*d);
            G(:,next) = generator;
            next = next+1;
        end
    end
end

% Now we start collecting vertices of the zonotope and testing the
% objective that corresponds to them

% The signing zonotope that we are constructing is in R^{d^2}

its = 0;

BestObj = 0;            
npaul = d^2;
ObjScores = [];
C = ones(n,1);
randn('seed',0)
while its < k
    x = randn(npaul,1);
    v = sign(G'*x);         % This will be an extremal p-signing.
                            % See Constantine/Gleich and Onn/Schulman

    [Clus,~] = pSignToClustering(v,n,d);  % Get clustering, this is the botteneck
       
    Obj = LRCCobjective(V,Clus);    % Check the low-rank
                                     % correlation clustering objective
                                        
    if Obj > BestObj                % If it's the new best...
        BestObj = Obj;              % update the highest objective 
        C = Clus;                   % and best clustering found
    end

    its = its + 1;
    if mod(its,frequency) == 0
        Newscore = CCmaxAgreeObj(A,C);
        ObjScores = [ObjScores; Newscore];
        fprintf('Number of its = %d, best obj %f \n',its,Newscore)
    end
end

nonzeroColumns = find(sum(C));
C = C(:,nonzeroColumns);
c = zeros(n,1);
% Get the cluster vector from the cluster id matrix
for t = 1:size(C,2);
    c = c+ t*C(:,t);
end

end

function Obj = LRCCobjective(V,C)
% Tests the low-rank correlation clustering objective, the version where we
% maximize the dot products of each sum point with itself

d = size(V,2);

SumPts = V'*C;        % Gives us a matrix where each column is a sum point

p = size(SumPts,2);   % number of clusters
assert(p<=(d+1));

Obj = 0;

for i = 1:p
   point = SumPts(:,i);     % grab a sum point
   Obj = Obj + point'*point;
end

end
