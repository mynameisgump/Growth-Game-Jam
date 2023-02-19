shader_type spatial;
// noisePulse() by @yonatan
// https://twigl.app/?ol=true&ss=-NNIajM4aEzy75lqtAUd
// https://twitter.com/zozuar
mat2 rotate2D(float r){
    return mat2(vec2(cos(r), sin(r)),vec2( -sin(r), cos(r)));
}

void fragment() {
	vec2 r = 1.0/TEXTURE_PIXEL_SIZE*3.0;
	vec2 n,N,q,p=(UV.xy*6.-r)/r.y;
	float S=2.,a,j;
	for(mat2 m=rotate2D(5.);j++<30.;S*=1.2){
  		p*=m;
		n*=m;
		q=p*S+j+n+TIME*4.+sin(TIME*4.)*.8;
		a+=dot(cos(q)/S,r/r);
		n+=q=sin(q);
		N+=q/(S+20.);
	}  
	COLOR+=.001-a*.1;
	COLOR.r*=5.;
	COLOR+=min(.7,.001/length(N));
	COLOR-=COLOR*dot(p,p)*.3;
//	vec2 r = 1.0/TEXTURE_PIXEL_SIZE;
//	vec2 n,q,p=(UV.xy)/r.x;
//	float d=dot(p,p);
//	float S=5.;
//	float i,a,j;
//	vec4 o = vec4(0.0,0.0,0.0,0.7);
//	for(mat2 m=rotate2D(5.);j<30.;j++){
//	  p*=m;
//	  n*=m;
//	  q=p*S+TIME*4.+sin(TIME*4.-d*6.)*.8+j+n;
//	  a+=dot(cos(q)/S,vec2(.2));
//	  n-=sin(q);
//	  S*=1.2;
//	}
//	o += (a+.2)*vec4(1,1,1,0)+a+a-d;
//	COLOR=o;
}