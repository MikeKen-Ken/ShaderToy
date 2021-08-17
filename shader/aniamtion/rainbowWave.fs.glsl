void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord / iResolution.xy;
    uv -= 0.5;
    uv.x *= iResolution.x / iResolution.y;
    float amplitude = .05;
    float frequency = 10.;
    float offsetY = .0;
    float timsScale = 10.;
    // y = Asin(ωx ± φ) + k
    float y = amplitude * sin((frequency * uv.x) + iTime * timsScale) + offsetY;
    vec3 col = .5 + .5 * cos(iTime + uv.xyx + vec3(0, 2, 4));
    vec4 color = uv.y > y ? vec4(0., 0., 0., 1.) : vec4(col, 1.);
    fragColor = color;
}