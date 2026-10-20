shader_type canvas_item;

// Controls tilt
uniform float depth_distortion : hint_range(0.0, 1.0) = 0.3;

uniform float pivot_x : hint_range(0.0, 1.0) = 0.5;

void fragment() {
    // 1. Center the UV coordinates around the horizontal pivot point
    vec2 centered_uv = UV - vec2(pivot_x, 0.5);
    
    // 2. Calculate the depth scaling factor based on the X position
    // abs() ensures that both left and right sides scale down equally
    float depth_factor = 1.0 + abs(UV.x - pivot_x) * depth_distortion;
    
    // 3. Compress the Y-axis by the depth factor to create the vertical taper on the sides
    centered_uv.y /= depth_factor;
    
    // 4. Restore the UV coordinates back to the standard 0.0 - 1.0 grid space
    vec2 final_uv = centered_uv + vec2(pivot_x, 0.5);
    
    // 5. Render the texture if the distorted UVs remain within the original image boundary
    if (final_uv.x >= 0.0 && final_uv.x <= 1.0 && final_uv.y >= 0.0 && final_uv.y <= 1.0) {
        COLOR = texture(TEXTURE, final_uv);
    } else {
        COLOR = vec4(0.0); // Make the empty, squeezed areas transparent
    }
}