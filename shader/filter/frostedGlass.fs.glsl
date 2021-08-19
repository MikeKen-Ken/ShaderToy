#iChannel0 "file://imgs/dva1.jpg"
#iChannel1 "file://imgs/blur.png"

const float blurStrength = 0.1;
const float speed = 2.;
const float moveRang = 8.;

float stepfun(float x) {
    return (sign(x) + 1.0) / 2.0;
}

float square(vec2 pos) {
    return (stepfun(pos.x + 1.0) * stepfun(1.0 - pos.x)) *
        (stepfun(pos.y + 1.0) * stepfun(1.0 - pos.y));
}

vec2 dynamicDist(vec2 uv) {
    vec2 dynamicUv = uv + vec2(cos(iTime * speed) / moveRang, sin(iTime * speed) / moveRang);
    dynamicUv -= 0.5;//修改uv到屏幕中心
    return uv + square(dynamicUv * 5.) *
        texture(iChannel1, dynamicUv * 5.0).xy * blurStrength;
}

vec2 staticDist(vec2 uv) {
     //静态
    vec4 target = texture(iChannel1, uv * 5.);
    return uv + vec2(target.x * blurStrength, target.y * blurStrength);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord / iResolution.xy;
    // fragColor = texture(iChannel0, dynamicDist(uv));
    fragColor = texture(iChannel0, staticDist(uv));
}
