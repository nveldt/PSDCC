clear
load 157CSconferences

%% Take data from past six years
dates_raw = dates;
sdates = cellfun(@(x) x(3:7), dates,'UniformOutput',false);
nm = size(volume,1);
nc = size(volume,2);
X = volume;
nyears = 6;
X = X(nm-nyears*12+1:nm,:);
fdates = sdates(nm-nyears*12+1:nm);
nm = size(X,1);

%% Smooth the data

F = smoothts(X','e',0.05)';
plot(F(:,1))
plot(F)
%%
trend = polyval(polyfit((1:nm)',mean(F,2),2),1:nm)';
plot(1:nm,trend,'-',1:nm,mean(F,2));
F = F - repmat(trend,1,nc);
F = zscore(F);

%%
C = corr(F);
imagesc(C);
mycmap();

%% Find the best clustering with several different algorithms
addpath('../Algs')

%% Solve using CGW, the SDP relaxation

cCGW = CGW(C); % takes a while
               % You can edit the code to return the semidefinite matrix X
               % and then run the rounding procedure on this matrix
               % many times to obtain the best result.
               % The bottleneck of the computation is solving the SDP
               
X = CGWgetX(C); % bottleneck of the algorithm

[cCGW,ObjCGW] = CGWroundX(X);       % do this multiple time if desired
               
%% Pivot algorithm, many instantiations, returns best result
tic
Best = 0;
for times = 1:900
cPiv = PivotCC(C);  
Obj = CCmaxAgreeObj(C,cPiv);
if Obj > Best
    Best = Obj;
end
end
toc

%% Solve with ZonoCC
rank = 3;
V = LRapprox(C,rank);
tic
c = ZonoCC(V,10000); % .1 seconds
toc
CCmaxAgreeObj(C,c)

%% Solve Problem Exactly

cExact = GeneralCC(C);


%% Plots
load CSexact
c = cExact;
figure(1)
for i = 1:max(c)
    figure(i); clf;
    inds = find(c ==i);
    h = plot(F(:,inds),'k-','LineWidth',0.5);
    %transparent_lines(h,0.2);
    hold on;
    plot(mean(F(:,inds),2),'r-','LineWidth',2.5);
    set(gca,'XTick',[1,nyears*12])
    set(gca,'XTickLabel',fdates([1,nyears*12]));
    xlim([1,nyears*12]);
    xlabel('Date');
    ylabel({'De-trended, smoothed','search volume'});
    set_figure_size([2.25,1.75]);
    %print(gcf,sprintf('search-cluster-%i',i),'-depsc2');
    print(gcf,sprintf('search-cluster-%i.pdf',i),'-dpdf'); % doesn't work with MATLAB 2014.
    %system(sprintf('/Library/TeX/texbin/pdfcrop search-cluster-%i.pdf',i));
end
hold off
%% Objective as you increase Rank

load Cconf157     % This has results from running ZonoCC with various values of rank
figure(4)
plot(2:15,ObjCC,'k-','linewidth',1)
hold on
n = 157;
best = CCmaxAgreeObj(C,cExact);
xlabel('rank d');
ylabel({'Weight of Agreements'});
set_figure_size([2.25,1.75]);
plot((2:15),(best*ones(14,1)),'--','color','r','linewidth',1)
ylim([6000,8000])
xlim([2,15])
box off
print(gcf,sprintf('CSobjVaryd.eps'),'-depsc2');
Process_AtendHeader('CSobjVaryd.eps','');

%% Checking the accuracy or NMI scores as you vary rank
load CSexact.mat   % This gives the optimal solution
Accuracy = zeros(14,1);
for i = 1:14
    [~,~,ac] = CheckAccuracy(CCconf(:,i),cExact);
    Accuracy(i) = ac;
end
figure(5)
plot(2:15,Accuracy,'k-','linewidth',1)
hold on
n = 157;
xlabel('rank d');
ylabel({'Accuracy'});
set_figure_size([2.25,1.75]);
ylim([.8,1])
xlim([2,15])
box off
print(gcf,sprintf('CSaccuracyVaryd.eps'),'-depsc2');
Process_AtendHeader('CSaccuracyVaryd.eps','');