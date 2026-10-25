shader_type canvas_item;
// Wyblakły obraz z wyobraźni Antoniego: sepia, winieta, ziarno i lekkie drżenie.

uniform sampler2D ekran : hint_screen_texture, filter_nearest;
uniform float trzask = 0.0;  // 0-1, obraz trzeszczy (przymierzanie)

float szum(vec2 p) {
	return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453);
}

void fragment() {
	vec2 uv = SCREEN_UV;
	uv.x += (szum(vec2(floor(uv.y * 90.0), floor(TIME * 12.0))) - 0.5) * 0.02 * trzask;
	vec3 k = texture(ekran, uv).rgb;
	float j = dot(k, vec3(0.3, 0.59, 0.11));
	vec3 sepia = vec3(j * 1.1 + 0.06, j * 0.95 + 0.04, j * 0.75 + 0.02);
	vec2 d = SCREEN_UV - 0.5;
	float winieta = 1.0 - dot(d, d) * 1.6;
	float ziarno = (szum(SCREEN_UV * 400.0 + TIME) - 0.5) * 0.08;
	COLOR = vec4(mix(sepia, vec3(0.9, 0.85, 0.7), 0.12) * winieta + ziarno, 1.0);
}
