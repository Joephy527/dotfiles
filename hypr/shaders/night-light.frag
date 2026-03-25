#version 300 es

precision highp float;
in vec2 v_texcoord;
uniform sampler2D tex;

layout(location = 0) out vec4 fragColor;

void main() {
    vec4 color = texture(tex, v_texcoord);
    vec3 warmed = vec3(color.r * 1.03, color.g * 0.92, color.b * 0.78);
    fragColor = vec4(clamp(warmed, 0.0, 1.0), color.a);
}
