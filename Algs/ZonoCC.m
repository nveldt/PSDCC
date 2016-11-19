function c = ZonoCC(V,k)
% ZONOCC: returns the clustering from running the zonotope correlation
% clustering algorithm for k iterations on the n x d matrix V

[n,d] = size(V);            % n = number of elements to cluster
                            % d = dimension of the problem/ rank of the
                            % matrix

% Step 1: Set up the matrix of generators G
% The generators of the signing zonotope
% are v_i' * (e_r - e_s) for r \neq s, 

% References:
%           Signing Zonotope:
% Shmuel Onn and Leonard J Schulman. 
% The vector partition problem for convex objective functions. 
% Mathematics of Operations Research, 26(3):583?590, 2001.
%
%           Randomized Zonotope vertex enumeration:
% K. Stinson, D. F. Gleich, and P. G. Constantine.
% A randomized algorithm for enumerating zonotope
% vertices. arXiv preprint arXiv:1602.06620, 2016.


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

C = ones(n,1);

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
    if mod(its,5000) == 0
        fprintf('Number of its = %d, best obj %f \n',its,BestObj)
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

