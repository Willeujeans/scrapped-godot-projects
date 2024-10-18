shader_type canvas_item;

uniform sampler2D vertical_gradient; // used to set alpha values. So you can use this to make the effect dis-/re-appear at points
uniform sampler2D color_gradient; // sets the effect color, supports 2d gradients
uniform float size_effect: hint_range(-5.0, 5.0, 0.05) = 0.1; // size of the effect
uniform float speed = 1; // effect speed; Will reverse effect if set to negative
uniform float highlight_strength: hint_range(-4.0, 4.0, 0.05) = 0.5; // how strong the color overrides the base color
uniform bool color_mode_toggle = false; // changes how the color gradient is applied. Default is on the entire texture, if set to true it is only applied to the effect
uniform float angle = 45.0; // angle of the diagonal effect in degrees
uniform float extend_factor: hint_range(1.0, 10.0) = 2.0; // factor to extend the swipe effect

void fragment() {
    // Set up base parameters
    vec4 old_color = COLOR;
    float time = TIME * speed;
    float current_time = fract(-time);
    current_time = mix(-size_effect * extend_factor, 1.0 + size_effect * extend_factor, current_time); // Start effect further off the object

    // Calculate diagonal position
    float angle_rad = angle * 3.14159 / 180.0; // Convert to radians
    float diag_position_value = UV.x * cos(angle_rad) + UV.y * sin(angle_rad);

    // Set the effect bounds based on the current_time
    float effect_lower_bound = current_time - size_effect * extend_factor;
    float effect_upper_bound = current_time + size_effect * extend_factor;

    // Smooth out the lower/upper bounds with the UV values
    float effect_distance = smoothstep(effect_lower_bound, current_time, diag_position_value) - smoothstep(current_time, effect_upper_bound, diag_position_value);

    // Inner effect position
    float inner_effect_position = smoothstep(effect_lower_bound, effect_upper_bound, diag_position_value);
    vec2 color_position = (color_mode_toggle) ? vec2(UV.x, inner_effect_position) : vec2(current_time);

    // Get the new color from the gradient
    vec4 new_color = vec4(texture(color_gradient, color_position));

    // Calculate the vertical gradient and alpha values
    new_color = mix(old_color, new_color, vec4(texture(vertical_gradient, vec2(current_time))));

    // Apply the color to the texture
    COLOR.rgb = mix(old_color.rgb, new_color.rgb, vec3(effect_distance * highlight_strength));
}
