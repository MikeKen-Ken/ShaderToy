#iChannel0 "file://imgs/dva.jpg"
#iChannel1 "file://imgs/dva1.jpg"

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord / iResolution.xy;
    vec2 direction = vec2(0., 1.);
    vec2 speed = vec2(0.14, 0.11);
    vec2 runtimeUv = uv + iTime * sign(direction) * speed;
    vec2 remainder = mod(runtimeUv, 2.);
    fragColor = mix(texture(iChannel0, runtimeUv), texture(iChannel1, runtimeUv), step(0.0, remainder.y) * step(remainder.y, 1.0));
}
