uniform sampler2D uTexture;

varying float vElevation;

void main() {

    vec4 textureColor = texture2D(uTexture, vec2(0.0, vElevation * 12.0));

    gl_FragColor = textureColor;
}