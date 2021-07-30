void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord / iResolution.xy;
    uv -= .5;
    fragColor = vec4(1., 1., 1., 1.);
}