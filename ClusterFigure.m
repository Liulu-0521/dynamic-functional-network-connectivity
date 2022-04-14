%函数说明：绘制相干矩阵图像并标记脑区信息
clear
clc
close all

num_roi = 22;

% label_roi = {'Precentral_L','Frontal_Sup_L','Frontal_Sup_Orb_L','Frontal_Mid_L','Frontal_Mid_Orb_L','Frontal_Inf_Oper_L','Frontal_Inf_Tri_L','Frontal_Inf_Orb_L','Rolandic_Oper_L','Supp_Motor_Area_L','Olfactory_L','Frontal_Sup_Medial_L','Frontal_Med_Orb_L','Rectus_L','Insula_L','Cingulum_Ant_L','Cingulum_Mid_L', 'Cingulum_Post_L','Hippocampus_L', 'ParaHippocampal_L','Amygdala_L','Calcarine_L','Cuneus_L','Lingual_L','Occipital_Sup_L','Occipital_Mid_L','Occipital_Inf_L','Fusiform_L', 'Postcentral_L','Parietal_Sup_L','Parietal_Inf_L','SupraMarginal_L','Angular_L','Precuneus_L','Paracentral_Lobule_L','Caudate_L','Putamen_L','Pallidum_L','Thalamus_L',...
%              'Precentral_R','Frontal_Sup_R','Frontal_Sup_Orb_R','Frontal_Mid_R','Frontal_Mid_Orb_R','Frontal_Inf_Oper_R','Frontal_Inf_Tri_R','Frontal_Inf_Orb_R','Rolandic_Oper_R','Supp_Motor_Area_R','Olfactory_R','Frontal_Sup_Medial_R','Frontal_Med_Orb_R','Rectus_R','Insula_R','Cingulum_Ant_R','Cingulum_Mid_R', 'Cingulum_Post_R','Hippocampus_R','ParaHippocampal_R','Amygdala_R','Calcarine_R', 'Cuneus_R','Lingual_R','Occipital_Sup_R', 'Occipital_Mid_R','Occipital_Inf_R','Fusiform_R', 'Postcentral_R','Parietal_Sup_R','Parietal_Inf_R','SupraMarginal_R','Angular_R','Precuneus_R','Paracentral_Lobule_R','Caudate_R','Putamen_R','Pallidum_R','Thalamus_R'};
%DMN  label      
label_roi = {'Frontal_Sup_L','Frontal_Mid_L','Frontal_Inf_Oper_L','Cingulum_Ant_L','Cingulum_Mid_L', 'Cingulum_Post_L','Hippocampus_L', 'ParaHippocampal_L','Angular_L','Precuneus_L','Temporal_Mid_L',...
             'Frontal_Sup_R','Frontal_Mid_R','Frontal_Inf_Oper_R','Cingulum_Ant_R','Cingulum_Mid_R', 'Cingulum_Post_R','Hippocampus_R','ParaHippocampal_R','Angular_R','Precuneus_R','Temporal_Mid_R'};
    

% % 健康被试
% load('E:\LiuluData\CTF\SourceData\HCP\DMN\ExtractROI\IMFs\HilbertTransform\Network\Ang_cluster.mat')          % 加载Ang_cluster
% load('E:\LiuluData\CTF\SourceData\HCP\DMN\ExtractROI\IMFs\HilbertTransform\Network\Coh_cluster.mat')          % 加载Coh_cluster
% load('E:\LiuluData\CTF\SourceData\HCP\DMN\ExtractROI\IMFs\HilbertTransform\Network\Time_FrequencyCluster\Time_FrequencyCluster.mat') % 加载ClusterResult

% load('E:\LiuluData\CTF\SourceData\HCP\DMN\ExtractROI\IMFs\HilbertTransform\Network\Cohcluster315.mat')            % 加载Coh_cluster
load('E:\LiuluData\CTF\SourceData\HCP\DMN\ExtractROI\IMFs\HilbertTransform\Network\317\5_7Cluster.mat') % 加载ClusterResult

set(0,'defaultfigurecolor','w');

num_cluster = 5;

c = ones(num_roi,num_roi);
coh = cell(num_cluster,1);
ang = cell(num_cluster,1);

fname = {'State-1','State-2','State-3','State-4','State-5'};
for i = 1:num_cluster

    coh{i} = C_min(i,1:num_roi*num_roi);           % 相干性的聚类中心
    coh{i} = reshape(coh{i},num_roi,num_roi);
    tmp = triu(coh{i},1);
    coh{i} = coh{i}+tmp';
    
    ang{i} = C_min(i,num_roi*num_roi+1:2*num_roi*num_roi); % 相位信息的聚类中心
    
    for j = 1:num_roi*num_roi
        if ang{i}(j)>0
        ang{i}(j) = ang{i}(j)/(2*pi);
        elseif ang{i}(j)<0
            ang{i}(j) = 1-ang{i}(j)/(-2*pi);
        end
    end
    ang{i} = reshape(ang{i},num_roi,num_roi);    
    tmp = triu(ang{i},1);
    ang{i} = ang{i}+tmp';
    
    h = cat(3,ang{i},coh{i},c);   % phase = hue; amplitude = saturation; value = constant
    colormap = hsv2rgb(h);
    
    figure(i);
    imagesc(colormap);            % 产生矩阵图像

    set(gca,'ytick',1:num_roi);
    set(gca,'Yticklabel',label_roi,'Fontname','Times New Roman','FontSize',0.05);
    set(gca, 'YDir', 'normal')
    set(gca,'xtick',1:num_roi);
    set(gca,'Xticklabel',label_roi,'Fontname','Times New Roman','FontSize',0.05);
    xtickangle(90);
    
    ax = gca;
    ax.FontSize = 8;%更改标签大小
    
    tmp1 = Percent_min(i,3);
    tmp2 = sprintf('%.2f',tmp1);
    title([fname{i} '(' tmp2 '%)'],'FontSize',10);
    
    cd('E:\LiuluData\CTF\SourceData\HCP\DMN\ExtractROI\IMFs\HilbertTransform\Network\317\5-7min\')      % 健康被试
    fig = gcf;
    fig.PaperUnits = 'inches';
    fig.PaperPosition = [0 0 2.25 2];                   % width & length
    print(fname{i},'-dpng','-r300');

end