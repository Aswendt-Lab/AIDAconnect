%% General Info
% Author: A.Kalantari
% arefks@gmail.com

%% First Steps
% Consolidates all graph-theoretical measures of the processed DTI. 
% Please specify all information below and hit 'Run'.
clc
clear
%% Specifications
% Observation days e.g. “P1" etc.
inputDTI.days = ["Baseline","P1","P7","P14","P21","P28"];
% Groups e.g. “Sham” etc.
inputDTI.groups = ["Sham","StrokeBad","StrokeGood"];
% path where the results where saved
inputDTI.out_path = "Z:\CRC_WP1\outputs\AIDAconnet_results\OutputDTI_thres0";

%% Do not modify the following lines
% This Script tests the existence of the output path and consolidates all
% data only if the path does not exist. If the path already exists only
% the struct inputDTI and the cell matrices graphCell, matrixValues and ids
% will be created, which are necessary for several analysis functions.
[graphCell,matrixValues,ids]=graphAnalysis_DTI(inputDTI);
acronyms = load('..\Tools\infoData\acronyms_splitted.mat').acronyms;
%% Applying modified functions

Reg_L = ["L MOp","L MOs","L SSp-un","L SSp-ul","L SSp-n","L SSp-m","L SSp-ll","L SSp-bfd"];
Reg_R = ["R MOp","R MOs","R SSp-un","R SSp-ul","R SSp-n","R SSp-m","R SSp-ll","R SSp-bfd"];

for rr = 1:length(Reg_R)
Tables = FiberCount(inputDTI, graphCell, Reg_L(rr), Reg_R(rr));
Table_for_prism = []
Table_for_boxchart = []

%% Tables for Prism: Use Table_for_prism to copy paste the data into prism directly 
for tt=1:length(Tables)
    T = Tables{tt};
    M = table2array(T)';
    S(tt) = size(M,2)
end
mm = 30;
for tt=1:length(Tables)
    T = Tables{tt};
    M = table2array(T)';
    M_bigger = nan(size(M,1),mm);
    M_bigger(:,1:length(M)) = M;
    Table_for_prism = [Table_for_prism,M_bigger];
    Table_for_boxchart = cat(3,Table_for_boxchart,M_bigger);
end
temp(:,:,:,rr) = Table_for_boxchart;

end
S = size(temp)
temp = reshape(temp,S(1),S(2)*S(4),S(3));
p_Sham = temp(:,:,1);
p_Bad = temp(:,:,2);
p_Good = temp(:,:,3);
final_prism = [p_Good,p_Bad,p_Sham];

%% Table to use boxchart function
% S = size(Table_for_boxchart);
% GroupName=[];
% TimeName=[];
% Value = [];
% 
% for tt=1:S(1)
%     for mm=1:S(2)
%         for gg=1:S(3)
%             GroupName= [GroupName;inputDTI.groups(gg)];
%             TimeName = [TimeName;inputDTI.days(tt)];
%             Value = [Value;Table_for_boxchart(tt,mm,gg)];
%         end
%     end
% end
% 
% [p,tbl,stats,~] = anovan(Value,{GroupName,TimeName},"interaction");
% 
% [c,~,~,gnames] = multcompare(stats,"Dimension",[1 2]);




% 
% X_time = categorical(TimeName,inputDTI.days);
% 
% boxchart(X_time,Value,'GroupByColor',GroupName)
% ylabel('ConnectionWegiht')
% legend()
% 
% 
% 







