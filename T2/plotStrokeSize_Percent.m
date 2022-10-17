function plotStrokeSize_Percent(filename)

%% plotStrokeSize_Percent
% Plots overlay of the lesion in relation to the size of the affected 
% region in percent.

% Input Arguments
% filename = Path to a processed T2 MAT-file (as String)

%% Example
% plotStrokeSize_Percent('\Volumes\MRI\proc_data\out_path\T2\Group1\P1.mat')
% Remember to replace the path with an existing path 

%% Do not modify the following lines

fileData = dir(filename);
colV = [0, 0.2, 0.9410];

P = load(filename);
infoT2_P = P.infoT2;

lesionSize = infoT2_P.affectedRegions_percent(:,mean(infoT2_P.affectedRegions_percent)>0);
regionName = strrep(infoT2_P.labels(mean(infoT2_P.affectedRegions_percent)>0),'_',' ');

figure;
x0=10;
y0=500;
width=1600;
height=400';
set(gcf,'position',[x0,y0,width,height])

name=strsplit(fileData.name,'.');
name=name(1);
boxplot(lesionSize,regionName,'orientation','horizontal');title(name)
xlabel('Relation affected Volume / region Volume [%]')
grid
set(gca,'FontSize',12)
ax = gca;
ax.XGrid = 'off';
ax.YGrid = 'on';
h = findobj(gca,'tag','Median');
set(h,'linestyle','-');
set(h,'Color',[1 0 0])
end