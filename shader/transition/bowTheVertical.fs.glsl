#iChannel0 "file://imgs/dva.jpg"
#iChannel1 "file://imgs/dva1.jpg"

float progress;
vec2 topTraingle1P1;
vec2 topTraingle1P2;
vec2 topTraingle1P3;
vec2 btoTraingle2P1;
vec2 btoTraingle2P2;
vec2 btoTraingle2P3;

bool isPointInTriangle(vec2 pt, vec2 p1, vec2 p2, vec2 p3) {
    vec3 v3pt = vec3(pt, 0.);
    vec3 v3p1 = vec3(p1, 0.);
    vec3 v3p2 = vec3(p2, 0.);
    vec3 v3p3 = vec3(p3, 0.);
    float sign1 = cross(v3pt - v3p1, (v3p2 - v3p1)).z;
    float sign2 = cross(v3pt - v3p2, (v3p3 - v3p2)).z;
    float sign3 = cross(v3pt - v3p3, (v3p1 - v3p3)).z;
    if(sign(sign1) == sign(sign2) && sign(sign2) == sign(sign3)) {
        return true;
    }
    return false;
}

bool inTopTriangle(vec2 p) {
    return isPointInTriangle(p, topTraingle1P1, topTraingle1P2, topTraingle1P3);
}

bool inBottomTriangle(vec2 p) {
    return isPointInTriangle(p, btoTraingle2P1, btoTraingle2P2, btoTraingle2P3);
}

float blurEdge(vec2 top, vec2 p1, vec2 p2, vec2 uv) {
    //求点到两个边的距离，当距离小于一定范围的时候，做模糊化处理
    vec2 topToP1 = p1 - top;
    vec2 uvToP1 = p1 - uv;
    float angle1 = abs(dot(topToP1, uvToP1)) / (length(topToP1) * length(uvToP1));
    float distanceToP1 = sin(acos(angle1) * length(uvToP1));

    vec2 topToP2 = p2 - top;
    vec2 uvToP2 = p2 - uv;
    float angle2 = abs(dot(topToP2, uvToP2)) / (length(topToP2) * length(uvToP2));
    float distanceToP2 = sin(acos(angle2)) * length(uvToP2);

    float min_dist = min(distanceToP1, distanceToP2);
    if(min_dist < 0.005) {
        return min_dist / 0.005;
    }
    return 1.0;
}

vec4 getFromColor(vec2 uv) {
    return texture(iChannel0, uv);
}

vec4 getToColor(vec2 uv) {
    return texture(iChannel1, uv);
}

vec4 getColor(vec2 uv) {
    if(inTopTriangle(uv) && uv.y < 0.5) {
        //模糊边界
        return mix(getFromColor(uv), getToColor(uv), blurEdge(topTraingle1P1, topTraingle1P2, topTraingle1P3, uv));
    }
    if(inBottomTriangle(uv) && uv.y >= 0.5) {
        return mix(getFromColor(uv), getToColor(uv), blurEdge(btoTraingle2P1, btoTraingle2P2, btoTraingle2P3, uv));
    }
    return getFromColor(uv);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord / iResolution.xy;
    progress = (cos(iTime) + 1.) / 2.;

    //左右两个定点分别从0.49 0.51作为起点的原因，是因为左右两边会出现未完全移出的三角
    topTraingle1P1 = vec2(0.5, progress);
    topTraingle1P2 = vec2(0.49 - progress, 0.0);
    topTraingle1P3 = vec2(0.51 + progress, 0.0);

    btoTraingle2P1 = vec2(0.5, 1.0 - progress);
    btoTraingle2P2 = vec2(0.49 - progress, 1.0);
    btoTraingle2P3 = vec2(0.51 + progress, 1.0);

    fragColor = getColor(uv);
}
