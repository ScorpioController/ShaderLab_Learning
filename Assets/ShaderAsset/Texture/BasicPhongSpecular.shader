Shader "Custom/Texture/BasicTexture"
{
	Properties
	{
		_Diffuse ("Diffuse", COLOR) = (1, 1, 1, 1)
		_Specular ("Specular", COLOR) = (1, 1, 1, 1)
		_Gloss ("Gloss", Range(8.0, 256)) = 20
		_MainTex ("Main Tex", 2D) = "white" {}
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
				// 在顶点着色器中 TEXCOORD0 语义绑定的变量，Unity会传入模型的第一组纹理坐标
				float4 texcoord : TEXCOORD0;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float3 worldNormal : TEXCOORD0;
				float3 worldPos : TEXCOORD1;
				// 存储纹理坐标以便采样
				float2 uv : TEXCOORD2;
			};
			
			fixed4 _Diffuse;
			fixed4 _Specular;
			float _Gloss;
			sampler2D _MainTex;
			float4 _MainTex_ST; // 存储纹理的缩放(xy)和偏移值(zw)
			
			v2f vert (appdata v)
			{
				v2f vertexOutput;
				
				vertexOutput.vertex = UnityObjectToClipPos(v.vertex);
				vertexOutput.worldNormal = normalize(UnityObjectToWorldNormal(v.normal));
				// 存储世界坐标位置
				vertexOutput.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;

				// 变换uv坐标 1
				vertexOutput.uv = v.texcoord.xy; // 取得纹理坐标
				vertexOutput.uv *= _MainTex_ST.xy; // 缩放
				vertexOutput.uv += _MainTex_ST.zw; // 偏移

				// 变换uv坐标 2 (和上面的流程等价)
				vertexOutput.uv = TRANSFORM_TEX(v.texcoord, _MainTex);

				return vertexOutput;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed3 lightColor = _LightColor0.rgb;
				
				fixed3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
				
				fixed3 viewDir = normalize(UnityWorldSpaceViewDir(i.worldPos));
				
				fixed3 halfDir = normalize(lightDir + viewDir);

				// 对纹理采样获得纹素值，和本身颜色相乘作为反射率
				fixed3 albedo = tex2D(_MainTex, i.uv).rgb * _Diffuse;
				
				fixed3 specular = lightColor * _Specular.rgb * pow(saturate(dot(halfDir, i.worldNormal)), _Gloss);

				// 使用反射率计算漫反射光
				fixed3 diffuse = lightColor.xyz * albedo * max(0, dot(i.worldNormal, lightDir));

				// 将反射率叠加到环境光
				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT * albedo;
				
				fixed4 color = fixed4(ambient + diffuse + specular, 1.0);

				return color;
			}
			ENDCG
		}
	}
}