shader_type spatial;

uniform float wave_speed = 1.0;
uniform float wave_magnitude = 2.0;
uniform float uv_magnitude = 100.0;
varying float y;

void vertex() {
	y = sin((TIME * wave_speed) + ((UV.y) * uv_magnitude)) * wave_magnitude;
	y += sin((TIME * wave_speed * 0.5) + ((UV.x * -0.5 - UV.y) * uv_magnitude * 0.5)) * wave_magnitude * 0.3;
	y -= sin((TIME * wave_speed * 1.5) + ((UV.x) * uv_magnitude * 1.1)) * wave_magnitude * 0.3;
	VERTEX.y = y;
}

void fragment() {
	ALBEDO = vec3(0.2, 0.3, 0.8) * y; // TODO proper foam and whatever
}
