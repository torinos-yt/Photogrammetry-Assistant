//@author: vux
//@help: template for standard shaders
//@tags: template
//@credits: 
//@author: vux
//@help: template for geometry fx
//@tags: geometry
//@credits:

SamplerState linearSampler: IMMUTABLE
{
    Filter = MIN_MAG_MIP_LINEAR;
    AddressU = Wrap;
    AddressV = Wrap;
};

float conelength = 0.5;

cbuffer cbPerDraw : register(b0)
{
	float4x4 tVP : LAYERVIEWPROJECTION;
};

cbuffer cbPerObj : register( b1 )
{
	float4x4 tW : WORLD;
	float4 cAmb <bool color=true;String uiname="Color";> = { 1.0f,1.0f,1.0f,1.0f };
};

struct vs2gs
{
	float4 PosO: POSITION;
};

struct GSout
{
	float4 Pos: SV_Position;
};

vs2gs VS(uint iv : SV_VertexID)
{
	vs2gs Out;
	Out.PosO = float4(0,0,0,1);
    return Out;
}

[maxvertexcount(60)]
void Cone(point vs2gs input[1], inout LineStream<GSout> gsout)
{	
	float z = conelength;
	float s = z * 2;
	GSout o;
	float4x4 tWVP = mul(tW, tVP);
	float4 cpos[] = {float4(0, 0, 0, 1),
					 float4(.3*s, .3*s, z, 1),
					 float4(-.3*s, .3*s, z, 1),
					 float4(.3*s, -.3*s, z, 1),
					 float4(-.3*s, -.3*s, z, 1)
					};
	
	float4 bpos[] = {float4(.3, .3, -1, 1),
					 float4(.3, -.3, -1, 1),
					 float4(-.3, -.3, -1, 1),
					 float4(-.3, .3, -1, 1),
					 float4(.3, .3, 0, 1),
					 float4(.3, -.3, 0, 1),
					 float4(-.3, -.3, 0, 1),
					 float4(-.3, .3, 0, 1)
					};
	
	for(int i = 0; i < 3; i++){
		o.Pos = mul(cpos[i], tWVP);
		gsout.Append(o);
	}
	o.Pos = mul(cpos[0], tWVP);
	gsout.Append(o);
	gsout.RestartStrip();
	
	o.Pos = mul(cpos[0], tWVP);
	gsout.Append(o);
	for(i = 3; i < 5; i++){
		o.Pos = mul(cpos[i], tWVP);
		gsout.Append(o);
	}
	o.Pos = mul(cpos[0], tWVP);
	gsout.Append(o);
	gsout.RestartStrip();
	
	o.Pos = mul(cpos[1], tWVP);
	gsout.Append(o);
	o.Pos = mul(cpos[3], tWVP);
	gsout.Append(o);
	gsout.RestartStrip();
	
	o.Pos = mul(cpos[2], tWVP);
	gsout.Append(o);
	o.Pos = mul(cpos[4], tWVP);
	gsout.Append(o);	
	gsout.RestartStrip();
	
	for(i = 0; i < 4; i++){
		o.Pos = mul(bpos[i], tWVP);
		gsout.Append(o);
	}
	o.Pos = mul(bpos[0], tWVP);
	gsout.Append(o);
	gsout.RestartStrip();
	
	for(i = 4; i < 8; i++){
		o.Pos = mul(bpos[i], tWVP);
		gsout.Append(o);
	}
	o.Pos = mul(bpos[4], tWVP);
	gsout.Append(o);
	gsout.RestartStrip();
	
	for(i = 0; i < 4; i++){
		o.Pos = mul(bpos[i], tWVP);
		gsout.Append(o);
		o.Pos = mul(bpos[i+4], tWVP);
		gsout.Append(o);
		gsout.RestartStrip();
	}
}

float4 PS(GSout In): SV_Target
{
    return cAmb;
}


technique10 Constant
{
	pass P0
	{
		SetVertexShader( CompileShader( vs_4_0, VS() ) );
		SetGeometryShader( CompileShader( gs_5_0, Cone() ) );
		SetPixelShader( CompileShader( ps_4_0, PS() ) );
	}
}




