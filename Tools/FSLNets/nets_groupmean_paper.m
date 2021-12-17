%
% nets_groupmean - estimate group mean/one-group-t-test and consistency of netmats across runs/subjects
% Steve Smith, 2012-2014
% modified 01/09/2017 by CG
%
% [Vector,Mnet,Mnetstd]=nets_groupmean(netmats,path,fname);
% netmats = input data
% path = storage path
% fname = addendum for unique data saving


function [Vector,Mnet,Mnetstd]=nets_groupmean_paper(netmats,path,fname)

Nf=sqrt(size(netmats,2));  N=round(Nf);  Nsub=size(netmats,1);

% one-group t-test
grot=netmats; DoF=Nsub-1;

Mnet=mean(grot);
Mnetstd=std(grot);
Mnetd=Mnet;

if N==Nf      % is netmat square....
  Mnet=reshape(Mnet,N,N);
  Mnetstd=reshape(Mnetstd,N,N);
end


%% calculate Vector
Mnetl=tril(Mnet);
Mnetu=Mnetl(:);
Mnet_vector=Mnetu(Mnetu~=0);
size_vector=size(Mnet_vector,1);
Mnetstdu=tril(Mnetstd);
Mnetstdu=Mnetstdu(:);
Mnetstd_vector=Mnetstdu(Mnetstdu~=0);
Vector=zeros(size_vector+size_vector+1,1);
Vector(1:size_vector,1)=Mnet_vector;
Vector(size_vector+2:end,1)=Mnetstd_vector;
seedno=size(Mnet,1);    % calculate seed number

%% make textfile to cellchars and empty lower part of matrix for plotting
textStrings = num2str(Mnet(:),'%0.1f');         
textStrings = strtrim(cellstr(textStrings));
for i =1:seedno
    if i==1
        textStrings(i:seedno)={''};
    else
        textStrings((i+(seedno*(i-1))):(i*seedno))={''};
    end
end

