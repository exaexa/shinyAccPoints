HTMLWidgets.widget({

  name: 'accPoints',

  type: 'output',

  factory: function(el, width, height) {

    // TODO: define shared variables for this instance here
		var scene = null;
		var camera = null;
		var renderer = null;
		var material = null;

		var n_points = 0;
		var geometry = null;
		var positions = null;
		var colors = null;

    return {

      renderValue: function(data) {

				console.log("render start")

        // TODO: code to render the widget, e.g.

				if(renderer===null) {
					renderer = new THREE.WebGLRenderer();
					renderer.setSize(width, height);
					renderer.setClearColor(0xffffff);
					renderer.setPixelRatio(window.devicePixelRatio);
					el.appendChild(renderer.domElement);

					material = new THREE.RawShaderMaterial({
						vertexColors: THREE.VertexColors,
						transparent: true,
						uniforms: {
							size: { value: 3 },
						},
						vertexShader:`
							precision mediump float;
							precision mediump int;
							uniform mat4 modelViewMatrix;
							uniform mat4 projectionMatrix;
							uniform float size;
							attribute vec3 position;
							attribute vec4 color;
							varying vec3 vPosition;
							varying vec4 vColor;
							void main()	{
								vPosition = position;
								vColor = color;
								gl_PointSize = size;
								gl_Position = projectionMatrix * modelViewMatrix * vec4( position, 1.0 );
							}
						`,
						fragmentShader: `
							precision mediump float;
							precision mediump int;
							varying vec3 vPosition;
							varying vec4 vColor;
							void main()	{
								gl_FragColor = vColor;
							}
						`,
					});
				}

				scene = new THREE.Scene();

				camera = new THREE.OrthographicCamera
					(data.xlim[0], data.xlim[1],
					 data.ylim[1], data.ylim[0],
					 -1,1);

				camera.position.z = 0.5;
				camera.updateMatrixWorld();
				camera.updateProjectionMatrix();

				n_points = data.x.length;
				geometry = new THREE.BufferGeometry();
				positions = new Float32Array(n_points*3);
				colors = new Float32Array(n_points*4);

				for(var i=0; i<n_points; i++) {
					positions[3*i+0] = data.x[i];
					positions[3*i+1] = data.y[i];
					positions[3*i+2] = 0;
					colors[4*i+0] = data.r[i]/255;
					colors[4*i+1] = data.g[i]/255;
					colors[4*i+2] = data.b[i]/255;
					colors[4*i+3] = data.a[i]/255;
				}

				geometry.addAttribute('position', new THREE.BufferAttribute(positions, 3));
				geometry.addAttribute('color', new THREE.BufferAttribute(colors, 4));
				geometry.computeBoundingBox();

				var points = new THREE.Points(geometry, material);
				points.position.set(0,0,0);

				scene.add(points);

				function animate() {
					//TODO is it worth to try to minimize redraws?
					requestAnimationFrame(animate);
					renderer.render(scene, camera);
				}

				animate();
      },

      resize: function(width, height) {

        renderer.setSize(width, height);

				renderer.render(scene, camera);
      }

    };
  }
});
