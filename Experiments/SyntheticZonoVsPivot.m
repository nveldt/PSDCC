% This compares Pivot vs ZonoCC for a range of n values

d = 5;
Nvals = [100,250,500,750,1000,1500,2000,3000,4000,5000,10000,20000];
numNs = numel(Nvals);
trials = 1;

tPiv = zeros(numNs,trials);
tZono = zeros(numNs,trials);

ObjZono = zeros(numNs,trials);
ObjPiv = zeros(numNs,trials);
    
for i = 1:numNs
    n = Nvals(i);

    % Set number of iterations
    k = 500;
    
    for times = 1:trials
        V = randn(n,d);
        A = V*V';
        fprintf('New Trial\n')
        tic
        cZ = ZonoCC(V,k);
        time = toc
        tZono(i,times) = time;
        objz = CCmaxAgreeObj(A,cZ);
        ObjZono(i,times) = objz;
        
        
        tic
        Best = 0;
        for trialruns = 1:500
        cPiv = PivotCCIndicator(A);  
        %Obj = CCmaxAgreeObj(C,cPiv);
        
        Obj = LRCCobjective(V,cPiv);
        if Obj > Best
            Best = Obj;
            Bestc = cPiv;
        end
        end
        timer = toc
        Best = CCmaxAgreeObj(A,Bestc);
        tPiv(i,times) = timer;
        ObjPiv(i,times) = Best;
        
            
    end
    s = strcat('ZonoVsPivotN',num2str(n));
    save(s,'ObjZono','ObjPiv','tPiv','tZono');
    fprintf('Results for n = %d \n',n);
    
end