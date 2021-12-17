%% plots in the lower triangle of the matrix one goup and in the other triangle another group

% load Mnet text files of both groups
load('Nestin_end_Nestin_Mnet_icov.txt');
load('Sham_end_Sham_Mnet_icov.txt');

% create a new matrix
Nestin=tril(Nestin_end_Nestin_Mnet_icov);
Sham=triu(Sham_end_Sham_Mnet_icov);
Nestin_Sham=Nestin + Sham;
seedno=size(Nestin,1);    
N=size(Nestin,1);

Nestin_Sham(1:length(Nestin_Sham)+1:numel(Nestin_Sham)) = nan;

% plot as color-coded figure
figure;
%figure('position',[100 100 400 400]);
plot(Nestin_Sham);
%Mnetd=reshape(Nestin_Sham,N,N);
h=imagesc(Nestin_Sham,[-0.3 1.2]); colormap(jet); grid off; colorbar;
set(h,'alphadata',~isnan(Nestin_Sham)) 
% set(gca,'XTick',1:seedno,...
%     'XTickLabel',{'Cg1','Cg2','RSG','RSD','PrL','MO','PaS','CPu','Th','HyTh','Hp','Pir','M1/M2','S1','S2','V','Au','CEnt'},...
%     'XTickLabelRotation',45,'fontsize',12,...
%     'YTick',1:seedno,...
%     'YTickLabel',{'Cg1','Cg2','RSG','RSD','PrL','MO','PaS','CPu','Th','HyTh','Hp','Pir','M1/M2','S1','S2','V','Au','CEnt'},...
%     'TickLength',[0 0],'fontsize',12);

set(gca,'XTick',1:seedno,...
            'XTickLabel',{'lCg','lRS','lCPu','lTh','lHyTh','lHp','lPir','lM1/M2','lS1','lS2','lV','lAu','lCEnt',...
            'rCg','rRS','rCPu','rTh','rHyTh','rHp','rPir','rM1/M2','rS1','rS2','rV','rAu','rCEnt'},...
            'XTickLabelRotation',45,'fontsize',12,...
            'YTick',1:seedno,...
            'YTickLabel',{'lCg','lRS','lCPu','lTh','lHyTh','lHp','lPir','lM1/M2','lS1','lS2','lV','lAu','lCEnt',...
            'rCg','rRS','rCPu','rTh','rHyTh','rHp','rPir','rM1/M2','rS1','rS2','rV','rAu','rCEnt'},...
            'TickLength',[0 0],'fontsize',12);



saveas(gcf,'end_Mnet_both_icov','tif');

clear;
