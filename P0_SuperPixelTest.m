close all; clear all; clc;

name='videoplayback 138'; 
path=['./TrainingData/',name,'.jpg'];

A=imread(path);
A=imresize(A,[1080,1920]);
[L,N] = superpixels(A, 512, 'NumIterations', 10, 'Compactness', 1, 'Method', 'SLIC0');
graindata = regionprops(L, 'basic');

BW = boundarymask(L);

BW = boundarymask(L);



outputImage = zeros(size(A),'like',A);
idx = label2idx(L);
numRows = size(A,1);
numCols = size(A,2);

for labelVal=1:N
    redIdx = idx{labelVal};
    greenIdx = idx{labelVal}+numRows*numCols;
    blueIdx = idx{labelVal}+2*numRows*numCols;
    outputImage(redIdx) = mean(A(redIdx));
    outputImage(greenIdx) = mean(A(greenIdx));
    outputImage(blueIdx) = mean(A(blueIdx));
end
% 
% imwrite(A,'ax1.jpg')
% imwrite(imoverlay(A, BW, 'r'),'ax2.jpg');