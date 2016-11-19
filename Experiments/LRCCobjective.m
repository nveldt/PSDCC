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