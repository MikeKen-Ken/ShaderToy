//SDF ------ signed distance field 
//An SDF is just a function which takes a position as an input, 
//and outputs the distance from that position to the nearest part of a shape.

vec3 getBackgroundColor(vec2 uv) {
    uv = uv * 0.5 + 0.5; // remap uv from <-0.5,0.5> to <0.25,0.75>
    vec3 gradientStartColor = vec3(1., 0., 1.);
    vec3 gradientEndColor = vec3(0., 1., 1.);
    return mix(gradientStartColor, gradientEndColor, uv.y); // gradient goes from bottom to top
}

float sdCircle(vec2 uv, float r, vec2 offset) {
    float x = uv.x - offset.x;
    float y = uv.y - offset.y;
    return length(vec2(x, y)) - r;
}

float sdSquare(vec2 uv, float size, vec2 offset) {
    float x = uv.x - offset.x;
    float y = uv.y - offset.y;
    return max(abs(x), abs(y)) - size;
}

// smooth min
float smin(float a, float b, float k) {
    float h = clamp(0.5 + 0.5 * (b - a) / k, 0.0, 1.0);
    return mix(b, a, h) - k * h * (1.0 - h);
}

// smooth max
float smax(float a, float b, float k) {
    return -smin(-a, -b, k);
}

float opSymX(vec2 p, float r) {
    p.x = abs(p.x);
    return sdCircle(p, r, vec2(0.1, 0));
}

float opRep(vec2 p, float r, vec2 c) {
    //把坐标移动到单位向量上面，方便计算
    vec2 q = mod(p + 0.5 * c, c) - 0.5 * c;
    return sdCircle(q, r, vec2(0));
}

float opRepLim(vec2 p, float r, float c, vec2 l) {
    vec2 q = p - c * clamp(round(p / c), -l, l);
    return sdCircle(q, r, vec2(0));
}

float opDisplace(vec2 p, float r) {
    float d1 = sdCircle(p, r, vec2(0));
    float d2 = sin(p.x); // Some arbitrary values I played around with
    return d1 + d2;
}

vec3 drawScene(vec2 uv) {
    vec3 col = getBackgroundColor(uv);
    float d1 = sdCircle(uv, 0.1, vec2(0., 0.));//点到圆周的距离 
    float d2 = sdSquare(uv, 0.1, vec2(0.1, 0));//点到方块周的距离
    float res; // result
    res = d1;//圆
    //res = d2;//方块
    //res = min(d1, d2); //min代表圆和方块的合集
    //res = max(d1, d2); //max代表圆和方块的交集
    //res = max(-d1, d2); 
    //res = max(d1, -d2);
    //res = max(min(d1, d2), -max(d1, d2));
    //res = smin(d1, d2, 0.05);
    //res = smax(d1, d2, 0.05);
    //res = opSymX(uv, 0.1);
    // res = opRep(uv, 0.05, vec2(0.2, 0.2));
    // res = opRepLim(uv, 0.05, 0.15, vec2(2, 2));
    // res = opDisplace(uv, 0.1);

    res = smoothstep(0., .04, res); // Same as res > 0. ? 1. : 0.;
    col = mix(vec3(0.502, 0.0275, 0.0275), col, res);
    return col;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord / iResolution.xy; // <0, 1>
    uv -= 0.5; // <-0.5,0.5>
    uv.x *= iResolution.x / iResolution.y; // fix aspect ratio
    vec3 col = drawScene(uv);
    fragColor = vec4(col, 1.0); // Output to screen
}