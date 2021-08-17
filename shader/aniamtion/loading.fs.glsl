const float PI = 3.141592654;

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec3 col = vec3(0.0, 0.0, 0.0);
    vec2 circlePosition = vec2(0., 0.);
    const float circleCount = 8.;
    float circleRadius = 0.;//每个圆的半径
    float rotateRadius = 0.;//旋转半径
    float angular = 0.;//角度
    for(float i = 0.; i < circleCount; i++) {
        angular = 2. * PI * i / circleCount + iTime * PI;
        rotateRadius = 100. * abs(sin(iTime));
        circlePosition = vec2(rotateRadius * cos(angular), rotateRadius * sin(angular));
        circleRadius = 15. + sin(angular - PI * .75) * 4.;

        // glowing
        // float d = distance(iResolution.xy / 2. - pos, fragCoord);
        // float glow = d;
        // glow = smoothstep(0., radius * 1.5, d);

        if(distance(iResolution.xy / 2. - circlePosition, fragCoord) <= circleRadius) {
            if(rotateRadius <= 15.) {
                //缩成中心的圆的时候，统一颜色
                col = .5 + .5 * cos(iTime + vec3(0, 2, 4));
            } else {
                col = .5 + .5 * cos(iTime + i / 10. + vec3(0, 2, 4));
            }
            // col += glow;
        }
    }
    fragColor = vec4(col, 1.);
}