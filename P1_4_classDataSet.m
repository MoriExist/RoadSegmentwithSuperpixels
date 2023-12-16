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
Gray=rgb2gray(A);
roi=~logical(rgb2gray(outputImage));
Mask=Gray(roi);

RP_R=A(:,:,1); RP_G=A(:,:,2); RP_B=A(:,:,3);


RP_R(roi)=Mask;RP_G(roi)=Mask; RP_B(roi)=Mask;
im_new(:,:,1)=RP_R;im_new(:,:,2)=RP_G; im_new(:,:,3)=RP_B;
figure;imshow(im_new)
