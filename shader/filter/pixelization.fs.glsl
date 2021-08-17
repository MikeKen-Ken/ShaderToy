#iChannel0 "file://imgs/dva.jpg"
const float RADIUS = 10.; //加权的半径范围，越大马赛克越大

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord / iResolution.xy;
    vec4 color = texture(iChannel0, uv);
    float sumWeight = 0.;//总加权值
    vec2 textureSize = vec2(textureSize(iChannel0, 0));//纹理大小
    vec2 onePixel = vec2(1, 1) / textureSize;//每个像素大小转换为uv坐标下
    //卷积
    float row = floor(uv.x / RADIUS / onePixel.x);
    float column = floor(uv.y / RADIUS / onePixel.y);
    vec2 target = vec2((row + 0.5) * RADIUS * onePixel.x, (column + 0.5) * RADIUS * onePixel.y);
    for(float r = -RADIUS; r <= RADIUS; r++) { // 水平方向
        for(float c = -RADIUS; c <= RADIUS; c++) { // 垂直方向
            vec2 targetUv = target + vec2(r * onePixel.x, c * onePixel.y); // 目标像素位置
            float weight = (RADIUS - abs(r)) * (RADIUS - abs(c)); // 计算权重
            color += texture(iChannel0, targetUv) * weight; // 累加颜色
            sumWeight += weight; // 累加权重
        }
    }
    color /= sumWeight;
    fragColor = color;
}