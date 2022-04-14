%���Ʋ�ͬ״̬�µ�˲ʱƵ��
close all
clear
clc
%% %%%%%%%%%%%%%%%%%% Initialzation %%%%%%%%%%%%%%%%%%
% %%%%%%��Ϣ״̬����
num_subj = 2;%16;                                     % ������
num_roi = 22;                                      % ����Ȥ����ĸ���
num_vol = 1018;                                    % ʱ������
ts = 1/300;  fs = 1/ts;   t =0:ts:ts*(num_vol-1);  % tsΪʱ������fsΪ����Ƶ�ʡ�tΪʱ�䳤��0-2.0s

%%%%%%Figures
set(0,'defaultfigurecolor','w');                   % Set background white


% ��������
% load('E:\LiuluData\CTF\SourceData\HCP\DMN\ExtractROI\IMFs\HilbertTransform\Network\Time_FrequencyCluster\Time_FrequencyCluster.mat') % ����ClusterResult
load('E:\LiuluData\CTF\SourceData\HCP\DMN\ExtractROI\IMFs\HilbertTransform\Network\317\5_7Cluster.mat')
% load('E:\LiuluData\CTF\SourceData\HCP\DMN\ExtractROI\IMFs\AllSubjects_signal.mat')            % ����MEG�ź�
% load('E:\LiuluData\CTF\SourceData\HCP\DMN\ExtractROI\IMFs\AllSubjects_imf.mat')               % ����IMF�ź�
load('E:\LiuluData\CTF\SourceData\HCP\DMN\ExtractROI\IMFs\HilbertTransform\AllSubjects_hilbertFrequency.mat')
num_imf = 5;
num_cluster = 5;
imfinsf = cell(num_subj,1);

for i = 1:num_subj
    for j = 1:num_roi
        % ����ֵ�ֱ�Ϊhs��ϣ������Ƶ�ס�f:Ƶ��������t:ʱ��������imfinsf������ģ̬������˲ʱƵ�ʡ�imfinse������ģ̬������˲ʱ����
%         [~,~,~,imfinsf{i}{j},~] = hht(imf{i}{j}(:,1:num_imf),fs);
        imfinsf{i}{j}=Freq{i+5}{j};
        % ��IMF���е�˲ʱ��Ƶ�ʶ���Ϊnan
        tmp_idx = find(imfinsf{i}{j}<=0);
        imfinsf{i}{j}(tmp_idx) = nan;
    end
end

tmp = cell(num_subj,1);
avg_IF = cell(num_subj,1);
for i = 1:num_subj
    for j = 1:num_roi
        tmp{i}(:,:,j) = imfinsf{i}{j};
    end
    avg_IF{i} = nanmean(tmp{i},3);
end
clearvars i j tmp*

tmp_acg_IF_inall = [];
for i = 1:num_subj
    tmp = reshape(avg_IF{i},num_vol*num_imf,1);
    tmp_acg_IF_inall = cat(1,tmp_acg_IF_inall,tmp);
end
% idx=Percent_max;
idx=idx_inall{61};
tmp_rearrange_idx{1} = find(idx==1);
tmp_rearrange_idx{2} = find(idx==2);
tmp_rearrange_idx{3} = find(idx==3);
tmp_rearrange_idx{4} = find(idx==4);
tmp_rearrange_idx{5} = find(idx==5);

acg_IF_inall{1} = tmp_acg_IF_inall(tmp_rearrange_idx{1});
acg_IF_inall{2} = tmp_acg_IF_inall(tmp_rearrange_idx{2}(1:1953,:));
acg_IF_inall{3} = tmp_acg_IF_inall(tmp_rearrange_idx{3});
acg_IF_inall{4} = tmp_acg_IF_inall(tmp_rearrange_idx{4});
acg_IF_inall{5} = tmp_acg_IF_inall(tmp_rearrange_idx{5});
for i = 1:num_cluster
    z = find(acg_IF_inall{i} > 150);
    for j = 1:length(z)
        y = find(acg_IF_inall{i}(z(j)) == tmp_acg_IF_inall);
        for k = length(tmp_rearrange_idx{i}):-1:1
            if tmp_rearrange_idx{i}(k) == y
                tmp_rearrange_idx{i}(k) = [];
            end
        end
    end
%     y = find(acg_IF_inall{i}(x) == tmp_acg_IF_inall);
    acg_IF_inall{i}(z) = [];
%     tmp_rearrange_idx{i}(y) = [];
end

rearrange_idx = zeros(size(idx));
for i = 1:num_cluster
    rearrange_idx(tmp_rearrange_idx{i}) = i;
end
xx = find(rearrange_idx == 0);
rearrange_idx(xx) = [];


x = [];
for i = 1:num_cluster
    x = cat(1,x,acg_IF_inall{i});
end

boxplot(x,rearrange_idx(1:4278,1),'Labels',{'State 1','State 2','State 3','State 4','State 5'},'Whisker',2);
% for i = 1:num_cluster
%     mx = mean(acg_IF_inall{i});
%     disp(mean(acg_IF_inall{i}));
%     hold on
%     plot(mx,'d');
% end

ax = gca;
% ax.YTick = 0:0.04:0.2;
% ax.YLim = [0 0.2];
ax.FontSize = 5;

ylabel('Instantaneous Frequency')
% cd('F:\HHT\Result\right_DMN\boxState_IF')
cd('E:\LiuluData\CTF\SourceData\HCP\DMN\ExtractROI\IMFs\HilbertTransform\Network\317\5-7min\')
% cd('F:\HHT\Result\health_DMN\boxState_IF')
fig = gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 2.25 2];
print('Cluster IF Distribution','-dpng','-r300')

% close