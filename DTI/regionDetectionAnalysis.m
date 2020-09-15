
%% RegionDetectionAnalysis
% Plots the difference of two matrices using the MAT-File and a threshold as 
% input parameters.
% Please specify both paths of the matrices to compare below in line 12 and
% 13 and the threshold in line 10 and hit 'Run'.

%% Specifications

threshold=0;

path_matrix1 = '/Users/Username/Documents/Projects/proc_data/outputDTI/GroupName1/Baseline.mat';
path_matrix2 = '/Users/Username/Documents/Projects/proc_data/outputDTI/GroupName1/P7.mat';

%% Do not modify the following lines

% Plot Generation
load(path_matrix1)
baseline=infoDTI;
load(path_matrix2)
post=infoDTI;
labels=baseline.labels;
Baseline_medMatrix=median(baseline.matrix,3);
P14_medMatrix=median(post.matrix,3);
diffMatrix=Baseline_medMatrix;
indices=find(sum(abs(diffMatrix),2)<threshold);
diffMatrix(:,indices)=[];
diffMatrix(indices,:)=[];
labels(indices)=[];
%indices = find(abs(diffMatrix)>2);
%diffMatrix(indices) = NaN;
[nrows,ncols]=size(diffMatrix);

% Set main diagonal to NaN
diffMatrix(1:nrows+1:numel(diffMatrix))=nan;
figure
h=imagesc(diffMatrix,[0 100]); colormap(jet); colorbar; grid off;
set(h,'alphadata',~isnan(diffMatrix));

 set(gca,'XTick',1:98,'XTickLabel',labels,'XTickLabelRotation',90,'fontsize',10,...
            'YTick',1:98,'YTickLabel',labels,'TickLength',[0 0],'fontsize',10);
        colorbar
