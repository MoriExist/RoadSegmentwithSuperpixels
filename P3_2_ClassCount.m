close all; clear all; clc;

% load netCfP14893.mat
load('netCfPvpb138.mat')

order = 3; % 設定超像素分割的場景（1：市區，2：郊區，3：封閉式）
name = 'videoplayback 138'; % 資料名稱


scene = {'#1_City'; '#2_Suburbs'; '#3_Limited-Access Road'}; % 場景的類型

% name = '14893';path = ['./TrainingData/', name, '.png'];

path = ['.\SceneData\', char(scene(order)), '\', name, '.jpg']; % 影像文件的路徑


imds = imageDatastore('./CLASS', ...
    'IncludeSubfolders', true, ...
    'LabelSource', 'foldernames');



A = imread(path);
A = imresize(A, [1080, 1920]);
[L, N] = superpixels(A, 512, 'NumIterations', 10, 'Compactness', 1, 'Method', 'SLIC0');
graindata = regionprops(L, 'basic');

BW = boundarymask(L);
BW = boundarymask(L, 4);
nHood=[0 0 1 0 0;...
                 0 0 1 0 0;...
                 1 1 1 1 1;...
                 0 0 1 0 0;...
                 0 0 1 0 0;];
BW=imdilate(BW,nHood);



idx = label2idx(L);
numRows = size(A, 1);
numCols = size(A, 2);
cNum=9;
classCount=[0,0,0,0,0,0,0,0;
                     0,0,0,0,0,0,0,0;
                     0,0,0,0,0,0,0,0;
                     0,0,0,0,0,0,0,0;
                     0,0,0,0,0,0,0,0;
                     0,0,0,0,0,0,0,0;
                     0,0,0,0,0,0,0,0;
                     0,0,0,0,0,0,0,0;];


for label = 1:size(imds.Files, 1)
    className = strsplit(string(imds.Files(label)), {'\', '_'});
    classLabel = string(imds.Labels(label));

    if className(cNum) == name && classLabel == 'C1'
        outputDetection = zeros(size(A), 'like', A);
        labelIdx = strsplit(string(imds.Files(label)), {'_', '.'});
        labelVal = str2double(labelIdx(2));
        redIdx = idx{labelVal};
        greenIdx = idx{labelVal} + numRows * numCols;
        blueIdx = idx{labelVal} + 2 * numRows * numCols;
        outputDetection(redIdx) = A(redIdx);
        outputDetection(greenIdx) = A(greenIdx);
        outputDetection(blueIdx) = A(blueIdx);
        detection = imresize(imcrop(outputDetection, graindata(labelVal).BoundingBox), [224 224]);
        [YPred, probs] = classify(net, detection);
        
        if YPred == 'C1'
            classCount(1,1)=classCount(1,1)+1;
        elseif YPred == 'C2'
            classCount(1,2)=classCount(1,2)+1;
        elseif YPred == 'C3'
            classCount(1,3)=classCount(1,3)+1;
        elseif YPred == 'C4'
            classCount(1,4)=classCount(1,4)+1;
        elseif YPred == 'C5'
            classCount(1,5)=classCount(1,5)+1; 
        elseif YPred == 'C6'
            classCount(1,6)=classCount(1,6)+1;            
        elseif YPred == 'C7'
            classCount(1,7)=classCount(1,7)+1; 
        elseif YPred == 'C8'
            classCount(1,8)=classCount(1,8)+1;            
        end 
    elseif className(cNum) == name && classLabel == 'C2'
        outputDetection = zeros(size(A), 'like', A);
        labelIdx = strsplit(string(imds.Files(label)), {'_', '.'});
        labelVal = str2double(labelIdx(2));
        redIdx = idx{labelVal};
        greenIdx = idx{labelVal} + numRows * numCols;
        blueIdx = idx{labelVal} + 2 * numRows * numCols;
        outputDetection(redIdx) = A(redIdx);
        outputDetection(greenIdx) = A(greenIdx);
        outputDetection(blueIdx) = A(blueIdx);
        detection = imresize(imcrop(outputDetection, graindata(labelVal).BoundingBox), [224 224]);
        [YPred, probs] = classify(net, detection);
        
        if YPred == 'C1'
            classCount(2,1)=classCount(2,1)+1;
        elseif YPred == 'C2'
            classCount(2,2)=classCount(2,2)+1;
        elseif YPred == 'C3'
            classCount(2,3)=classCount(2,3)+1;
        elseif YPred == 'C4'
            classCount(2,4)=classCount(2,4)+1;
        elseif YPred == 'C5'
            classCount(2,5)=classCount(2,5)+1; 
        elseif YPred == 'C6'
            classCount(2,6)=classCount(2,6)+1;            
        elseif YPred == 'C7'
            classCount(2,7)=classCount(2,7)+1; 
        elseif YPred == 'C8'
            classCount(2,8)=classCount(2,8)+1;            
        end 
    elseif className(cNum) == name && classLabel == 'C3'
        outputDetection = zeros(size(A), 'like', A);
        labelIdx = strsplit(string(imds.Files(label)), {'_', '.'});
        labelVal = str2double(labelIdx(2));
        redIdx = idx{labelVal};
        greenIdx = idx{labelVal} + numRows * numCols;
        blueIdx = idx{labelVal} + 2 * numRows * numCols;
        outputDetection(redIdx) = A(redIdx);
        outputDetection(greenIdx) = A(greenIdx);
        outputDetection(blueIdx) = A(blueIdx);
        detection = imresize(imcrop(outputDetection, graindata(labelVal).BoundingBox), [224 224]);
        [YPred, probs] = classify(net, detection);
        
        if YPred == 'C1'
            classCount(3,1)=classCount(3,1)+1;
        elseif YPred == 'C2'
            classCount(3,2)=classCount(3,2)+1;
        elseif YPred == 'C3'
            classCount(3,3)=classCount(3,3)+1;
        elseif YPred == 'C4'
            classCount(3,4)=classCount(3,4)+1;
        elseif YPred == 'C5'
            classCount(3,5)=classCount(3,5)+1; 
        elseif YPred == 'C6'
            classCount(3,6)=classCount(3,6)+1;            
        elseif YPred == 'C7'
            classCount(3,7)=classCount(3,7)+1; 
        elseif YPred == 'C8'
            classCount(3,8)=classCount(3,8)+1;            
        end 
    elseif className(cNum) == name && classLabel == 'C4'
        outputDetection = zeros(size(A), 'like', A);
        labelIdx = strsplit(string(imds.Files(label)), {'_', '.'});
        labelVal = str2double(labelIdx(2));
        redIdx = idx{labelVal};
        greenIdx = idx{labelVal} + numRows * numCols;
        blueIdx = idx{labelVal} + 2 * numRows * numCols;
        outputDetection(redIdx) = A(redIdx);
        outputDetection(greenIdx) = A(greenIdx);
        outputDetection(blueIdx) = A(blueIdx);
        detection = imresize(imcrop(outputDetection, graindata(labelVal).BoundingBox), [224 224]);
        [YPred, probs] = classify(net, detection);
        
        if YPred == 'C1'
            classCount(4,1)=classCount(4,1)+1;
        elseif YPred == 'C2'
            classCount(4,2)=classCount(4,2)+1;
        elseif YPred == 'C3'
            classCount(4,3)=classCount(4,3)+1;
        elseif YPred == 'C4'
            classCount(4,4)=classCount(4,4)+1;
        elseif YPred == 'C5'
            classCount(4,5)=classCount(4,5)+1; 
        elseif YPred == 'C6'
            classCount(4,6)=classCount(4,6)+1;            
        elseif YPred == 'C7'
            classCount(4,7)=classCount(4,7)+1; 
        elseif YPred == 'C8'
            classCount(4,8)=classCount(4,8)+1;            
        end  
    elseif className(cNum) == name && classLabel == 'C5'
        outputDetection = zeros(size(A), 'like', A);
        labelIdx = strsplit(string(imds.Files(label)), {'_', '.'});
        labelVal = str2double(labelIdx(2));
        redIdx = idx{labelVal};
        greenIdx = idx{labelVal} + numRows * numCols;
        blueIdx = idx{labelVal} + 2 * numRows * numCols;
        outputDetection(redIdx) = A(redIdx);
        outputDetection(greenIdx) = A(greenIdx);
        outputDetection(blueIdx) = A(blueIdx);
        detection = imresize(imcrop(outputDetection, graindata(labelVal).BoundingBox), [224 224]);
        [YPred, probs] = classify(net, detection);
        
        if YPred == 'C1'
            classCount(5,1)=classCount(5,1)+1;
        elseif YPred == 'C2'
            classCount(5,2)=classCount(5,2)+1;
        elseif YPred == 'C3'
            classCount(5,3)=classCount(5,3)+1;
        elseif YPred == 'C4'
            classCount(5,4)=classCount(5,4)+1;
        elseif YPred == 'C5'
            classCount(5,5)=classCount(5,5)+1; 
        elseif YPred == 'C6'
            classCount(5,6)=classCount(5,6)+1;            
        elseif YPred == 'C7'
            classCount(5,7)=classCount(5,7)+1; 
        elseif YPred == 'C8'
            classCount(5,8)=classCount(5,8)+1;            
        end 
    elseif className(cNum) == name && classLabel == 'C6'
        outputDetection = zeros(size(A), 'like', A);
        labelIdx = strsplit(string(imds.Files(label)), {'_', '.'});
        labelVal = str2double(labelIdx(2));
        redIdx = idx{labelVal};
        greenIdx = idx{labelVal} + numRows * numCols;
        blueIdx = idx{labelVal} + 2 * numRows * numCols;
        outputDetection(redIdx) = A(redIdx);
        outputDetection(greenIdx) = A(greenIdx);
        outputDetection(blueIdx) = A(blueIdx);
        detection = imresize(imcrop(outputDetection, graindata(labelVal).BoundingBox), [224 224]);
        [YPred, probs] = classify(net, detection);
        
        if YPred == 'C1'
            classCount(6,1)=classCount(6,1)+1;
        elseif YPred == 'C2'
            classCount(6,2)=classCount(6,2)+1;
        elseif YPred == 'C3'
            classCount(6,3)=classCount(6,3)+1;
        elseif YPred == 'C4'
            classCount(6,4)=classCount(6,4)+1;
        elseif YPred == 'C5'
            classCount(6,5)=classCount(6,5)+1; 
        elseif YPred == 'C6'
            classCount(6,6)=classCount(6,6)+1;            
        elseif YPred == 'C7'
            classCount(6,7)=classCount(6,7)+1; 
        elseif YPred == 'C8'
            classCount(6,8)=classCount(6,8)+1;            
        end 
    elseif className(cNum) == name && classLabel == 'C7'
        outputDetection = zeros(size(A), 'like', A);
        labelIdx = strsplit(string(imds.Files(label)), {'_', '.'});
        labelVal = str2double(labelIdx(2));
        redIdx = idx{labelVal};
        greenIdx = idx{labelVal} + numRows * numCols;
        blueIdx = idx{labelVal} + 2 * numRows * numCols;
        outputDetection(redIdx) = A(redIdx);
        outputDetection(greenIdx) = A(greenIdx);
        outputDetection(blueIdx) = A(blueIdx);
        detection = imresize(imcrop(outputDetection, graindata(labelVal).BoundingBox), [224 224]);
        [YPred, probs] = classify(net, detection);
        
        if YPred == 'C1'
            classCount(7,1)=classCount(7,1)+1;
        elseif YPred == 'C2'
            classCount(7,2)=classCount(7,2)+1;
        elseif YPred == 'C3'
            classCount(7,3)=classCount(7,3)+1;
        elseif YPred == 'C4'
            classCount(7,4)=classCount(7,4)+1;
        elseif YPred == 'C5'
            classCount(7,5)=classCount(7,5)+1; 
        elseif YPred == 'C6'
            classCount(7,6)=classCount(7,6)+1;            
        elseif YPred == 'C7'
            classCount(7,7)=classCount(7,7)+1; 
        elseif YPred == 'C8'
            classCount(7,8)=classCount(7,8)+1;            
        end         
    elseif className(cNum) == name && classLabel == 'C8'
        outputDetection = zeros(size(A), 'like', A);
        labelIdx = strsplit(string(imds.Files(label)), {'_', '.'});
        labelVal = str2double(labelIdx(2));
        redIdx = idx{labelVal};
        greenIdx = idx{labelVal} + numRows * numCols;
        blueIdx = idx{labelVal} + 2 * numRows * numCols;
        outputDetection(redIdx) = A(redIdx);
        outputDetection(greenIdx) = A(greenIdx);
        outputDetection(blueIdx) = A(blueIdx);
        detection = imresize(imcrop(outputDetection, graindata(labelVal).BoundingBox), [224 224]);
        [YPred, probs] = classify(net, detection);
        
        if YPred == 'C1'
            classCount(8,1)=classCount(8,1)+1;
        elseif YPred == 'C2'
            classCount(8,2)=classCount(8,2)+1;
        elseif YPred == 'C3'
            classCount(8,3)=classCount(8,3)+1;
        elseif YPred == 'C4'
            classCount(8,4)=classCount(8,4)+1;
        elseif YPred == 'C5'
            classCount(8,5)=classCount(8,5)+1; 
        elseif YPred == 'C6'
            classCount(8,6)=classCount(8,6)+1;            
        elseif YPred == 'C7'
            classCount(8,7)=classCount(8,7)+1; 
        elseif YPred == 'C8'
            classCount(8,8)=classCount(8,8)+1;            
        end 
        
    end

end