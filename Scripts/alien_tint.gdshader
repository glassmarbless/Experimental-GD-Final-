shader_type spatial;

render_mode unshaded, cull_disabled, blend_mix;

uniform sampler2D albedo_texture : source_color;
uniform vec4 tint_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);

void fragment() {
	vec4 tex = texture(albedo_texture, UV);

	ALBEDO = tex.rgb * tint_color.rgb;
	ALPHA = tex.a * tint_color.a;
}