import React, { useRef, useEffect } from 'react';
import * as THREE from 'three';
import { GLTFLoader } from 'three/examples/jsm/loaders/GLTFLoader';

const GLBViewer = ({ url, width = 300, height = 300 }) => {
    const mountRef = useRef(null);

    useEffect(() => {
        if (!url) return;
        const scene = new THREE.Scene();
        const camera = new THREE.PerspectiveCamera(75, width / height, 0.1, 1000);
        camera.position.z = 2.5;

        const renderer = new THREE.WebGLRenderer({ antialias: true, alpha: true });
        renderer.setSize(width, height);
        mountRef.current.appendChild(renderer.domElement);

        const ambientLight = new THREE.AmbientLight(0xffffff, 1.2);
        scene.add(ambientLight);
        const directionalLight = new THREE.DirectionalLight(0xffffff, 0.8);
        directionalLight.position.set(0, 1, 1);
        scene.add(directionalLight);

        const loader = new GLTFLoader();
        loader.load(
            url,
            (gltf) => {
                scene.add(gltf.scene);
                animate();
            },
            undefined,
            (error) => {
                console.error('Error loading GLB:', error);
            }
        );

        function animate() {
            requestAnimationFrame(animate);
            renderer.render(scene, camera);
        }

        return () => {
            renderer.dispose();
            while (mountRef.current && mountRef.current.firstChild) {
                mountRef.current.removeChild(mountRef.current.firstChild);
            }
        };
    }, [url, width, height]);

    return <div ref={mountRef} style={{ width, height }} />;
};

export default GLBViewer;
