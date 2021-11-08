#iChannel0 "file://imgs/dva.jpg"
#iChannel1 "file://imgs/dva1.jpg"

float frequency = 30.;
float speed = 30.;
#define PI 3.141592653589793

vec4 getFromColor(vec2 uv) {
    return texture(iChannel0, uv);
}

vec4 getToColor(vec2 uv) {
    return texture(iChannel1, uv);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord / iResolution.xy;
    float progress = (cos(iTime - PI) + 1.) / 2.;
    vec2 center = vec2(0.5, 0.5);
    vec2 dir = uv - center;
    float dist = length(dir);
    if(dist > progress) {
        fragColor = mix(getFromColor(uv), getToColor(uv), progress);
    } else {
        vec2 offset = dir * sin(dist * frequency - progress * speed);
        fragColor = mix(getFromColor(uv + offset), getToColor(uv), progress);
    }
}