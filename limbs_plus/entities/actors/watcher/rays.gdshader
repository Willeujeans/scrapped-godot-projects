shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 current_pixel = texture(TEXTURE, UV);
	if (current_pixel == vec4(1.0, 1.0, 1.0, 1.0)){
		COLOR = vec4(1.0, 1.0, 1.0, 0.5);
	}
}

