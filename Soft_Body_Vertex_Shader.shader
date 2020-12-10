// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

Shader "Custom/test"
{
    
	Properties
	{
		_Color("Color", Color) = (1,1,1,1)
		_MainTex("Albedo (RGB)", 2D) = "white" {}
		_Glossiness("Smoothness", Range(0,1)) = 0.5
		_Metallic("Metallic", Range(0,1)) = 0.0

		_Position("Position", Vector) = (0, 0, 0, 0)
		_PrevPosition("Prev Position", Vector) = (0, 0, 0, 0)
		_ColPos("Colision Position", Vector) = (0,0,0,0)
		_Impact("Impact", Float) = 0
		_Scaling("Distortion", Range(0,1)) = 0.5
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque" }
		LOD 200

		CGPROGRAM
		#pragma surface surf Standard vertex:vert addshadow
		#pragma target 3.0

		sampler2D _MainTex;

		struct Input
		{
			float2 uv_MainTex;
		};
	
		half _Glossiness;
		half _Metallic;
		fixed4 _Color;
		fixed4 _PrevPosition;
		fixed4 _Position;
		fixed4 _ColPos;
		half _Impact;
		half _Distortion;

		

	
		void vert(inout appdata_full v, out Input o) //deleted parameter out Input o
		{
			UNITY_INITIALIZE_OUTPUT(Input, o);
			fixed4 worldPos = mul(unity_ObjectToWorld, v.vertex);
	
			fixed3 worldOffset = (_Position.xyz - _PrevPosition.xyz)*_Impact; 
			fixed3 localOffset = (worldPos.xyz - _Position.xyz)*_Impact; 

			fixed3 worldOffsetCol = (_Position.xyz - _PrevPosition.xyz)*_Impact; 
	
			// World offset should only be behind swing
			float dirDot = dot(normalize(worldOffset), normalize(localOffset));
			float dirDotCol = dot(normalize(worldOffsetCol), normalize(localOffset));

			fixed3 unitVec = fixed3(1, 1, 1);

			worldOffset = clamp(worldOffset, unitVec * -1, unitVec);
			worldOffsetCol = clamp(worldOffsetCol, unitVec * -1, unitVec);

			worldOffset *= clamp(dirDot, -1, -_Distortion) * lerp(1, _Distortion, step(length(worldOffset), _Distortion));

			worldOffsetCol *= clamp(-dirDot, -1, -_Distortion) * lerp(1, _Distortion, step(length(worldOffsetCol), _Distortion));

			worldPos.xyz += (worldOffset.xyz + worldOffsetCol.xyz);

			
			v.vertex = mul(unity_WorldToObject, worldPos);
			
			//if(v.vertex.x<0)
			//v.vertex.x = lerp(v.vertex.x + worldOffset.x , worldOffset.x , _Impact);

			
			
			//v.vertex.xyz = normalize(v.vertex + _ColPos + worldOffset);

			//v.vertex.y = _ColPos.y *lerp(v.vertex.y + worldOffset.y , worldOffset.y , _Impact); // flatten the bottom
			//v.vertex.z = _ColPos.z *lerp(v.vertex.z + worldOffset.z , worldOffset.z , _Impact); // flatten the bottom

			// float3 norm = normalize(v.normal);
			// if(v.vertex.y<0)
			// 	v.vertex.xyz += norm * _Scaling * (sin(2*3.14159*((-v.vertex.y*2)-0.25))+1); //buldge

			//v.vertex.xyz += norm * _Scaling * (sin(2*3.14159*((v.vertex+_ColPos + worldOffset*2)-0.25))+1)/2; //buldge


			
			
		}
	
		void surf(Input IN, inout SurfaceOutputStandard o)
		{
			fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = c.rgb;
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
			o.Alpha = c.a;
		}
		ENDCG
	}

	FallBack "Diffuse"
}
