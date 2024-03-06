### 标准光照模型

- 自发光 emissive

  用于描述物体自身的直接光线，通常直接使用材质的自发光颜色

  大部分物体没有自发光属性，如有需要则可以在片元着色器阶段最后输出颜色前加上自发光颜色

- 环境光 ambient

  用于描述在物体之间多次反射的间接光照，通常应用一个相同的全局变量

  在Lighting设置中的Envionment Lighting栏目下可以找到环境光的设置，可以控制环境光的源、颜色和强度信息

  在编写ShaderLab的过程中可以通过内置的变量`UNITY_LIGHTMODEL_AMBIENT`获取

- 高光反射 specular
  
  用于模拟物体表面完全镜面反射的光
  
  使用的是Phong模型，一种经验模型
  
  C<sub>light</sub> 光源颜色
  
  $\vec{r}$​ 反射方向
  
  $\vec{v}$ 视角方向
  
  $\vec{n}$​ 表面法线
  
  $\vec{h}$ 对视角向量和法线向量取平均后归一化得到的向量（避免超过90°夹角后丢失高光）
  
  $\vec{I}$​​​ 指向光源的单位矢量
  
  M<sub>gloss</sub> 材质的光泽度，控制高光反射的亮点大小
  
  高光反射部分的计算为：
  
  C<sub>specular</sub> = (C<sub>light</sub> · M<sub>specular</sub>)max(0, $\vec{r}$ · $\vec{v}$​)<sup>M<sub>gloss</sub></sup> （Phong模型）
  
  C<sub>specular</sub> = (C<sub>light</sub> · M<sub>specular</sub>)max(0, $\vec{n}$ · $\vec{h}$​)<sup>M<sub>gloss</sub></sup> （Blinn模型）
  
  反射方向的计算为：
  
  $\vec{r}$ = reflect(-$\vec{I}$ * $\vec{n}$​)
  
  Blinn模型的半程向量计算为：
  
  $\vec{h}$ = normalize($\vec{I}$ + $\vec{v}$)
  
- 漫反射 diffuse

  用于模拟物体表面被反射到各个方向的光

  符合兰伯特定律：反射光线的强度与表面法线和光源方向之间的夹角余弦成正比

  C<sub>light</sub> 光源颜色

  M<sub>diffuse</sub> 漫反射颜色

  $\vec{n}$ 表面法线

  $\vec{I}$ 指向光源的单位矢量

  漫反射部分的计算为： 

  C<sub>diffuse</sub> = (C<sub>light</sub> · M<sub>diffuse</sub>)max(0, $\vec{n}$ · $\vec{I}$​​​) （Lambert模型）
  
  这里使用max函数避免点乘结果为负值
  
  C<sub>diffuse</sub> = (C<sub>light</sub> · M<sub>diffuse</sub>)(α * ($\vec{n}$ · $\vec{I}$) + β) （Half-Lambert模型）
  
  其中α和β通常取0.5，用于将点积结果映射到[0, 1]范围内，使得结果小于0的背光面也可以呈现一定的光照效果而不是全黑

对于计算光照模型时选择逐顶点光照还是逐像素光照：

由于顶点数目通常远小于像素数目，因此逐顶点光照的计算成本通常更小

但由于像素颜色数据依赖于顶点输出数据的线性插值，因此光照模型中存在非线性计算时显示效果往往会出现问题



Tips: 颜色的加法和乘法和色光混合有关



```
// 一些简便的shaderLab函数

// 输入世界空间顶点位置，返回摄像机方向
UnityWorldSpaceViewDir(float4 pos);

// 输入世界空间的顶点位置，返回光源方向(仅前向渲染)
UnityWorldSpaceLightDir(float4 pos);

// tips 上面两个函数去掉Unity前缀则应该传入模型空间顶点位置
```

