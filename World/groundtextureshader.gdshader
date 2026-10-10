shader_type canvas_item;

/**
* The texture you want to overlay onto your tilemap. This uses filter_nearest by default to prevent blurry textures.
**/
uniform sampler2D overlay_texture: filter_nearest;
/**

* Optional color overlay for your base texture. The final base sprite will be multiplied with this. Keep as white if you want your original colors.
**/
uniform vec4 base_color: source_color = vec4(1.0);
/**

* Optional color overlay for the overlay texture. The final overlay will be multiplied with this color. Keep white if you want the original colors.
**/
uniform vec4 overlay_color: source_color = vec4(1.0);

/**
* The scale to apply to the texture. Adjust until your texture tiles properly and is the size you want.
* Note: If you want to allow for sub-pixels, you can change this to a float instead.
**/
uniform int scale = 1;

/**
* How much to offset the texture by as a percentage of the image width and height. Useful for either randomizing texture placement or tweaking alignment.
**/
uniform vec2 offset = vec2(0.0, 0.0);

// Store the vertex position during the vertex call so we can use during fragment
varying vec2 vert;


void vertex() {
	// Determine position accounting for scale and offset
	vert = (VERTEX / float(scale) + (vec2(offset)));
}

void fragment() {
	vec2 tiled_position =  fract(vert);
	
	// Create a texture from the overlay texture with our tiled position as the coordinates, then multiply w/ overlay color and base color
	vec4 overlay = texture(overlay_texture, (tiled_position));;
	overlay *= overlay_color * COLOR;

	// The actual base color
	vec4 combined_color = COLOR * base_color;
	
	if(overlay.a == 0.0) {
		COLOR = combined_color;
	}
	else {
		COLOR = overlay;
	}

	
}
