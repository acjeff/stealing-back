shader_type spatial;

uniform float transparency : hint_range(0.0, 1.0) = 1.0;
uniform sampler2D albedo_texture;

void fragment() {
    vec4 albedo_color = texture(albedo_texture, UV);
    //albedo_color.a *= transparency;
    //ALBEDO = albedo_color.rgb;
    ALPHA = albedo_color.a;
}

//render_mode blend_mix, depth_draw_opaque, cull_back, unshaded;
