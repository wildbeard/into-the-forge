shader_type canvas_item;

uniform vec4 heat_color : source_color = vec4(1.0);
uniform float opacity : hint_range(0.0, 1.0, 0.1) = 0.5;

void fragment() {
	vec4 mainTexture = texture(TEXTURE, UV);
	vec4 finalColor = mainTexture;
	finalColor.rgb = mix(mainTexture.rgb * (1.0 - opacity), heat_color.rgb * opacity, opacity);
	
	COLOR = finalColor;
}