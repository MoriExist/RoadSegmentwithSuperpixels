close all; clear all; clc;


load net230619.mat


f1=figure;
% f1.Color='none';
C = confusionmat(imdsValidation.Labels,YPred)
cm=confusionchart(imdsValidation.Labels, YPred)
cm.RowSummary = 'row-normalized'; %recalls 
cm.ColumnSummary = 'column-normalized'; %precisions 
% cm.RowSummary = 'absolute'; 
% cm.ColumnSummary = 'absolute'; 

Accuracy= sum(diag(C))/sum(C,"all")
precision=diag(C)./(sum(C,1)+0.0001)'
recall=diag(C)./(sum(C,2)+0.0001)
precisionAll=mean(precision)
recallAll=mean(recall)
F1_score=2*precisionAll*recallAll/(precisionAll+recallAll)
F1=2.*precision.*recall./(precision+recall)
myAns=[Accuracy; precisionAll; recallAll; F1_score]

