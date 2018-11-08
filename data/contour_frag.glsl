#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform vec4 peak1;
uniform vec4 peak2;
uniform vec4 peak3;

uniform vec3 heights;

float gauss2d(vec2 ds, vec2 sds) {
  float z = ( (pow(ds.x,2) / pow(sds.x,2)) + (pow(ds.y,2) / pow(sds.y,2)));
  return (1.0/(2*3.1415 * sds.x * sds.y)) * pow(2.7182, -z/2);
}

float computeHeightOn(vec4 peak, vec2 p, float h) {
  return gauss2d(p-peak.xy, peak.zw)/gauss2d(vec2(0), peak.zw) * h;
}

vec3 hsv2rgb(vec3 c) {
  vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
  vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
  return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

void main() {
  vec2 coord = gl_FragCoord.xy;

  // if (distance(coord, peak1.xy) < 3){
  //   gl_FragColor = vec4(1,0,0,1);
  //   return;
  // } else if (distance(coord, peak2.xy) < 3) {
  //   gl_FragColor = vec4(0,1,0,1);
  //   return;
  // } else if (distance(coord, peak3.xy) < 3) {
  //   gl_FragColor = vec4(0,0,1,1);
  //   return;
  // }

  float h1 = computeHeightOn(peak1, coord, heights.x);
  float h2 = computeHeightOn(peak2, coord, heights.y);
  float h3 = computeHeightOn(peak3, coord, heights.z);

  float d1 = distance(coord, peak1.xy);
  float d2 = distance(coord, peak2.xy);
  float d3 = distance(coord, peak3.xy);

  float d = d1 + d2 + d3;
  // float d = d1 + d2;

  float h = d1/d*h1 + d2/d*h2 + d3/d*h3;
  float l = h*10;
  float disc = (l - floor(l));

  // gl_FragColor = vec4(hsv2rgb(vec3(1-h,0.75,0.85)),1);
  // return;

  if (disc < 0.165 && h > 0.01) {
      gl_FragColor = vec4(vec3(0.2),1);
  } else {
      gl_FragColor = vec4(vec3(0.93),1);
  }
}