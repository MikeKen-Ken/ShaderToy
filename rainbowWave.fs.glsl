void mainImage( out vec4 fragColor, in vec2 fragCoord )
{

    
    vec2 uv = fragCoord / iResolution.xy;
	
    float amplitude = 0.05;
    
    float angularVelocity = 10.0;
    
    float frequency = 10.0;
    
    float offset = 0.5;
    
    // y = Asin(ωx ± φ) + k
    float y = amplitude * sin((angularVelocity * uv.x) + (frequency * iTime)) + offset;
    
    // Time varying pixel color
    vec3 col = 0.5 + 0.5*cos(iTime+uv.xyx+vec3(0,2,4));
    
    vec4 color = uv.y > y ? vec4(0.0, 0.0, 0.0, 1.0) : vec4(col,1.0);
	
    fragColor = color;
}