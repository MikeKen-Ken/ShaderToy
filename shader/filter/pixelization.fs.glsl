#iChannel0 "file://imgs/dva1.jpg"
const float COLOR_RADIUS = 10.; // 马赛克块颜色的加权的半径范围，越大马赛克块之间过渡越自然
const float BLOCK_RADIUS = 5.; // 马赛克块的加权的半径范围，越大马赛克越大

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord / iResolution.xy;
    vec4 color = texture(iChannel0, uv);
    float sumWeight = 0.;// 总加权值
    vec2 textureSize = vec2(textureSize(iChannel0, 0));// 纹理大小
    vec2 onePixelSize = vec2(1, 1) / textureSize;// 每个pixel大小转换为uv坐标下
    //卷积
    float blockWidth = BLOCK_RADIUS * 2. * onePixelSize.x;
    float blockHeight = BLOCK_RADIUS * 2. * onePixelSize.y;
    float row = floor(uv.x / blockWidth);// 所在pixel在第几行
    float column = floor(uv.y / blockHeight);// 所在pixel在第几列
    vec2 conversionUv = vec2(row * blockWidth, column * blockHeight);//转换后的uv
    for(float r = -COLOR_RADIUS; r <= COLOR_RADIUS; r++) { // 水平方向
        for(float c = -COLOR_RADIUS; c <= COLOR_RADIUS; c++) { // 垂直方向
            vec2 targetUv = conversionUv + vec2(r * onePixelSize.x, c * onePixelSize.y); // 目标像素位置
            if(targetUv.x < 0. || targetUv.x > 1. || targetUv.y < 0. || targetUv.y > 1.) {
                continue;
            }
            float weight = (COLOR_RADIUS - abs(r)) * (COLOR_RADIUS - abs(c)); // 计算权重
            color += texture(iChannel0, targetUv) * weight; // 累加颜色
            sumWeight += weight; // 累加权重
        }
    }
    color /= sumWeight;
    fragColor = color;
}