/**
* Crop a texture.
* License: CC0
* https://creativecommons.org/publicdomain/zero/1.0/
*/
shader_type canvas_item;

uniform float crop_left:hint_range(0.0,1.0,0.01) = 0.0;
uniform float crop_right:hint_range(0.0,1.0,0.01) = 0.5;
uniform float crop_top:hint_range(0.0,1.0,0.01) = 0.0;
uniform float crop_bottom:hint_range(0.0,1.0,0.01) = 0.0;

void fragment(){
	vec4 color = texture(TEXTURE,UV);
	if (UV.x<=crop_left || UV.x>=1.0-crop_right || UV.y>=1.0-crop_bottom || UV.y<=crop_top){
		color.a = 0.0;
	}
	COLOR = color;
}