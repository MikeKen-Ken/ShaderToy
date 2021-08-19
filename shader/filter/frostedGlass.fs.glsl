#iChannel0 "file://imgs/dva1.jpg"
#iChannel1 "file://imgs/blur.png"

float stepfun(float x) {
    return (sign(x) + 1.0) / 2.0;
}

float square(vec2 pos) {
    return (stepfun(pos.x + 1.0) * stepfun(1.0 - pos.x)) *
        (stepfun(pos.y + 1.0) * stepfun(1.0 - pos.y));
}

vec2 dist(vec2 pos) {
    vec2 offset = pos + vec2(cos(iTime * 2.0) / 8.0, sin(iTime * 2.0) / 8.0);

    return pos + square((offset - 0.5) * 5.0) *
        texture(iChannel1, (offset - 0.5) * 5.0).xy * 0.05;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = fragCoord / iResolution.xy;

    // Output to screen
    fragColor = texture(iChannel0, dist(uv));
}
