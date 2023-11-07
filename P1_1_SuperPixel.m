close all; clear all; clc;
% 1_市區, 2_郊區, 3_封閉式
order = 1;
imName = '14103';
% videoplayback 014
scene = {'#1_City'; '#2_Suburbs'; '#3_Limited-Access Road'};

imdir = dir([strcat('.\SceneData\', char(scene(order)), '\')])
path = strcat('.\SceneData\', char(scene(order)), '\', imName,'.png');
A = imresize(imread(path), [1080, 1920]);


[L, N] = superpixels(A, 512, 'NumIterations', 10, 'Compactness', 1, 'Method', 'SLIC0');
figure
BW = boundarymask(L);
imshow(imoverlay(A, BW, 'red'), 'InitialMagnification', 67)

graindata = regionprops(L, 'basic');

outputImage = zeros(size(A), 'like', A);
idx = label2idx(L);
numRows = size(A, 1);
numCols = size(A, 2);

% ---- 切割未分類超級像素 ----
for i = 1:size(graindata, [1])
    outputImage = zeros(size(A), 'like', A);
    redIdx = idx{i};
    greenIdx = idx{i} + numRows * numCols;
    blueIdx = idx{i} + 2 * numRows * numCols;
    outputImage(redIdx) = A(redIdx);
    outputImage(greenIdx) = A(greenIdx);
    outputImage(blueIdx) = A(blueIdx);

    sg = imcrop(outputImage, graindata(i).BoundingBox);
    
%     imwrite(sg, strcat('.\n\', imName, '_', string(i), '.png'));
end



% % ---- 確認切割位置 ---- %%
% for i = 1:10
%     redIdx = idx{i};
%     greenIdx = idx{i} + numRows * numCols;
%     blueIdx = idx{i} + 2 * numRows * numCols;
%     outputImage(redIdx) = A(redIdx)/2;
%     outputImage(greenIdx) = A(greenIdx)/2;
%     outputImage(blueIdx) = A(blueIdx)/2;
%      j = 200; figure(i), imshow(imcrop(imoverlay(A, BW, 'red'), [graindata(i).BoundingBox(1) - j, graindata(i).BoundingBox(2) - j, graindata(i).BoundingBox(3) + j, graindata(i).BoundingBox(4) + j]))  
% end
% figure; imshow(outputImage)
% ---- END ---- %%

% 
% % ---- 創建資料夾 ---- %%
% FolderName = strcat("CLASSforPaper_", imName); %創建資料夾名稱
% 
% for i = 1:8
%     mkdir(strcat('.\ClassData\', char(scene(order)), '\', FolderName), strcat('C', string(i)))
% end
% % ---- END ---- %%




