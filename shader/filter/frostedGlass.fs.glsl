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
    //这里uv * 5.的原因是，uv*的越大，对应在iChannel1上的pixel范围越少
    //使得pixle之间的uv改变就越小，图片看起来就更自然
    //极端情况可能所有的pixel对应一个uv,此时显示原图
    return uv + texture(iChannel1, uv * 5.).xy * blurStrength;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord / iResolution.xy;
    // fragColor = texture(iChannel0, dynamicDist(uv));
    fragColor = texture(iChannel0, staticDist(uv) - blurStrength * 0.25);
}
