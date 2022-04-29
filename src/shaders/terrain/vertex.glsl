#pragma glslify: noise = require('glsl-noise/simplex/3d');

varying float vElevation;
uniform float uTime;
uniform float uElevation;
uniform float uElevationValleyFrequency;
uniform float uElevationValley;
uniform float uElevationGeneral;
uniform float uElevationGeneralFrequency;
uniform float uElevationDetails;
uniform float uElevationDetailsFrequency;

float getElevation(vec2 _position) {

    float elevation = 0.0;

    // float valleyStrength = cos(_position.y * uElevationValleyFrequency + 3.1415) * 0.5 + 0.5;

    // elevation += valleyStrength * uElevationValley;

    // elevation += noise(_position * uElevationGeneralFrequency) * uElevationGeneral * (valleyStrength + 0.1);
    
    // // Smaller details
    // elevation += noise(_position * uElevationDetailsFrequency + 123.0) * uElevationDetails * (valleyStrength + 0.1);

    // elevation *= uElevation;

    

    vec2 position = _position;
    position.x -= uTime * 0.03;
    position.y -= uTime * 0.1;

    elevation += noise(vec3(
        position * .7,
         uTime * 0.001
    )) * .3;

    elevation += noise(vec3(
        (position * .4) * 1.0,
         uTime * 0.003
    )) * .9;
   
    elevation *= .8;

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