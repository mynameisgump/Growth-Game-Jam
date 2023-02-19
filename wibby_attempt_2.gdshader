shader_type canvas_item;
uniform sampler2D u_tex0;
mat2 rotationMatrix(float angle) {
	angle *= PI/180.0;
	float s=sin(angle), c=cos(angle);
	return mat2( vec2(c,-s), vec2(s, c) );
}

mat2 rotate2D(float r){
    return mat2(vec2(cos(r), sin(r)),vec2( -sin(r), cos(r)));
}



void fragment() {
	vec2 res = 1.0/SCREEN_PIXEL_SIZE;
	vec2 uv = FRAGCOORD.xy/res;
	
	vec2 fc = FRAGCOORD.xy * 1.;
	vec2 r = res;
	
	vec2 n,q;
	vec2 p=(fc.xy-vec2(.5)*r)/r.y;
	
	float d=dot(p,p);
	float S=9.;
	float i,a,j;
	float t = TIME;
	
	vec4 col = vec4(0);
	
	for(mat2 m=rotationMatrix(25.);j++<30.;){
		p*=m;
		n*=m;
		q=p*S+TIME*4.+sin(TIME*4.-d*6.)*.8+j+n;
		a+=dot(cos(q)/S,vec2(.2));
		n-=sin(q);
		S*=1.2;
	}
	
	col = (a+.2)*vec4(4,2,1,0)+a+a-d;
	//COLOR = vec4(1.0);
//	vec4 texCol = vec4(res.x,res.y,0.0,1.0);
//	texCol = texture(col,res);
	// COLOR = col;
	
	
	
	
	
	
	
	
	
	
//	vec2 res = 1.0/SCREEN_PIXEL_SIZE;
//	vec2 n,q,p=(FRAGCOORD.xy-.5*res)/res.y;
//	float d=dot(p,p),S=9.,i,a,j;
//	//vec4 o = vec4(0.0);
//	for(mat2 m=rotate2D(5.);j++<30.;){
//		  p*=m;
//		  n*=m;
//		  q=p*S+TIME*4.+sin(TIME*4.-d*6.)*.8+j+n;
//		  a+=dot(cos(q)/S,vec2(.2));
//		  n-=sin(q);
//		  S*=1.2;
//	}










	//o += (a+.2)*vec4(4,2,1,0)+a+a-d;
	//COLOR = o;
//	vec2 res = 1.0/SCREEN_PIXEL_SIZE;
//	// vec2 uv = UV.xy / r.xy;
//	vec2 n,N,q,p=(FRAGCOORD.xy*2.0-res)/(res.y);
//	float S=5.0,a,j;
//	//COLOR = texture(TEXTURE, UV); //read from texture
//	vec4 o = vec4(0.0);
//	for(mat2 m=rotate2D(5.);j++<30.;S*=1.2){
//		p*=m;
//		n*=m;
//		q=p*S+j+n+TIME*4.+sin(TIME*4.)*.8;
//		a+=dot(cos(q)/S,res/res);
//		n+=q;
//		q=sin(q);
//		N+=q/(S+60.);
//	}
//	o+=.1-a*.1;
//	o.r*=5.;
//	o+=min(.7,.001/length(N));
//	o-=o*dot(p,p)*.1;
//	COLOR = o;
	
//	COLOR+=.1-a*.1;
//	COLOR.r*=5.;
//	COLOR+=min(.7,.001/length(N));
//	COLOR-=COLOR*dot(p,p)*.1;
//
//	ALBEDO+=texture(u_texture, uv).rgb;

}