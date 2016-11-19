function [times,Objectives,WeightSum,ObjExact] = PlantedClusterSynthetic(n,d,eps,PivIts,ZonoIts,ExactFlag)
%
% Synthetic Data experiment where we generate a dataset with true clusters
% planted in the data. We compare between different correlation clustering
% techniques

addpath('../Algs')

% Step One: determine the number of "True" Clusters 
numClus = randi([ceil(d/2) d+1]); % d/2 to d+1 uniformly at random


% Step Two: get a set of clusters that are pairwise negative
X = simplex_coordinates1(d);

p = randperm(d+1);  
subset = p(1:numClus);            % take just one vertex per "True" cluster
X = X(:,subset);
[Q,~] = qr(rand(d));
X = Q*X;                          % rotate points for variety

% Step Three: Generate a Random Planted Clustering
cPlant = randi(numClus,n,1);
toSort = [cPlant (1:n)'];
Sort = sortrows(toSort,1);
NewOrder = Sort(:,2);
cPlant = Sort(:,1);

% Step Four: Form the matrix V that is a perfect clustering.
V = zeros(n,d);
for i = 1:n
    V(i,:) = X(:,cPlant(i))';
end

% Step Five: Add noise
Vf = (1-eps)*V + eps*randn(n,d);
A = Vf*Vf';

% At this point we have a synthetic dataset with planted clusters
fprintf('Synthetic dataset with planted clusters has been formed \n')
Best = 0;
ObjPlant = CCmaxAgreeObj(A,cPlant);
tExact = 0;

if ExactFlag
    [~,cExact,tExact] = GeneralCC(A);
    fprintf('Solved the problem exactly with Gurobi \n')
    Best = CCmaxAgreeObj(A,cExact);
    ObjExact = Best;
    fprintf('The planted cluster is %f of the optimal CC solution \n',ObjPlant/Best);
    
    if ObjPlant/Best < .65
        fprintf('The score is very low, there is too much noise in the dataset for epsilon = %f \n',eps);
    end
end

[cTriv,~,pp,mm] = MaxAgree2Approx(A);      % 1/2 approx algorithm
Total = pp+mm;
ObjTriv = CCmaxAgreeObj(A,cTriv);
if Best > 0
    Total = Best;                          % If we solve optimally, then we can compute exactly how good the approx is
end
fprintf('We can trivially obtain a %f approximation \n',ObjTriv/Total);

% Solve with ZonoCC
tic
cZono = ZonoCC(Vf,ZonoIts);
tZono = toc;

ObjZono = CCmaxAgreeObj(A,cZono);
RelZono = ObjZono/Total;        % gives a measure of relative performance

[cPiv,when,tPiv] = Pivots(Vf,PivIts);
ObjPiv = CCmaxAgreeObj(A,cPiv);
RelPiv = ObjPiv/Total;         % gives a measure of relative performance

[cCGW,ObjCGW,tCGW] = CGW(A);
ObjCGW = CCmaxAgreeObj(A,cCGW);
if Best == 0
    fprintf('Did not solve the problem exactly, so the scores are lower bounds for the approximation \n')
end
fprintf('\nTrivial:   Obj = %f;                \n',ObjTriv/Total);
fprintf('CGW:       Obj = %f; time = %f, \n',ObjCGW/Total,tCGW);
fprintf('Pivot:     Obj = %f; time = %f, when = %d of %d \n',RelPiv,tPiv,when,PivIts);
fprintf('ZonoCC:    Obj = %f; time = %f  Iterations =  %d \n',RelZono,tZono,ZonoIts);
fprintf('Planted    Obj = %f;                \n',ObjPlant/Total);
times = [tZono, tPiv, tCGW, tExact];
Objectives = [ObjCGW, ObjPiv, ObjZono, ObjTriv,ObjPlant];
WeightSum = pp+mm;

end