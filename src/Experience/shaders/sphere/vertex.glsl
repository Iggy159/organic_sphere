#define M_PI 3.1415926535897932384626433832795

uniform vec3 uLightAColor;
uniform vec3 uLightAPosition;
uniform float uLightAIntensity;
uniform vec3 uLightBColor;
uniform vec3 uLightBPosition;
uniform float uLightBIntensity;

uniform float uTime;

uniform vec2 uSubdivision;
uniform vec3 uOffset;

uniform float uDistortionFrequency;
uniform float uDistortionStrength;
uniform float uDisplacementFrequency;
uniform float uDisplacementStrength;

varying vec3 vNormal;
varying float vPerlinStrength;

varying vec3 vColor;

uniform float uFresnelOffset;
uniform float uFresnelMultiplier;
uniform float uFresnelPower;

#pragma glslify: perlin4d = require('../partials/perlin4d.glsl')
#pragma glslify: perlin3d = require('../partials/perlin3d.glsl')

vec3 getDisplacedPosition(vec3 _position)
{
    vec3 distoredPosition = _position;
    distoredPosition += perlin4d(vec4(distoredPosition * uDistortionFrequency + uOffset, uTime)) * uDistortionStrength;

    float perlinStrength = perlin4d(vec4(distoredPosition * uDisplacementFrequency + uOffset, uTime));
    
    vec3 displacedPosition = _position;
    displacedPosition += normalize(_position) * perlinStrength * uDisplacementStrength;

    return displacedPosition;
}

void main() {

    // Position
    vec3 displacedPosition = getDisplacedPosition(position);
    vec4 viewPosition = viewMatrix * vec4(displacedPosition, 1.0);
    gl_Position = projectionMatrix * viewPosition;

    vec3 newPosition = position;

    vec3 displacementPosition = position;
    displacementPosition += perlin4d(vec4(displacementPosition * uDistortionFrequency, uTime * 0.00005)) * uDistortionStrength;
    
    float perlinStrength = perlin4d(vec4(displacementPosition, uTime * 0.0005)) * uDisplacementStrength;
    
    newPosition += normal * perlinStrength;



    float distanceA = (M_PI * 2.0) / uSubdivision.x;
    float distanceB = M_PI / uSubdivision.x;

    vec3 biTangent = cross(normal, tangent.xyz);

    vec3 positionA = position + tangent.xyz * distanceA;
    vec3 displacedPositionA = getDisplacedPosition(positionA);

    vec3 positionB = position + biTangent.xyz * distanceB;
    vec3 displacedPositionB = getDisplacedPosition(positionB);

    vec3 computedNormal = cross(displacedPositionA - displacedPosition.xyz, displacedPositionB - displacedPosition.xyz);
    computedNormal = normalize(computedNormal);

    //Color
    vec3 uLightAColor = vec3(1.0, 0.59, 0.24);
    vec3 uLightAPosition = vec3(1.0, 1.0, 0.0);
    float lightAIntensity = - dot(computedNormal.xyz, normalize(- uLightAPosition));

    vec3 uLightBColor = vec3(0.34, 0.56, 1.0);
    vec3 uLightBPosition = vec3(-1.0, -1.0, 0.0);
    float lightBIntensity = - dot(computedNormal.xyz, normalize(- uLightBPosition));

    vec3 color = vec3(0.0);
    color = mix(color, uLightAColor, lightAIntensity);
    color = mix(color, uLightBColor, lightBIntensity);

    vNormal = normal;
    vPerlinStrength = perlinStrength;
    vColor = color;

}