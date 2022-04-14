%����˵����ɸѡ������ϵ��֮�󣬰��վ���K=5���о��࣬�����������Ϊ100

clear
clc
close all


load('E:\LiuluData\CTF\SourceData\HCP\DMN\ExtractROI\IMFs\HilbertTransform\Network\Ang_cluster.mat')          % ����Ang_cluster
% load('E:\LiuluData\CTF\SourceData\HCP\DMN\ExtractROI\IMFs\HilbertTransform\Network\Coh_cluster.mat')      
load('E:\LiuluData\CTF\SourceData\HCP\DMN\ExtractROI\IMFs\HilbertTransform\Network\Cohcluster315.mat')      

num_cluster = 5;                                            % ���þ�����Ϊ5
Ang_cluster=Ang_cluster(25450:35630,:);
Coh_cluster=Coh_cluster(25450:35630,:);                           %����ɷ�ֵ
Combo = [Coh_cluster,Ang_cluster];                          % ��ɷ��Ⱥ������λ
% count = 50;                                                % ����K-means�Ĵ�����500��
count =100;
fr = zeros(count,1);
idx_inall = cell(count,1);
C_inall = cell(count,1);
Percent_inall = cell(count,1);
sumd_inall=cell(count,1);
for i = 1:count
    % ���ս����5�࣬ÿ�����648���ݵ�(��648����ô�ó��ģ�������������)
    [tmp_idx,tmp_C,tmp_sumd,d] = kmeans(Combo,num_cluster,'MaxIter',1000);%Combo���󣬺����������ʱ��㣬���������ͬʱ����ROI��ع�ϵ
    
    idx_inall{i} = tmp_idx;               % idxΪÿ�����ݶ�Ӧ�ķ����������
    C_inall{i} = tmp_C;                   % CΪ��������
    sumd_inall{i}=tmp_sumd;                    %ÿ������У��㵽��Ӧ���ľ���֮�ͣ�ȡsumd_inall��С�ľ�������Ϊ���ս����Ҳ��F-ratio��С�ķ��ࣩ
    % tabulateΪͳ��ÿ���������ִ����ĺ������������ÿ������ռ�ܴ����İٷֱ�
    Percent_inall{i} = tabulate(tmp_idx); 

    tmp = zeros(1,num_cluster);
    for j = 1:num_cluster
        location_insider = find(tmp_idx==j);
        location_outsider = find(tmp_idx~=j);
        
        insider = d(location_insider,j).^2;
        outsider = d(location_outsider,j).^2;

        tmp_f(j) = sum(insider)/sum(outsider);%����F-ratio
    end
    fr(i) = mean(tmp_f);
    fprintf('���ڽ��е�%d�ξ���',i);
end

[~,idx_min] = min(fr);
C_min = C_inall{idx_min};
Percent_min = Percent_inall{idx_min};

[~,idx_max]=max(fr);
C_max = C_inall{idx_max};
Percent_max = Percent_inall{idx_max};
% % ��������
save('E:\LiuluData\CTF\SourceData\HCP\DMN\ExtractROI\IMFs\HilbertTransform\Network\317\5_7Cluster.mat','C_min','C_max','Percent_min','Percent_max','idx_min','idx_max','C_inall','Percent_inall','idx_inall')