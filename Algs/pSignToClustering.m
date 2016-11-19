function [C,isPart] = pSignToClustering(s,n,d)
% PSIGNTOCLUSTERING: Given a pSigning s 
% (see "Vector Partition Problem for Convex Objective Functions" Onn & 
% Schulman, 2001), which is of length n*(d+1)*d/2, this function finds
% the clustering corresponding to the pSigning. Output is an n x d+1
% indicator matrix C for which node is in which cluster.
% 
% Note: this implementation is specifically to be used with the low-rank
% correlation clustering objective, where we know the number of clusters is
% upper bounded by (d+1). Thus d+1 takes the role of the value 'p' from the
% Onn & Schulman 2001 paper.
%
% Note 2: Not every {-1,1} vector corresponds to a partition. For this
% reason, we return the boolean variable isPart which indicates whether the
% answer corresponds to an actual partition of the dataset
%
% Inputs:
%       s : pSigning vector
%       n : number of data points to be clustered
%       d : dimension of the clustering problem
%
% Outputs:
%       C : zero-one matrix of size n x (d+1) indicating clusters
%       isPar: 0 if C doesn't not define a partition, 1 if it does
%

C = ones(n,d+1);                  % for now ignore the last column

next = 1;                       % where we are in the s vector


for i = 1:d                     % i is the ID of the first cluster
    
    for j = (i+1):(d+1)         % j is the ID of the second cluster
        
                                % We are considering which nodes are on
                                % which side of the hyperplane that
                                % separates clusters i and j
        
        
        for k = 1:n             % k is the node in question
            %Reshaped = reshape(s,[n d*(d+1)/2])
            if (s(next) == -1)  % i.e., node k is NOT in cluster i
                C(k,i) = 0;   % So we zero out the corresponding entry 
                                % of the indicator matrix
            else                % i.e. node k is NOT in cluster j
                C(k,j) = 0;
            end
            
            next = next+1;
        end
    end
end

isPart = (n==sum(sum(C)));
%LastCluster = sum(C,2) < 1;

%C = [C LastCluster];


end