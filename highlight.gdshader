shader_type canvas_item;


uniform vec2 highlight_position = vec2(0.0, 0.0);
uniform float highlight_radius = 8.0; // The radius of the highlight in tiles.
uniform vec4 highlight_color: source_color = vec4(1.0, 0.5, 0.5, 0.5); // Highlight color.

void fragment() {
    // Calculate the world position of the current pixel.
    vec2 world_position = (FRAGCOORD.xy / SCREEN_PIXEL_SIZE);

    // Calculate the tile coordinate of the fragment.
    vec2 tile_position = floor(world_position / vec2(16.0, 16.0)); // Assuming tile size is 16x16.

    // Calculate the distance from the highlight center.
    float dist = distance(tile_position, highlight_position);

    // If the distance is within the highlight radius, apply the highlight color.
    if (dist < highlight_radius) {
        vec4 current_color = texture(TEXTURE, UV);
        vec4 blend_color = highlight_color * (1.0 - dist / highlight_radius);
        COLOR = mix(current_color, blend_color, 0.5);
    } else {
        // Otherwise, keep the original color.
        COLOR = texture(TEXTURE, UV);
    }
}