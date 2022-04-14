%函数说明明：根据AAL模板，抽取DMN标签
close all;
clear;
clc;

ModelPath='E:\LiuluData\CTF\SourceData\HCP\DMN\';%标准模型所在位置
DMN_ROIsPath='E:\LiuluData\CTF\SourceData\HCP\DMN\';
%read atlas
atlas = ft_read_atlas([ModelPath,'AAL\ROI_MNI_V4.nii']);
num_DMN=22;
MDN_atlas={3,4,7,8,11,12,31,32,33,34,35,36,37,38,39,40,65,66,67,68,85,86};%116个ROIlabel中属于DMN网络的label序号

for i=1:num_DMN

DMN_ROIs.label(i)=atlas.tissuelabel(MDN_atlas{i});
DMN_ROIs.index(i)=i;
end
save([DMN_ROIsPath,'DMN_ROIs.mat'],'DMN_ROIs');