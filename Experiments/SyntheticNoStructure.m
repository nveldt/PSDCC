% Synthetic Experiment with Datasets that have no underlying structure
addpath('../Algs')
dList = [2:10,15,20];
n = 60;

numDs = numel(dList);

trials = 5;

tCGW = zeros(numDs,trials);
tZono = zeros(numDs,trials);
tPiv = zeros(numDs,trials);
tExact = zeros(numDs,trials)

ObjZono = zeros(numDs,trials);
ObjCGW = zeros(numDs,trials);
ObjExact = zeros(numDs,trials);
ObjPiv = zeros(numDs,trials);
    
for i = 1:numDs
    d = dList(i);

    % Set number of iterations
    k = 50000;
    pivIts = 1000;
    for times = 1:trials
        V = randn(n,d);
        A = V*V';
        
        tic
        cZ = ZonoCC(V,k);
        time = toc;
        tZono(i,times) = time;
        objz = CCmaxAgreeObj(A,cZ);
        ObjZono(i,times) = objz;
        
        [~,CGWObj,timeSDP] = CGW(A);
        tCGW(i,times) = timeSDP;
        ObjCGW(i,times) = CGWObj;
        
        tic
        Best = 0;
        for trialruns = 1:pivIts
        cPiv = PivotCCIndicator(A);  
        
        Obj = LRCCobjective(V,cPiv);
        if Obj > Best
            Best = Obj;
            Bestc = cPiv;
        end
        end
        timer = toc;
        Best = CCmaxAgreeObj(A,Bestc);
        tPiv(i,times) = timer;
        ObjPiv(i,times) = Best;
        
        tic
        [~,cExact,~] = GeneralCC(A);
        timeE = toc;
        tExact(i,times) = timeE;
        ObjExact(i,times) = CCmaxAgreeObj(A,cExact);
            
    end
    fprintf('Results for d = %d are complete \n',d);
    
end