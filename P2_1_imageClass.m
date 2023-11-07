close all; clear all; clc;
% 色彩分析樣本 市區 14089; 郊區 14893; 封閉式 videoplayback 138;

order = 2; % 設定超像素分割的場景（1：市區，2：郊區，3：封閉式）
name = '14050'; % 資料名稱
labelName = 'C1'; % 標籤名稱

scene = {'#1_City'; '#2_Suburbs'; '#3_Limited-Access Road'}; % 場景的類型

imdsPath = strcat('.\ClassData\', char(scene(order)), '\CLASSforPaper_', name); % 影像數據集的路徑
imds = imageDatastore(imdsPath, ...
    'IncludeSubfolders', true, ...
    'LabelSource', 'foldernames'); % 創建影像數據存儲對象

path = ['.\SceneData\', char(scene(order)), '\', name, '.png']; % 影像文件的路徑

A = imread(path); % 讀取影像
A = imresize(A, [1080, 1920]); % 調整影像尺寸
[L, N] = superpixels(A, 512, 'NumIterations', 10, 'Compactness', 1, 'Method', 'SLIC0'); % 超像素分割
graindata = regionprops(L, 'basic'); % 提取超像素區域的基本特徵

BW = boundarymask(L); % 生成超像素邊界掩碼

outputImage = zeros(size(A), 'like', A); % 初始化輸出影像
outputField = zeros(size(A), 'like', A); % 初始化輸出邊界
meanImage = zeros(size(A), 'like', A); % 初始化平均影像
varImage = zeros(size(A), 'like', A); % 初始化方差影像
covImage = zeros(size(A), 'like', A); % 初始化協方差影像

idx = label2idx(L); % 將超像素標籤轉換為索引
numRows = size(A, 1); % 影像行數
numCols = size(A, 2); % 影像列數
classNum = 0; % 類別數量計數器

for label = 1:size(imds.Files, 1) % 迭代處理每個標籤
    className = contains(imds.Files(label), name); % 解析檔案路徑獲取類別名稱
    classLabel = string(imds.Labels(label)); % 獲取標籤名稱

    [FolderPath, labelIdx] = fileparts(imds.Files(label)); % 解析檔案路徑獲取超像素區域索引
    labelVal = str2double(extractAfter(labelIdx, "_")); % 轉換超像素區域索引為數字

    if className && classLabel == labelName % 如果類別名稱和標籤名稱匹配
        classNum = classNum + 1; % 類別數量增加

        redIdx = idx{labelVal}; % 超像素區域紅色通道的索引
        greenIdx = idx{labelVal} + numRows * numCols; % 超像素區域綠色通道的索引
        blueIdx = idx{labelVal} + 2 * numRows * numCols; % 超像素區域藍色通道的索引

        AR = A(redIdx); % 超像素區域紅色通道的值
        AG = A(greenIdx); % 超像素區域綠色通道的值
        AB = A(blueIdx); % 超像素區域藍色通道的值

        outputImage(redIdx) = double(A(redIdx)); % 將超像素區域的紅色通道值複製到輸出影像
        outputImage(greenIdx) = double(A(greenIdx)); % 將超像素區域的綠色通道值複製到輸出影像
        outputImage(blueIdx) = double(A(blueIdx)); % 將超像素區域的藍色通道值複製到輸出影像

        outputField(redIdx) = 255; % 將超像素區域的紅色通道標記為255
        outputField(greenIdx) = 255; % 將超像素區域的綠色通道標記為255
        outputField(blueIdx) = 255; % 將超像素區域的藍色通道標記為255

        outputBw(:, :, labelVal) = boundarymask(im2bw(outputField)); % 將超像素區域的邊界轉換為二值掩碼
        
        meanImage(redIdx) = mean(double(A(redIdx))); % 計算超像素區域紅色通道的平均值
        meanImage(greenIdx) = mean(double(A(greenIdx))); % 計算超像素區域綠色通道的平均值
        meanImage(blueIdx) = mean(double(A(blueIdx))); % 計算超像素區域藍色通道的平均值

        varImage(redIdx) = var(double(A(redIdx))); % 計算超像素區域紅色通道的方差
        varImage(greenIdx) = var(double(A(greenIdx))); % 計算超像素區域綠色通道的方差
        varImage(blueIdx) = var(double(A(blueIdx))); % 計算超像素區域藍色通道的方差

        covImage(redIdx) = cov(double(A(redIdx))); % 計算超像素區域紅色通道的協方差
        covImage(greenIdx) = cov(double(A(greenIdx))); % 計算超像素區域綠色通道的協方差
        covImage(blueIdx) = cov(double(A(blueIdx))); % 計算超像素區域藍色通道的協方差

        AColor = double(cat(2, AR, AG, AB)); % 將超像素區域的顏色通道合併
        [covColor, mColor] = covmatrix(AColor); % 計算超像素區域的顏色通道的協方差矩陣和平均值

        Mean(:, classNum) = mColor; % 保存超像素區域的顏色通道的平均值
        Variance(1, classNum) = covColor(1, 1); % 保存超像素區域的顏色通道的方差
        Variance(2, classNum) = covColor(2, 2); % 保存超像素區域的顏色通道的方差
        Variance(3, classNum) = covColor(3, 3); % 保存超像素區域的顏色通道的方差
        CoVariance(1, classNum) = covColor(1, 2); % 保存超像素區域的顏色通道的協方差
        CoVariance(2, classNum) = covColor(1, 3); % 保存超像素區域的顏色通道的協方差
        CoVariance(3, classNum) = covColor(2, 3); % 保存超像素區域的顏色通道的協方差

        SuperpixelPath(:, classNum) = string(imds.Files(label)); % 保存超像素區域的檔案路徑
    end

end

outputSave = strcat('./ColorAnalyze/', name, '_', labelName, '.mat'); % 輸出檔案的保存路徑
save(outputSave, 'name', 'labelName', 'A', 'outputImage', 'meanImage', 'varImage', 'covImage', 'Mean', 'Variance', 'CoVariance', 'outputBw', "SuperpixelPath"); % 將結果保存到檔案中

% outputBw=logical(sum(outputBw,3));
% figure;imshow(imoverlay(A,outputBw,'r'))
% figure;imshow(imoverlay(outputImage,outputBw,'r'));

% %製作主色過度
% maincolorpoint=[[68 114 196];...
% [237 155 49];...
% [165 165 165];...
% [255 192 0];...
% [91 155 213];...
% [112 173 71]];
% maincolorposition=[1 11 21 31 41 51];
% maincolor(:,1)=interp1(maincolorposition,maincolorpoint(:,1),1:51,'linear','extrap');
% maincolor(:,2)=interp1(maincolorposition,maincolorpoint(:,2),1:51,'linear','extrap');
% maincolor(:,3)=interp1(maincolorposition,maincolorpoint(:,3),1:51,'linear','extrap');
% maincolor=[maincolor(:,1),maincolor(:,2),maincolor(:,3)]/255;
% maincolor=round(maincolor*10^4)/10^4;
%
% colorpoint=[[0 0 0];...
% maincolorpoint(1,:);...
% [255 255 255]];
% colorposition=[1 51 101];
% color(:,1)=interp1(colorposition,colorpoint(:,1),1:101,'linear','extrap');
% color(:,2)=interp1(colorposition,colorpoint(:,2),1:101,'linear','extrap');
% color(:,3)=interp1(colorposition,colorpoint(:,3),1:101,'linear','extrap');
% color1=[color(:,1),color(:,2),color(:,3)]/255;
% color1=round(color1*10^4)/10^4;
% % 24 35 51 71 81 91
% % 輔助色過度
% colorpoint=[[0 0 0];...
% maincolorpoint(2,:);...
% [255 255 255]];
% colorposition=[1 51 101];
% color(:,1)=interp1(colorposition,colorpoint(:,1),1:101,'linear','extrap');
% color(:,2)=interp1(colorposition,colorpoint(:,2),1:101,'linear','extrap');
% color(:,3)=interp1(colorposition,colorpoint(:,3),1:101,'linear','extrap');
% color2=[color(:,1),color(:,2),color(:,3)]/255;
% color2=round(color2*10^4)/10^4;
% % 24 35 51 71 81 91
%
%
% % 繪圖格式
% mainx=linspace(1,size(Mean,2),size(Mean,2));
% interp1x=1:0.05:size(Mean,2);
% pointSize=9;lineWidth=1;
% % % 文字
% fontSize=12;fontName='微軟正黑體';fontWeight='bold';
%
% % 道路場景超級像素
% f1=figure(1);layout=tiledlayout('flow','TileSpacing','tight');
% outputBw=logical(sum(outputBw,3));
% ax1=nexttile;imshow(imoverlay(outputImage,outputBw,'r'));
% ax2=nexttile;imshow(imoverlay(meanImage,outputBw,'r'))
% ax3=nexttile;imshow(imoverlay(varImage,outputBw,'r'))
% ax4=nexttile;imshow(imoverlay(covImage,outputBw,'r'))
% t1=title(ax1,'原始影像');t2=title(ax2,'均值');t3=title(ax3,'變異值');t4= title(ax4,'共變異');
% set([t1 t2 t3 t4],'fontname', fontName, 'fontsize', fontSize,'fontweight',fontWeight)

% % MeanValue
% f2=figure(2);layout=tiledlayout('flow');
% % % xy散點
% meanGray=[Mean(1,:)+Mean(2,:)+Mean(3,:)]./3;
% ax1=nexttile;scR=scatter(mainx,Mean(1,mainx),'MarkerEdgeColor',[maincolor(11,:)],'MarkerFaceColor',[maincolor(11,:)]);
% ax2=nexttile;scG=scatter(mainx,Mean(2,mainx),'MarkerEdgeColor',[maincolor(51,:)],'MarkerFaceColor',[maincolor(51,:)]);
% ax3=nexttile;scB=scatter(mainx,Mean(3,mainx),'MarkerEdgeColor',[maincolor(1,:)],'MarkerFaceColor',[maincolor(1,:)]);
% ax4=nexttile([1 3]);plot(interp1x,interp1(meanGray,interp1x,'spline'),'LineWidth',lineWidth,'Color',[maincolor(21,:)]);
% set([scR scG scB],'SizeData',pointSize)
% t1=title(ax1,'R數值');t2=title(ax2,'G數值');t3=title(ax3,'B數值');t4=title(ax4,'RGB之合除3');t5=title(layout,'類別 : '+string(labelName)+'之RGB數值','fontweight',fontWeight);
% x1=xlabel([ax1 ax2 ax3 ax4],'超級像素塊','FontWeight','bold');y1= ylabel([ax1 ax2 ax3 ax4],'RGB值','FontWeight','bold');
% set([t1 t2 t3 t4 t5 x1 y1], 'fontname', fontName, 'fontsize', fontSize)
% grid([ax1 ax2 ax3 ax4],'on')
% % layout=tiledlayout('flow')
% % % % 直接連接
% % p=plot(x,meanValue(1,x),'-','LineWidth',3,'Color',[color(21,:)]);hold on
% % p=plot(x,meanValue(2,x),'-','LineWidth',3,'Color',[color(101,:)]);
% % p=plot(x,meanValue(3,x),'-','LineWidth',3,'Color',[color(1,:)]);hold off
%
%
% f3=figure(3);layout=tiledlayout(3,2);
% % % 內差優化
% ax1=nexttile(1,[1 2]);plot(interp1x,interp1(Mean(1,:),interp1x,'spline'),'LineWidth',lineWidth,'Color',[maincolor(11,:)]);
% ax2=nexttile(3,[1 2]);plot(interp1x,interp1(Mean(2,:),interp1x,'spline'),'LineWidth',lineWidth,'Color',[maincolor(51,:)]);
% ax3=nexttile(5,[1 2]);plot(interp1x,interp1(Mean(3,:),interp1x,'spline'),'LineWidth',lineWidth,'Color',[maincolor(1,:)]);
% t1=title(ax1,'R數值');t2=title(ax2,'G數值');t3=title(ax3,'B數值');
% t4=title(layout,'類別 : '+string(labelName),'fontweight',fontWeight);
% x1=xlabel([ax3],'超級像素塊','FontWeight','bold'); y1=ylabel([ax1 ax2 ax3],'RGB值','FontWeight',fontWeight);
% % legend('R','G','B','Location','Best')
% set([t1 t2 t3 t4 x1 y1],'fontname', fontName, 'fontsize', fontSize)
% grid([ax1 ax2 ax3], 'on')
%
% f4=figure(4);layout=tiledlayout('flow');
% % 使用SMOOTH優化
% smoothM(:,1)=smooth(Mean(1,:)',10);smoothM(:,2)=smooth(Mean(2,:)',10);smoothM(:,3)=smooth(Mean(3,:)',10);smoothM(:,4)=smooth(meanGray',10);
% smoothM=smoothM';
% ax1=nexttile;
% plot(mainx,smoothM(1,:),'LineWidth',lineWidth,'Color',[maincolor(11,:)]); hold on;
% plot(mainx,smoothM(2,:),'LineWidth',lineWidth,'Color',[maincolor(51,:)]);
% plot(mainx,smoothM(3,:),'LineWidth',lineWidth,'Color',[maincolor(1,:)]);hold off
% ax2=nexttile;plot(mainx,smoothM(4,:),'LineWidth',lineWidth,'Color',[maincolor(21,:)]);
% t1=title(ax1,'Smooth RGB');t2=title(ax2,'Smooth 灰度');t3=title(layout,'Smooth 處理');
% x1=xlabel([ax2],'超級像素塊','FontWeight','bold'); y1=ylabel([ax1 ax2],'RGB值','FontWeight',fontWeight);
% % legend('R','G','B','Location','Best')
% set([t1 t2 t3 x1 y1],'fontname', fontName, 'fontsize', fontSize)
% grid([ax1 ax2], 'on')
%
%
% % varValue繪圖格式
% mainx=linspace(1,size(Variance,2),size(Variance,2));
% interp1x=1:0.05:size(Variance,2);
% f5=figure(5);layout=tiledlayout('flow');
% % % xy散點
% varianceGray=[Variance(1,:)+Variance(2,:)+Variance(3,:)]./3;
% ax1=nexttile;scR=scatter(mainx,Variance(1,mainx),'MarkerEdgeColor',[maincolor(11,:)],'MarkerFaceColor',[maincolor(11,:)]);
% ax2=nexttile;scG=scatter(mainx,Variance(2,mainx),'MarkerEdgeColor',[maincolor(51,:)],'MarkerFaceColor',[maincolor(51,:)]);
% ax3=nexttile;scB=scatter(mainx,Variance(3,mainx),'MarkerEdgeColor',[maincolor(1,:)],'MarkerFaceColor',[maincolor(1,:)]);
% ax4=nexttile([1 3]);plot(interp1x,interp1(varianceGray,interp1x,'spline'),'LineWidth',lineWidth,'Color',[maincolor(21,:)]);
% set([scR scG scB],'SizeData',pointSize)
% t1=title(ax1,'cov(R,R)數值');t2=title(ax2,'cov(G,G)數值');t3=title(ax3,'cov(B,B)數值');t4=title(ax4,'RGB之合除3');t5=title(layout,'類別 : '+string(labelName)+'之RGB數值','fontweight',fontWeight);
% x1=xlabel([ax1 ax2 ax3 ax4],'超級像素塊','FontWeight',fontWeight); y1=ylabel([ax1 ax2 ax3 ax4],'RGB值','FontWeight',fontWeight);
% set([t1 t2 t3 t4 t5 x1 y1], 'fontname', fontName, 'fontsize', fontSize)
% grid([ax1 ax2 ax3 ax4],'on')
%
%
% f6=figure(6);layout=tiledlayout(3,2);
% % % 內差優化
% ax1=nexttile(1,[1 2]);plot(interp1x,interp1(Variance(1,:),interp1x,'spline'),'LineWidth',lineWidth,'Color',[maincolor(11,:)]);
% ax2=nexttile(3,[1 2]);plot(interp1x,interp1(Variance(2,:),interp1x,'spline'),'LineWidth',lineWidth,'Color',[maincolor(51,:)]);
% ax3=nexttile(5,[1 2]);plot(interp1x,interp1(Variance(3,:),interp1x,'spline'),'LineWidth',lineWidth,'Color',[maincolor(1,:)]);
% t1=title(ax1,'cov(R,R)數值');t2=title(ax2,'cov(G,G)數值');t3=title(ax3,'cov(B,B)數值');
% t4=title(layout,'類別 : '+string(labelName),'fontweight',fontWeight);
% x1=xlabel([ax3],'超級像素塊','FontWeight','bold'); y1=ylabel([ax1 ax2 ax3],'RGB值','FontWeight',fontWeight);
% % legend('R','G','B','Location','Best')
% set([t1 t2 t3 t4 x1 y1],'fontname', fontName, 'fontsize', fontSize)
% grid([ax1 ax2 ax3], 'on')
%
% f7=figure(7);layout=tiledlayout('flow');
% % 使用SMOOTH優化
% smoothVar(:,1)=smooth(Variance(1,:)',10);smoothVar(:,2)=smooth(Variance(2,:)',10);smoothVar(:,3)=smooth(Variance(3,:)',10);smoothVar(:,4)=smooth(varianceGray',10);
% smoothVar=smoothVar';
% ax1=nexttile;
% plot(mainx,smoothVar(1,:),'LineWidth',lineWidth,'Color',[maincolor(11,:)]); hold on;
% plot(mainx,smoothVar(2,:),'LineWidth',lineWidth,'Color',[maincolor(51,:)]);
% plot(mainx,smoothVar(3,:),'LineWidth',lineWidth,'Color',[maincolor(1,:)]);hold off
% ax2=nexttile;plot(mainx,smoothVar(4,:),'LineWidth',lineWidth,'Color',[maincolor(21,:)]);
% t1=title(ax1,'Smooth RGB');t2=title(ax2,'Smooth 灰度');t3=title(layout,'Smooth 處理');
% x1=xlabel([ax2],'超級像素塊','FontWeight','bold'); y1=ylabel([ax1 ax2],'RGB值','FontWeight',fontWeight);
% % legend('R','G','B','Location','Best')
% set([t1 t2 t3 x1 y1],'fontname', fontName, 'fontsize', fontSize)
% grid([ax1 ax2], 'on')
%
%
% % covValue繪圖格式
% mainx=linspace(1,size(CoVariance,2),size(CoVariance,2));
% interp1x=1:0.05:size(CoVariance,2);
% f8=figure(8);layout=tiledlayout('flow');
% % % xy散點
% covarianceGray=[CoVariance(1,:)+CoVariance(2,:)+CoVariance(3,:)]./3;
% ax1=nexttile;scR=scatter(mainx,CoVariance(1,mainx),'MarkerEdgeColor',[maincolor(11,:)],'MarkerFaceColor',[maincolor(11,:)]);
% ax2=nexttile;scG=scatter(mainx,CoVariance(2,mainx),'MarkerEdgeColor',[maincolor(51,:)],'MarkerFaceColor',[maincolor(51,:)]);
% ax3=nexttile;scB=scatter(mainx,CoVariance(3,mainx),'MarkerEdgeColor',[maincolor(1,:)],'MarkerFaceColor',[maincolor(1,:)]);
% ax4=nexttile([1 3]);plot(interp1x,interp1(covarianceGray,interp1x,'spline'),'LineWidth',lineWidth,'Color',[maincolor(21,:)]);
% set([scR scG scB],'SizeData',pointSize)
% t1=title(ax1,'cov(R,G)數值');t2=title(ax2,'cov(R,B)數值');t3=title(ax3,'cov(G,B)數值');t4=title(ax4,'RGB之合除3');t5=title(layout,'類別 : '+string(labelName)+'之RGB數值','fontweight',fontWeight);
% x1=xlabel([ax1 ax2 ax3 ax4],'超級像素塊','FontWeight',fontWeight);y1= ylabel([ax1 ax2 ax3 ax4],'RGB值','FontWeight',fontWeight);
% set([t1 t2 t3 t4 t5 x1 y1], 'fontname', fontName, 'fontsize', fontSize)
% grid([ax1 ax2 ax3 ax4],'on')
%
%
% f9=figure(9);layout=tiledlayout(3,2);
% % % 內差優化
% ax1=nexttile(1,[1 2]);plot(interp1x,interp1(CoVariance(1,:),interp1x,'spline'),'LineWidth',lineWidth,'Color',[maincolor(11,:)]);
% ax2=nexttile(3,[1 2]);plot(interp1x,interp1(CoVariance(2,:),interp1x,'spline'),'LineWidth',lineWidth,'Color',[maincolor(51,:)]);
% ax3=nexttile(5,[1 2]);plot(interp1x,interp1(CoVariance(3,:),interp1x,'spline'),'LineWidth',lineWidth,'Color',[maincolor(1,:)]);
% t1=title(ax1,'cov(R,G)數值');t2=title(ax2,'cov(R,B)數值');t3=title(ax3,'cov(G,B)數值');
% t4=title(layout,'類別 : '+string(labelName),'fontweight',fontWeight);
% x1=xlabel([ax3],'超級像素塊','FontWeight','bold');y1=ylabel([ax1 ax2 ax3],'RGB值','FontWeight',fontWeight);
% % legend('R','G','B','Location','Best')
% set([t1 t2 t3 t4 x1 y1],'fontname', fontName, 'fontsize', fontSize)
% grid([ax1 ax2 ax3], 'on')
%
% f10=figure(10);layout=tiledlayout('flow');
% % 使用SMOOTH優化
% smoothCov(:,1)=smooth(Variance(1,:)',10);smoothCov(:,2)=smooth(Variance(2,:)',10);smoothCov(:,3)=smooth(Variance(3,:)',10);smoothCov(:,4)=smooth(covarianceGray',10);
% smoothCov=smoothCov';
% ax1=nexttile;
% plot(mainx,smoothCov(1,:),'LineWidth',lineWidth,'Color',[maincolor(11,:)]); hold on;
% plot(mainx,smoothCov(2,:),'LineWidth',lineWidth,'Color',[maincolor(51,:)]);
% plot(mainx,smoothCov(3,:),'LineWidth',lineWidth,'Color',[maincolor(1,:)]);hold off
% ax2=nexttile;plot(mainx,smoothCov(4,:),'LineWidth',lineWidth,'Color',[maincolor(21,:)]);
% t1=title(ax1,'Smooth RGB');t2=title(ax2,'Smooth 灰度');t3=title(layout,'Smooth 處理');
% x1=xlabel([ax2],'超級像素塊','FontWeight','bold'); y1=ylabel([ax1 ax2],'RGB值','FontWeight',fontWeight);
% % legend('R','G','B','Location','Best')
% set([t1 t2 t3 x1 y1],'fontname', fontName, 'fontsize', fontSize,'FontWeight','bold')
% grid([ax1 ax2], 'on')
%
% % % 繪圖區域
% figureLeft=10;figureBottem=30; figureWidth=720; figureHeight=540;
% set([f1 f2 f3 f4 f5 f6 f7 f8 f9 f10],'position',[figureLeft,figureBottem,figureWidth,figureHeight])

% % saveAs
% imwrite(getframe(f1).cdata,strcat('D:\NCUE\王衡鈞\碩士論文\道路場景影像資料庫\實驗數據\',name,labelName,'_影像分析.png'))
% imwrite(imoverlay(outputImage,outputBw,'r'),strcat('D:\NCUE\王衡鈞\碩士論文\道路場景影像資料庫\實驗數據\',name,labelName,'_原始影像分析.png'))
% imwrite(imoverlay(meanImage,outputBw,'r'),strcat('D:\NCUE\王衡鈞\碩士論文\道路場景影像資料庫\實驗數據\',name,labelName,'_均值影像分析.png'))
% imwrite(imoverlay(varImage,outputBw,'r'),strcat('D:\NCUE\王衡鈞\碩士論文\道路場景影像資料庫\實驗數據\',name,labelName,'_變異影像分析.png'))
% imwrite(imoverlay(covImage,outputBw,'r'),strcat('D:\NCUE\王衡鈞\碩士論文\道路場景影像資料庫\實驗數據\',name,labelName,'_共變異影像分析.png'))
% imwrite(getframe(f2).cdata,strcat('D:\NCUE\王衡鈞\碩士論文\道路場景影像資料庫\實驗數據\',name,labelName,'_MeanRGB.png'))
% imwrite(getframe(f3).cdata,strcat('D:\NCUE\王衡鈞\碩士論文\道路場景影像資料庫\實驗數據\',name,labelName,'_MeanRGB內差.png'))
% imwrite(getframe(f4).cdata,strcat('D:\NCUE\王衡鈞\碩士論文\道路場景影像資料庫\實驗數據\',name,labelName,'_MeanRGBSmooth.png'))
% imwrite(getframe(f5).cdata,strcat('D:\NCUE\王衡鈞\碩士論文\道路場景影像資料庫\實驗數據\',name,labelName,'_varRGB.png'))
% imwrite(getframe(f6).cdata,strcat('D:\NCUE\王衡鈞\碩士論文\道路場景影像資料庫\實驗數據\',name,labelName,'_varRGB內差.png'))
% imwrite(getframe(f7).cdata,strcat('D:\NCUE\王衡鈞\碩士論文\道路場景影像資料庫\實驗數據\',name,labelName,'_varRGBSmooth.png'))
% imwrite(getframe(f8).cdata,strcat('D:\NCUE\王衡鈞\碩士論文\道路場景影像資料庫\實驗數據\',name,labelName,'_covRGB.png'))
% imwrite(getframe(f9).cdata,strcat('D:\NCUE\王衡鈞\碩士論文\道路場景影像資料庫\實驗數據\',name,labelName,'_covRGB內差.png'))
% imwrite(getframe(f10).cdata,strcat('D:\NCUE\王衡鈞\碩士論文\道路場景影像資料庫\實驗數據\',name,labelName,'_covRGBSmooth.png'))
