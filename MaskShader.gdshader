shader_type spatial;

uniform vec3 player_position;
uniform float mask_radius : hint_range(0.0, 10.0) = 3.0;
uniform vec4 mask_color = vec4(1.0, 0.0, 0.0, 1.0); // Red for debugging

void fragment() {
    float distance_from_player = length(VERTEX - player_position);
    if (distance_from_player < mask_radius) {
        ALPHA = 1.0; // Fully visible
    } else {
        ALPHA = 0.0; // Fully transparent
    }
    ALBEDO = mask_color.rgb;
}
