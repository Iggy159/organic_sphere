uniform sampler2D uTexture;

varying float vElevation;
uniform float uTime;

void main() {

    vec4 textureColor = texture2D(uTexture, vec2(1.0, (vElevation * 20.0) / 0.5));
    //vec4 textureColor = texture2D(uTexture, vec2(1.0, (vElevation * 10.0) * 0.8));

    gl_FragColor = textureColor;
}