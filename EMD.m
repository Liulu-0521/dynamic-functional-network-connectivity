%数据来源：HCP数据库
%数据状态：采用最大功率法提取静息状态下78脑区信号
%本程序功能：根据提取的RIO信号进行黄变换的第一步经验模态分解
clear;
clc;
%数据路径设置
data_Path = 'E:\LiuluData\CTF\SourceData\HCP\DMN\ExtractROI\ROIsignal_DMN\';%提取的ROI位置
result_Path =  'E:\LiuluData\CTF\SourceData\HCP\DMN\ExtractROI\IMFs\';  %结果得到的本征模态函数位置  

%可能用到的静息态变量赋值
num_roi = 22;                                % 感兴趣区域的个数，根据raw_roi结构体中的数据具体赋值
num_vol = 1018;                              % 时间点个数，根据结构体内的time具体赋值
ts = 1/500;  
fs = 1/ts;   
t = 0:ts:ts*(num_vol-1); % ts为时间间隔、fs为采样频率、t为时间长度0-2.0s
%Sub_name='100307_RAWrois_maxpow_1.mat';   %感兴趣区文件名

subjList={'100307','102816','105923','106521','108323','109123','111514','113922','116524','133019','140117','146129','153732','156334','158136','162026'};                      %需要批量处理的数据名字
num_subj=length(subjList);                               %需要批量处理的数据个数

%加载数据，取出roi信号的第五个trial的信号进行后续处理
signal=cell(num_subj,1);%开辟元胞数组空间
for i = 1:num_subj 
    load([data_Path,subjList{i},'_RAWrois_maxpow_DMN.mat']);   % 加载每个被试的源重建后的MEG数据
    signal{i} = DMN_rois.trial{1,5};                         % 将第5个trial的时间序列作为要处理的信号
     signal{i} = abs(hilbert(signal{i}));                     % 获取信号的幅度包络
     signal{i} = zscore(signal{i});                           % zscore用于标准化，相当于z = (x-mean(x))./std(x)
end
clearvars i                                                  % 清除变量i

save( [result_Path,'AllSubjects', '_signal.mat'],'signal')                   % 将标准化后的信号保存在结果路径中

%对取出的trial信号进行经验模态分解EMD得到本征模态函数IMFs
imf = cell(num_subj,1);                                         %为后续产生的本征模态函数开辟存储空间
for i = 1:num_subj                                              % 外循环为被试数
    for j = 1:num_roi                                           % 内循环为感兴趣区域的数目
       imf{i}{j} = emd(signal{i}(j,:),'Interpolation','pchip','Display',0);%,'Display',0);% 对每个被试的每个感兴趣区域的信号进行EMD分解，每个脑区分解得到6~8个IMFs信号（每列一个IMF信号）    
    end   
end
clearvars i j                                                        % 清除变量i，j

save( [result_Path,'AllSubjects','_imf.mat'],'imf');                                % 将IMFs信号保存在结果路径中

%绘图ROI分解为IMFs的函数
%DrawIMFs(t,ts,imf,num_subj,num_roi);

%结果显示每个感兴趣区信号被分解成6~8个IMFs信号，
%matlab默认当sifting stops when current relative tolerance is less than SiftRelativeTolerance
%SiftRelativeTolerance默认值为0.2
%计算分解得到的IMFs信号与源信号的皮尔森相关
%CoIMFsSignal(imf,signal,num_subj,num_roi);