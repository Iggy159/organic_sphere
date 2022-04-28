#pragma glslify: noise = require('glsl-noise/simplex/3d');
varying float vElevation;
uniform float uTime;

float getElevation(vec2 _position) {

    float elevation = 0.0;

    vec2 position = _position;
    position.x -= uTime * 0.03;
    position.y -= uTime * 0.1;

    elevation += noise(vec3(
        position * 0.3,
         uTime * 0.001
    )) * .6;

    elevation += noise(vec3(
        (position + 200.0) * 1.0,
         uTime * 0.003
    )) * 0.3;
   
    elevation *= 1.5;

    return elevation;
}

void main() {
    
    vec4 modelPosition = modelMatrix * vec4(position, 1.0);

    float elevation = getElevation(modelPosition.xz);

    modelPosition.y += elevation;
    
    vec4 viewPosition = viewMatrix * modelPosition;
    vec4 projectionPosition = projectionMatrix * viewPosition;
    gl_Position = projectionPosition;

    vElevation = elevation;
}