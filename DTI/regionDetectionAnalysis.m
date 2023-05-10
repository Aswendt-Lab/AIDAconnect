
%% RegionDetectionAnalysis
% Plots the difference of two matrices using the MAT-File and a threshold as 
% input parameters.
% Please specify both paths of the matrices to compare below in line 12 and
% 13 and the threshold in line 10 and hit 'Run'.

%% Specifications

threshold = 0;

path_matrix1 = '\Volumes\AG_Aswendt_Projects\Student_projects\14_Aref_Kalantari_2021\Projects\CRC_WP1\proc_data_sorted_timeline_2\outputDTI\Stroke\P14.mat';
path_matrix2 = '\Volumes\AG_Aswendt_Projects\Student_projects\14_Aref_Kalantari_2021\Projects\CRC_WP1\proc_data_sorted_timeline_2\outputDTI\Stroke\P28.mat';

%% Do not modify the following lines

% Plot Generation
load(path_matrix1)
baseline=infoDTI;
labelsFirstDay = baseline.labels;
numberOfLabelsFirstDay = size(labelsFirstDay,1);
load(path_matrix2)
post=infoDTI;
labelsSecondDay = post.labels;
numberOfLabelsSecondDay = size(labelsSecondDay,1);
if numberOfLabelsFirstDay ~= numberOfLabelsSecondDay
    disp('Warning: Number of labels differ between both matrices');
end
Baseline_medMatrix=median(baseline.matrix,3);
P14_medMatrix=median(post.matrix,3);
diffMatrix=Baseline_medMatrix;
indices=find(sum(abs(diffMatrix),2)<threshold);
diffMatrix(:,indices)=[];
diffMatrix(indices,:)=[];
labelsFirstDay(indices)=[];
%indices = find(abs(diffMatrix)>2);
%diffMatrix(indices) = NaN;
[nrows,ncols]=size(diffMatrix);

% Set main diagonal to NaN
diffMatrix(1:nrows+1:numel(diffMatrix))=nan;
figure
h=imagesc(diffMatrix,[0 numberOfLabelsFirstDay+2]); colormap(jet); colorbar; grid off;
set(h,'alphadata',~isnan(diffMatrix));

 set(gca,'XTick',1:numberOfLabelsFirstDay,'XTickLabel',labelsFirstDay,'XTickLabelRotation',90,'fontsize',10,...
            'YTick',1:numberOfLabelsFirstDay,'YTickLabel',labelsFirstDay,'TickLength',[0 0],'fontsize',10);
        colorbar
