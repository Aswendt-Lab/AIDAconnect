function [connectivity,labels] =  matrixMaker_DTI(mat_file,varargin)

%% matrixMaker_DTI
% This function is used by getMergedFMRI_data.m and is not meant to be
% used manually. It creates matrices from raw .mat-files of the
% DTI-measurement.

if nargin==2
    var_plot=varargin{1};
else
    var_plot=1;
end

addpath('./GraphEval/');
[dataPath,filename]=fileparts(mat_file);
filename = strsplit(filename,'.');

groupInfo = dtigroup_load(dataPath,filename{1});
connectivity = groupInfo.mergedMat;

labels = groupInfo.labels;
%% Plot values
if var_plot == true
    %[C,Q] = modularity_und(connectivity,2);
    %[X,Y,On] = grid_communities(C);
    %disp(Q)
   
    %[On,~] = reorder_mod(connectivity,labels);
    plotmat_values_DTI(connectivity,dataPath,filename{1},[0.0 100.0],0,labels);
end
end