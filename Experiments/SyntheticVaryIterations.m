% Run this to obtain data on how the objective changes as you change the
% number of iterations to run for ZonoCC


Nvals = [100,250,500,750,1000,1500,2000,3000,5000];

k = 20000;
frequency = 100;

ObjCC = zeros(numel(Nvals),k/frequency);
tZono = zeros(numel(Nvals),1);
for i = 1:1 
    n = Nvals(i);
    V = randn(n,5);
    tic
    [c,Obj] = ZonoCCits(V,k,frequency);
    time = toc;
    ObjCC(i,:) = Obj';
    tZono(i) = time;
    plot(1:numel(Obj),Obj)
    hold on
end
save('VaryItsExperiment')

%% You can load the code directly rather than re-running.
% Since ZonoCC is randomized, you won't always get the same thing.
load VaryItsExperiment

%% This gives several different plots for different parameters
for i = 1:9
Obj = ObjCC(i,:);
figure(i)
plot(1:frequency:k,Obj)
end
%% Try a simpler experiment, with just one set of parameters
n = 1000;
k = 10000;
d = 5;
frequency = 100;
V = randn(n,5);
[~,Obj] = ZonoCCits(V,k,frequency);

%%
plot(1:frequency:k,Obj)
%%
Obj = ObjCC(8,:);
figure(1)
plot(1:frequency:k,Obj, 'k-','LineWidth',2.5)
set(gca,'XTick',[1,20000])
set(gca,'XTickLabel',[1,20000]);
xlim([1,20000]);
xlabel('Number of Iterations k');
ylabel({'Weighted of Agreements'});
box off
set_figure_size([4.5/1.5,3.5/1.5]);
print(gcf,sprintf('SynVaryIts.eps'),'-depsc2');
Process_AtendHeader('SynVaryIts.eps','');
