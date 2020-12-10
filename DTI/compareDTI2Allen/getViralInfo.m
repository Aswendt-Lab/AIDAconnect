function getViralInfo(matFile,bslCell)
[~,name,~] = fileparts(matFile);
vpm_data = load(matFile);
%get raw data
par_conn=vpm_data.matrix;
tempStr = string(vpm_data.column_labels);
par_labels= cellstr(tempStr);
par_values = nanmean(par_conn,1);
tempL = load('labels.mat');
parTrans = tempL.Allen2Par;


% delete zero values
nonZeroValues= par_values>0;
par_conn = par_conn(:,nonZeroValues);
par_conn(par_conn==0)=nan;
par_labels=par_labels(nonZeroValues);
par_std=nanstd(par_conn,[],1);
par_mean = nanmean(par_conn,1);

[~,par_values,~,k] = sortLabel2Par(par_labels,par_mean,par_std,parTrans);
%[par_sorted,ia] = sort(par_values);
regionName=strsplit(name,'_');
regionName=regionName(1);

k(1)=[];
k(end)=[];
cellDegreeL=bslCell.Nodes.Degree(1:49);
cellDegreeR=bslCell.Nodes.Degree(50:end);
cellDegreeL=cellDegreeL(k);
cellDegreeR=cellDegreeR(k);
cellDegree=cellDegreeR+cellDegreeL;
% reoorder labels
corrinfo = {'rho (p)'};
labels = {'DTI node strength','Allen projection volume'}; % volume of projection signal for each node in mm3
[~,~,statsStroke]=correlationPlot(cellDegree, par_values,labels,regionName,[],'corrInfo',corrinfo,'colors','r');
disp(statsStroke)
end


function [par_labels,par_values,par_std,k] = sortLabel2Par(ARAlabels,ARAvalues,ARAstd,parTrans)
par_labels=ARAlabels;

for i =2:length(parTrans)
    parName = parTrans{i,1};
    parChilds=strsplit(parTrans{i,2},',');
    if isempty(parChilds{1})
        continue;
    end
    for j=1:length(parChilds)
        curChildN=[erase(parChilds{j},' '), ' '];
        par_labels(contains(ARAlabels,curChildN))=cellstr(parName);
        curChildL=[erase(parChilds{j},' '), '-L'];
        par_labels(contains(ARAlabels,curChildL))=cellstr(parName);
        curChildR=[erase(parChilds{j},' '), '-R'];
        par_labels(contains(ARAlabels,curChildR))=cellstr(parName);
    end
end
[par_labels,~,c]=unique(par_labels);
par_values = accumarray(c,ARAvalues);
par_std = accumarray(c,ARAstd);
%delete fiber tracts
[k,v]=ismember(parTrans(:,1),par_labels);
valValues=v(k);
par_values=par_values(valValues);
par_labels=par_labels(valValues);
par_values(contains(par_labels,'fiber tracts'))=[];
par_std(contains(par_labels,'fiber tracts'))=[];
par_labels(contains(par_labels,'fiber tracts'))=[];

end


