shader_type canvas_item;
uniform sampler2D SCREEN_TEXTURE: hint_screen_texture;

uniform bool overlay = false;

uniform float scanlines_opacity : hint_range(0.0, 1.0) = 0.4;
uniform float scanlines_width : hint_range(0.0, 0.5) = 0.25;
uniform vec2 resolution = vec2(640.0, 480.0); // Set the number of rows and columns the texture will be divided in. Scanlines and grille will make a square based on these values

//uniform bool pixelate = true; // Fill each square ("pixel") with a sampled color, creating a pixel look and a more accurate representation of how a CRT monitor would work.

uniform float brightness = 1.4; // When adding scanline gaps and grille the image can get very dark. Brightness tries to compensate for that.
//uniform bool discolor = true; // Add a discolor effect simulating a VHS

uniform float warp_amount :hint_range(0.0, 5.0) = 1.0; // Warp the texture edges simulating the curved glass of a CRT monitor or old TV.
uniform bool clip_warp = false;

//const float midpoint = pow(0.5, 2.2);

void fragment()
{
	vec2 uv = SCREEN_UV; // Warp the uv. uv will be used in most cases instead of UV to keep the warping
	vec2 text_uv = uv;
	float time = 0.0;
	

	// Pixelate the texture based on the given resolution.
	//if (pixelate)
	//{
		//text_uv = ceil(uv * resolution) / resolution;
	//}
	
	vec4 text;

	text.r = texture(SCREEN_TEXTURE, text_uv).r;
	text.g = texture(SCREEN_TEXTURE, text_uv).g;
	text.b = texture(SCREEN_TEXTURE, text_uv).b;
	text.a = 1.0;
	
	float r = text.r;
	float g = text.g;
	float b = text.b;
	
	
	// Apply the grille to the texture's color channels and apply Brightness. Since the grille and the scanlines (below) make the image very dark you
	// can compensate by increasing the brightness.
	text.r = clamp(r * brightness, 0.0, 1.0);
	text.g = clamp(g * brightness, 0.0, 1.0);
	text.b = clamp(b * brightness, 0.0, 1.0);
	
	// Scanlines are the horizontal lines that make up the image on a CRT monitor. 
	// Here we are actual setting the black gap between each line, which I guess is not the right definition of the word, but you get the idea  
	float scanlines = 0.5;
	if (scanlines_opacity > 0.0)
	
	// Same technique as above, create lines with sine and applying it to the texture. Smoothstep to allow setting the line size.
	scanlines = smoothstep(scanlines_width, scanlines_width + 0.5, abs(sin(uv.y * (resolution.y * 3.14159265))));
	text.rgb = mix(text.rgb, text.rgb * vec3(scanlines), scanlines_opacity);

	float saturation = 0.5;
	float contrast = 1.2;
	//if (discolor)
	//{
		//vec3 greyscale = vec3(text.r + text.g + text.b) / 3.;
		//text.rgb = mix(text.rgb, greyscale, saturation);
		//
		//text.rgb = (text.rgb - vec3(midpoint)) * contrast + midpoint;
	//}
	
	COLOR = text;
}