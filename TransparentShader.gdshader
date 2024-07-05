shader_type spatial;

void fragment() {
    ALPHA = 0.5;
    ALBEDO = vec3(1.0, 0.5, 0.5);  // Optional: Set a color for the transparent material
}
