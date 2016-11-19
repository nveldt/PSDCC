function V = node2vecEmbedding(K)
% V =  node2vecEmbedding(K)
% K is the output embedding from running node2vec on a certain dataset.
% V is the result of subtracting the mean point to turn the problem into an
% instance of correlation clustering.

columnAverage = mean(K,1);
[n,~] = size(K);
V = K - ones(n,1)*columnAverage; 


end