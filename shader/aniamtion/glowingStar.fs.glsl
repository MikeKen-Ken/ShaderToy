float sdStar5(vec2 p, float r, float rf) {
    const vec2 k1 = vec2(0.809016994375, -0.587785252292);
    const vec2 k2 = vec2(-k1.x, k1.y);
    p.x = abs(p.x);
    p -= 2.0 * max(dot(k1, p), 0.0) * k1;
    p -= 2.0 * max(dot(k2, p), 0.0) * k2;
    p.x = abs(p.x);
    p.y -= r;
    vec2 ba = rf * vec2(-k1.y, k1.x) - vec2(0, 1);
    float h = clamp(dot(p, ba) / dot(ba, ba), 0.0, r);
    return length(p - ba * h) * sign(p.y * ba.x - p.x * ba.y);
}

vec2 rotate(vec2 uv, float th) {
    return mat2(cos(th), sin(th), -sin(th), cos(th)) * uv;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord / iResolution.xy;
    uv -= 0.5;
    uv.x *= iResolution.x / iResolution.y;
    float radius = 0.2;

    float diatance = sdStar5(rotate(uv, iTime), 0.12, 0.45);
    vec3 col = vec3(step(0., -diatance));
    col += clamp(vec3(0.001 / diatance), 0., 1.) * 12.; // add glow
    col *= vec3(1, 1, 0);

//-------------------------------------
    //vec3 col = vec3(0.0, 0.0, 0.0);
    //diatance =>[-radiuis --- n]
    //float diatance = length(uv) - radius;
    // //发光方法一
    // float glow = clamp(0.01 / diatance, 0., 1.);
    // //发光方法二 效果不如第一种好 不能自由控制半径 -diatance => [-n --- radius]
    //float glow = smoothstep(-0.1, radius, -diatance);
    //col += glow * 5.0;
//-------------------------------------
    fragColor = vec4(col, 1.0); // output color 
}