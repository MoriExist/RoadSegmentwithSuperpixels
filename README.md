# Folder
- SceneData    : 場景影像
- n            : 切割區塊暫存區
- ClassData    : 每一張影像的超級像素區塊分類結果
- ColorAnalyze : 色彩分析參數
- Functions    : 引用方法
- Class        : 訓練用總資料集
## 資料結構

```mermaid
%%{
  init: {
    'theme': 'base',
    'themeVariables': {
      'darkMode': 'true', 
      'background':'#202020',
      'primaryColor': '#233B48',
      'primaryTextColor': '#fff',
      'primaryBorderColor': '#ADC6CD',
      'lineColor': '#ADC6CD',
      'secondaryColor': '#ADC6CD',
      'tertiaryColor': '#1C1C1C'
    }
  }
}%%
graph LR
%% Colors %%
classDef pink fill:#f4acb7, stroke:#000, srroke-width:2px, color:#fff
classDef red fill:#e63946, stroke:#000, srroke-width:2px, color:#fff
classDef orange fill:#fe7f2d, stroke:#000, srroke-width:2px, color:#000
classDef green fill:#2a9d8f, stroke:#000, srroke-width:2px, color:#fff
classDef blue fill:#1d3557, stroke:#000, srroke-width:2px, color:#fff
classDef C1 fill:#211B1F, stroke:#A5A5A5, srroke-width:2px, color:#fff
classDef C2 fill:#FAFAFA, stroke:#000, srroke-width:2px, color:#000
classDef C3 fill:#FBBE07, stroke:#000, srroke-width:2px, color:#000
classDef C4 fill:#E93F6E, stroke:#000, srroke-width:2px, color:#fff
classDef C5 fill:#CB712E, stroke:#000, srroke-width:2px, color:#fff
classDef C6 fill:#A5A5A5, stroke:#000, srroke-width:2px, color:#000
classDef C7 fill:#32946E, stroke:#000, srroke-width:2px, color:#fff
classDef C8 fill:#2274A4, stroke:#000, srroke-width:2px, color:#fff
    Folder("D:.")--> CLASS[(CLASS)]
    Folder --> ClassData[(ClassData)]
    Folder --> ColorAnalyze(ColorAnalyze)
    Folder --> Functions(Functions)
    Folder --> n(n)
    Folder --> SceneData[(SceneData)]
	subgraph Road Scene Superpixels
    ClassData --- ClassData1[[#1_City]]
    ClassData --- ClassData2[[#2_Suburbs]]
    ClassData --- ClassData3[[#3_Limited-Access Road]]
    end
	subgraph Orignal Road Scene Image
		SceneData --- SceneData1[[#1_City]]
    SceneData --- SceneData2[[#2_Suburbs]]
    SceneData --- SceneData3[[#3_Limited-Access Road]]
	end
	subgraph Classify All of Superpixels 
		CLASS --- CLASS1[[C1]]:::C1
		CLASS --- CLASS2[[C2]]:::C2
		CLASS --- CLASS3[[C3]]:::C3
		CLASS --- CLASS4[[C4]]:::C4
		CLASS --- CLASS5[[C5]]:::C5
		CLASS --- CLASS6[[C6]]:::C6
		CLASS --- CLASS7[[C7]]:::C7
	  CLASS --- CLASS8[[C8]]:::C8
	end
```


---

# Code
- P0_SuperPixelTest               : 建立單張超級像素分割影像
- P1_1_SuperPixel                 : 分割超級像素+創建資料夾
- P1_2_imageClassSeg              : 超級像素人工標記結果展示+人工標記結果區域檢測
- P2_1_imageClass                 : 影像色彩計算
- P2_2_PlotColor                  : 繪製P2_1_imageClass計算結果
- Train_Network                   : 訓練超級像素 (Train Deep Learning Network to Classify New Images)
- P3_0_countYPred                 : 計算測試集的混淆矩陣
- P3_1_Use                        : 預測超級像素類別
- P3_2_ClassCount                 : 計算超級像素分類預測數量
- P3_3_ClassCountwithConfusionmat : 使用混淆矩陣

