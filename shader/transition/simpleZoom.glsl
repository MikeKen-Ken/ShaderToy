#iChannel0 "file://imgs/dva.jpg"
#iChannel1 "file://imgs/dva1.jpg"
#define PI 3.141592653589793

float progress;
const float zoomFactor = 0.8;

vec4 getFromColor(vec2 uv) {
    return texture(iChannel0, uv);
}

vec4 getToColor(vec2 uv) {
    return texture(iChannel1, uv);
}

vec2 zoom(vec2 uv, float amount) {
    vec2 radialCenter = vec2(0.5, 0.5);
    return radialCenter + ((uv - radialCenter) * (1.0 - amount));
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord / iResolution.xy;
    progress = smoothstep(0., 1., (cos(iTime - PI) + 1.) / 2.);
    fragColor = mix(getFromColor(zoom(uv, smoothstep(0.0, zoomFactor, progress))), getToColor(uv), smoothstep(zoomFactor - 0.2, 1.0, progress));
}
