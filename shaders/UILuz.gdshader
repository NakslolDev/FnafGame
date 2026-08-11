shader_type canvas_item;

uniform vec2 mouse_pos;
uniform float radio = 10.0;
uniform vec2 viewport_size;
uniform float fade_range = 380.0;
uniform float shader_enabled = 0.0;
uniform float transparencia = 0.0;
uniform float nivel_transparencia = 0.0;
uniform bool active = false;

void fragment() {
	vec4 tex = texture(TEXTURE, UV);

	// COLOR ya contiene el modulate del Sprite2D
	COLOR = tex * COLOR;

	if (transparencia >= 0.5) {
		COLOR.a *= nivel_transparencia;
	}

	if (active) {
		if (shader_enabled < 0.5) {
			COLOR.a = 0.0;
		} else {
			vec2 screen_pixel = SCREEN_UV * viewport_size;
			float dist = distance(screen_pixel, mouse_pos);

			if (dist > radio + fade_range) {
				COLOR.a = 0.0;
			} else if (dist > radio) {
				float fade = 1.0 - (dist - radio) / fade_range;
				COLOR.a *= fade;
			}
		}
	}
}