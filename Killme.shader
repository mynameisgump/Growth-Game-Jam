shader_type canvas_item;
// noisePulse() by @yonatan
// https://twigl.app/?ol=true&ss=-NNIajM4aEzy75lqtAUd
// https://twitter.com/zozuar

mat2 rotate2D(float r){
    return mat2(vec2(cos(r), sin(r)),vec2( -sin(r), cos(r)));
}

float noisePulse(in vec2 p, in float t){

    vec2 n,q;
    float d=dot(p,p),S=9.0,i,a,j;
    for( mat2 m=rotate2D(5.0);j<16.0;j++)
    {
      p*=m;
      n*=m;
      q=(p)*S+t*4.+sin(t*4.-d*6.)*.8+j+n ;
      a+=dot(cos(q)/S,vec2(.2));
      n-=sin(q);
      S*=1.2;
    }
    
    return a;
}

void fragment() {
	vec2 iResolution = 1.0/SCREEN_PIXEL_SIZE;
    vec2 r = (FRAGCOORD.xy-.5*iResolution.xy);
    float a = iResolution.y;
    vec2 uv = r/a;
	
    // VARIABLES
    vec3 sp = vec3(uv + .5, 0.);
    vec3 ro = vec3(0., 0., -1.);
    vec3 rd = normalize(ro-sp);

    // NORMALS
    vec2 x1 = (r-vec2(-1.,0.))/a;
    vec2 y1 = (r-vec2(0.,-1.))/a;
         
    float nB = noisePulse(uv, TIME);

    // SHADE
    float occl = nB + .5;  
    
    // COMP
    vec3 tint = vec3(0.3, 0.03, 0.005);
    vec3 comp = vec3(0);
    comp += occl * occl * tint;
    
    // POST
    uv -= vec2(1.);
    comp *= pow(2.0*uv.x*uv.y*(uv.x-1.)*(uv.y-1.),0.4);
    comp = sqrt(comp);    
    COLOR=vec4(1.0);
    //COLOR=vec4(comp,1.);
    
}