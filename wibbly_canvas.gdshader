shader_type canvas_item;

mat2 rotate2D(float r){
    return mat2(vec2(cos(r), sin(r)),vec2( -sin(r), cos(r)));
}

void fragment() {
	vec2 res = 1.0/SCREEN_PIXEL_SIZE;
	vec2 uv = 1.0-2.0*(UV.xy / (1.0 / TEXTURE_PIXEL_SIZE).xy);
	// vec2 uv = UV.xy / r.xy;
	vec2 n,N,q,p=(uv.xy*1.0-res)/(res.y);
	float S=5.0,a,j;
	//COLOR = texture(TEXTURE, UV); //read from texture
	vec4 o = vec4(0.0);
	// Pulses
	for(mat2 m=rotate2D(5.);j++<30.;S*=1.2){
		p*=m;
		n*=m;
		q=p*S+j+n+TIME*4.+sin(TIME*4.)*.8;
		a+=dot(cos(q)/S,res/res);
		n+=q;
		q=sin(q);
		N+=q/(S+60.);
	}
	o+=.1-a*.1;
	o.r*=5.;
	o+=min(.7,.001/length(N));
	o-=o*dot(p,p)*.1;
	COLOR = o;
	
//	COLOR+=.1-a*.1;
//	COLOR.r*=5.;
//	COLOR+=min(.7,.001/length(N));
//	COLOR-=COLOR*dot(p,p)*.1;
//
//	ALBEDO+=texture(u_texture, uv).rgb;

}