float hit_sphere(vec3 center, float radius, vec3 rOrigin, vec3 rDirection){
    vec3 oc = rOrigin - center;
    float a = dot(length(rDirection), length(rDirection));
    float half_b = dot(oc, rDirection);
    float c = dot(length(oc), length(oc)) - radius*radius;
    float discriminant = half_b*half_b - a*c;
    if (discriminant < 0.) {
        return -1.;
    } else {
        return (-half_b - sqrt(discriminant) ) / a;
    }
}

vec3 ray_color(vec3 rOrigin, vec3 rDirection){
    float t = hit_sphere(vec3(0.,0.,-1.), .5, rOrigin, rDirection);
    if(t > 0.){
        vec3 N = normalize(rOrigin + normalize(rDirection) * t - vec3(0.,0.,-1.));
        return vec3(.5),vec3(N.x+1.,N.y+1.,N.z+1.) / 2.;
    }
    
    t = (normalize(rDirection).y + 1.) / 2.;
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
