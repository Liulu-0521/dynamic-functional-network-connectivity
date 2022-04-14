%����˵������ȫ���ź�����ȡ116������Ȥ����ÿ������������ź�

close all;
clear;
clc;
SourcePath='E:\LiuluData\CTF\SourceData\HCP\DMN\ExtractROI\ReconSource\';%Դ�ؽ��źŵ�λ��
resultPath = 'E:\LiuluData\CTF\SourceData\HCP\DMN\ExtractROI\ROIsignal\';%��ȡ��ROI�źŴ��λ��
dataPath = 'E:\LiuluData\CTF\SourceData\HCP\DMN\Data\';%Ԥ����data��������λ��

subjList={'100307','102816','105923','106521','108323','109123','111514','113922','116524','133019','140117','146129','153732','156334','158136','162026'};                      %��Ҫ�����������������
nSubj = length(subjList);

for subjNum = 1:nSubj
        %load raw data: meg data
    load([dataPath,subjList{subjNum},'_MEG_3-Restin_rmegpreproc.mat']);
        %load raw data: meg data
    load([SourcePath,subjList{subjNum},'_source.mat']);
    mkdir([resultPath,subjList{subjNum}]);
    for z=1:116
    
    tissuenum=z;
    
    %extract_sources;
    %% extract_sources.m
    %% compute all virtual MEG channels for one ROI
    %  you need to difine tissuenum
    %  tissuenum=7;

    raw_oneroi = [];
    raw_oneroi.time  = data.time;
    raw_oneroi.label = [];

    %  select MEG channels
    megchannel = ft_channelselection('MEG', data.label);% find MEG sensor names
    chansel = match_str(data.label, megchannel);         % find MEG sensor indices

    idx = find(source.tissue==tissuenum);

        for i=1:length(idx)
             raw_one3roi.label{i,1} = num2str(idx(i));
        end
        % Extract the virtual channel time-series

        filter_roi(1:length(idx),:)=cell2mat(source.avg.filter(idx));

        for i=1:length(data.trial)
             raw_oneroi.trial{i} = filter_roi * data.trial{i}(chansel,:);
            
        end
    clear('i');
    clear('filter_roi');
    

    save([resultPath,subjList{subjNum},'\',subjList{subjNum},'_raw_',num2str(z),'.mat'],'raw_oneroi');

    end
   %clear('filter_roi');
    
end