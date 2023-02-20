shader_type canvas_item;
// noisePulse() by @yonatan
// https://twigl.app/?ol=true&ss=-NNIajM4aEzy75lqtAUd
// https://twitter.com/zozuar
uniform float brightness : hint_range(0.0,8.0) = 1.0;
uniform float contrast : hint_range(0.0,8.0) = 1.0;
uniform float saturation : hint_range(0.0,8.0) = 1.0;

mat2 rotate2D(float r){
    return mat2(vec2(cos(r), sin(r)),vec2( -sin(r), cos(r)));
}

void fragment() {
	vec2 r = 1.0/TEXTURE_PIXEL_SIZE*8.0;
	vec2 n,N,q,p=((UV.xy*20.-r)/r.x)*0.7;
	float S=20.,a,j;
	for(mat2 m=rotate2D(5.);j++<30.;S*=1.2){
  		p*=m;
		n*=m;
		q=p*S+j+n+TIME*3.+sin(TIME*3.)*.9;
		a+=dot(cos(q)/S,r/r);
		n+=q=sin(q);
		N+=q/(S+10.);
	}  
	COLOR+=.01-a*.2;
	COLOR.r*=5.;
	COLOR.g*=1.;
	COLOR.b*=1.;
	COLOR+=min(0.3,10.0/length(N));
	COLOR-=COLOR*dot(p,p)*.2;
	
	COLOR = mix(vec4(0.0), COLOR, brightness);
	COLOR = mix(vec4(0.5), COLOR, contrast);
	COLOR = mix(vec4(dot(vec4(1.0), COLOR) * 0.33333), COLOR, saturation);
	
}