const int LIGHT_COUNT = 1;
extern vec3 light_position[LIGHT_COUNT];
extern vec3 light_diffuse[LIGHT_COUNT];

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 pixel_coords) {
   vec4 diffuse = Texel(texture, texture_coords);
   vec4 channels = Texel(texture, texture_coords + vec2(0.66667, 0));
   float ao = channels.r;
   float bypass = channels.g;

   vec3 normal = Texel(texture, texture_coords + vec2(0.3333, 0)).rgb;
   normal.y = 1 - normal.y;
   normal = normalize(mix(vec3(-1), vec3(1), normal));

   vec3 light;
   for (int i = 0; i < light_position.length(); i++) {      
      vec3 light_direction = light_position[i] - vec3(pixel_coords, 0);
      float dist = length(light_direction);
      float attenuation = smoothstep(100, 50, dist);
      light_direction = normalize(light_direction);
      vec3 current_light = light_diffuse[i] * attenuation * clamp(dot(normal, light_direction), 0.0, 1.0);
      //light += light_diffuse[i] * attenuation * clamp(dot(normal, light_direction), 0.0, 1.0);
      if (length(current_light) > length(light)) {
         light = current_light;
      }
   }
   //light *= (0.3 + ao*0.7);
   light *= ao;

   vec3 dark_color = vec3(0.0, 0.0, 1);
   vec3 light_color = vec3(1, 1, 0.0);
   vec3 gooch_light = mix(dark_color, light_color, light) * 0.15;

   //float cel_light = smoothstep(0.49, 0.52, length(light))*0.6 + 0.4;
   vec3 cel_light = smoothstep(0.49, 0.52, light) * 0.6 + 0.4;
   //smoothstep(0.49, 0.52, length(light))

   //return vec4(mix(diffuse.rgb, (length(light) != 0 ? normalize(light) : vec3(0.57)) * cel_light * diffuse.rgb + gooch_light, bypass), diffuse.a);
   return vec4(mix(diffuse.rgb, cel_light * diffuse.rgb + gooch_light, bypass), diffuse.a);
}