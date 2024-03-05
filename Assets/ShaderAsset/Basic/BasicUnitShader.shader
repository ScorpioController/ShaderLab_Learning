
/*
    Unity Shader是Unity在底层着色器之上的一层"封装"
    当然由于高度的封装性，会失去底层真实着色器编写中可行的一些类型和语法
*/
Shader "Custom/BasicUnitShader"
{
    // 定义一系列会出现在材质面板中的属性，定义在此处的作用是关联到材质
    Properties
    {
        // 原生支持的类型
        // 格式为：变量名称 ("材质面板显示的名称", 变量类型) = 默认值
        _Int("Int", Int) = 2
        _Float("Float", Float) = 1.5
        _Range("Range", Range(0.0, 5.0)) = 3.0
        _Color("Color", Color) = (1, 1, 1, 1)
        _Vector("Vector", Vector) = (2, 3, 6, 1)
        _2D("2D", 2D) = ""{}
        _3D("3D", 3D) = "white"{}
        _Cube("Cube", Cube) = "black"{}
        // tips Unity允许重载默认材质面板以支持更多类型
    }
    // 扫描第一个可以在目标平台运行的SubShader块，否则执行Fallback
    SubShader
    {
        // 标签和状态在这里设置会应用于所有的Pass(tips 在Pass中单独设置的会和全局设置存在区别)
        // 渲染标签 Tags 
        // 渲染状态 RenderSetup
        
        // 每个Pass定义了一次完整的渲染流程
        Pass
        {
            // 可以定义Pass的名称，定义名称的Pass可以在SubShader块中使用UsePass指令复用 (tips Pass名称会转换为大写形式)
            Name "BasicPass"
            // 渲染标签 Tags
            // 渲染状态 RenderSetup
            
            // tips 吐槽一下CG片段里面高亮注释是无效的
            // 虽然也可以使用GLSL，但是Unity 会在需要时将 HLSL 交叉编译为优化的 GLSL
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            // 引用内置头文件
            #include "UnityCG.cginc"

            // Properties 中的属性需要在CGPROGRAM中再次声明Unity才会将值传递过来（tips 变量类型是不同的，会存在一个映射关系）
            fixed4 _Color;

            // tips 若使用的是单个的数值，编译器会重复该值来生成对应的数据类型

            // 可以定义结构体作为着色器的输入和输出数据格式
            // tips UnityCG.cginc头文件中包含了Unity预定义的一些顶点着色器输入结构体可以便捷的使用
            // 其中[float4 vertex : POSITION;]这种格式进行的是语义绑定，让系统根据绑定填充命令标识的值
            // 在不同阶段语义有不同的含义，如作为顶点着色器的输入，TEXCOORD0意味着第一套纹理坐标，由模型的MeshRenderer组件提供
            struct appdata
            {
                float4 vertex : POSITION; // 填充顶点坐标
                float4 tangent : TANGENT; // 填充切线切线
                float3 normal : NORMAL; // 填充法线
                // TEXCOORD0~N 
                float4 texcoord : TEXCOORD0; //UV1
                float4 texcoord1 : TEXCOORD1; //UV2
                float4 texcoord2 : TEXCOORD2; //UV3
                float4 texcoord3 : TEXCOORD3; //UV4
                // COLOR0~N
                fixed4 color0 : COLOR0; // 第一组顶点色
                fixed4 color1 : COLOR1; // 第二组顶点色
            };
            
            float4 vert (float4 v : POSITION) : SV_POSITION // SV前缀代表系统值，POSITION代表最终顶点位置
            {
                return UnityObjectToClipPos(v);
            }

            // 此时传入的值已经是插值后的结果
            fixed4 frag (float4 i : SV_POSITION) : SV_Target // 默认的着色器目标，代表帧缓冲区
            {
                return i;
            }
            ENDCG
        }
    }
    
    // 若上述所有的SubShader在目标显卡上无法执行，则使用此处指定的"后路"
    Fallback "VertexLit"
}
