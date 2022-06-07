#iChannel0 "file://imgs/dva1.jpg"
const float RADIUS = 15.;
const float PI = 3.141592654;
const float MY_E = 2.718281828;

// 真正的高斯模糊---用高斯等式计算的高斯模糊
float getWeight(float a, float b) {
    float deviation = 1.0;
    float n = -(a * a + b * b) / (2. * deviation * deviation);
    float result = pow((1. / (deviation * deviation * 2. * PI)), pow(MY_E, n));
    return result;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord / iResolution.xy;
    vec4 color = texture(iChannel0, uv);
    float sumWeight = 0.;
    vec2 textureSize = vec2(textureSize(iChannel0, 0));
    vec2 onePixelSize = vec2(1, 1) / textureSize;
    // 卷积
    for(float r = -RADIUS; r <= RADIUS; r++) {
        for(float c = -RADIUS; c <= RADIUS; c++) {
            vec2 targetUv = uv + vec2(r * onePixelSize.x, c * onePixelSize.y);
            if(targetUv.x < 0. || targetUv.x > 1. || targetUv.y < 0. || targetUv.y > 1.) {
                continue;
            }
            // 简略的高斯filter
            // float weight = (RADIUS - abs(r)) * (RADIUS - abs(c));
            float weight = getWeight(r, c);
            color += texture(iChannel0, targetUv) * weight;
            sumWeight += weight;
        }
    }
    color /= sumWeight;
    fragColor = color;
}