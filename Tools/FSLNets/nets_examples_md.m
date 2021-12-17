

%%% FSLNets - simple network matrix estimation and applications
%%% FMRIB Analysis Group
%%% Copyright (C) 2012-2014 University of Oxford
%%% See documentation at  www.fmrib.ox.ac.uk/fsl

clear;

%%% change the following paths according to your local setup
addpath /Users/pallastn/Desktop/Test/SCA/FSLNets           % wherever you've put this package
addpath /Users/pallastn/Desktop/Test/SCA/L1precision       % L1precision toolbox
addpath /Users/pallastn/Desktop/Test/SCA/pwling            % pairwise causality toolbox


ts_dir = 'group6';
data_prefix = 'SP';
seed_prefix = 'Seed_ROIs';
pathName = '/Users/pallastn/Desktop/Test/SCA/ICA/stat';


pathOfData = fullfile(pathName,ts_dir);
%%% extract timeseries from data with seeds
%nets_fslmeants_md(pathOfData,data_prefix,seed_prefix);


%%% load timeseries data from the dual regression output directory
% ts=nets_load(ts_dir,3,1);
   %%% arg2 is the TR (in seconds)
   %%% arg3 controls variance normalisation: 0=none, 1=normalise whole subject stddev, 2=normalise each separate timeseries from each subject
% ts_spectra=nets_spectra(ts);    % have a look at mean timeseries spectra


ts=nets_load_md(pathOfData,'MasksTCs.',1.42,1);

%ts_spectra=nets_spectra(ts);              % have a look at mean spectra after this cleanup


%%% create various kinds of network matrices and optionally convert correlations to z-stats.
%%% here's various examples - you might only generate/use one of these.
%%% the output has one row per subject; within each row, the net matrix is unwrapped into 1D.
%%% ts: structure containing node information including all timeseries
%%% the r2z transformation estimates an empirical correction for autocorrelation in the data.
%%% r2z correction: set to 1 to use the r to z correction factor; set to 0 to leave netmats as z-score
% netmats0=nets_netmats(ts,0,'cov');        % covariance (with variances on diagonal)
% netmats0a=nets_netmats(ts,0,'amp');       % amplitudes only - no correlations (just the diagonal)
% netmats1=nets_netmats(ts,1,'corr');       % full correlation (normalised covariances)
% netmats2=nets_netmats(ts,1,'icov');       % partial correlation
% netmats3=nets_netmats(ts,1,'icov',10);    % L1-regularised partial, with lambda=10
% netmats5=nets_netmats(ts,1,'ridgep');     % Ridge Regression partial, with rho=0.1
% netmats11=nets_netmats(ts,0,'pwling');    % Hyvarinen's pairwise causality measure

% netmats1=nets_netmats_md(ts,0,0,'corr');
netmats1=nets_netmats_md(ts,1,0,'corr');

% netmats1=nets_netmats_md(ts,1,1,'corr');
% netmats2=nets_netmats_md(ts,1,0,'icov');
% netmats5=nets_netmats_md(ts,1,0,'ridgep',1);

%nets_savemat_md(pathOfData,ts_dir,netmats1,'netmats');

%figure;
%Mnet1 = reshape(netmats1(1,:),[sqrt(length(netmats1)) sqrt(length(netmats1))]);
% imagesc(Mnet1,[0.0 1.0])
% % imagesc(testMat,[0.0 1.0]);
% colormap(jet);
% colorbar; grid off;
% return
%%% view of consistency of netmats across subjects; returns t-test Z values as a network matrix
%%% second argument (0 or 1) determines whether to display the Z matrix and a consistency scatter plot
%%% third argument (optional) groups runs together; e.g. setting this to 4 means each group of 4 runs were from the same subject
[Znet1,Mnet1]=nets_groupmean(netmats1,1); % test whichever netmat you're interested in; returns Z values from one-group t-test and group-mean netmat
% [Znet5,Mnet5]=nets_groupmean(netmats5,1); % test whichever netmat you're interested in; returns Z values from one-group t-test and group-mean netmat

