% 函数说明：整理后得到ROI的二维相干矩阵和相位矩阵后，接下来确定聚类数k的取值

clear
clc
close all

load('E:\LiuluData\CTF\SourceData\HCP\DMN\ExtractROI\IMFs\HilbertTransform\Network\Ang_cluster.mat')          % 加载Ang_cluster
load('E:\LiuluData\CTF\SourceData\HCP\DMN\ExtractROI\IMFs\HilbertTransform\Network\Cohcluster315.mat')          % 加载Coh_cluster

%set(0,'defaultfigurecolor','w');
num_roi = 22;
max_num_cluster = 9;
Ang_cluster=Ang_cluster(15270:25450,:);
Coh_cluster=Coh_cluster(15270:25450,:);
Combo = [Coh_cluster,Ang_cluster];          %                           % 相干振幅和相干相位值
c = ones(num_roi,num_roi);                                             % c为78*78的全1矩阵 
fr = zeros(max_num_cluster-2,1);                                       % fr为7*1的全0向量
num_cluster = 3;                                                       % 聚类数
idx = cell(max_num_cluster-2,1);                                       % idx为7*1的单元数组
percent = cell(max_num_cluster-2,1);                                   % percent为7*1的单元数组

for i = 1:max_num_cluster-2 
    
    %%%%% K均值聚类，最大迭代次数为1000次
    % idx为聚类的索引，若k = 5,那么idx可能的取值为1,2,3,4,5；C为聚类中心的位置；
    % ~为类内各点到聚类中心的距离之和；d为每个点到聚类中心的距离
    [idx{i},C,~,d] = kmeans(Combo,num_cluster,'MaxIter',1000);   
%       percent{i} = tabulate(idx{i});
    tmp_fr = zeros(1,num_cluster);

    % 健康被试
    mkdir(['E:\LiuluData\CTF\SourceData\HCP\DMN\ExtractROI\IMFs\HilbertTransform\Network\316\555\KCluster-' num2str(num_cluster)])
    cd(['E:\LiuluData\CTF\SourceData\HCP\DMN\ExtractROI\IMFs\HilbertTransform\Network\316\555\KCluster-' num2str(num_cluster)])
     
    for j = 1:num_cluster % for each cluster at this number of cluster
        
        %%%%% 计算F比值
        location_insider = find(idx{i}==j);         % 返回属于当前类别样本点的索引
        location_outsider = find(idx{i}~=j);        % 返回不属于当前类别样本点的索引         
        
        insider = d(location_insider,j).^2;         % 类内样本点到本类聚类中心的距离平方 
        outsider = d(location_outsider,j).^2;       % 类外样本点到本类聚类中心的距离平方

        tmp_fr(j) = sum(insider)/sum(outsider);     % 当前F比值
        
        %%% 相干的聚类中心
        coh = C(j,1:num_roi*num_roi);               % 
        coh = reshape(coh,num_roi,num_roi);
        tmp = triu(coh,1);
        coh = coh+tmp';
        
        %%% 相位的聚类中心
        ang = C(j,num_roi*num_roi+1:2*num_roi*num_roi);

        for k = 1:num_roi*num_roi
            if ang(k)>0
                ang(k) = ang(k)/(2*pi);
            elseif ang(k)<0
                ang(k) = 1-ang(k)/(-2*pi);
            end
        end
        ang = reshape(ang,num_roi,num_roi);    
        tmp = triu(ang,1);
        ang = ang+tmp';
        
        %%% 绘制k取不同值时的各状态下的矩阵
        h = cat(3,ang,coh,c);            % h(:,:,1) = ang;h(:,:,2) = coh;h(:,:,3) = c 
        colormap = hsv2rgb(h);           % h = ang;s = coh;v = c,其中h表示色调；s表示饱和度；v表示值，将hsv转换为rgb值
        percent{i} = tabulate(idx{i});   % 得到一个频率表，第一列为值；第二列为该值出现的次数；第三列为该值所占的比例。获取某个状态出现的概率
        
        figure(j);                       
        imagesc(colormap);               % 产生矩阵图
        axis off;                        % 关闭坐标轴 
        set(gca, 'YDir', 'normal')              
        tmp1 = percent{i}(j,3);          % 获取某状态的百分比
        tmp2 = sprintf('%.2f',tmp1);     % 保留百分比小数点后两位，并按字符串的格式输出   
        title([tmp2 '%']);               % 给figure添加title
        
        fig = gcf;
        fig.PaperUnits = 'inches';
        fig.PaperPosition = [0 0 2.25 2];       
        fname = ['State-',num2str(j)];
        print(fname,'-dpng','-r300');

        close
    end
    
    fr(i) = mean(tmp_fr);   
    num_cluster = num_cluster+1;

end

% 绘制F-Ratio图像
figure 
plot(3:max_num_cluster,fr,'r-o','Markers',5,'MarkerFaceColor',[1 .6 .6]);
xlabel('Number of Clusters');                   
ylabel('F-Ratio')
title('Optimal Selection of {\itk}')

ax = gca;
ax.FontSize = 5;
 
ax.XTick = 3:max_num_cluster;
ax.XLim = [1 10]; 

ax.YTick = 0:0.2:1;
ax.YLim = [0 0.8];


cd('E:\LiuluData\CTF\SourceData\HCP\DMN\ExtractROI\IMFs\HilbertTransform\Network\316\555\')        % 健康被试
fig = gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 2.25 2];
print('F-Ratio','-dpng','-r300')

close