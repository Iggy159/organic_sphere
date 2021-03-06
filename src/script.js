import './style.css'
import * as THREE from 'three'
import { OrbitControls } from 'three/examples/jsm/controls/OrbitControls.js'
import terrainVertexShader from './shaders/terrain/vertex.glsl'
import terrainFragmentShader from './shaders/terrain/fragment.glsl'


/**
 * Base
 */
// Canvas
const canvas = document.querySelector('canvas.webgl')

// Scene
const scene = new THREE.Scene()

/**
 * Sizes
 */
const sizes = {
    width: window.innerWidth,
    height: window.innerHeight
}

window.addEventListener('resize', () =>
{
    // Update sizes
    sizes.width = window.innerWidth
    sizes.height = window.innerHeight

    // Update camera
    camera.aspect = sizes.width / sizes.height
    camera.updateProjectionMatrix()

    // Update renderer
    renderer.setSize(sizes.width, sizes.height)
    renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2))
})

/**
 * Camera
 */
// Base camera
const camera = new THREE.PerspectiveCamera(75, sizes.width / sizes.height, 0.1, 100)
camera.position.x = 1
camera.position.y = 1
camera.position.z = 1
scene.add(camera)

// Controls
const controls = new OrbitControls(camera, canvas)
controls.enableDamping = true

// const skySphere = {}
// skySphere.geometry = new THREE.SphereBufferGeometry(15, 64, 64)
// skySphere.geometry.rotateX(-Math.PI * 0.5)


// skySphere.material = new THREE.ShaderMaterial({ 
//     wireframe: true,
//     color: 'red'
// })


// skySphere.mesh = new THREE.Mesh(skySphere.geometry, skySphere.material)
// scene.add(skySphere.mesh)

/**
 
 */
 const terrain ={}

 terrain.texture = {}
 terrain.texture.lineCount = 5
 terrain.texture.bigLineWidth = 0.13
 terrain.texture.smallLineWidth = 0.06
 terrain.texture.smallLineAlpha = 0.5 
 terrain.texture.smallLineWidth = 0.01
 terrain.texture.width = 1
 terrain.texture.height = 128
 terrain.texture.canvas = document.createElement('canvas')
 terrain.texture.canvas.width = terrain.texture.width
 terrain.texture.canvas.height = terrain.texture.height
 terrain.texture.canvas.style.position = 'fixed'
 terrain.texture.canvas.style.top = 0
 terrain.texture.canvas.style.left = 0
 terrain.texture.canvas.style.zIndex = 1
 document.body.append(terrain.texture.canvas)

 terrain.texture.context = terrain.texture.canvas.getContext('2d')

 terrain.texture.instance = new THREE.CanvasTexture(terrain.texture.canvas)
 terrain.texture.instance.wrapS = THREE.RepeatWrapping
 terrain.texture.instance.wrapT = THREE.RepeatWrapping
 terrain.texture.instance.magFilter = THREE.NearestFilter
 

 terrain.texture.update = () => {

    terrain.texture.context.clearRect(0, 0, terrain.texture.width, terrain.texture.height)

    const actualBigLineWidth = Math.round(terrain.texture.height * terrain.texture.bigLineWidth)
    terrain.texture.context.globalAlpha = 1
    terrain.texture.context.fillStyle = '#d000ff'

    terrain.texture.context.fillRect(
        0,
        0,
        terrain.texture.width,
        actualBigLineWidth
    )

    const actualSmallLineWidth = Math.round(terrain.texture.height * terrain.texture.smallLineWidth)
    const smallLinesCount = terrain.texture.lineCount - 1

    for(let i = 0; i < smallLinesCount; i++) {
        terrain.texture.context.globalAlpha = terrain.texture.smallLineAlpha
        terrain.texture.context.fillStyle = '#8b00cc'
        terrain.texture.context.fillRect(
            0,
            actualBigLineWidth + Math.round((terrain.texture.height - actualBigLineWidth) / terrain.texture.lineCount) * (i + 1),
            terrain.texture.width,
            actualSmallLineWidth
        )
    }
    terrain.texture.instance.needsUpdate = true
 }

 terrain.texture.update()

 terrain.geometry = new THREE.PlaneGeometry(1, 1, 500, 500)
 terrain.geometry.rotateX(-Math.PI * 0.5)

 terrain.uniforms = {
    uTexture: { value: terrain.texture.instance },
    uElevation: { value: 0 },
    uTime: { value: 0 }
 }

 terrain.material = new THREE.ShaderMaterial({
     transparent: true,
     //blending: THREE.AdditiveBlending,
     side: THREE.DoubleSide,
     vertexShader: terrainVertexShader,
     fragmentShader: terrainFragmentShader,
     uniforms: terrain.uniforms
 })

 terrain.mesh = new THREE.Mesh(terrain.geometry, terrain.material)
 terrain.mesh.scale.set(10,10,10)
 scene.add(terrain.mesh)


/**
 * Renderer
 */

const renderer = new THREE.WebGLRenderer({
    canvas: canvas,
    antialias: true,
})
renderer.setClearColor(0x111111, 1)
renderer.outputEncoding = THREE.sRGBEncoding
renderer.setSize(sizes.width, sizes.height)
renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2))

/**
 * Animate
 */
const clock = new THREE.Clock()
let lastElapsedTime = 0

const tick = () =>
{
    const elapsedTime = clock.getElapsedTime()
    const deltaTime = elapsedTime - lastElapsedTime
    lastElapsedTime = elapsedTime

    terrain.uniforms.uTime.value = elapsedTime
    
    // Update controls
    controls.update()

    // Render
    renderer.render(scene, camera)

    // Call tick again on the next frame
    window.requestAnimationFrame(tick)
}

tick()