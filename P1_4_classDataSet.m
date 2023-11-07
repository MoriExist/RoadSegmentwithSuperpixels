close all; clear all; clc;

load .\DataSet\'videoplayback 007.mat'

outputImage = zeros(size(A), 'like', A);

cName=3;

for i = 1:size(class{cName},1)
    redIdx = idx{class{cName}(i)};
    greenIdx = idx{class{cName}(i)} + numRows * numCols;
    blueIdx = idx{class{cName}(i)} + 2 * numRows * numCols;
    outputImage(redIdx) = A(redIdx);
    outputImage(greenIdx) = A(greenIdx);
    outputImage(blueIdx) = A(blueIdx);
end

imshow(outputImage)