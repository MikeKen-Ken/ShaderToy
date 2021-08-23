#iChannel0 "file://imgs/dva.jpg"
#iChannel1 "file://imgs/dva1.jpg"

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord / iResolution.xy;
    vec2 direction = vec2(0., 1.);//移动方向
    vec2 speed = vec2(0., 0.11);//移动速度
    vec2 dynamic = uv + iTime * sign(direction) * speed;//移动后的uv
    vec2 remainder = mod(dynamic, 2.);//相对移动的值
    //step(0.0, remainder.y) * step(remainder.y, 1.0) 表示 y >= 0 &&　y <= 1
    fragColor = mix(texture(iChannel0, dynamic), texture(iChannel1, dynamic), step(0.0, remainder.y) * step(remainder.y, 1.0));
}
