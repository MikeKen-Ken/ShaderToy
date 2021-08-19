#iChannel0 "file://imgs/dva.jpg"
#iChannel1 "file://imgs/dva1.jpg"

const float count = 10.;
const float smoothness = .5;

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord / iResolution.xy;
    float period = (cos(iTime) + 1.) / 2.; // 0-1
    float pr = smoothstep(-smoothness, 0., uv.x - period * (1. + smoothness));
    //可以直接用period 此时的效果是全部的slice同步
    // float s = step(period, fract(count * uv.x));
    float s = step(pr, fract(count * uv.x));
    fragColor = mix(texture(iChannel0, uv), texture(iChannel1, uv), s);
    //淡入淡出效果
    // fragColor = mix(texture(iChannel0, uv), texture(iChannel1, uv), pr);
}

//fract(count * uv.x) 取到的是x相对的uv值
//uv:1 
//假设 count = 4
//当 x = 0.25 时， fract(count * uv.x) = 0
//当 x = 0.4 时， fract(count * uv.x) = 0.6 = (0.4 - 0.25) / 0.25 
//当 x = 0.1时， fract(count * uv.x) = 0.4 = 0.1 / 0.25

//可以把
//float pr = smoothstep(-smoothness, 0., uv.x - period * (1. + smoothness));
//看成是 如下的一个【扫描】格子
// -n -n -n -n 0 ... 1 n n n n 
// -n -n -n -n 0 ... 1 n n n n 
// -n -n -n -n 0 ... 1 n n n n 
// -n -n -n -n 0 ... 1 n n n n 
// -n -n -n -n 0 ... 1 n n n n 
// -n -n -n -n 0 ... 1 n n n n 
// -n -n -n -n 0 ... 1 n n n n 
//去扫描屏幕中相对pixel的uv值 count = 10
// 0...1 0...1 0...1 0...1 0...1 0...1 0...1 0...1 0...1
// 0...1 0...1 0...1 0...1 0...1 0...1 0...1 0...1 0...1
// 0...1 0...1 0...1 0...1 0...1 0...1 0...1 0...1 0...1
// 0...1 0...1 0...1 0...1 0...1 0...1 0...1 0...1 0...1
// 0...1 0...1 0...1 0...1 0...1 0...1 0...1 0...1 0...1
// 0...1 0...1 0...1 0...1 0...1 0...1 0...1 0...1 0...1
// ...
//可以想象，扫描格子【扫描】屏幕，当扫描格子中 0 ... 1部分经过时，对应的像素，才能进行slice操作