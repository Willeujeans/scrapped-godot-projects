shader_type canvas_item;

void fragment() {
    vec4 curr_color = texture(TEXTURE,UV);
	if(curr_color.a > 0.0){
		COLOR = vec4(0.25,0.25,0.25,0.25);
	}
}