%函数说明：筛选出聚类系数之后，按照聚类K=5进行聚类，聚类次数设置为100

clear
clc
close all


load('E:\LiuluData\CTF\SourceData\HCP\DMN\ExtractROI\IMFs\HilbertTransform\Network\Ang_cluster.mat')          % 加载Ang_cluster
% load('E:\LiuluData\CTF\SourceData\HCP\DMN\ExtractROI\IMFs\HilbertTransform\Network\Coh_cluster.mat')      
load('E:\LiuluData\CTF\SourceData\HCP\DMN\ExtractROI\IMFs\HilbertTransform\Network\Cohcluster315.mat')      

num_cluster = 5;                                            % 设置聚类数为5
Ang_cluster=Ang_cluster(25450:35630,:);
Coh_cluster=Coh_cluster(25450:35630,:);                           %求相干幅值
Combo = [Coh_cluster,Ang_cluster];                          % 相干幅度和相干相位
% count = 50;                                                % 运行K-means的次数：500次
count =100;
fr = zeros(count,1);
idx_inall = cell(count,1);
C_inall = cell(count,1);
Percent_inall = cell(count,1);
sumd_inall=cell(count,1);
for i = 1:count
    % 最终结果有5类，每类包含648数据点(这648是怎么得出的？？？？？？？)
    [tmp_idx,tmp_C,tmp_sumd,d] = kmeans(Combo,num_cluster,'MaxIter',1000);%Combo矩阵，横坐标代表单独时间点，纵坐标代表不同时间点的ROI相关关系
    
    idx_inall{i} = tmp_idx;               % idx为每行数据对应的分类类别索引
    C_inall{i} = tmp_C;                   % C为聚类中心
    sumd_inall{i}=tmp_sumd;                    %每类分类中，点到相应中心距离之和（取sumd_inall最小的聚类结果作为最终结果，也是F-ratio最小的分类）
    % tabulate为统计每个索引出现次数的函数，并计算出每个索引占总次数的百分比
    Percent_inall{i} = tabulate(tmp_idx); 

    tmp = zeros(1,num_cluster);
    for j = 1:num_cluster
        location_insider = find(tmp_idx==j);
        location_outsider = find(tmp_idx~=j);
        
        insider = d(location_insider,j).^2;
        outsider = d(location_outsider,j).^2;

        tmp_f(j) = sum(insider)/sum(outsider);%计算F-ratio
    end
    fr(i) = mean(tmp_f);
    fprintf('正在进行第%d次聚类',i);
end

[~,idx_min] = min(fr);
C_min = C_inall{idx_min};
Percent_min = Percent_inall{idx_min};

[~,idx_max]=max(fr);
C_max = C_inall{idx_max};
Percent_max = Percent_inall{idx_max};
% % 健康被试
save('E:\LiuluData\CTF\SourceData\HCP\DMN\ExtractROI\IMFs\HilbertTransform\Network\317\5_7Cluster.mat','C_min','C_max','Percent_min','Percent_max','idx_min','idx_max','C_inall','Percent_inall','idx_inall')