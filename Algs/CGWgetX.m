function X = CGWgetX(A)
% X = CGWgetX(A): 
% Solves just the SDP relaxation for the CGW method, which is the
% bottleneck of the computation
%
% Reference:
% Moses Charikar, Venkatesan Guruswami, and Anthony Wirth. 
% Clustering with qualitative information. 
% In Foundations of Computer Science, 2003. Proceedings. 
% 44th Annual IEEE Symposium on, pages 524?533. IEEE, 2003.

n = size(A,1);
% First solve the semidefinite program
fprintf('Solving the SDP with cvx \n');
cvx_clear
cvx_begin sdp
    variable X(n,n) symmetric
    maximize (sum(sum(A.*X)))
    subject to

    for i = 1:n-1
        for j = i+1:n
            X(i,j) >= 0
        end
    end
    for i = 1:n
        X(i,i) == 1
    end
    X == semidefinite(n);
cvx_end

end