randn('seed',0);
V = randn(35,2);


A = V*V';

C = GeneralCC(A);


%% Colored picture
c = C;
figure(1)
clus = length(c(1,:));
set_figure_size([2.25*1.5,1.75*1.5]);
for i = 1:clus
    if i == 1
        color = 'k';
    elseif i ==2
        color = 'g';
    else
        color = 'b';
    end
    
    nodes = find(c(:,i));
    xlim([-3,3])
    ylim([-2,2])
    set_figure_size([2.25*1.5,1.75*1.5]);
    plot(V(nodes,1),V(nodes,2),'.','color',color,'markersize',20,'linewidth',2)
    hold on
end
plot(0,0,'o')
hold on

%% Find the points that delimit the clusters
i = 35
j = 21
k = 33
set = [i j k]

%% Incides
W = V(set,:);
for i = 1:3
    a = W(i,1);
    b = W(i,2);
    ab = [a b];
    ab = ab/.001;
    a = ab(1);
    b = ab(2);
    X = .0001:.5;
    Y = b/a*X;
    plot([0, a],[0,b],'k--')
    hold on
end
%%
hold on
plot(V(set,1),V(set,2),'O','color','r','markersize',10,'linewidth',2)
axis off;
print(gcf,sprintf('Rank2.eps',i),'-depsc2');
Process_AtendHeader('Rank2.eps','');
hold off
