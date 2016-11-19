%% Results for Planted Experiments. These results are obtained from running
% SyntheticPlantedClusters.m on other, faster computers.

Objectives = [
    1.0000    1.0000    1.0000
    1.0000    0.9425    0.9767
    1.0000    0.9130    1.0000
    1.0000    0.8372    0.8873
    1.0000    0.8263    0.9108
    1.0000    0.7567    0.9402
    0.9788    0.7830    0.9014
    0.9759    0.8173    0.9205
    0.9666    0.8372    0.9448
    0.9486    0.7862    0.9195
    0.9469    0.8087    0.9155
    0.9279    0.8593    0.8899
    0.9142    0.8122    0.8999
    0.9069    0.7994    0.8925
    0.9035    0.8524    0.9096
    0.8895    0.8350    0.9081
    0.9122    0.8521    0.9143
    0.8843    0.8440    0.9059
    0.8860    0.8711    0.9260
];

oZ = Objectives(:,1);
oP = Objectives(:,2);
oC = Objectives(:,3);

Ds = 2:20;

figure(1); clf;
dmax = 20;
%plot(Ds,Objectives,'.-','LineWidth',2,'markersize',15);
plot(Ds,oZ,'.-','LineWidth',2,'markersize',15,'color','g');
hold on
plot(Ds,oC,'.-','LineWidth',2,'markersize',15,'color','r');
hold on
plot(Ds,oP,'.-','LineWidth',2,'markersize',15,'color','b');
hold on
box off
%set(gca,'XTick',[2,15])
%set(gca,'XTickLabel',[2,15]);
xlim([2,dmax]);
ylim([.6,1]);
legend('ZonoCC','CGW','Pivot')
legend('Location','Southeast');
legend boxoff
xlabel('rank d');
ylabel({'Approximation of True Clustering'});
set_figure_size([2.25*1.5,1.75*1.5]);
%
%print(gcf,sprintf('Synthetic1Objectives.pdf'),'-dpdf');
print(gcf,sprintf('SyntheticPlant.eps'),'-depsc2');
Process_AtendHeader('SyntheticPlant.eps','');


%% Times
tC =[0.5058
    0.9371
    1.7440
    4.0006
    6.2733
   13.7541
   22.4681
   33.6054
   55.5141
   81.5119
  118.9101
  158.8305
  232.9255
  328.8559
  434.7194
  623.5532
  710.6893
  988.7145
  1303.9];
     
 tZ =[

    1.4133
    1.7592
    2.1828
    2.8166
    3.5764
    4.4589
    5.4298
    6.6677
    8.3277
   10.2022
   12.7417
   15.4754
   18.5707
   22.3959
   27.1545
   38.0399
   63.7661
  106.6233
  160.6370];



tP =[

    0.3412
    0.4766
    0.4833
    0.7272
    0.8407
    0.7118
    0.7381
    0.8755
    0.8476
    0.8722
    0.8436
    0.9373
    0.9681
    0.9455
    0.9785
    0.9911
    1.0460
    1.1644
    1.0920];

Ds = 2:20;

figure(2); clf;
dmax = 20;
%plot(Ds,Objectives,'.-','LineWidth',2,'markersize',15);
semilogy(Ds,tZ,'.-','LineWidth',2,'markersize',15,'color','g');
hold on
semilogy(Ds,tC,'.-','LineWidth',2,'markersize',15,'color','r');
hold on
semilogy(Ds,tP,'.-','LineWidth',2,'markersize',15,'color','b');
hold on
box off
%set(gca,'XTick',[2,15])
%set(gca,'XTickLabel',[2,15]);
xlim([2,dmax]);
%ylim([.6,1]);
legend('ZonoCC','CGW','Pivot')
legend('Location','Northwest');
legend boxoff
xlabel('rank d');
ylabel({'Runtime in Seconds'});
set_figure_size([2.25*1.5,1.75*1.5]);
%
%print(gcf,sprintf('Synthetic1Objectives.pdf'),'-dpdf');
print(gcf,sprintf('SyntheticPlantRuntime.eps'),'-depsc2');
Process_AtendHeader('SyntheticPlantRuntime.eps','');