%����˵����ROI�źű��ֽ��ΪIMFs�ź�֮��ͳ��ÿ��ROI�źŶ����ֽ���˼���IMFs�ź�
%ͬʱͳ�Ʒֽ�ɵ�IMFs�ź���Դ�źŵ���ضȣ�����������������ʱ���õ��źųɷ�
%�ú�����EMD�б�����
close all;
clear;
clc;

%����IMFs�źź�Դ�ź�
IMFs_Path =  'E:\LiuluData\CTF\SourceData\HCP\DMN\ExtractROI\IMFs\';  %����õ��ı���ģ̬����λ��  
Signal_Path= 'E:\LiuluData\CTF\SourceData\HCP\DMN\ExtractROI\IMFs\';%����emd���ź�λ��
Figure_Path= 'E:\LiuluData\CTF\SourceData\HCP\DMN\ExtractROI\IMFs\CoIMFsSignalFigure\';%���ͼ�洢λ��
num_roi =22;                                % ����Ȥ����ĸ���������raw_roi�ṹ���е����ݾ��帳ֵ
load([IMFs_Path,'AllSubjects_imf.mat']);
load([Signal_Path,'AllSubjects_signal.mat']);
num_subj=16;   


%function Correlation=CoIMFsSignal(imf,signal,num_subj,num_roi)


%����IMFs�ź���Դ�źŵ����������
imf_r = cell(num_subj,1);    %���ٿռ�洢����Ȥ������Դ�źŵ����ϵ������Ϊ��������Ϊ��k��IMF        
num_imf = [];%zeros(num_subj,num_roi);  %���ٿռ�洢ÿ��ROI�źű��ֽ�ɵ�IMFs������ÿ�д���һ��ʵ������б�ʾʵ�����ÿ�������źű��ֽ������IMFs����   

for i = 1:num_subj     %iΪ��������jΪ��������kΪIMF��
    for j = 1:num_roi
        num_imf(i,j) = size(imf{i,1}{1,j},2);                          % ��i�����Ե�j��ROI���źŷֽ��IMFs�ĸ���
        for k = 1:num_imf(i,j)                                         % ����ÿһ��imf�źţ���������ԭ�źŵ�Ƥ��ɭ���
            imf_r{i}(j,k) = corr((signal{i}(j,:))',(imf{i}{j}(:,k)));   
        end
    end
end

% ����imfs��Ŀ�ֲ�����״ͼ
max_num_imf = max(max(num_imf));                                       % ���IMFs��
min_num_imf = min(min(num_imf));                                       % ��СIMFs��
count = 1;
count_num_imf = zeros((max_num_imf-min_num_imf+1),1);                  % ÿ���źŷֽ�ɵ�imf��

for i = min_num_imf:max_num_imf                                        % ͳ��min_num_imf��max_num_imf������
    count_num_imf(count) = length(find(num_imf==i));
    count = count+1;
end

figure('visible','off');
b=bar(min_num_imf:max_num_imf,count_num_imf);                     % ����ͼ��ʾÿ���źŵ�IMFs����
title('IMF Results from EMD');
xlabel('Amount of IMFs');
ylabel('Number of Signals');
%����״ͼ�������
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
save( [IMFs_Path, 'imf_corr.mat'],'imf_r')%����IMFs��Դ�źŵ����ϵ������


%%%%%% ����ʽͼ�������ϵ���ķֲ�
imf_label = [];
for j = 1:max_num_imf-1                 % ����imf��ǩ
    tmp = ['IMF ' num2str(j)];
    imf_label = [imf_label; tmp];
end
imf_label = [imf_label;'IMF 9'];%���һλ��IMF ���ֿ�����Ҫ����ʵ�����������ݵ��������
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