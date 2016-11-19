%% Example of running the experiment once

eps = .15;
n = 60;
d = 5;

PivIts = 500;
ZonoIts = 40000;
ExactFlag = 1;
[RunTimes,Objectives,WeightSum,Exact] = PlantedClusterSynthetic(n,d,eps,PivIts,ZonoIts,ExactFlag);
%% Synthetic Experiment with Planted Clusters

eps = .15;

C = Get_ConstraintsFastest(n);
dList = [11,12,13,14];
numDs = numel(dList);
trials = 5;

tCGW = zeros(numDs,trials);
tZono = zeros(numDs,trials);
tExact = zeros(numDs,trials);
tPiv = zeros(numDs,trials);

ObjZono = zeros(numDs,trials);
ObjCGW = zeros(numDs,trials);
ObjPiv = zeros(numDs,trials);
ObjTriv = zeros(numDs,trials);
ObjExact = zeros(numDs,trials);
ObjPlant = zeros(numDs,trials);
Aweights = zeros(numDs,trials);

PivIts = 500;
ZonoIts = 40000;
ExactFlag = 1;
for i = 1:numDs
    for times = 1:trials
    
    d = dList(i);
    n = d*10;
    [RunTimes,Objectives,WeightSum,Exact] = PlantedClusterSynthetic(n,d,eps,PivIts,ZonoIts,ExactFlag);
    ObjCGW(i,times) = Objectives(1);
    ObjPiv(i,times) = Objectives(2);
    ObjZono(i,times) = Objectives(3);
    ObjTriv(i,times) = Objectives(4);
    ObjPlant(i,times) = Objectives(5);
    ObjExact(i,times) = Exact;
    tZono(i,times) = RunTimes(1);
    tPiv(i,times) = RunTimes(2);
    tCGW(i,times) = RunTimes(3);
    tExact(i,times) = RunTimes(4);
    Aweights(i,times) = WeightSum;

    end
end