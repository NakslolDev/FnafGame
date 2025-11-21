shader_type canvas_item;

uniform vec2 mouse_pos;
uniform float radio = 0.0;
uniform vec2 viewport_size;
uniform float fade_range = 380.0;
uniform float shader_enabled = 0.0;
uniform float transparencia = 0.0; // 1.0 = fondo semitransparente, 0.0 = opaco
uniform float nivel_transparencia = 0.0;

void fragment() {
    vec4 tex = texture(TEXTURE, UV);
    vec2 screen_pixel = SCREEN_UV * viewport_size;
    float dist = distance(screen_pixel, mouse_pos);

    float alpha = tex.a;

    // 🌫️ Aplicar transparencia general SIEMPRE si está activada
    if (transparencia >= 0.5) {
        alpha *= nivel_transparencia;
    }

    // 🔦 Aplicar solo si el shader (linterna) está activado
    if (shader_enabled >= 0.5) {
        if (dist < radio) {
            alpha = 0.0;
        } else if (dist < radio + fade_range) {
            float fade = (dist - radio) / fade_range;
            alpha *= fade;
        }
    }

    tex.a = alpha;
    COLOR = tex;
}
