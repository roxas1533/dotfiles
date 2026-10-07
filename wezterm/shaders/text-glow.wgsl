// Ripple effect triggered by cursor movement — background only (idx=0)

fn ripple(uv: vec2<f32>, center: vec2<f32>, age: f32) -> vec2<f32> {
  if (age < 0.0 || age > 4.0) {
    return vec2<f32>(0.0);
  }

  let d = distance(uv, center);
  let speed = 0.08;
  let wave_front = age * speed;
  let wavelength = 0.05;
  let k = 6.2831853 / wavelength;

  let width = 0.12;
  let envelope = exp(-((d - wave_front) * (d - wave_front)) / (2.0 * width * width));

  let fade = exp(-age * 0.8);
  let amp = 0.006 * fade * envelope / max(sqrt(d), 0.01);

  let dir = normalize(uv - center + vec2<f32>(0.0001));
  let wave = sin(k * d - k * wave_front) * amp;

  return dir * wave;
}

@fragment
fn fs_postprocess(in: VertexOutput) -> @location(0) vec4<f32> {
  let aspect = pp.resolution.x / pp.resolution.y;
  let uv = in.uv;
  let uv_aspect = vec2<f32>(uv.x * aspect, uv.y);
  let dt = pp.cursor_move_time;
  let original = textureSample(screen_texture, screen_sampler, uv);

  if (dt > 4.0) {
    return original;
  }

  // Convert cursor positions to UV space
  let prev_uv = pp.cursor_prev_pos / pp.resolution;
  let curr_uv = pp.cursor_pos / pp.resolution;
  let prev_aspect = vec2<f32>(prev_uv.x * aspect, prev_uv.y);
  let curr_aspect = vec2<f32>(curr_uv.x * aspect, curr_uv.y);

  var displacement = vec2<f32>(0.0);

  displacement += ripple(uv_aspect, prev_aspect, dt);
  displacement += ripple(uv_aspect, curr_aspect, dt - 0.1);

  let mid_aspect = (prev_aspect + curr_aspect) * 0.5;
  displacement += ripple(uv_aspect, mid_aspect, dt - 0.2) * 0.6;

  let displaced_uv = clamp(uv + displacement, vec2<f32>(0.001), vec2<f32>(0.999));
  return textureSample(screen_texture, screen_sampler, displaced_uv);
}