%[Znet1,Mnet1]=nets_groupmean_md(netmats1,0);
% 
% 
% nets_savemat_md(ts_dir,Znet1,'Znet');
%nets_savemat_md(pathOfData,Mnet1,'Mnet');
% 
% 
%
%t = load('/Volumes/AG_Aswendt_Share/Scratch/Asw_fMRI2AllenBrain_Data/annotations.mat');
%labels = t.annotations;
%  labels={'lM1/M2','lS1','lS2','lVC','lAC','lEntC','lCg','lPrL','lRSG/RSD','lMO','lGP','lCPu','lTh','lHyTh','lHp','lAmy','rM1/M2','rS1','rS2','rVC','rAC','rEntC','rCg','rPrL','rRSG/RSD','rMO','rGP','rCPu','rTh','rHyTh','rHp','rAmy'...
%      'lM1/M2','lS1','lS2','lVC','lAC','lEntC','lCg','lPrL','lRSG/RSD','lMO','lGP','lCPu','lTh','lHyTh','lHp','lAmy','rM1/M2','rS1','rS2','rVC','rAC','rEntC','rCg','rPrL','rRSG/RSD','rMO','rGP','rCPu','rTh','rHyTh','rHp','rAmy','rVC'};
% % 
%plotmat_values([pathOfData '/' ts_dir '_Mnet'], [pathName '/images/' ts_dir '_Mnet'],[0.0 1.0],0,labels,12);
%plotmat_2in1([pathOfData '/' ts_dir '_Mnet'],[pathOfData '/' ts_dir '_Mnet'],['images/' ts_dir_2 '_Mnet_' ts_dir_1 '_Mnet'],[0.0 1.8],labels,10);




%%% view hierarchical clustering of nodes
%%% arg1 is shown below the diagonal (and drives the clustering/hierarchy); arg2 is shown above diagonal
%nets_hierarchy(Znet1,Znet5,ts.DD,group_maps);

%%% view interactive netmat web-based display
% nets_netweb(Znet1,Znet5,ts.DD,group_maps,'netweb');


%%% cross-subject GLM, with inference in randomise (assuming you already have the GLM design.mat and design.con files).
%%% arg4 determines whether to view the corrected-p-values, with non-significant entries removed above the diagonal.
% [p_uncorrected,p_corrected]=nets_glm(netmats1,'design.mat','design.con',1);  % returns matrices of 1-p
%%% OR - GLM, but with pre-masking that tests only the connections that are strong on average across all subjects.
%%% change the "8" to a different tstat threshold to make this sparser or less sparse.
% netmats=netmats3;  [grotH,grotP,grotCI,grotSTATS]=ttest(netmats);  netmats(:,abs(grotSTATS.tstat)<8)=0;
% [p_uncorrected,p_corrected]=nets_glm(netmats,'design.mat','design.con',1);

%design='Designs/nestin/design_n.mat';
%contrast='Designs/nestin/design_n.con';
%[p_uncorrected3,p_corrected3]=nets_glm(netmats3,design,contrast,1);


%%% view 6 most significant edges from this GLM
% nets_edgepics(ts,group_maps,Znet1,reshape(p_corrected(1,:),ts.Nnodes,ts.Nnodes),6);


%%% simple cross-subject multivariate discriminant analyses, for just two-group cases.
%%% arg1 is whichever netmats you want to test.
%%% arg2 is the size of first group of subjects; set to 0 if you have two groups with paired subjects.
%%% arg3 determines which LDA method to use (help nets_lda to see list of options)
% [lda_percentages]=nets_lda(netmats3,36,1)
%[lda_percentages]=nets_lda(netmats3,10,2)        % Linear Discriminant Analysis (LDA)
%[lda_percentages]=nets_lda(netmats3,10,8)        % Support Vector Machines (SVM) classifier


%%% create boxplots for the two groups for a network-matrix-element of interest (e.g., selected from GLM output)
%%% arg3 = matrix row number,    i.e. the first  component of interest (from the DD list)
%%% arg4 = matrix column number, i.e. the second component of interest (from the DD list)
%%% arg5 = size of the first group (set to -1 for paired groups)
% nets_boxplots(ts,netmats3,1,7,36);
% print('-depsc',sprintf('boxplot-%d-%d.eps',IC1,IC2));     % example syntax for printing to file
%nets_boxplots(ts,netmats3,3,6,2);

