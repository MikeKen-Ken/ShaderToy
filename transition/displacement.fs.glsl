#iChannel0 "file://imgs/dva.jpg"
#iChannel1 "file://imgs/dva1.jpg"
#iChannel2 "file://imgs/1.png"
#iChannel3 "file://imgs/2.png"
#iChannel4 "file://imgs/3.png"
#iChannel5 "file://imgs/4.png"
#iChannel6 "file://imgs/5.png"
#iChannel7 "file://imgs/6.png"
#iChannel8 "file://imgs/7.png"
#iChannel9 "file://imgs/9.png"
#iChannel10 "file://imgs/9.png"

const float strength = 0.5;

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord / iResolution.xy;
    float displacement = texture2D(iChannel3, uv).r * strength;
    float period = (sin(iTime) + 1.) / 2.; // 0-1
    vec2 uvFrom = vec2(uv.x, uv.y + period * displacement);
    vec2 uvTo = vec2(uv.x, uv.y - (1.0 - period) * displacement);
    fragColor = mix(texture(iChannel0, uvFrom), texture(iChannel1, uvTo), period);
}
