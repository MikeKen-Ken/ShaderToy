#iChannel0 "file://imgs/dva.jpg"
#iChannel1 "file://imgs/dva1.jpg"
#define PI 3.141592653589793

const float strength = 0.3;
vec2 radialCenter = vec2(.5, .5);
vec3 blurColor = vec3(0.0);

highp float rand(const in vec2 uv, float seed) {
    const highp float a = 12.9898, b = 78.233, c = 43758.5453;
    highp float dt = dot(uv.xy + seed, vec2(a, b));
    highp float sn = mod(dt, PI);
    return fract(sin(sn) * c + seed);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord / iResolution.xy;
    vec2 toCenter = radialCenter - uv;
    //-PI 目的是为了progress 的起点值为0 
    //一个progress控制径像模糊效果，一个控制图片切换，图片切换速度应该未镜像速度1/2；
    float strengthProgress = (cos(iTime * 2. - PI) + 1.) / 2.;
    float textureProgress = (cos(iTime - PI) + 1.) / 2.;
    float blurStrength = strength * strengthProgress;
    float totalWeight = 0.0;
    float offset = rand(uv, 0.);
    for(float t = 0.0; t <= 20.0; t++) {
        float percent = (t + offset) / 20.0; // 0 - 1.05
        float weight = percent - percent * percent;
        vec2 dynamicUv = uv + toCenter * percent * blurStrength;
        vec4 targetColor = mix(texture(iChannel0, dynamicUv), texture(iChannel1, dynamicUv), textureProgress);
        blurColor += targetColor.rgb * weight;
        totalWeight += weight;
    }
    fragColor = vec4(blurColor / totalWeight, 1.0);
}
