%函数说明：ROI信号被分解成为IMFs信号之后，统计每个ROI信号都被分解成了几个IMFs信号
%同时统计分解成的IMFs信号与源信号的相关度，用来决定后续处理时采用的信号成分
%该函数在EMD中被调用
close all;
clear;
clc;

%加载IMFs信号和源信号
IMFs_Path =  'E:\LiuluData\CTF\SourceData\HCP\DMN\ExtractROI\IMFs\';  %结果得到的本征模态函数位置  
Signal_Path= 'E:\LiuluData\CTF\SourceData\HCP\DMN\ExtractROI\IMFs\';%进行emd的信号位置
Figure_Path= 'E:\LiuluData\CTF\SourceData\HCP\DMN\ExtractROI\IMFs\CoIMFsSignalFigure\';%结果图存储位置
num_roi =22;                                % 感兴趣区域的个数，根据raw_roi结构体中的数据具体赋值
load([IMFs_Path,'AllSubjects_imf.mat']);
load([Signal_Path,'AllSubjects_signal.mat']);
num_subj=16;   


%function Correlation=CoIMFsSignal(imf,signal,num_subj,num_roi)


%计算IMFs信号与源信号的线性相关性
imf_r = cell(num_subj,1);    %开辟空间存储感兴趣脑区与源信号的相关系数，行为脑区，列为第k个IMF        
num_imf = [];%zeros(num_subj,num_roi);  %开辟空间存储每个ROI信号被分解成的IMFs数量，每行代表一个实验对象，列表示实验对象每个脑区信号被分解出来的IMFs数量   

for i = 1:num_subj     %i为被试数，j为脑区数，k为IMF数
    for j = 1:num_roi
        num_imf(i,j) = size(imf{i,1}{1,j},2);                          % 第i个被试第j个ROI的信号分解的IMFs的个数
        for k = 1:num_imf(i,j)                                         % 对于每一个imf信号，计算其与原信号的皮尔森相关
            imf_r{i}(j,k) = corr((signal{i}(j,:))',(imf{i}{j}(:,k)));   
        end
    end
end

% 绘制imfs数目分布的柱状图
max_num_imf = max(max(num_imf));                                       % 最大IMFs数
min_num_imf = min(min(num_imf));                                       % 最小IMFs数
count = 1;
count_num_imf = zeros((max_num_imf-min_num_imf+1),1);                  % 每个信号分解成的imf数

for i = min_num_imf:max_num_imf                                        % 统计min_num_imf到max_num_imf的数量
    count_num_imf(count) = length(find(num_imf==i));
    count = count+1;
end

figure('visible','off');
b=bar(min_num_imf:max_num_imf,count_num_imf);                     % 条形图表示每个信号的IMFs数量
title('IMF Results from EMD');
xlabel('Amount of IMFs');
ylabel('Number of Signals');
%给柱状图添加柱高
for i=1:(max_num_imf-min_num_imf+1)
    text(b.XData(i),b.YData(i),num2str(b.YData(i)),...
    'HorizontalAlignment','center',...
    'VerticalAlignment','bottom')
end
ylim([0,300]);
% ax = gca;
% ax.FontSize = 10;
% fig = gcf;
% fig.PaperUnits = 'inches';fig.PaperPosition = [0 0 2.25 2];
print([Figure_Path, 'Amount of IMFs'],'-dpng','-r300')
save( [IMFs_Path, 'imf_corr.mat'],'imf_r')%保存IMFs与源信号的相关系数矩阵


%%%%%% 用箱式图绘制相关系数的分布
imf_label = [];
for j = 1:max_num_imf-1                 % 产生imf标签
    tmp = ['IMF ' num2str(j)];
    imf_label = [imf_label; tmp];
end
imf_label = [imf_label;'IMF 9'];%最后一位的IMF 数字可能需要根据实际上所有数据的情况更改
imf_r_sorted = cell(length(imf_r),1); % rearrange IMFs correlation data
for i = 1:num_subj
    if size(imf_r{i},2) < max_num_imf
        for j = 1:num_roi            
            tmp = imf_r{i}(j,:);
            tmp(numel(zeros(1,max_num_imf))) = 0;
            imf_r_sorted{i}(j,:) = tmp;
        end
    else
        imf_r_sorted{i} = imf_r{i};
    end
end


imf_r_all = cell(max_num_imf,1); % pool all the IMFs together
for i = 1:length(imf_r_all)
    imf_r_all{i} = [];
    for j = 1:num_subj
        imf_r_all{i} = [imf_r_all{i};imf_r_sorted{j}(:,i)];
    end
end

num_imf_all = zeros(length(imf_r_all),1); % set 0 as empty
for i = 1:length(imf_r_all)
	indx = find(imf_r_all{i}==0);
    imf_r_all{i}(indx) = [];
    num_imf_all(i) = length(imf_r_all{i});
end

data = []; % rearrange IMFs correlation for boxplot
for i = 1:length(imf_r_all)
    data = [data;imf_r_all{i}];
end
label = []; % rearrange IMF labels for boxplot
for i = 1:length(imf_r_all)
    tmp = repmat(imf_label(i,:),[length(imf_r_all{i}),1]);
    label = [label;tmp];
end

figure('visible','off');
boxplot(data,label)
title('IMFs & Original Signal Correlation');xlabel('IMFs');ylabel('Pearson Correlation');
% ax = gca;
% ax.FontSize = 10;
% ax.YTick = -0.2:0.2:1;
% ax.YLim = [-0.2 1];
% fig = gcf;
% fig.PaperUnits = 'inches';
% fig.PaperPosition = [0 0 2.25 2];
print([Figure_Path, 'IMFs Correlation Distribution'],'-dpng','-r300')
%end
% close