const float PI = 3.141592654;

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = fragCoord / iResolution.xy - .5;

    vec3 col = vec3(0.0, 0.0, 0.0);

    const float count = 8.;

    float radius = 10.;

    float rotation = 0.;

    vec2 pos = vec2(0., 0.);

    float R = 120.;

    for(float i = 0.; i < count; i++) {
        rotation = 2. * PI * i / count + iTime * PI;
        R = 100. * abs(sin(iTime));
        pos = vec2(R * cos(rotation), R * sin(rotation));
        radius = 15. + cos(rotation) * 4.;
        // float d = distance(iResolution.xy / 2. - pos, fragCoord);
        // float glow = d;
        // glow = smoothstep(0., radius * 1.5, d);
        if(distance(iResolution.xy / 2. - pos, fragCoord) <= radius) {
            if(R <= 15.) {
                col = .5 + .5 * cos(iTime + vec3(0, 2, 4));
            } else {
                col = .5 + .5 * cos(iTime + i / 10. + vec3(0, 2, 4));
            }
            // col += glow;
        }
    }

    // Output to screen
    fragColor = vec4(col, 1.);
}