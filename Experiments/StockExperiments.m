load prices_easy

[A,K] = getCorrelations(prices);

List = [(1:497)' sectors];
List = sortrows(List,2);
[p,neworder] = sort(sectors);
assert(norm(List(:,1) - neworder) == 0)
ArrangeSectors = corr(K(neworder,:)');

figure(1)
mycmap()
imagesc(ArrangeSectors)

%%
CCstocks = zeros(497,14);
C = A;
for r = 2:15
        its = 10000;
        V = LRapprox(C,r);
        c = ZonoCC(V,its);
        CCstocks(:,r-1) = c;
        ObjCC(r-1)= CCmaxAgreeObj(C,c);
end
%% ZonoCC

rank = 2;
tic
V = LRapprox(A,rank);

its = 50000;

cLR = ZonoCC(V,its);
toc
ObjLR = CCmaxAgreeObj(A,cLR)

%% Pivot

tic
Best = 0;
for times = 1:40000
cPiv = PivotCC(A);  
Obj = CCmaxAgreeObj(A,cPiv);
if Obj > Best
    Best = Obj;
end
end
toc
Best

%% Many k means

tic
Best = 0;
for times = 1:400
cPiv = kmeans(V,2);  
Obj = CCmaxAgreeObj(A,cPiv); 
if Obj > Best
    Best = Obj;
end
end
toc
Best

%% Plotting
c = cLR;
c = c2;
figure(2)
mycmap()
[p,new] = sort(c);

Arrange = corr(K(new,:)');

imagesc(Arrange) 

    