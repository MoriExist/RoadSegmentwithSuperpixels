close all; clear all; clc;
load('./ColorAnalyze/videoplayback 138_C8.mat')
% load ./ColorAnalyze/14893_C1.mat

%製作主色過度
maincolorpoint=[[68 114 196];... 
[237 155 49];...
[165 165 165];...
[255 192 0];...
[91 155 213];...
[112 173 71]];
maincolorposition=[1 11 21 31 41 51];
maincolor(:,1)=interp1(maincolorposition,maincolorpoint(:,1),1:51,'linear','extrap');
maincolor(:,2)=interp1(maincolorposition,maincolorpoint(:,2),1:51,'linear','extrap');
maincolor(:,3)=interp1(maincolorposition,maincolorpoint(:,3),1:51,'linear','extrap');
maincolor=[maincolor(:,1),maincolor(:,2),maincolor(:,3)]/255;
maincolor=round(maincolor*10^4)/10^4;

colorpoint=[[0 0 0];... 
maincolorpoint(1,:);...
[255 255 255]];
colorposition=[1 51 101];
color(:,1)=interp1(colorposition,colorpoint(:,1),1:101,'linear','extrap');
color(:,2)=interp1(colorposition,colorpoint(:,2),1:101,'linear','extrap');
color(:,3)=interp1(colorposition,colorpoint(:,3),1:101,'linear','extrap');
color1=[color(:,1),color(:,2),color(:,3)]/255;
color1=round(color1*10^4)/10^4;
% 24 35 51 71 81 91
% 輔助色過度
colorpoint=[[0 0 0];... 
maincolorpoint(2,:);...
[255 255 255]];
colorposition=[1 51 101];
color(:,1)=interp1(colorposition,colorpoint(:,1),1:101,'linear','extrap');
color(:,2)=interp1(colorposition,colorpoint(:,2),1:101,'linear','extrap');
color(:,3)=interp1(colorposition,colorpoint(:,3),1:101,'linear','extrap');
color2=[color(:,1),color(:,2),color(:,3)]/255;
color2=round(color2*10^4)/10^4;
% 24 35 51 71 81 91


% 繪圖格式
Meanx=linspace(1,size(Mean,2),size(Mean,2));
Varx=linspace(1,size(Variance,2),size(Variance,2));
Covx=linspace(1,size(CoVariance,2),size(CoVariance,2));
lineWidth=1.5;
% % 文字
fontSize=12;fontName='微軟正黑體';fontWeight='bold';

layout=tiledlayout('flow','TileSpacing','tight');
ax1=nexttile;
f1=figure(1);
outputBw=logical(sum(outputBw,3));
nHood=[0 0 1 0 0;
                 0 0 1 0 0;
                 1 1 1 1 1;
                 0 0 1 0 0;
                 0 0 1 0 0;];
outputBw=imdilate(outputBw,nHood);
imshow(imoverlay(outputImage,outputBw,'r'));

ax2=nexttile;
smoothM(:,1)=smooth(Mean(1,:)',10);smoothM(:,2)=smooth(Mean(2,:)',10);smoothM(:,3)=smooth(Mean(3,:)',10);smoothM=smoothM';
plot(Meanx,smoothM(1,:),'LineWidth',lineWidth,'Color',[maincolor(11,:)]); hold on;
plot(Meanx,smoothM(2,:),'LineWidth',lineWidth,'Color',[maincolor(51,:)]);
plot(Meanx,smoothM(3,:),'LineWidth',lineWidth,'Color',[maincolor(1,:)]);hold off
legend('M_R','M_G','M_B','Location','northeastoutside')
f1.Children.Children(1).Color='none';

ax3=nexttile;
smoothVar(:,1)=smooth(Variance(1,:)',10);smoothVar(:,2)=smooth(Variance(2,:)',10);smoothVar(:,3)=smooth(Variance(3,:)',10);smoothVar=smoothVar';
plot(Varx,smoothVar(1,:),'LineWidth',lineWidth,'Color',[maincolor(11,:)]); hold on;
plot(Varx,smoothVar(2,:),'LineWidth',lineWidth,'Color',[maincolor(51,:)]);
plot(Varx,smoothVar(3,:),'LineWidth',lineWidth,'Color',[maincolor(1,:)]);hold off
legend('Var_R','Var_G','Var_B','Location','northeastoutside')
f1.Children.Children(1).Color='none';

ax4=nexttile;
smoothCov(:,1)=smooth(Variance(1,:)',10);smoothCov(:,2)=smooth(Variance(2,:)',10);smoothCov(:,3)=smooth(Variance(3,:)',10);smoothCov=smoothCov';
plot(Covx,smoothCov(1,:),'LineWidth',lineWidth,'Color',[maincolor(11,:)]); hold on;
plot(Covx,smoothCov(2,:),'LineWidth',lineWidth,'Color',[maincolor(51,:)]);
plot(Covx,smoothCov(3,:),'LineWidth',lineWidth,'Color',[maincolor(1,:)]);hold off
legend('Cov_{RG}','Cov_{RB}','Cov_{GB}','Location','northeastoutside')
f1.Children.Children(1).Color='none';




% for i=1:5
%     imsp=imread(SuperpixelPath(i));
%     figure;imshow(imsp)
%     imwrite(imsp,strcat('asp',string(i),'.jpg'))
% end

x1=xlabel([ax1],'(a)','FontWeight','bold');
x2=xlabel([ax2],'(b)','FontWeight','bold');
x3=xlabel([ax3],'(c)','FontWeight','bold');
x4=xlabel([ax4],'(d)','FontWeight','bold');
CreateFigureOneColumn(f1,[ax1 ax2 ax3 ax4],[])
% xlim([ax2 ax3 ax4], [0 24])
% xticks([ax2 ax3 ax4],[0:10:150])
grid([ax2 ax3 ax4],"on")
% figureLeft = 1620; figureBottem = 150; figureWidth = 1400; figureHeight = 450;
% set(f1, 'unit', 'pixel', 'position', [figureLeft, figureBottem, figureWidth, figureHeight])
% saveas(f1,'aa.emf')
% exportgraphics(ax1,'ax1.emf','BackgroundColor','none')
% exportgraphics(ax2,'ax2.emf','BackgroundColor','none')
% exportgraphics(ax3,'ax3.emf','BackgroundColor','none')
% exportgraphics(ax4,'ax4.emf','BackgroundColor','none')

% imwrite(imoverlay(outputImage,outputBw,'r'), 'a.jpg')



