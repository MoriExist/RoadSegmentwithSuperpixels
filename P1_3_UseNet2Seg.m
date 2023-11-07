close all; clear all; clc;

load net230619.mat

order = 3; % 設定超像素分割的場景（1：市區，2：郊區，3：封閉式）
% imName = 'videoplayback 060'; % 資料名稱
scene = {'#1_City'; '#2_Suburbs'; '#3_Limited-Access Road'}; % 場景的類型

filePath = strcat('.\SceneData\', char(scene(order(1))), '\', imName, '.png');

% ---- 創建資料夾 ---- %%
FolderName = strcat("CLASSforPaper_", imName); %創建資料夾名稱

for i = 1:8
    mkdir(strcat('.\ClassData\', char(scene(order)), '\', FolderName), strcat('C', string(i)))
end

% ---- END ---- %%

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

    sg = imcrop(outputDetection, graindata(labelVal).BoundingBox);

    switch YPred
        case 'C1'
            imwrite(sg, strcat('.\ClassData\', char(scene(order)), '\', FolderName, '\C1\', imName, '_', string(labelVal), '.png'));
        case 'C2'
            imwrite(sg, strcat('.\ClassData\', char(scene(order)), '\', FolderName, '\C2\', imName, '_', string(labelVal), '.png'));
        case 'C3'
            imwrite(sg, strcat('.\ClassData\', char(scene(order)), '\', FolderName, '\C3\', imName, '_', string(labelVal), '.png'));
        case 'C4'
            imwrite(sg, strcat('.\ClassData\', char(scene(order)), '\', FolderName, '\C4\', imName, '_', string(labelVal), '.png'));
        case 'C5'
            imwrite(sg, strcat('.\ClassData\', char(scene(order)), '\', FolderName, '\C5\', imName, '_', string(labelVal), '.png'));
        case 'C6'
            imwrite(sg, strcat('.\ClassData\', char(scene(order)), '\', FolderName, '\C6\', imName, '_', string(labelVal), '.png'));
        case 'C7'
            imwrite(sg, strcat('.\ClassData\', char(scene(order)), '\', FolderName, '\C7\', imName, '_', string(labelVal), '.png'));
        case 'C8'
            imwrite(sg, strcat('.\ClassData\', char(scene(order)), '\', FolderName, '\C8\', imName, '_', string(labelVal), '.png'));
    end

end
