%绘制状态转移矩阵
clear
clc
close all

% % % 健康被试
% % % 健康被试
% load('E:\LiuluData\CTF\SourceData\HCP\IMFs\HilbertTransform\Network\Ang_cluster.mat')          % 加载Ang_cluster
% load('E:\LiuluData\CTF\SourceData\HCP\IMFs\HilbertTransform\Network\Coh_cluster.mat')          % 加载Coh_cluster
% load('E:\LiuluData\CTF\SourceData\HCP\DMN\ExtractROI\IMFs\HilbertTransform\Network\Time_FrequencyCluster\Time_FrequencyCluster.mat') % 加载ClusterResult
load('E:\LiuluData\CTF\SourceData\HCP\DMN\ExtractROI\IMFs\HilbertTransform\Network\317\5_7Cluster.mat')
set(0,'defaultfigurecolor','w'); % Set background white
% % y = tem -'0';
% % x=1:length(tem);
% % x1=[x;x(2:end),x(end)+1];
% % x2=x1(:);
% % y1=[y;y];
% % y2=y1(:);
% % plot(x2,y2,'b','LineWidth',3);
% % ylim([0,1.3]);
% % box off;
% x = linsapce(0,2*pi,100);
% function y = containsArray(big,small)
%     [row_s,col_s] = size(small);
%     [row_b,col_b] = size(big);
%     y = 0;
%     for i = 1:row_b-row_s+1
%         if big(i:i+row_s-1,:) == small
%             y = 1;
%             break;
%         end
%     end
% m=61;
one2one = 0;one2two = 0;one2three = 0;one2four = 0;one2five = 0;
two2one = 0;two2two = 0;two2three = 0;two2four = 0;two2five = 0;
three2one = 0;three2two = 0;three2three = 0;three2four = 0;three2five = 0;
four2one = 0;four2two = 0;four2three = 0;four2four = 0;four2five = 0;
five2one = 0;five2two = 0;five2three = 0;five2four = 0;five2five = 0;

num1 = 0;num2 = 0;num3= 0;num4 = 0;num5 = 0;
% idx = idx(1:636);
% % idx = idx(1:1272);
%for j=1:m
idx=idx_inall{89};%可以设置为聚类结果中的F-ratio最小值/最大值
n = length(idx);

  for i = 1:n-1
    if idx(i) == 1 & idx(i+1) == 1
        one2one = one2one + 1;
    elseif idx(i) == 1 & idx(i+1) == 2
        one2two = one2two + 1;
    elseif idx(i) == 1 & idx(i+1) == 3
        one2three = one2three + 1;
    elseif idx(i) == 1 & idx(i+1) == 4
        one2four = one2four + 1;
    elseif idx(i) == 1 & idx(i+1) == 5
        one2five = one2five + 1;
    elseif idx(i) == 2 & idx(i+1) == 1
        two2one = two2one + 1;
    elseif idx(i) == 2 & idx(i+1) == 2
        two2two = two2two + 1;
    elseif idx(i) == 2 & idx(i+1) == 3
        two2three = two2three + 1;
    elseif idx(i) == 2 & idx(i+1) == 4
        two2four = two2four + 1;
    elseif idx(i) == 2 & idx(i+1) == 5
        two2five = two2five + 1;
    elseif idx(i) == 3 & idx(i+1) == 1
        three2one = three2one + 1;
    elseif idx(i) == 3 & idx(i+1) == 2
        three2two = three2two + 1;
    elseif idx(i) == 3 & idx(i+1) == 3
        three2three = three2three + 1;
    elseif idx(i) == 3 & idx(i+1) == 4
        three2four = three2four + 1;
    elseif idx(i) == 3 & idx(i+1) == 5
        three2five = three2five + 1;
    elseif idx(i) == 4 & idx(i+1) == 1
        four2one = four2one + 1;
    elseif idx(i) == 4 & idx(i+1) == 2
        four2two = four2two + 1;
    elseif idx(i) == 4 & idx(i+1) == 3
        four2three = four2three + 1;
    elseif idx(i) == 4 & idx(i+1) == 4
        four2four = four2four + 1;
    elseif idx(i) == 4 & idx(i+1) == 5
        four2five = four2five + 1;
    elseif idx(i) == 5 & idx(i+1) == 1
        five2one = five2one + 1;
    elseif idx(i) == 5 & idx(i+1) == 2
        five2two = five2two + 1;
    elseif idx(i) == 5 & idx(i+1) == 3
        five2three = five2three + 1;
    elseif idx(i) == 5 & idx(i+1) == 4
        five2four = five2four + 1;
    elseif idx(i) == 5 & idx(i+1) == 5
        five2five = five2five + 1;
    end
  end

  for i = 1:n
    if idx(i) == 1
        num1 = num1 + 1;
    elseif idx(i) == 2
        num2 = num2 + 1;
    elseif idx(i) == 3
        num3 = num3 + 1;
    elseif idx(i) == 4
        num4 = num4 + 1;
    elseif idx(i) == 5
        num5 = num5 + 1;
    end
  end
%end
%five2one = five2one + 1;
matrix = zeros(5,5);
% matrix(1,1) = one2one/num1;matrix(1,2) = one2two/num1;matrix(1,3) = one2three/num1;matrix(1,4) = one2four/num1;matrix(1,5) = one2five/num1;
% matrix(2,1) = two2one/num2;matrix(2,2) = two2two/num2;matrix(2,3) = two2three/num2;matrix(2,4) = two2four/num2;matrix(2,5) = two2five/num2;
% matrix(3,1) = three2one/num3;matrix(3,2) = three2two/num3;matrix(3,3) = three2three/num3;matrix(3,4) = three2four/num3;matrix(3,5) = three2five/num3;
% matrix(4,1) = four2one/num4;matrix(4,2) = four2two/num4;matrix(4,3) = four2three/num4;matrix(4,4) = four2four/num4;matrix(4,5) = four2five/num4;
% matrix(5,1) = five2one/num5;matrix(5,2) = five2two/num5;matrix(5,3) = five2three/num5;matrix(5,4) = five2four/num5;matrix(5,5) = five2five/num5;
matrix(1,1) = one2one/n;matrix(1,2) = one2two/n;matrix(1,3) = one2three/n;matrix(1,4) = one2four/n;matrix(1,5) = one2five/n;
matrix(2,1) = two2one/n;matrix(2,2) = two2two/n;matrix(2,3) = two2three/n;matrix(2,4) = two2four/n;matrix(2,5) = two2five/n;
matrix(3,1) = three2one/n;matrix(3,2) = three2two/n;matrix(3,3) = three2three/n;matrix(3,4) = three2four/n;matrix(3,5) = three2five/n;
matrix(4,1) = four2one/n;matrix(4,2) = four2two/n;matrix(4,3) = four2three/n;matrix(4,4) = four2four/n;matrix(4,5) = four2five/n;
matrix(5,1) = five2one/n;matrix(5,2) = five2two/n;matrix(5,3) = five2three/n;matrix(5,4) = five2four/n;matrix(5,5) = five2five/n;
matrix = matrix - diag(diag(matrix));
imagesc(matrix)
xlabel('State at t+1')
ylabel('State at t')
title('State transitions','FontSize',12);
% cd('E:\LiuluData\CTF\SourceData\HCP\DMN\ExtractROI\IMFs\HilbertTransform\Network\Time_FrequencyCluster\ChoResult\')
cd('E:\LiuluData\CTF\SourceData\HCP\DMN\ExtractROI\IMFs\HilbertTransform\Network\317\5-7max\')
print('State transitions 01','-dpng','-r300')