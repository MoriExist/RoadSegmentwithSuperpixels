close all; clear all; clc;

load .\DataSet\'videoplayback 138.mat'

outputImage = zeros(size(A), 'like', A);

cName=7;

for i = 1:size(class{cName},1)
    redIdx = idx{class{cName}(i)};
    greenIdx = idx{class{cName}(i)} + numRows * numCols;
    blueIdx = idx{class{cName}(i)} + 2 * numRows * numCols;
    outputImage(redIdx) = A(redIdx);
    outputImage(greenIdx) = A(greenIdx);
    outputImage(blueIdx) = A(blueIdx);
end

figure;imshow(outputImage)
roi=~logical(rgb2gray(outputImage));
Mask=A(roi);
%%
[m,n]=size(roi);
z=zeros(m,n);
roiRed=uint8(cat(3,~roi,z,z).*255);
figure;imshow(~roi)
BW=bwperim(~roi,8);
nHood = [0 0 1 0 0; ...
             0 0 1 0 0; ...
             1 1 1 1 1; ...
             0 0 1 0 0; ...
             0 0 1 0 0; ];
BW = imdilate(BW, nHood);
figure;imshow(roiRed)
figure;imshow(imoverlay(roi, BW, 'r'))
AugmentedImage = imoverlay(A + roiRed * 0.55, BW, 'red');
figure; imshow(AugmentedImage)
