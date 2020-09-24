function compareTotalDegree(inputFMRI, graphCell, day1, day2, out_path)

%% compareTotalDegree
% Collects all Degrees of all nodes and compares them with a paired t-test
% on two selected days. You can save the plot as DifferenceDegreeGroup.pdf 
% if you specify an output path as the last input argument.

% Input Arguments
% inputFMRI and graphCell from mergeFMRIdata_input.m
% day1 = Number of the first day (as in the order of inputFMRI.days)
% day2 = Number of the second day (as in the order of inputFMRI.days)
% out_path = Output path of the plot

%% Examples
% compareTotalDegree(inputFMRI, graphCell, 2, 4, "/Users/Username/Desktop")
% compareTotalDegree(inputFMRI, graphCell, 2, 4)
% Remember to replace the path with an existing path or to just leave it out

%% Do not modify the following lines

if nargin == 4
    inputFMRI.save = 0;
    out_path = "";
else
    inputFMRI.save = 1; % control if figure should be saved
    if ~exist(out_path, 'dir')
        mkdir(out_path)
    end
end

numberOfDays = size(inputFMRI.days,2);

NodesGroup2 = zeros(98, numberOfDays);
NodesGroup1 = zeros(98, numberOfDays);

for b = 1:98 % for all regions
% Group 1
    for dIdx = 1:numberOfDays % for all days
        numOfAnimals = size(graphCell{1, dIdx}.Nodes.allMatrix, 3);
        for animal = 1:numOfAnimals % for all subjects in the group
            Group1(animal, dIdx) = graphCell{1, dIdx}.Nodes.allDegree(b, animal);
            % get the Degree-Values
        end
    end
    NodesGroup1(b, :) = nanmean(Group1, 1);
    Group1(Group1 == 0) = nan; % matrix with 98 rows and X columns as days
% Group 2
    for dIdx = 1:numberOfDays
        numOfAnimals = size(graphCell{2, dIdx}.Nodes.allMatrix, 3);
        for animal = 1:numOfAnimals
            Group2(animal, dIdx) = graphCell{2, dIdx}.Nodes.allDegree(b, animal);
        end
    end
    NodesGroup2(b, :) = nanmean(Group2, 1);

    for ii = 1:numberOfDays
        [testV, pValue2(1, ii)] = ttest2(NodesGroup2(:, ii), NodesGroup1(:, ii));
    end
end
pValue2(pValue2<0.001)=-1;
pValue2 = string(round(pValue2, 4));
pValue2 = strrep(pValue2,'-1','< 0.001');

figure()
boxplot(NodesGroup2(:, [day1, day2])-NodesGroup1(:, [day1, day2]), 'Labels', ... 
    {{inputFMRI.days(day1),inputFMRI.days(day2)}, {['p = ',char(pValue2(1, day1))], ...
    ['p = ',char(pValue2(1, day2))]}})
title(['Group difference in Node Degree' strrep(inputFMRI.groups(2),'_',' ')+' - '+strrep(inputFMRI.groups(1),'_',' ')])
ylabel('Difference');
xlabel('Days');

if inputFMRI.save == 1
    fig = gcf;
    fig.PaperPositionMode = 'auto';
    print([out_path+'/DifferenceDegreeGroup'], '-dpdf', '-fillpage')
    disp('Figure saved to '+out_path+'/DifferenceDegreeGroup.pdf');
end

end
