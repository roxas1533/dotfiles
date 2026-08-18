// Cursor trail shader — Kitty-style deforming quad with exponential decay
// The 4 corners of the cursor rectangle independently chase their targets.
// Leading corners (closer to destination) decay faster, trailing corners slower.

// Check if point is inside a convex quad defined by 4 corners (in order)
fn cross2d(a: vec2<f32>, b: vec2<f32>) -> f32 {
  return a.x * b.y - a.y * b.x;
}

fn point_in_quad(p: vec2<f32>, a: vec2<f32>, b: vec2<f32>, c: vec2<f32>, d: vec2<f32>) -> bool {
  let s0 = cross2d(b - a, p - a);
  let s1 = cross2d(c - b, p - b);
  let s2 = cross2d(d - c, p - c);
  let s3 = cross2d(a - d, p - d);
  return (s0 >= 0.0 && s1 >= 0.0 && s2 >= 0.0 && s3 >= 0.0) ||
         (s0 <= 0.0 && s1 <= 0.0 && s2 <= 0.0 && s3 <= 0.0);
}

// Kitty's exponential decay: step = 1 - exp2(-10 * dt / decay)
fn decay_step(dt: f32, decay: f32) -> f32 {
  return 1.0 - exp2(-10.0 * dt / decay);
}

@fragment
fn fs_postprocess(in: VertexOutput) -> @location(0) vec4<f32> {
  let original = textureSample(screen_texture, screen_sampler, in.uv);
  let pixel = in.uv * pp.resolution;

  let prev = pp.cursor_prev_pos;
  let curr = pp.cursor_pos;
  let dt = pp.cursor_move_time;
  let cw = pp.cell_width;
  let ch = pp.cell_height;

  let move_dist = length(curr - prev);
  if (move_dist < 1.0 || dt > 2.5) {
    return original;
  }

  // Cursor rectangle corners: top-left, top-right, bottom-right, bottom-left
  // Target (current cursor)
  let t_tl = curr;
  let t_tr = curr + vec2<f32>(cw, 0.0);
  let t_br = curr + vec2<f32>(cw, ch);
  let t_bl = curr + vec2<f32>(0.0, ch);

  // Source (previous cursor)
  let s_tl = prev;
  let s_tr = prev + vec2<f32>(cw, 0.0);
  let s_br = prev + vec2<f32>(cw, ch);
  let s_bl = prev + vec2<f32>(0.0, ch);

  // Cursor center for determining leading/trailing
  let target_center = curr + vec2<f32>(cw * 0.5, ch * 0.5);

  // Decay parameters (seconds) — larger = longer trail
  let decay_fast = 0.1;
  let decay_slow = 0.4;

  // For each corner, compute dot product to determine if leading or trailing
  // Leading corners (closer to target direction) get fast decay
  let dir = normalize(curr - prev + vec2<f32>(0.0001, 0.0001));

  // Corner offsets from cursor center
  let offsets = array<vec2<f32>, 4>(
    vec2<f32>(-0.5, -0.5), // top-left
    vec2<f32>(0.5, -0.5),  // top-right
    vec2<f32>(0.5, 0.5),   // bottom-right
    vec2<f32>(-0.5, 0.5),  // bottom-left
  );

  var corners: array<vec2<f32>, 4>;
  let sources = array<vec2<f32>, 4>(s_tl, s_tr, s_br, s_bl);
  let targets = array<vec2<f32>, 4>(t_tl, t_tr, t_br, t_bl);

  for (var i = 0u; i < 4u; i = i + 1u) {
    // Dot product: how aligned is this corner's offset with the movement direction?
    // Positive = leading (in direction of movement), negative = trailing
    let d = dot(offsets[i], dir);
    // Map from [-1,1] to [0,1], 1 = most leading
    let lead_factor = d * 0.5 + 0.5;
    // Interpolate decay: leading gets fast, trailing gets slow
    let decay = mix(decay_slow, decay_fast, lead_factor);
    let step = decay_step(dt, decay);
    corners[i] = mix(sources[i], targets[i], step);
  }

  // Check if pixel is inside the deformed trail quad
  if (!point_in_quad(pixel, corners[0], corners[1], corners[2], corners[3])) {
    return original;
  }

  // Cut out the actual cursor rectangle (like Kitty)
  let in_cursor_x = step(curr.x, pixel.x) * step(pixel.x, curr.x + cw);
  let in_cursor_y = step(curr.y, pixel.y) * step(pixel.y, curr.y + ch);
  let in_cursor = in_cursor_x * in_cursor_y;

  // Trail color: sample cursor area for color, fallback to bright
  let cursor_uv = (curr + vec2<f32>(cw * 0.5, ch * 0.5)) / pp.resolution;
  let cursor_sample = textureSample(screen_texture, screen_sampler, cursor_uv).rgb;
  let trail_color = mix(vec3<f32>(0.75, 0.8, 0.85), cursor_sample, 0.6);

  // Opacity: fade based on overall convergence
  let convergence = length(corners[0] - t_tl) + length(corners[1] - t_tr) +
                    length(corners[2] - t_br) + length(corners[3] - t_bl);
  let opacity = smoothstep(0.0, cw * 2.0, convergence) * (1.0 - in_cursor);

  let result = mix(original.rgb, trail_color, opacity * 0.85);
  return vec4<f32>(result, original.a);
}
