function [A,Km] = getCorrelations(K)
% Get the PearsonCorrelation coefficients and store them in A
% K is n x d, you have n objects with d sample values and you want to get
% the correlation

m = mean(K,2);      % average over samples

Km = K - repmat(m,1,size(K,2));


for i = 1:size(Km,1);
    Km(i,:) = Km(i,:)/norm(Km(i,:));
end
A = corr(Km');




end