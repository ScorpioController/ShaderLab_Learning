Shader "Custom/Illumination/BasicPixelSpecular"
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
				// 作为顶点着色器的输出使用的TEXCOORD0可以用于填充一些自定义数据
				float3 worldNormal : TEXCOORD0;
				// 保留原本的世界空间坐标在片元阶段计算视角方向
				float3 worldPos : TEXCOORD1;
			};

			fixed4 _Diffuse;
			fixed4 _Specular;
			float _Gloss;
			
			v2f vert (appdata v)
			{
				v2f fragInput;
				
				// 转换顶点
				fragInput.vertex = UnityObjectToClipPos(v.vertex);

				// 转换法线
				float3 worldNormal = UnityObjectToWorldNormal(v.normal);
				float3 normal = normalize(worldNormal);
				fragInput.worldNormal = normal;

				// 转换坐标
				fragInput.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;

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

				// 计算反射方向
				fixed3 refDir = normalize(reflect(-lightDir, i.worldNormal));

				// 计算视角方向
				fixed3 viewDir = normalize(UnityWorldSpaceViewDir(i.worldPos));

				// 计算高光反射
				fixed3 specular = lightColor * _Specular.rgb * pow(saturate(dot(refDir, viewDir)), _Gloss);

				// 叠加颜色
				fixed4 color = fixed4(ambient + diffuse + specular, 1.0);

				return color;
			}
			ENDCG
		}
	}
}