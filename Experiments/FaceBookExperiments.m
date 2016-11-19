%% Facebook Experiments
addpath('~/data/Facebook100/') %% This assumes you have access to the Facebook graphs
addpath('node2vec');
addpath('../Algs')
for z = 6
    if z ==1
        txt = 'JohnsHop';
        load Jo'hns Hopkins55'
        fileID = fopen('5JohnsHopkins55','r');
    elseif z ==2
        txt = 'Maine'
        load Maine59
        fileID = fopen('5Maine59','r');
    elseif z == 3
        txt = 'Cornell'
        load Cornell5
        fileID = fopen('5Cornell5','r');
    elseif z ==4
        txt = 'Texas'
        load Texas84
        fileID = fopen('5Texas84','r');        
    elseif z == 5
        txt = 'Michigan'
        load Michigan23
        fileID = fopen('5Michigan23','r');  
    else
        txt = 'Reed';
        load Reed98
        fileID = fopen('5Reed98','r');  
    end

%% Edit local_info so that the last column is a bogus 4 labeling

 local_info = local_info(:,[1, 3, 5, 6]);
%%

WholeFile = fscanf(fileID,'%f');
fclose(fileID);
n = int32(WholeFile(1));   
d = int32(WholeFile(2));

rawV = reshape(WholeFile(3:end),[d+1 n])';
rawV = sortrows(rawV,1);
K = rawV(:,2:end);

Network = A;
Vn2v = node2vecEmbedding(K);
An2v = Vn2v*Vn2v';

embed = size(Vn2v,2);
Vlap = LaplacianEmbedding(Network,embed,0);

its = 5;
cn2v = ZonoCC(Vn2v,its);
clap = ZonoCC(Vlap,its);
cKmeans = kmeans(Vn2v,max(cn2v),'Replicates',100);
cKmeans2 = kmeans(Vlap,max(clap),'Replicates',100);
%%
fprintf('\n\t\tNEW DATASET, NEW RESULTS \n\n')
fprintf('z = %d, Lap has %d clusters, Node2Ved has %d\n',z,max(clap),max(cn2v));

[PrCgivenKn2v, PrKgivenCn2v,PrK] = ProbwithClustering(Network,local_info,cn2v);

[PrCgivenKLap, PrKgivenClap,~] = ProbwithClustering(Network,local_info,clap);

[PrCgivenKrand, PrKgivenCrand,~] = ProbwithClustering(Network,local_info,randi(6,n,1));

[~, PrKgivenCkmeansn2v,~] = ProbwithClustering(Network,local_info,cKmeans);
[~, PrKgivenCkmeanslap,~] = ProbwithClustering(Network,local_info,cKmeans2);

FullStats = [PrK, PrKgivenCn2v, PrKgivenCkmeansn2v,PrKgivenClap, PrKgivenCkmeanslap]';
   
%%
[I,J] = size(FullStats);
fprintf('\nNice Tables of Data for z = %d\n \n',z)
    for i = 1:I

        % Before Numbers:
        if i == 1
            fprintf('\\textbf{%s}& Full Graph   & ---  ',char(txt));
        elseif i == 2 
            fprintf('$n = %d$ & n2v & \\alg{ZonoCC} ');
        elseif i == 3
            fprintf('&        & $k$-means');
        elseif i == 4 
            fprintf('& Lap & \\alg{ZonoCC} ');
        else
            fprintf('&     &  $k$-means ');
        end
        for j = 1:J
            fprintf('& %.3f ',FullStats(i,j));
        end

        % After numbers
        if i == 1
            fprintf('\\\\    \\addlinespace\n')
        elseif i == 2 
            fprintf('\\\\ \n ');
        elseif i == 3
            fprintf('\\\\    \\addlinespace\n')
        elseif i == 4 
            fprintf('\\\\ \n ');
        else
            fprintf('\\\\ \n ');
        end
    end
end