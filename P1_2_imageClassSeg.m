close all; clear all; clc;
order = 3;
imName = 'videoplayback 138';

scene = {'#1_City'; '#2_Suburbs'; '#3_Limited-Access Road'};
impath = strcat('.\ClassData\', char(scene(order)), '\CLASSforPaper_', imName);
imds = imageDatastore(impath, ...
    'IncludeSubfolders', true, ...
    'LabelSource', 'foldernames');
% montage(imds)

path = ['.\SceneData\', char(scene(order)), '\', imName, '.png'];

A = imresize(imread(path), [1080, 1920]);
[L, N] = superpixels(A, 512, 'NumIterations', 10, 'Compactness', 1, 'Method', 'SLIC0');
graindata = regionprops(L, 'basic');

BW = boundarymask(L);
BW = boundarymask(L, 4);
nHood = [0 0 1 0 0; ...
             0 0 1 0 0; ...
             1 1 1 1 1; ...
             0 0 1 0 0; ...
             0 0 1 0 0; ];
BW=imdilate(BW,nHood);

outputImage = zeros(size(A), 'like', A);

idx = label2idx(L);
numRows = size(A, 1);
numCols = size(A, 2);

class1=[];class2=[];class3=[];class4=[];class5=[];class6=[];class7=[];class8=[];


for label = 1:size(imds.Files, 1)
    className = contains(imds.Files(label), imName);
    classLabel = string(imds.Labels(label));

    [FolderPath, labelIdx] = fileparts(imds.Files(label));
    labelVal = str2double(extractAfter(labelIdx, "_"));

    redIdx = idx{labelVal};
    greenIdx = idx{labelVal} + numRows * numCols;
    blueIdx = idx{labelVal} + 2 * numRows * numCols;

    if className && classLabel == 'C1'
        outputImage(redIdx) = 33;
        outputImage(greenIdx) = 26;
        outputImage(blueIdx) = 30;
        class1(end+1,1)=labelVal;
    elseif className && classLabel == 'C2'
        outputImage(redIdx) = 255;
        outputImage(greenIdx) = 255;
        outputImage(blueIdx) = 255;
        class2(end+1,1)=labelVal;
    elseif className && classLabel == 'C3'
        outputImage(redIdx) = 255;
        outputImage(greenIdx) = 191;
        outputImage(blueIdx) = 0;
        class3(end+1,1)=labelVal;
    elseif className && classLabel == 'C4'
        outputImage(redIdx) = 232;
        outputImage(greenIdx) = 63;
        outputImage(blueIdx) = 111;
        class4(end+1,1)=labelVal;
    elseif className && classLabel == 'C5'
        outputImage(redIdx) = 203;
        outputImage(greenIdx) = 113;
        outputImage(blueIdx) = 46;
        class5(end+1,1)=labelVal;
    elseif className && classLabel == 'C6'
        outputImage(redIdx) = 165;
        outputImage(greenIdx) = 165;
        outputImage(blueIdx) = 165;
        class6(end+1,1)=labelVal;
    elseif className && classLabel == 'C7'
        outputImage(redIdx) = 50;
        outputImage(greenIdx) = 147;
        outputImage(blueIdx) = 111;
        class7(end+1,1)=labelVal;
    elseif className && classLabel == 'C8'
        outputImage(redIdx) = 34;
        outputImage(greenIdx) = 116;
        outputImage(blueIdx) = 165;
        class8(end+1,1)=labelVal;
    end

end



f1 = figure(1); layout = tiledlayout('flow', 'TileSpacing', 'tight');
ax1 = nexttile; imshow(imoverlay(outputImage, BW, 'r'));
%
% ---- 確認標記區域 ---- %
RegionImage = zeros(size(A),'like',A);
idx = label2idx(L);
numRows = size(A,1);
numCols = size(A,2);
for i =350:400
    redIdx = idx{i};
    greenIdx = idx{i}+numRows*numCols;
    blueIdx = idx{i}+2*numRows*numCols;
    RegionImage(redIdx) = A(redIdx);
    RegionImage(greenIdx) = A(greenIdx);
    RegionImage(blueIdx) = A(blueIdx);
end
% RegionImage=imoverlay(RegionImage./2+A./2,BW,'red');
% imshow(RegionImage)
% ---- END ---- %

AugmentedImage = imoverlay(A * 0.45 + outputImage * 0.55, BW, 'red');
ax2 = nexttile; imshow(AugmentedImage)
figureLeft = 50; figureBottem = 150; figureWidth = 1400; figureHeight = 450;
% 1620
set(f1, 'unit', 'pixel', 'position', [figureLeft, figureBottem, figureWidth, figureHeight])


imwrite(imoverlay(outputImage, BW, 'r'),strcat('.\SceneData\', char(scene(order)), '_Label\', imName, '_Label.png'));
imwrite(AugmentedImage, strcat('.\SceneData\', char(scene(order)), '_Mix\', imName, '_Mix.png'));



%%
% % ---- 搬移超級像素至訓練集內 ----
% FolderName = strcat("CLASSforPaper_", imName); %創建資料夾名稱
% sourcePath = strcat('.\ClassData\', char(scene(order)), '\', FolderName, '\C*');
% targetPath = '.\CLASS';
% status = copyfile(sourcePath, targetPath)
% % ---- END ---- %


%%
% class={class1, class2, class3, class4, class5, class6, class7, class8};
% 
% outputSave = strcat('./DataSet/', imName, '.mat'); % 輸出檔案的保存路徑
% save(outputSave, 'imName', "A","L","N","idx", "numRows", "numCols", 'class');

