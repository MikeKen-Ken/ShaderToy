precision highp float;
const float PI = 3.141592654;

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = fragCoord/iResolution.xy - 0.5;
    
    vec3 col = vec3(0.0,0.0,0.0);
    
    const float count = 8.0;
    
    float radius = 10.0;
    
    float rotation = 0.0;
    
    vec2 pos = vec2(0.0,0.0);

    float R = 120.0; 
    
    for(float i = 0.0; i < count; i++){
        rotation = 2.0 * PI * i / count + iTime * PI ;
        R = 100.0 * abs(sin(iTime));
        pos = vec2(R * cos(rotation), R * sin(rotation));
        radius = 15.0 + cos(rotation) * 4.0;
        if( distance(iResolution.xy/2.0 - pos,fragCoord) <= radius)
        {
            if(R <= 15.0){
            col = 0.5 + 0.5*cos(iTime+vec3(0,2,4));
            }else{
            col = 0.5 + 0.5*cos(iTime+i / 10.0 + vec3(0,2,4));
            }
        }
    }
   
    // Output to screen
    fragColor = vec4(col,1.0);
}