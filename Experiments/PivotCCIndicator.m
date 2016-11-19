function C = PivotCC(A)
% Pivot Algorithm for correlation clustering

n = size(A,1);
c = ones(n,1);

Vinds = (1:n)';
C = [];

while numel(Vinds >0)
    i = randi(numel(Vinds));    % select random index from Vinds
    pivot = Vinds(i);           % index for pivot
    scores = A(pivot,Vinds);    % gives a list of similarities with pivot
    similar = find(scores >0);  % gives a list of those that are similar
    Similar = Vinds(similar);   % gets original indices
    
    NewCinds = [pivot; Similar];  % new cluster
    ci = zeros(n,1);
    ci(NewCinds) = 1;           % Forms a cluster indicator vector
    C = [C ci];
    Vinds = setdiff(Vinds,NewCinds);    % updates Vinds
end

end
