Shader "Unlit/BasicUnitShader"
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
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            float4 vert (float4 v : POSITION) : SV_POSITION
            {
                return UnityObjectToClipPos(v);
            }

            fixed4 frag (float4 i : SV_POSITION) : SV_Target
            {
                return i;
            }
            ENDCG
        }
    }
    
    Fallback "VertexLit"
}