---

# 研究系統架構
## Flow Chart
```mermaid
%%{
  init: {
    'theme': 'base',
    'themeVariables': {
      'darkMode': 'true', 
      'background':'#202020',
      'primaryColor': '#233B48',
      'primaryTextColor': '#fff',
      'primaryBorderColor': '#ADC6CD',
      'lineColor': '#ADC6CD',
      'secondaryColor': '#000',
			'secondaryTextColor': '#000',
      'tertiaryColor': '#1C1C1C'
    }
  }
}%%
graph LR
subgraph 影像處理
Input(原始影像) --> SLIC(超級像素處理)
SLIC --> SP(超級像素)
end

subgraph 訓練與辨識
SP .-> |標記| Net(神經網路)
SP --> |提取超級像素| Net
end


subgraph 超級像素類別
Net --> Output(輸出)
end
```
# GoogleNet
## Inception Module
```mermaid
%%{
  init: {
    'theme': 'base',
    'themeVariables': {
      'darkMode': 'true', 
      'background':'#202020',
      'primaryColor': '#233B48',
      'primaryTextColor': '#fff',
      'primaryBorderColor': '#ADC6CD',
      'lineColor': '#ADC6CD',
      'secondaryColor': '#ADC6CD',
      'tertiaryColor': '#1C1C1C'
    }
  }
}%%
graph BT
%% Colors %%
classDef PL fill:#2274A4, stroke:#000, srroke-width:2px, color:#fff
classDef Conv_1  fill:#A5A5A5, stroke:#000, srroke-width:2px, color:#000
classDef Conv_3 fill:#FBBE07, stroke:#000, srroke-width:2px, color:#000
classDef Conv_5 fill:#CB712E, stroke:#000, srroke-width:2px, color:#fff
classDef MaxP_3 fill:#E93F6E, stroke:#000, srroke-width:2px, color:#fff
classDef FC fill:#32946E, stroke:#000, srroke-width:2px, color:#fff

PL(PreviousLayer)
Conv#A_1(1 x 1 Convolutions)
Conv#C_1(1 x 1 Convolutions)
Conv#D_1(1 x 1 Convolutions)
Conv#B_1(1 x 1 Convolutions)
Conv#3(3 x 3 Convolutions):::Conv_3
Conv#5(5 x 5 Convolutions):::Conv_5
MaxP#3(3 x 3 Max Pooling):::MaxP_3
FC(Filter Concatenation)

PL --> Conv#A_1 --> FC
PL --> Conv#B_1 --> Conv#3 --> FC
PL --> Conv#C_1 --> Conv#5 --> FC
PL --> MaxP#3 --> Conv#D_1 --> FC
```

#SLIC
```mermaid
%%{
  init: {
    'theme': 'base',
    'themeVariables': {
      'darkMode': 'true', 
      'background':'#202020',
      'primaryColor': '#233B48',
      'primaryTextColor': '#fff',
      'primaryBorderColor': '#ADC6CD',
      'lineColor': '#ADC6CD',
      'secondaryColor': '#000',
      'tertiaryColor': '#1C1C1C'
    }
  }
}%%
graph LR
InputImage(輸入影像)
InitialSegmentation(初始分割)
InitializeClustersandLabels(初始化集群和標記)
ComputeDistanceMetrics(計算距離度量)
PerformPixelClustering(執行像素聚類)
UpdateClusterCenters(更新聚類中心)
CheckResidualError(檢查殘差)
Post-Processing(後期處理)

InputImage 
--> InitialSegmentation
--> InitializeClustersandLabels
--> ComputeDistanceMetrics
--> PerformPixelClustering
--> UpdateClusterCenters
--> CheckResidualError
--> |E > T| ComputeDistanceMetrics
CheckResidualError --> |E < T| Post-Processing


```

