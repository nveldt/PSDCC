function [Mistakes, Agreements, Accuracy] = CheckAccuracy(c,labels)
% input a clustering c, and a set of labels. Return how many mistakes are
% made and how many agreements there are (whether or not two items are
% clustered together or separate vs. whether they share the same label

Result = [c labels];
num = size(c,1);
numClus = size(Result,2)-1;
Clustering = zeros(num,1);
for i = 1:numClus
    Clustering = Clustering + c(:,i)*i;
end

Mistakes = 0;
Agreements = 0;
for i = 1:num
    for j = i+1:num
            
            if Clustering(i) == Clustering(j) && labels(i) == labels(j)
                Agreements = Agreements + 1;
            elseif Clustering(i) ~=Clustering(j) && labels(i) ~=labels(j)
                Agreements = Agreements + 1;
            else
                Mistakes = Mistakes +1;
            end

    end
end

Accuracy = Agreements/(num*(num-1)/2);
end