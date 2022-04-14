% ����˵���������õ�ROI�Ķ�ά��ɾ������λ����󣬽�����ȷ��������k��ȡֵ

clear
clc
close all

load('E:\LiuluData\CTF\SourceData\HCP\DMN\ExtractROI\IMFs\HilbertTransform\Network\Ang_cluster.mat')          % ����Ang_cluster
load('E:\LiuluData\CTF\SourceData\HCP\DMN\ExtractROI\IMFs\HilbertTransform\Network\Cohcluster315.mat')          % ����Coh_cluster

%set(0,'defaultfigurecolor','w');
num_roi = 22;
max_num_cluster = 9;
Ang_cluster=Ang_cluster(15270:25450,:);
Coh_cluster=Coh_cluster(15270:25450,:);
Combo = [Coh_cluster,Ang_cluster];          %                           % �������������λֵ
c = ones(num_roi,num_roi);                                             % cΪ78*78��ȫ1���� 
fr = zeros(max_num_cluster-2,1);                                       % frΪ7*1��ȫ0����
num_cluster = 3;                                                       % ������
idx = cell(max_num_cluster-2,1);                                       % idxΪ7*1�ĵ�Ԫ����
percent = cell(max_num_cluster-2,1);                                   % percentΪ7*1�ĵ�Ԫ����

for i = 1:max_num_cluster-2 
    
    %%%%% K��ֵ���࣬����������Ϊ1000��
    % idxΪ�������������k = 5,��ôidx���ܵ�ȡֵΪ1,2,3,4,5��CΪ�������ĵ�λ�ã�
    % ~Ϊ���ڸ��㵽�������ĵľ���֮�ͣ�dΪÿ���㵽�������ĵľ���
    [idx{i},C,~,d] = kmeans(Combo,num_cluster,'MaxIter',1000);   
%       percent{i} = tabulate(idx{i});
    tmp_fr = zeros(1,num_cluster);

    % ��������
    mkdir(['E:\LiuluData\CTF\SourceData\HCP\DMN\ExtractROI\IMFs\HilbertTransform\Network\316\555\KCluster-' num2str(num_cluster)])
    cd(['E:\LiuluData\CTF\SourceData\HCP\DMN\ExtractROI\IMFs\HilbertTransform\Network\316\555\KCluster-' num2str(num_cluster)])
     
    for j = 1:num_cluster % for each cluster at this number of cluster
        
        %%%%% ����F��ֵ
        location_insider = find(idx{i}==j);         % �������ڵ�ǰ��������������
        location_outsider = find(idx{i}~=j);        % ���ز����ڵ�ǰ��������������         
        
        insider = d(location_insider,j).^2;         % ���������㵽����������ĵľ���ƽ�� 
        outsider = d(location_outsider,j).^2;       % ���������㵽����������ĵľ���ƽ��

        tmp_fr(j) = sum(insider)/sum(outsider);     % ��ǰF��ֵ
        
        %%% ��ɵľ�������
        coh = C(j,1:num_roi*num_roi);               % 
        coh = reshape(coh,num_roi,num_roi);
        tmp = triu(coh,1);
        coh = coh+tmp';
        
        %%% ��λ�ľ�������
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
        
        %%% ����kȡ��ֵͬʱ�ĸ�״̬�µľ���
        h = cat(3,ang,coh,c);            % h(:,:,1) = ang;h(:,:,2) = coh;h(:,:,3) = c 
        colormap = hsv2rgb(h);           % h = ang;s = coh;v = c,����h��ʾɫ����s��ʾ���Ͷȣ�v��ʾֵ����hsvת��Ϊrgbֵ
        percent{i} = tabulate(idx{i});   % �õ�һ��Ƶ�ʱ���һ��Ϊֵ���ڶ���Ϊ��ֵ���ֵĴ�����������Ϊ��ֵ��ռ�ı�������ȡĳ��״̬���ֵĸ���
        
        figure(j);                       
        imagesc(colormap);               % ��������ͼ
        axis off;                        % �ر������� 
        set(gca, 'YDir', 'normal')              
        tmp1 = percent{i}(j,3);          % ��ȡĳ״̬�İٷֱ�
        tmp2 = sprintf('%.2f',tmp1);     % �����ٷֱ�С�������λ�������ַ����ĸ�ʽ���   
        title([tmp2 '%']);               % ��figure���title
        
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

% ����F-Ratioͼ��
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


cd('E:\LiuluData\CTF\SourceData\HCP\DMN\ExtractROI\IMFs\HilbertTransform\Network\316\555\')        % ��������
fig = gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 2.25 2];
print('F-Ratio','-dpng','-r300')

close