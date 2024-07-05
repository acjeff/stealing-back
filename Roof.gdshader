shader_type spatial;

uniform float wave_amplitude : hint_range(0.0, 1.0) = 0.1;
uniform float wave_frequency : hint_range(0.0, 20.0) = 10.0;
uniform float wave_speed : hint_range(0.0, 10.0) = 1.0;
uniform vec4 base_color : source_color = vec4(0.72, 0.45, 0.20, 1.0); // Copper color
uniform vec4 highlight_color : source_color = vec4(0.95, 0.64, 0.30, 1.0); // Highlight color
uniform float metallic : hint_range(0.0, 1.0) = 1.0;
uniform float roughness : hint_range(0.0, 1.0) = 0.3;

void fragment() {
    vec2 uv = UV;
    float wave = sin(uv.x * wave_frequency + TIME * wave_speed) * wave_amplitude;

    // Adjust UV based on wave for corrugated effect
    uv.y += wave;

    // Blend base and highlight colors based on the wave value
    vec4 color = mix(base_color, highlight_color, wave * 0.5 + 0.5);

    ALBEDO = color.rgb;
    METALLIC = metallic;
    ROUGHNESS = roughness;

    // Normal mapping for the corrugated effect
    vec3 normal = normalize(vec3(wave_amplitude * cos(uv.x * wave_frequency + TIME * wave_speed), 1.0, 0.0));
	NORMAL = normal;
    //NORMAL = normalize((NORMALMAP * 2.0 - 1.0) + normal);
}
