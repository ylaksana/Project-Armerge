shader_type canvas_item;

uniform vec4 hit_flash_color: source_color = vec4(1.0,1.0,1.0,1.0);
uniform bool hit_flash_on = false;


void fragment(){
    if (hit_flash_on) {
        COLOR = vec4(1.0, 1.0, 1.0, COLOR.a);
    }
}
