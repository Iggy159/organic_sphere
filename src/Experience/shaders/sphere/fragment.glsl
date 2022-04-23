varying vec3 vNormal;
varying float vPerlinStrength;
varying vec3 vColor;

void main() {
    float temp = vPerlinStrength + 0.05;
    temp *= 2.0;
    gl_FragColor = vec4(vColor, 0.5);
}