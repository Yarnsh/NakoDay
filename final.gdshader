shader_type canvas_item;

uniform sampler2D base : source_color, filter_nearest;

void fragment() {
	vec3 base_color = texture(base, UV).rgb;
	
	COLOR.rgb = base_color;
}