%% plot mean matrix with all colors and save
figure;
Mnet=reshape(Mnetd,N,N);
Mnet(1:size(Mnet)+1:numel(Mnet)) = nan;
%figure('position',[100 100 400 400]);
plot(Mnet);
%if sum(sum(abs(Mnetd)-abs(Mnetd')))<0.00000001    % .....and symmetric
    h=imagesc(Mnet,[-0.5 1.0]);  colormap(jet);  colorbar; grid off;
    set(h,'alphadata',~isnan(Mnet)); 
    if seedno < 16
        set(gca,'XTick',1:seedno,...
            'XTickLabel',{'M1/M2','S1','S2','VC','AC','EntC','Cg','PrL','RSG/RSD','MO','GP','CPu','Th','HyTh','Hp'},...
            'XTickLabelRotation',45,'fontsize',12,...
            'YTick',1:seedno,...
            'YTickLabel',{'M1/M2','S1','S2','VC','AC','EntC','Cg','PrL','RSG/RSD','MO','GP','CPu','Th','HyTh','Hp'},...
            'TickLength',[0 0],'fontsize',12);
    else
        set(gca,'XTick',1:seedno,...
            'XTickLabel',{'lM1/M2','lS1','lS2','lVC','lAC','lEntC','lCg','lPrL','lRSG/RSD','lMO','lGP','lCPu','lTh','lHyTh','lHp',...
            'rM1/M2','rS1','rS2','rVC','rAC','rEntC','rCg','rPrL','rRSG/RSD','rMO','rGP','rCPu','rTh','rHyTh','rHp'},...
            'XTickLabelRotation',45,'fontsize',10,...
            'YTick',1:seedno,...
            'YTickLabel',{'lM1/M2','lS1','lS2','lVC','lAC','lEntC','lCg','lPrL','lRSG/RSD','lMO','lGP','lCPu','lTh','lHyTh','lHp',...
            'rM1/M2','rS1','rS2','rVC','rAC','rEntC','rCg','rPrL','rRSG/RSD','rMO','rGP','rCPu','rTh','rHyTh','rHp'},...
            'TickLength',[0 0],'fontsize',10);
    end
%end
fname_mean=strcat(fname,'_mean');
saveas(gcf,fullfile(path,fname_mean),'tif');
        
% %% plot mean matrix with upper triangle as numbers and lower triangle as colors + save
%        
% figure;
% myColorMap = jet; % Make a copy of jet.
% % Assign white (all 1's) to black (the first row in myColorMap).
% myColorMap(1,:) = [1 1 1];
% imagesc(Mnetl,[0.0 1.8]);  colormap(myColorMap);  colorbar; grid off;
%        
% [x,y] = meshgrid(1:seedno);
% hStrings = text(x(:),y(:),textStrings(:),'HorizontalAlignment','center','fontsize',6);
% 
% if seedno < 16
%     set(gca,'XTick',1:seedno,...
%         'XTickLabel',{'M1/M2','S1','S2','VC','AC','EntC','Cg','PrL','RSG/RSD','MO','GP','CPu','Th','HyTh','Hp'},...
%         'XTickLabelRotation',45,'fontsize',12,...
%         'YTick',1:seedno,...
%         'YTickLabel',{'M1/M2','S1','S2','VC','AC','EntC','Cg','PrL','RSG/RSD','MO','GP','CPu','Th','HyTh','Hp'},...
%         'TickLength',[0 0],'fontsize',12);
% else
%     set(gca,'XTick',1:seedno,...
%         'XTickLabel',{'lM1/M2','lS1','lS2','lVC','lAC','lEntC','lCg','lPrL','lRSG/RSD','lMO','lGP','lCPu','lTh','lHyTh','lHp',...
%         'rM1/M2','rS1','rS2','rVC','rAC','rEntC','rCg','rPrL','rRSG/RSD','rMO','rGP','rCPu','rTh','rHyTh','rHp'},...
%         'XTickLabelRotation',45,'fontsize',10,...
%         'YTick',1:seedno,...
%         'YTickLabel',{'lM1/M2','lS1','lS2','lVC','lAC','lEntC','lCg','lPrL','lRSG/RSD','lMO','lGP','lCPu','lTh','lHyTh','lHp',...
%         'rM1/M2','rS1','rS2','rVC','rAC','rEntC','rCg','rPrL','rRSG/RSD','rMO','rGP','rCPu','rTh','rHyTh','rHp'},...
%         'TickLength',[0 0],'fontsize',10);
% end
% fname_mean_number=strcat(fname,'_mean_paper_number');
% saveas(gcf,fullfile(path,fname_mean_number),'tif');
% 
%        
% %% plot the standard deviation and save
% plot(Mnetstd);
% Mnetstd=reshape(Mnetstd,N,N);
% imagesc(Mnetstd,[0.0 0.5]);  colormap(autumn);  colorbar; grid off;
% if seedno < 16
%     set(gca,'XTick',1:seedno,...
%         'XTickLabel',{'M1/M2','S1','S2','VC','AC','EntC','Cg','PrL','RSG/RSD','MO','GP','CPu','Th','HyTh','Hp'},...
%         'XTickLabelRotation',45,'fontsize',12,...
%         'YTick',1:seedno,...
%         'YTickLabel',{'M1/M2','S1','S2','VC','AC','EntC','Cg','PrL','RSG/RSD','MO','GP','CPu','Th','HyTh','Hp'},...
%         'TickLength',[0 0],'fontsize',12);
% else
%     set(gca,'XTick',1:seedno,...
%         'XTickLabel',{'lM1/M2','lS1','lS2','lVC','lAC','lEntC','lCg','lPrL','lRSG/RSD','lMO','lGP','lCPu','lTh','lHyTh','lHp',...
%         'rM1/M2','rS1','rS2','rVC','rAC','rEntC','rCg','rPrL','rRSG/RSD','rMO','rGP','rCPu','rTh','rHyTh','rHp'},...
%         'XTickLabelRotation',45,'fontsize',10,...
%         'YTick',1:seedno,...
%         'YTickLabel',{'lM1/M2','lS1','lS2','lVC','lAC','lEntC','lCg','lPrL','lRSG/RSD','lMO','lGP','lCPu','lTh','lHyTh','lHp',...
%         'rM1/M2','rS1','rS2','rVC','rAC','rEntC','rCg','rPrL','rRSG/RSD','rMO','rGP','rCPu','rTh','rHyTh','rHp'},...
%         'TickLength',[0 0],'fontsize',10);
% end
% fname_std=strcat(fname,'_std_paper');
% saveas(gcf,fullfile(path,fname_std),'tif');

close all;

