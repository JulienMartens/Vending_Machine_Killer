shader_type sky;
render_mode use_half_res_pass;

// Day Background Colors
group_uniforms day_bg_color;
uniform vec4 day_bottom_color : source_color = vec4(0.4, 1.0, 1.0, 1.0);
uniform vec4 day_top_color : source_color = vec4(0.0, 0.8, 1.0, 1.0);

// Night Background Colors
group_uniforms night_bg_color;
uniform vec4 night_bottom_color : source_color = vec4(0.0, 0.0, 0.2, 1.0);
uniform vec4 night_top_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);


// Cloud stuff
group_uniforms clouds;
uniform sampler2D cloud_noise1 : hint_default_black;
uniform sampler2D cloud_noise2 : hint_default_black;
uniform sampler2D base_noise : hint_default_black;
uniform vec4 cloud_edge_day_color : source_color = vec4(0.9, 0.9, 0.9, 1.0);
uniform vec4 cloud_main_day_color : source_color = vec4(1.0);
uniform vec4 cloud_edge_night_color : source_color = vec4(0.15, 0.19, 0.25, 1.0);
uniform vec4 cloud_main_night_color : source_color = vec4(0.15, 0.16, 0.20, 1.0);
uniform float cloud_speed_1 = 0.01;
uniform float cloud_speed_2 = 0.02;
uniform float cloud_speed_3 = 0.02;
uniform float cloud_scale_1 = 0.425;
uniform float cloud_scale_2 = 0.074;
uniform float cloud_scale_3 = 0.075;
uniform float cloud_distortion = 1.95;
uniform float cloud_strength = 1.0;
uniform float cloud_cutoff = 0.013;
uniform float cloud_fuzziness = 0.261;

void sky() {
	// get skyUV to place the sun and the moon
	vec2 skyUV = EYEDIR.xz / EYEDIR.y;
	
	// Unused variable? Removing this unneccessary texture sample
//	float base_n = texture(base_noise, (skyUV - TIME) * base_noise_scale).x;
	
	//Sky Background Gradient 
	// day color gradient
	vec3 gradientDay = mix(day_bottom_color.rgb, day_top_color.rgb, clamp(EYEDIR.y, 0.0, 1.0));
	// night color gradient
	vec3 gradientNight = mix(night_bottom_color.rgb, night_top_color.rgb, clamp(EYEDIR.y, 0.0, 1.0));
	vec3 skyGradients = mix(gradientNight, gradientDay, clamp(LIGHT0_DIRECTION.y, 0.0, 1.0));
	
	vec3 sky = skyGradients;
	
	
	// Clouds
	// UV space illusion
	// (I have no idea how MinionsArt learned how to do this but its amazing)
	vec2 cloud_uv = EYEDIR.xz / EYEDIR.y;
	// Sample Noise at different levels
	float bn = texture(base_noise, (cloud_uv - TIME * cloud_speed_1) * cloud_scale_1).r;
	float cn1 = texture(cloud_noise1, ((cloud_uv + bn * cloud_distortion) - TIME * cloud_speed_2) * cloud_scale_2).r;
	float cn2 = texture(cloud_noise2, ((cloud_uv + cn1 * cloud_strength) - TIME * cloud_speed_3) * cloud_scale_3).r;
	// Combine noise and chop it up
	float fc = clamp(cn1 * cn2, 0.0, 1.0) * clamp(EYEDIR.y, 0.0, 1.0);
	float cc = smoothstep(cloud_cutoff, cloud_cutoff + cloud_fuzziness, fc);
	// Mix colors according to time of day
	vec4 cloud_color_day = mix(cloud_edge_day_color, cloud_main_day_color, cc);
	vec4 cloud_color_night = mix(cloud_edge_night_color, cloud_main_night_color, cc);
	float linear_day_to_night = LIGHT0_DIRECTION.y * 0.5 + 0.5;
	vec4 cloud_color = mix(cloud_color_night, cloud_color_day, linear_day_to_night);
	
	COLOR = mix(sky, cloud_color.rgb, cc * cloud_color.a);
}