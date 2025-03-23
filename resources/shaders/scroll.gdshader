shader_type canvas_item;

uniform vec2 rate = vec2(0, 1);

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	COLOR = texture(TEXTURE, UV + (rate * TIME));
}