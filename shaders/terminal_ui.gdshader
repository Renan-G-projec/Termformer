shader_type canvas_item;
uniform float frequency: hint_range(0.0, 200.0, 10.0) = 200;
uniform sampler2D SCREEN_TEXTURE: hint_screen_texture;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	float far_from_center = UV.x - 0.5;
	float warped_uv_y = UV.y + UV.y * sin(far_from_center) * far_from_center * 0.2;
	vec2 distorted_uv = vec2(UV.x, warped_uv_y);
	COLOR = texture(SCREEN_TEXTURE, distorted_uv);
	
	float scanline_value = sin(PI * UV.y * frequency);
	COLOR.rgb = COLOR.rgb * scanline_value;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
