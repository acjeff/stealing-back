shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, filter_nearest;
uniform sampler2D mask_texture : hint_screen_texture, filter_nearest;

void fragment() {
    vec2 uv = FRAGCOORD.xy / SCREEN_PIXEL_SIZE.xy;
    vec4 screen_color = texture(screen_texture, uv);
    vec4 mask_color = texture(mask_texture, uv);
    
    // Blend the two textures based on the mask
    if (mask_color.a > 0.0) {
        COLOR = screen_color;
    } else {
        COLOR = vec4(screen_color.rgb * 0.5, screen_color.a); // Dimming effect
    }
}
