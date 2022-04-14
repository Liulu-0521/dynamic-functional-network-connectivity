%函数说明：得到各个被试的各个脑区之间的相干矩阵和相位矩阵后,对数据进行降维整理
%将所有被试的所有感兴趣区相干矩阵化为向量
close all;
clear;
clc;

Data_Path='E:\LiuluData\CTF\SourceData\HCP\DMN\ExtractROI\IMFs\HilbertTransform\Network\';
% load([Data_Path,'ROIs_Coherence.mat']);
load([Data_Path,'Coherence315.mat']);
% load([Data_Path,'ROIs_Phase.mat']);
%静态变量赋值
num_roi =22;  %感兴趣区个数，根据实际调整
num_subj=16;  %被试个数 
num_vol=1018; %时间点个数，根据数据的大小决定
num_imf=5;    %提取每个ROIs分解的前4个IMFs
%%%%%Rearrange
Coh_cluster = []; % rearrange Coherence for clustering
% Ang_cluster = []; % rearrange Phase for clustering

for i = 1:num_subj
    
    tmp_coh = Coherence{i};
%     tmp_ang = Phase{i};
    
    for j = 1:num_imf % 
        for k = 1:num_vol % 时间点
            
            % 相干
            tmp_coh_1 = squeeze(tmp_coh(j,k,:,:));
            tmp_coh_2 = triu(tmp_coh_1);
            tmp_coh_3 = reshape(tmp_coh_2,1,num_roi*num_roi);
            
            Coh_cluster = [Coh_cluster;tmp_coh_3];%横坐标代表时间点1:1018 X4 X nsubject，纵坐标为相干性ROI1 & Roi1....ROI22 & ROI22
          
            % 相位
%             tmp_ang_1 = squeeze(tmp_ang(j,k,:,:));
%             tmp_ang_2 = triu(tmp_ang_1);
%             tmp_ang_3 = reshape(tmp_ang_2,1,num_roi*num_roi);
%                
%             Ang_cluster = [Ang_cluster;tmp_ang_3];
        end
    end
end
save([Data_Path, 'Cohcluster315.mat'],'Coh_cluster','-v7.3');
% save([Data_Path, 'Ang_cluster.mat'],'Ang_cluster','-v7.3');