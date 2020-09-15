function shortestPath(inputFMRI, graphCell, day2examine, startNode, endNode)

%% shortestPath
% This function displays the shortest path from one region to another.
% The shortest path is calculated as an inverse Dijkstra's Algorithm,
% meaning that this function seeks for the shortest path with the hightest 
% sum of connection weights representing the best strengthened path.
% The output parameter 'Path Length' refers to the distance of the 
% indicated nodes calculated on the basis of the inverted correlations.
% A lower value corresponds to a stronger connection.

% Input Arguments
% inputFMRI and graphCell from mergeFMRIdata_input.m
% day2examine = Number of the day (as in the order of inputFMRI.days)
% startNode = Begin of the path (as String)
% endNode = End of the path (as String)

%% Example
% shortestPath(inputFMRI, graphCell, 1, 'R sAMY', 'L SSs')

%% Do not modify the following lines

numberOfGroups = size(inputFMRI.groups,2);
graphToExamine = cell(1,numberOfGroups);
connMatrix = cell(1,numberOfGroups);
invMatrix = cell(1,numberOfGroups);

addpath('../Tools/BCT');
load('../Tools/infoData/acronyms_splitted.mat');

% Find the acronym-numbers of the specified regions
RegIDstartNode = find(acronyms == startNode);
RegIDendNode = find(acronyms == endNode);

for ii = 1:numberOfGroups
    graphToExamine{ii} = graphCell{ii,day2examine};
    % Calculate the mean correlation matrix over all subjects
    connMatrix{ii} = full(adjacency(graphToExamine{ii},'weighted'));
    invMatrix{ii} = connMatrix{ii};
    invMatrix{ii}(connMatrix{ii}<=0) = 0;
    % The inverse matrix is some kind of connection length matrix, where small 
    % values refer to short distances (high correlations)
    invMatrix{ii} = 1./invMatrix{ii};   
    % The algorithm for calculating the shortest path only accepts 
    % positive values. We therefore decided to replace the negative 
    % connection weights with 0
    
    [SPL,hops,Pmat] = distance_wei_floyd(invMatrix{ii});
    path = retrieve_shortest_path(RegIDstartNode,RegIDendNode,hops,Pmat);
    
    % Prepare the Output Presentation
    pathSize = size(path,1);
    pathWithNames = strings(pathSize,1);
    % Replace the acronym-numbers with the actual region-names
    for i = 1:pathSize
        pathWithNames(i) = acronyms(path(i));
    end  
    pathWithNames_arrow = '';
    for j = 1:pathSize-1
        pathWithNames_arrow = strcat(pathWithNames_arrow,pathWithNames{j,1},"  ->  ");
    end
    pathWithNames_arrow = strcat(pathWithNames_arrow,pathWithNames{pathSize,1});
    disp('Shortest Path in Group '+inputFMRI.groups(ii)+' at '+inputFMRI.days(day2examine)+':');
    disp('    '+pathWithNames_arrow);
    disp('Path Length:');
    disp(SPL(RegIDstartNode,RegIDendNode));
end

end