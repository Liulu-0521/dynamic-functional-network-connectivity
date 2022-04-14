%����˵�����õ��������Եĸ�������֮�����ɾ������λ�����,�����ݽ��н�ά����
%�����б��Ե����и���Ȥ����ɾ���Ϊ����
close all;
clear;
clc;

Data_Path='E:\LiuluData\CTF\SourceData\HCP\DMN\ExtractROI\IMFs\HilbertTransform\Network\';
% load([Data_Path,'ROIs_Coherence.mat']);
load([Data_Path,'Coherence315.mat']);
% load([Data_Path,'ROIs_Phase.mat']);
%��̬������ֵ
num_roi =22;  %����Ȥ������������ʵ�ʵ���
num_subj=16;  %���Ը��� 
num_vol=1018; %ʱ���������������ݵĴ�С����
num_imf=5;    %��ȡÿ��ROIs�ֽ��ǰ4��IMFs
%%%%%Rearrange
Coh_cluster = []; % rearrange Coherence for clustering
% Ang_cluster = []; % rearrange Phase for clustering

for i = 1:num_subj
    
    tmp_coh = Coherence{i};
%     tmp_ang = Phase{i};
    
    for j = 1:num_imf % 
        for k = 1:num_vol % ʱ���
            
            % ���
            tmp_coh_1 = squeeze(tmp_coh(j,k,:,:));
            tmp_coh_2 = triu(tmp_coh_1);
            tmp_coh_3 = reshape(tmp_coh_2,1,num_roi*num_roi);
            
            Coh_cluster = [Coh_cluster;tmp_coh_3];%���������ʱ���1:1018 X4 X nsubject��������Ϊ�����ROI1 & Roi1....ROI22 & ROI22
          
            % ��λ
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