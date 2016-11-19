function Obj = CCmaxAgreeObj(A,c)
% Obj = CCmaxAgreeObj(A,c)
% Returns the Weighted MaxAgree correlation clustering objective based on
% the clustering c, given the coefficients from the matrix A.
%
% c can either be a cluster vector or an indicator matrix

[n,t] = size(c);
if t > 1 && max(max(c)) ==1
    % then we were given an indicator matrix
    cOld = c;
    c = zeros(n,1);
    for i = 1:t
        c = c + i*cOld(:,i);
    end
end

Pos = 0;
Neg = 0;
for i = 1:(n-1)         % we iterate through all pairs i < j
    for j = (i+1):n
        
        % We increase the objective if (i,j) is a positive edge
        % and i and j have been clustered together
        % OR if (i,j) is a negative edge and i and j have been clustered
        % apart
        
        if A(i,j) > 0 && c(i) == c(j)
            %Pos = [Pos; A(i,j)];
            Pos = Pos + A(i,j);
        end
        
        if A(i,j) < 0 && c(i) ~= c(j)
            %Neg = [Neg; A(i,j)];
            Neg = Neg + A(i,j);
        end
 
    end
end

Obj = sum(Pos) - sum(Neg);


end