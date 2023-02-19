shader_type spatial;

uniform sampler2D u_texture;

mat2 rotate2D(float r){
    return mat2(vec2(cos(r), sin(r)),vec2( -sin(r), cos(r)));
}

void fragment() {
	vec2 r = 1.0/VIEWPORT_SIZE;
	vec2 uv = UV.xy / r.xy;
	vec2 n,N,q,p=(UV.xy*2.-1.0/VIEWPORT_SIZE)/(1.0/VIEWPORT_SIZE.y);
	float S=5.,a,j;
	for(mat2 m=rotate2D(5.);j++<30.;S*=1.2){
		p*=m;
		n*=m;
		q=p*S+j+n+TIME*4.+sin(TIME*4.)*.8;
		a+=dot(cos(q)/S,r/r);
		n+=q;
		q=sin(q);
		N+=q/(S+60.);
	}
	ALBEDO+=.1-a*.1;ALBEDO.r*=5.;
	ALBEDO+=min(.7,.001/length(N));
	ALBEDO-=ALBEDO*dot(p,p)*.7;
	ALBEDO+=texture(u_texture, uv).rgb;

}
