shader_type canvas_item;
render_mode blend_premul_alpha;

uniform vec4 chroma_key : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform float intensity : hint_range(0.0, 1.0) = 0.01;

uniform vec2 mouse_pos;
uniform float radio = 10.0;
uniform vec2 viewport_size;
uniform float fade_range = 380.0;
uniform float shader_enabled = 0.0;

uniform float transparencia = 1.0;
uniform float nivel_transparencia = 0.0;

void fragment() {

	vec4 tex = texture(TEXTURE, UV);

	// =========================
	// CHROMA KEY
	// =========================

	vec3 color_diff = abs(tex.rgb - chroma_key.rgb);
	float diff_magnitude = length(color_diff);

	if (diff_magnitude < intensity) {
		discard;
	}


	// =========================
	// TRANSPARENCIA
	// =========================

	float alpha = tex.a;

	if (transparencia >= 0.5) {
		alpha *= nivel_transparencia;
	}


	// =========================
	// LINTERNA
	// =========================

	if (shader_enabled >= 0.5) {
		vec2 screen_pixel = SCREEN_UV * viewport_size;
		float dist = distance(screen_pixel, mouse_pos);

		if (dist < radio) {
			alpha = 0.0;
		}
		else if (dist < radio + fade_range) {
			float fade = (dist - radio) / fade_range;
			alpha *= fade;
		}
	}


	tex.a = alpha;
	tex.rgb *= alpha; // premultiplicar el color por el nuevo alpha
	COLOR = tex;
}