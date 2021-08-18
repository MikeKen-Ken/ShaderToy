#iChannel0 "file://imgs/dva1.jpg"
const float RADIUS = 15.; //加权的半径范围，越大越模糊

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord / iResolution.xy;
    vec4 color = texture(iChannel0, uv);
    float sumWeight = 0.;//总加权值
    vec2 textureSize = vec2(textureSize(iChannel0, 0));//纹理大小
    vec2 onePixelSize = vec2(1, 1) / textureSize;//每个像素大小转换为uv坐标下
    //卷积
    for(float r = -RADIUS; r <= RADIUS; r++) { // 水平方向
        for(float c = -RADIUS; c <= RADIUS; c++) { // 垂直方向
            vec2 targetUv = uv + vec2(r * onePixelSize.x, c * onePixelSize.y); // 目标像素位置
            if(targetUv.x < 0. || targetUv.x > 1. || targetUv.y < 0. || targetUv.y > 1.) {
                continue;
            }
            float weight = (RADIUS - abs(r)) * (RADIUS - abs(c)); // 计算权重
            color += texture(iChannel0, targetUv) * weight; // 累加颜色
            sumWeight += weight; // 累加权重
        }
    }
    color /= sumWeight;
    fragColor = color;
}