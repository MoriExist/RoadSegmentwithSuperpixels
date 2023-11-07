close all; clear all; clc;

load net230619.mat

order = 2; % 設定超像素分割的場景（1：市區，2：郊區，3：封閉式）
imName = '14050'; % 資料名稱
scene = {'#1_City'; '#2_Suburbs'; '#3_Limited-Access Road'}; % 場景的類型

filePath = strcat('.\SceneData\', char(scene(order(1))), '\', imName, '.png');
im = imresize(imread(filePath), [1080, 1920]);

[L, N] = superpixels(im, 512, 'NumIterations', 10, 'Compactness', 1, 'Method', 'SLIC0');

BW = boundarymask(L, 4);
nHood = [0 0 1 0 0; ...
             0 0 1 0 0; ...
             1 1 1 1 1; ...
             0 0 1 0 0; ...
             0 0 1 0 0; ];
BW = imdilate(BW, nHood);

graindata = regionprops(L, 'basic');
outputImage = zeros(size(im), 'like', im);
idx = label2idx(L);
numRows = size(im, 1);
numCols = size(im, 2);

for labelVal = 1:size(graindata, [1])
    outputDetection = zeros(size(im), 'like', im);
    redIdx = idx{labelVal};
    greenIdx = idx{labelVal} + numRows * numCols;
    blueIdx = idx{labelVal} + 2 * numRows * numCols;
    outputDetection(redIdx) = im(redIdx);
    outputDetection(greenIdx) = im(greenIdx);
    outputDetection(blueIdx) = im(blueIdx);
    detection = imresize(imcrop(outputDetection, graindata(labelVal).BoundingBox), [224 224]);
    [YPred, probs] = classify(net, detection);

    switch YPred
        case 'C1'
            outputImage(redIdx) = 33;
            outputImage(greenIdx) = 26;
            outputImage(blueIdx) = 30;
        case 'C2'
            outputImage(redIdx) = 255;
            outputImage(greenIdx) = 255;
            outputImage(blueIdx) = 255;
        case 'C3'
            outputImage(redIdx) = 255;
            outputImage(greenIdx) = 191;
            outputImage(blueIdx) = 0;
        case 'C4'
            outputImage(redIdx) = 232;
            outputImage(greenIdx) = 63;
            outputImage(blueIdx) = 111;
        case 'C5'
            outputImage(redIdx) = 203;
            outputImage(greenIdx) = 113;
            outputImage(blueIdx) = 46;
        case 'C6'
            outputImage(redIdx) = 165;
            outputImage(greenIdx) = 165;
            outputImage(blueIdx) = 165;
        case 'C7'
            outputImage(redIdx) = 50;
            outputImage(greenIdx) = 147;
            outputImage(blueIdx) = 111;
        case 'C8'
            outputImage(redIdx) = 34;
            outputImage(greenIdx) = 116;
            outputImage(blueIdx) = 165;
    end

end

f1 = figure(1); layout = tiledlayout('flow', 'TileSpacing', 'tight');
ax1 = nexttile; imshow(im);
ax2 = nexttile; imshow(imoverlay(im, BW, 'r'));
ax3 = nexttile; imshow(outputImage);
ax4 = nexttile; imshow(imoverlay(outputImage, BW, 'r'));
CreateFigureOneColumn(f1, [], [])
figureLeft = 1620; figureBottem = 150; figureWidth = 1400; figureHeight = 450;
set(f1, 'unit', 'pixel', 'position', [figureLeft, figureBottem, figureWidth, figureHeight])
% 
% % exportgraphics(ax1,'ax1.emf','BackgroundColor','none')
% % exportgraphics(ax2,'ax2.emf','BackgroundColor','none')
% % exportgraphics(ax3,'ax3.emf','BackgroundColor','none')
% % exportgraphics(ax4,'ax4.emf','BackgroundColor','none')

% imwrite(im, 'ax1.jpg');
% imwrite(imoverlay(im, BW, 'r'), 'ax2.jpg');
% imwrite(outputImage, 'ax3.jpg');
% imwrite(imoverlay(outputImage, BW, 'r'), 'ax4.jpg');
