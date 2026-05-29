shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;
uniform float strength = 3.0;

void fragment() {
	vec2 uv = SCREEN_UV;

	vec4 col = vec4(0.0);

	// 9-tap blur (better quality than simple 5-tap)
	for (int x = -1; x <= 1; x++) {
		for (int y = -1; y <= 1; y++) {
			vec2 offset = vec2(float(x), float(y)) * strength * SCREEN_PIXEL_SIZE;
			col += texture(SCREEN_TEXTURE, uv + offset);
		}
	}

	COLOR = col / 9.0;
}