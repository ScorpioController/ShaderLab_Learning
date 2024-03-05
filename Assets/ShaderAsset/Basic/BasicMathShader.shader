// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// 记录一下常用的数学内容
Shader "Custom/BasicMathSahder"
{
	Properties
	{
		
	}
	SubShader
	{
		Pass
		{
			CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            float4 vert (float4 v : POSITION) : SV_POSITION
            {
            	// 转置函数和Unity内置变换矩阵(模型空间->裁剪空间)
                matrix<float, 4, 4> mMatrixT_mvp = transpose(UNITY_MATRIX_MVP);
            	// 乘法函数
            	float4 mvpPos = UnityObjectToClipPos(v);
            	// 模型空间转裁剪空间
            	float4 clipPos = UnityObjectToClipPos(v);
                return clipPos;
            }

            fixed4 frag (float4 i : SV_POSITION) : SV_Target
            {
                return i;
            }
            ENDCG
		}
	}
}