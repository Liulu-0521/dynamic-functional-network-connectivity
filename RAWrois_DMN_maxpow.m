%����˵��������ȡÿһ��ROI������ͨ��֮�󣬲�������ʷ���һ��ROI�еĶ��ͨ���źű��һ��
%����116��ROI�źŽ��кϲ�
close all;
clear;
clc;
% SourcePath='E:\LiuluData\CTF\SourceData\HCP\DMN\ExtractROI\ReconSource\';%Դ�ؽ��źŵ�λ��
resultPath = 'E:\LiuluData\CTF\SourceData\HCP\DMN\ExtractROI\ROIsignal_maxpow\';%��ȡ��ROI�źŴ��λ��
% dataPath = 'E:\LiuluData\CTF\SourceData\HCP\DMN\Data\';%Ԥ����data��������λ��
% ModelPath='E:\LiuluData\CTF\SourceData\HCP\DMN\AAL\';%��׼ģ������λ��
ROIsignalPath='E:\LiuluData\CTF\SourceData\HCP\DMN\ExtractROI\ROIsignal\';%��ȡ��116�������ź�����λ��

subjList={'100307','102816','105923','106521','108323','109123','111514','113922','116524','133019','140117','146129','153732','156334','158136','162026'};                      %��Ҫ�����������������
nSubj = length(subjList);

num_roi=116;
for i=1:nSubj
    
    for j=1:num_roi
    %����ÿ�����Ե�����ROI�ź�
    load([ROIsignalPath,subjList{i},'\',subjList{i},'_raw_',num2str(j)]);
    raw_rois.time=raw_oneroi.time;
    raw_rois.method='maxpow';
    num_trial=length(raw_oneroi.trial);
        for k=1:num_trial
            raw_rois.trial{1,k}(j,:) = maxpow(raw_oneroi.trial{1,k},raw_oneroi.time{1}(k));
            
        end
    
    end
    
     save([resultPath,subjList{i},'_RAWrois_maxpow_116','.mat'],'raw_rois');
    
end