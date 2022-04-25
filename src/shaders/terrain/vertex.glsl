#pragma glslify: noise = require('glsl-noise/simplex/3d');
varying float vElevation;

float getElevation(vec3 _position) {

    float elevation = 0.0;
    elevation += noise(vec3(
        _position.xz * 0.3,
         0.0
    )) * 0.4;

    elevation += noise(vec3(
        (_position.xz + 200.0) * 1.0,
         0.0
    )) * 0.2;
   
    elevation *= 2.;

    return elevation;
}

void main() {
    
    vec4 modelPosition = modelMatrix * vec4(position, 1.0);

    float elevation = getElevation(modelPosition.xyz);

    modelPosition.y += elevation;
    
    vec4 viewPosition = viewMatrix * modelPosition;
    vec4 projectionPosition = projectionMatrix * viewPosition;
    gl_Position = projectionPosition;

    vElevation = elevation;
}