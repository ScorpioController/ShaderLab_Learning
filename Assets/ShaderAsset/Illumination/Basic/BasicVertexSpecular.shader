Shader "Custom/Illumination/BasicVertexSpecular"
{
	Properties
	{
		_Diffuse ("Diffuse", COLOR) = (1, 1, 1, 1)
		_Specular ("Specular", COLOR) = (1, 1, 1, 1)
		_Gloss ("Gloss", Range(8.0, 256)) = 20
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
				fixed4 color : COLOR;
			};

			fixed4 _Diffuse;
			fixed4 _Specular;
			float _Gloss;
			
			v2f vert (appdata v)
			{
				v2f fragInput;
				// 环境光
				fixed4 ambient = UNITY_LIGHTMODEL_AMBIENT;
				
				// 光源颜色(在ForwardBase光照模式下，_LightColor0会被填充为平行光颜色)
				fixed3 lightColor = _LightColor0.rgb;
				
				// 光源方向(在ForwardBase光照模式下，_WorldSpaceLightPos0会被填充为光源方向)
				fixed3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
				
				// 转换的法线
				float3 worldNormal = UnityWorldToObjectDir(v.normal);
				float3 normal = normalize(worldNormal);
				
				// 计算漫反射
				// 计算法线和光源方向点积时，两者处于相同坐标系才有实际意义，因此需要上面的转换
				fixed3 diffuse = lightColor * _Diffuse.rgb * max(0, dot(normal, lightDir));
				
				// 计算反射方向
				fixed3 refDir = normalize(reflect(-lightDir, normal));
				
				// 转换顶点
				fragInput.vertex = UnityObjectToClipPos(v.vertex);

				// 计算视角方向
				fixed3 viewDir = normalize(UnityWorldSpaceViewDir(fragInput.vertex));

				// 计算高光反射
				fixed3 specular = lightColor * _Specular.rgb * pow(saturate(dot(refDir, viewDir)), _Gloss);
				
				// 填充颜色
				fragInput.color = fixed4(ambient + diffuse + specular, 1.0);

				return fragInput;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				return i.color;
			}
			ENDCG
		}
	}
}