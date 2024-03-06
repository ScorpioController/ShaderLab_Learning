Shader "Custom/Illumination/BasicPixelDiffuse"
{
	Properties
	{
		_Diffuse ("Diffuse", COLOR) = (1, 1, 1, 1)
	}
	SubShader
	{
		Pass
		{
			// 指定光照模式
			Tags {"LightMode" = "ForwardBase"}
			
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			// 包含光源信息的头文件
			#include "Lighting.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				// 作为顶点着色器的输出使用的TEXCOORD0可以用于填充一些自定义数据
				float3 worldNormal : TEXCOORD0;
			};

			fixed4 _Diffuse;
			
			v2f vert (appdata v)
			{
				v2f fragInput;
				
				// 转换顶点
				fragInput.vertex = UnityObjectToClipPos(v.vertex);

				// 转换法线
				float3 worldNormal = UnityWorldToObjectDir(v.normal);
				float3 normal = normalize(worldNormal);
				fragInput.worldNormal = normal;

				return fragInput;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// 环境光
				fixed4 ambient = UNITY_LIGHTMODEL_AMBIENT;
				
				// 光源颜色(在ForwardBase光照模式下，_LightColor0会被填充为平行光颜色)
				fixed3 lightColor = _LightColor0.rgb;
				
				// 光源方向(在ForwardBase光照模式下，_WorldSpaceLightPos0会被填充为光源方向)
				fixed3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
				
				// 计算漫反射
				// 计算法线和光源方向点积时，两者处于相同坐标系才有实际意义，因此需要上面的转换
				fixed3 diffuse = lightColor.xyz * _Diffuse.rgb * max(0, dot(i.worldNormal, lightDir));

				fixed4 color = fixed4(diffuse, 1.0);

				color += ambient;

				return color;
			}
			ENDCG
		}
	}
}