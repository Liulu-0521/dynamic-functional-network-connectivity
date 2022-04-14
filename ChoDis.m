%函数说明：Coherence distribution绘制不同状态下ROI间相干性的分布
clear
clc
close all

% % % 健康被试
% % % 健康被试
% load('E:\LiuluData\CTF\SourceData\HCP\DMN\ExtractROI\IMFs\HilbertTransform\Network\Time_FrequencyCluster\Time_FrequencyCluster.mat') % 加载ClusterResult
load('E:\LiuluData\CTF\SourceData\HCP\DMN\ExtractROI\IMFs\HilbertTransform\Network\317\5_7Cluster.mat')
set(0,'defaultfigurecolor','w'); % Set background white

num_roi = 22;
num_cluster = 5;

% 读取1-5行，1-num_roi*num_roi列的数据
c = C_min(1:num_cluster,1:num_roi*num_roi);
% 将数据中值为0和值为1的数都定义为nan
c((c==1)) = nan;        
c((c==0)) = nan;

tmp_cc = [];
for i = 1:num_cluster
    tmp = c(i,:);
    tmp(isnan(tmp)) = []; 
    tmp_cc = cat(1,tmp_cc,tmp);
end

cc(1:2,:) = tmp_cc(1:2,:);
% cc(3,:) = tmp_cc(5,:);
% cc(4,:) = tmp_cc(3,:);
% cc(5,:) = tmp_cc(4,:);
cc(3,:) = tmp_cc(3,:);
cc(4,:) = tmp_cc(4,:);
cc(5,:) = tmp_cc(5,:);
% coh1 = rmoutliers(cc(1,:));
% coh2 = rmoutliers(cc(2,:));
% coh3 = rmoutliers(cc(3,:));
% coh4 = rmoutliers(cc(4,:));
% coh5 = rmoutliers(cc(5,:));
% % for i = 1:num_cluster
%     coh(i,:) = rmoutliers(cc(i,:));
% end
boxplot(cc','Labels',{'State 1','State 2','State 3','State 4','State 5'});
ylabel('Coherence');

ax = gca;
ax.FontSize = 5;
ax.YTick = 0.35:0.05:1;
ax.YLim = [0.35 1];
fig = gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 2.25 2];

% cd('F:\HHT\Result\right_DMN\coherenceDistribution')
% cd('F:\HHT\Result\left_DMN\coherenceDistribution')
% cd('E:\LiuluData\CTF\SourceData\HCP\DMN\ExtractROI\IMFs\HilbertTransform\Network\Time_FrequencyCluster\ChoResult\')
cd('E:\LiuluData\CTF\SourceData\HCP\DMN\ExtractROI\IMFs\HilbertTransform\Network\317\5-7min\')
print('Coherence Distribution','-dpng','-r300')