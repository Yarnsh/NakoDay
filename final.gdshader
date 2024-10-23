shader_type canvas_item;

uniform sampler2D base : source_color, filter_nearest;
//uniform sampler2D horns : source_color, filter_nearest;

vec4 overlay(vec4 a, vec4 b) {
	return vec4((a.rgb * (1.0 - b.a)) + (b.rgb * b.a), max(a.a, b.a));
}

void fragment() {
	vec4 base_color = texture(base, UV);
	//vec4 horns_color = texture(horns, UV);
	
	COLOR.rgb = base_color.rgb;
	//COLOR.rgb = overlay(base_color, horns_color).rgb;
}
