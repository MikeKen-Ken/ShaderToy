void mainImage(out vec4 fragColor, in vec2 fragCoord) {

    vec2 uv = fragCoord / iResolution.xy;

    float amplitude = .05;

    float angularVelocity = 10.;

    float frequency = 10.;

    float offset = .5;

    // y = Asin(ωx ± φ) + k
    float y = amplitude * sin((angularVelocity * uv.x) + (frequency * iTime)) + offset;

    // Time varying pixel color
    vec3 col = .5 + .5 * cos(iTime + uv.xyx + vec3(0, 2, 4));

    vec4 color = uv.y > y ? vec4(0., 0., 0., 1.) : vec4(col, 1.);

    fragColor = color;
}