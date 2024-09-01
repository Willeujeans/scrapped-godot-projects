shader_type canvas_item;
render_mode unshaded;

uniform sampler2D gradient: hint_default_black;
uniform float mix_amount = 1.0;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, repeat_disable, filter_nearest;

void fragment(){
	vec4 input_color = textureLod(SCREEN_TEXTURE, SCREEN_UV, 0.0);
	float greyscale_value = dot(input_color.rgb, vec3(0.299, 0.587, 0.114));
	vec3 sampled_color = texture(gradient, vec2(greyscale_value, 0.0)).rgb;

	COLOR.rgb = mix(input_color.rgb, sampled_color, mix_amount);
	COLOR.a = input_color.a;
}