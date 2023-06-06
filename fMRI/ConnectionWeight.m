function AllTable = ConnectionWeight(inputFMRI, graphCell, startP, endP)

%% plotConnectionWeight
% Compares the edge weight of two regions for two groups

% Input Arguments
% inputFMRI and graphCell from mergeFMRIdata_input.m
% startP = First Region (as String)
% endP = Second Region (as String)

%% Example
% plotConnectionWeight(inputFMRI, graphCell, 'L DORpm', 'L MOp')

%% Do not modify the following lines

days = inputFMRI.days;
groups = inputFMRI.groups;
numOfDays = size(inputFMRI.days,2);
numOfGroups =  size(inputFMRI.groups,2);
tempFile = load('..\Tools\infoData\acronyms_splitted.mat');
acronyms = tempFile.acronyms;
addpath('.\rsfMRI_Processing\');


for group = 1:numOfGroups

valuesGroup = nan(size(graphCell{group,1}.Nodes.allMatrix,3),numOfDays);
for day=1:numOfDays
    curGraph=graphCell{group,day};
    numOfAnimals=size(graphCell{group,day}.Nodes.allMatrix,3);
    for animal = 1:numOfAnimals
        c = graph(curGraph.Nodes.allMatrix(:,:,animal) , cellstr(acronyms),'lower');
        edge = findedge(c,{startP},{endP});
        % rows = animals, columns = days
        if edge>0
            valuesGroup(animal,day)=c.Edges.Weight(edge);
        else
            valuesGroup(animal,day)=-1;
        end
    end 
end
valuesGroup(valuesGroup==0)=nan;
valuesGroup(valuesGroup==-1)=0;

tableGroup = array2table(valuesGroup);
for day = 1:numOfDays
    tableGroup.Properties.VariableNames(day) = inputFMRI.days(day);
end
disp(strcat("Edge Weight from ",startP," to ",endP," in group ",inputFMRI.groups(group),':'));
disp(tableGroup);
AllTable{group} = tableGroup;
end