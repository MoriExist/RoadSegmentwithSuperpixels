clear all; close all; clc;

load net230619.mat


order = 3; % 設定超像素分割的場景（1：市區，2：郊區，3：封閉式）
name = 'videoplayback 007'; % 資料名稱

scene = {'#1_City'; '#2_Suburbs'; '#3_Limited-Access Road'}; % 場景的類型

imdsPath = strcat('.\ClassData\', char(scene(order)), '\CLASSforPaper_', name); % 影像數據集的路徑
imds = imageDatastore(imdsPath, ...
    'IncludeSubfolders', true, ...
    'LabelSource', 'foldernames'); % 創建影像數據存儲對象

for label = 1:size(imds.Files, 1)
    detection = imresize(imread(string(imds.Files(label))), [224 224]);
    myYPred(1,label)= classify(net, detection);
end
% f1=figure('Color','none');
f1=figure; 
% f1.Color='none';
C = confusionmat(imds.Labels',myYPred)
cm=confusionchart(imds.Labels', myYPred)
% cm.RowSummary = 'absolute'; 
cm.RowSummary = 'row-normalized'; %recalls 
cm.ColumnSummary = 'column-normalized'; %precisions 
% cm.Normalization = 'total-normalized'
sortClasses(cm,["C1", "C2","C3","C4","C5","C6","C7","C8"])



Accuracy= sum(diag(C))/sum(C,"all")
precision=(diag(C)+0.0001)./(sum(C,1)+0.0001)'
recall=(diag(C)+0.0001)./(sum(C,2)+0.0001)
precisionAll=mean(precision)
recallAll=mean(recall)
F1_score=2*precisionAll*recallAll/(precisionAll+recallAll) %F1值
F1=2.*precision.*recall./(precision+recall)



sum(C,'all')-sum(diag(C),"all")

myAns=[Accuracy; precisionAll; recallAll; F1_score]
% edit > copy figure