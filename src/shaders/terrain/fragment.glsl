uniform sampler2D uTexture;

varying float vElevation;
uniform float uTime;

void main() {

    vec4 textureColor = texture2D(uTexture, vec2(0.0, vElevation * 20.0));

    gl_FragColor = textureColor;
}