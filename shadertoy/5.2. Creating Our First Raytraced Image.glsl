bool hit_sphere(vec3 center, float radius, vec3 rOrigin, vec3 rDirection){
    vec3 oc = rOrigin - center;
    float a = dot(rDirection, rDirection);
    float b = 2.0 * dot(oc, rDirection);
    float c = dot(oc, oc) - radius*radius;
    float discriminant = b*b - 4.*a*c;
    return (discriminant > 0.);
}

vec3 ray_color(vec3 rOrigin, vec3 rDirection){
    if (hit_sphere(vec3(0,0,-1), 0.5, rOrigin, rDirection))
        return vec3(1, 0, 0);
    float t = (normalize(rDirection).y + 1.) / 2.;
    return mix(vec3(1.,1.,1.), vec3(.5,.7,1.), t);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord ){
    //Image
    float aspect_ratio = iResolution.x / iResolution.y;
    float image_width = iResolution.x;
    float image_height = iResolution.y;
    
    //Camera
    float viewport_height = 2.0;
    float viewport_width = aspect_ratio * viewport_height;
    float focal_length = 1.0;
    
    vec3 origin = vec3(0, 0, 0);
    vec3 horizontal = vec3(viewport_width, 0, 0);
    vec3 vertical = vec3(0, viewport_height, 0);
    vec3 lower_left_corner = origin - horizontal/2. - vertical/2. - vec3(0, 0, focal_length);
    
    // Render
    vec2 uv = fragCoord/iResolution.xy;
    vec3 pixel_color = ray_color(origin, lower_left_corner + uv.x*horizontal + uv.y*vertical - origin);
    
    fragColor = vec4(pixel_color,1.0);
}
