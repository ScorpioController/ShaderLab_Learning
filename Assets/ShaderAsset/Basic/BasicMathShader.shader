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