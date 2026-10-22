extends Node3D
## First playable Godot 4 prototype. Procedural voxel art keeps this prototype asset-free.

const ROUND_SECONDS := 60.0
const BASE_RABBIT_LIFETIME := 2.85
const MIN_RABBIT_LIFETIME := 1.80
const SPAWN_MIN := 0.58
const SPAWN_MAX := 1.00
const SAVE_PATH := "user://bush_slap.cfg"

var camera: Camera3D
var slap_hand: Node3D
var hand_rest_position := Vector3(0.92, -0.72, -1.85)
var hand_swinging := false
var world_root: Node3D
var rabbit: Area3D
var rabbit_visual: Node3D
var rabbit_ears: Array[Node3D] = []
var spawn_timer := 0.0
var rabbit_age := 0.0
var rabbit_home_position := Vector3.ZERO
var round_time := ROUND_SECONDS
var score := 0
var combo := 0
var best := 0
var playing := false
var rabbit_phase := 0.0
var hud_score: Label
var hud_time: Label
var hud_combo: Label
var hud_top: HBoxContainer
var overlay_panel: VBoxContainer
var message_label: Label
var hit_fx_label: Label
var hit_fx_tween: Tween
var overlay: ColorRect
var overlay_title: Label
var overlay_body: Label
var play_button: Button
var rng := RandomNumberGenerator.new()
var bush_positions: Array[Vector3] = []

func _ready() -> void:
	rng.randomize()
	_load_best()
	_build_world()
	_build_camera()
	_build_hud()
	get_viewport().size_changed.connect(_apply_responsive_hud)
	_apply_responsive_hud()
	_show_overlay("BUSH SLAP", "Tap or click the blocky rabbit when it pops out. Build a combo and beat your best!")
	_update_hud()

func _process(delta: float) -> void:
	if playing:
		round_time -= delta
		spawn_timer -= delta
		if rabbit and is_instance_valid(rabbit):
			rabbit_age += delta
			rabbit_phase += delta * 8.0
			# A quick upward pop-in makes each appearance feel like a little ambush.
			var entrance := clampf(rabbit_age / 0.18, 0.0, 1.0)
			rabbit.position = rabbit_home_position + Vector3(sin(rabbit_phase * 0.43) * 0.14, 0.1 + absf(sin(rabbit_phase)) * 0.24 - (1.0 - entrance) * 0.24, cos(rabbit_phase * 0.34) * 0.07)
			if rabbit_visual:
				rabbit_visual.rotation.y = sin(rabbit_phase * 0.45) * 0.10
				# Squash-and-stretch is layered over the pop-in without hiding the target.
				var hop := absf(sin(rabbit_phase))
				rabbit_visual.scale = Vector3(entrance + hop * 0.035, entrance - hop * 0.045, entrance + hop * 0.035)
				for ear_index in range(rabbit_ears.size()):
					var ear := rabbit_ears[ear_index]
					ear.rotation_degrees.z = sin(rabbit_phase * 0.8 + float(ear_index) * PI) * 7.0
			if rabbit_age >= _rabbit_lifetime():
				_escape_rabbit()
		if spawn_timer <= 0.0 and (not rabbit or not is_instance_valid(rabbit)):
			_spawn_rabbit()
		if round_time <= 0.0:
			_end_round()
		_update_hud()

func _unhandled_input(event: InputEvent) -> void:
	var pressed := false
	var screen_pos := Vector2.ZERO
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		pressed = true
		screen_pos = event.position
	elif event is InputEventScreenTouch and event.pressed:
		pressed = true
		screen_pos = event.position
	elif event is InputEventKey and event.pressed and not event.echo:
		# Keyboard fallback: Space targets the screen centre; Enter starts/restarts.
		if event.keycode == KEY_ENTER or event.keycode == KEY_KP_ENTER:
			if not playing:
				_start_round()
				get_viewport().set_input_as_handled()
				return
		elif event.keycode == KEY_SPACE and playing:
			pressed = true
			screen_pos = get_viewport().get_visible_rect().size * 0.5
	if pressed and playing:
		_animate_slap_hand()
		_try_slap(screen_pos)

func _build_world() -> void:
	world_root = Node3D.new()
	world_root.name = "VoxelGarden"
	add_child(world_root)
	_add_light(Vector3(-4, 9, 5), 2.0, Color(1.0, 0.84, 0.67))
	_add_light(Vector3(5, 6, -3), 1.1, Color(0.35, 0.83, 1.0))
	_add_box(world_root, Vector3(0, -0.42, -1.5), Vector3(20, 0.8, 19), Color(0.30, 0.62, 0.25))
	_add_box(world_root, Vector3(0, -0.005, 2.0), Vector3(4.2, 0.06, 15), Color(0.72, 0.62, 0.40))
	# Layered voxel trees frame the play area without hiding the target.
	for x in [-8.0, -6.1, 6.1, 8.0]:
		for z in [-5.0, -1.0, 3.0]:
			_make_tree(Vector3(x, 0, z), 0.8 if absf(x) > 7.0 else 1.0)
	# Six bushes define easy-to-read rabbit spawn zones.
	bush_positions = [
		Vector3(-4.5, 0.0, -2.0), Vector3(-2.0, 0.0, -3.7),
		Vector3(2.0, 0.0, -3.7), Vector3(4.5, 0.0, -2.0),
		Vector3(-3.8, 0.0, 1.1), Vector3(3.8, 0.0, 1.1)
	]
	for p in bush_positions:
		_make_bush(p)
		_make_bush_accents(p)
	# Pixel flowers and stones add detail to the foreground.
	for i in range(34):
		var x := rng.randf_range(-7.0, 7.0)
		var z := rng.randf_range(2.0, 6.5)
		var col := [Color(1.0, 0.75, 0.20), Color(1.0, 0.45, 0.68), Color(0.88, 0.94, 0.66)][i % 3]
		_add_box(world_root, Vector3(x, 0.02, z), Vector3(0.12, 0.12, 0.12), col)
		if i % 3 == 0:
			_add_box(world_root, Vector3(x + 0.13, 0.015, z + 0.08), Vector3(0.20, 0.06, 0.14), Color(0.48, 0.49, 0.43))
	# Tiny blocky trail markers guide the eye toward the rabbit spawn area.
	for i in range(8):
		var z := 5.4 - float(i) * 1.15
		var x := -1.75 if i % 2 == 0 else 1.75
		_add_box(world_root, Vector3(x, 0.045, z), Vector3(0.22, 0.09, 0.22), Color(0.93, 0.72, 0.36))

func _build_camera() -> void:
	camera = Camera3D.new()
	camera.position = Vector3(0, 5.3, 11.5)
	camera.rotation_degrees = Vector3(-17, 0, 0)
	camera.fov = 55.0
	add_child(camera)
	camera.current = true
	_build_slap_hand()
	var env := WorldEnvironment.new()
	var environment := Environment.new()
	environment.background_mode = Environment.BG_SKY
	var sky := Sky.new()
	var sky_mat := ProceduralSkyMaterial.new()
	sky_mat.sky_top_color = Color(0.05, 0.18, 0.40)
	sky_mat.sky_horizon_color = Color(0.30, 0.72, 0.91)
	sky_mat.ground_bottom_color = Color(0.10, 0.19, 0.10)
	sky_mat.ground_horizon_color = Color(0.35, 0.53, 0.28)
	sky.sky_material = sky_mat
	environment.sky = sky
	environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	environment.ambient_light_color = Color(0.62, 0.76, 0.94)
	environment.ambient_light_energy = 0.65
	env.environment = environment
	add_child(env)

func _build_hud() -> void:
	var layer := CanvasLayer.new()
	layer.name = "HUD"
	add_child(layer)
	hud_top = HBoxContainer.new()
	hud_top.set_anchors_and_offsets_preset(Control.PRESET_TOP_WIDE)
	hud_top.offset_left = 18
	hud_top.offset_top = 14
	hud_top.offset_right = -18
	hud_top.offset_bottom = 66
	hud_top.add_theme_constant_override("separation", 8)
	layer.add_child(hud_top)
	hud_score = _hud_label("SCORE  0000", 24)
	hud_time = _hud_label("TIME  60", 22)
	hud_combo = _hud_label("COMBO  x0", 22)
	hud_top.add_child(hud_score)
	hud_top.add_spacer(false)
	hud_top.add_child(hud_combo)
	hud_top.add_spacer(false)
	hud_top.add_child(hud_time)
	message_label = _hud_label("TAP THE RABBIT!", 20)
	message_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	message_label.set_anchors_and_offsets_preset(Control.PRESET_CENTER_TOP)
	message_label.offset_top = 78
	message_label.offset_left = -240
	message_label.offset_right = 240
	message_label.offset_bottom = 120
	layer.add_child(message_label)
	hit_fx_label = _hud_label("SLAP!", 48)
	hit_fx_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	hit_fx_label.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	hit_fx_label.offset_left = -190
	hit_fx_label.offset_right = 190
	hit_fx_label.offset_top = -65
	hit_fx_label.offset_bottom = 10
	hit_fx_label.scale = Vector2(0.4, 0.4)
	hit_fx_label.modulate.a = 0.0
	hit_fx_label.add_theme_color_override("font_color", Color(1.0, 0.83, 0.18))
	hit_fx_label.add_theme_font_size_override("font_size", 54)
	layer.add_child(hit_fx_label)
	overlay = ColorRect.new()
	overlay.color = Color(0.015, 0.025, 0.07, 0.82)
	overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	layer.add_child(overlay)
	overlay_panel = VBoxContainer.new()
	overlay_panel.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	overlay_panel.offset_left = -260
	overlay_panel.offset_top = -155
	overlay_panel.offset_right = 260
	overlay_panel.offset_bottom = 155
	overlay_panel.add_theme_constant_override("separation", 16)
	overlay.add_child(overlay_panel)
	overlay_title = _hud_label("BUSH SLAP", 42)
	overlay_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	overlay_panel.add_child(overlay_title)
	overlay_body = _hud_label("", 18)
	overlay_body.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	overlay_body.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	overlay_panel.add_child(overlay_body)
	play_button = Button.new()
	play_button.text = "▶  PLAY"
	play_button.custom_minimum_size = Vector2(220, 58)
	play_button.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	play_button.add_theme_font_size_override("font_size", 24)
	play_button.pressed.connect(_start_round)
	overlay_panel.add_child(play_button)


func _apply_responsive_hud() -> void:
	# Keep the score row and start/end panel inside narrow phone viewports.
	var viewport_size := get_viewport().get_visible_rect().size
	var compact := viewport_size.x < 760.0
	if hud_top:
		hud_top.offset_left = 10.0 if compact else 18.0
		hud_top.offset_right = -10.0 if compact else -18.0
		hud_top.offset_top = 8.0 if compact else 14.0
		hud_top.offset_bottom = 48.0 if compact else 66.0
		hud_top.add_theme_constant_override("separation", 3 if compact else 8)
	if hud_score:
		hud_score.add_theme_font_size_override("font_size", 16 if compact else 24)
	if hud_time:
		hud_time.add_theme_font_size_override("font_size", 16 if compact else 22)
	if hud_combo:
		hud_combo.add_theme_font_size_override("font_size", 15 if compact else 22)
	if message_label:
		message_label.add_theme_font_size_override("font_size", 15 if compact else 20)
		message_label.offset_top = 52.0 if compact else 78.0
		message_label.offset_left = -160.0 if compact else -240.0
		message_label.offset_right = 160.0 if compact else 240.0
		message_label.offset_bottom = 88.0 if compact else 120.0
	if overlay_panel:
		var panel_width := maxf(240.0, minf(520.0, viewport_size.x - 28.0))
		overlay_panel.offset_left = -panel_width * 0.5
		overlay_panel.offset_right = panel_width * 0.5
		overlay_panel.offset_top = -130.0 if compact else -155.0
		overlay_panel.offset_bottom = 130.0 if compact else 155.0
	if overlay_title:
		overlay_title.add_theme_font_size_override("font_size", 30 if compact else 42)
	if overlay_body:
		overlay_body.add_theme_font_size_override("font_size", 15 if compact else 18)
	if play_button:
		play_button.custom_minimum_size = Vector2(180, 50) if compact else Vector2(220, 58)
		play_button.add_theme_font_size_override("font_size", 20 if compact else 24)

func _hud_label(text_value: String, font_size: int) -> Label:
	var label := Label.new()
	label.text = text_value
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", Color(1.0, 0.96, 0.78))
	label.add_theme_color_override("font_shadow_color", Color(0.02, 0.04, 0.08, 0.9))
	label.add_theme_constant_override("shadow_offset_x", 2)
	label.add_theme_constant_override("shadow_offset_y", 3)
	return label


func _build_slap_hand() -> void:
	# Camera-attached blocky glove/forearm: a first-person slap cue that works on mouse and touch.
	slap_hand = Node3D.new()
	slap_hand.name = "FirstPersonSlapHand"
	slap_hand.position = hand_rest_position
	slap_hand.rotation_degrees = Vector3(-8, -16, -12)
	camera.add_child(slap_hand)
	var sleeve := _add_box(slap_hand, Vector3(0.0, -0.30, 0.12), Vector3(0.42, 0.68, 0.42), Color(0.13, 0.40, 0.76))
	sleeve.name = "PixelBlueSleeve"
	_add_box(slap_hand, Vector3(0.0, 0.05, -0.10), Vector3(0.52, 0.40, 0.46), Color(0.96, 0.72, 0.52))
	_add_box(slap_hand, Vector3(0.0, 0.20, -0.17), Vector3(0.50, 0.22, 0.30), Color(1.0, 0.83, 0.66))
	for i in range(4):
		_add_box(slap_hand, Vector3(-0.18 + float(i) * 0.12, -0.015, -0.34), Vector3(0.105, 0.23, 0.13), Color(0.96, 0.72, 0.52))
	_add_box(slap_hand, Vector3(0.29, 0.02, -0.12), Vector3(0.16, 0.25, 0.16), Color(0.96, 0.72, 0.52))

func _animate_slap_hand() -> void:
	if not slap_hand or not is_instance_valid(slap_hand) or hand_swinging:
		return
	hand_swinging = true
	var tween := create_tween()
	tween.set_parallel(true)
	tween.tween_property(slap_hand, "position", hand_rest_position + Vector3(-0.48, 0.20, 0.48), 0.075).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	tween.tween_property(slap_hand, "rotation_degrees", Vector3(-2, 18, 24), 0.075).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	tween.chain().tween_property(slap_hand, "position", hand_rest_position + Vector3(0.18, -0.04, -0.12), 0.10).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(slap_hand, "rotation_degrees", Vector3(12, -25, -32), 0.10)
	tween.chain().tween_property(slap_hand, "position", hand_rest_position, 0.16).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(slap_hand, "rotation_degrees", Vector3(-8, -16, -12), 0.16)
	tween.chain().tween_callback(func(): hand_swinging = false)

func _make_tree(origin: Vector3, scale_factor: float) -> void:
	_add_box(world_root, origin + Vector3(0, 1.0 * scale_factor, 0), Vector3(0.42, 2.0, 0.42) * scale_factor, Color(0.35, 0.19, 0.10))
	var greens := [Color(0.10, 0.39, 0.18), Color(0.13, 0.52, 0.20), Color(0.24, 0.66, 0.23), Color(0.39, 0.75, 0.24)]
	for i in range(15):
		var angle := float(i) * 2.399
		var radius := rng.randf_range(0.2, 1.05) * scale_factor
		var height := rng.randf_range(1.4, 3.0) * scale_factor
		var size := rng.randf_range(0.45, 0.9) * scale_factor
		_add_box(world_root, origin + Vector3(cos(angle) * radius, height, sin(angle) * radius), Vector3.ONE * size, greens[i % greens.size()])

func _make_bush(origin: Vector3) -> void:
	var greens := [Color(0.07, 0.32, 0.13), Color(0.12, 0.48, 0.17), Color(0.22, 0.62, 0.20), Color(0.37, 0.74, 0.24)]
	for i in range(13):
		var offset := Vector3(rng.randf_range(-0.8, 0.8), rng.randf_range(0.2, 0.85), rng.randf_range(-0.45, 0.45))
		var size := rng.randf_range(0.45, 0.78)
		_add_box(world_root, origin + offset, Vector3(size, size, size), greens[i % greens.size()])


func _make_bush_accents(origin: Vector3) -> void:
	# Bright leaf pixels and berry-like blocks make each target zone easier to parse.
	var leaf_colors := [Color(0.47, 0.79, 0.25), Color(0.67, 0.86, 0.30), Color(0.22, 0.65, 0.26)]
	for i in range(5):
		var side := -1.0 if i % 2 == 0 else 1.0
		var accent_pos := origin + Vector3(side * rng.randf_range(0.45, 0.88), rng.randf_range(0.38, 0.95), rng.randf_range(-0.42, 0.42))
		_add_box(world_root, accent_pos, Vector3(0.16, 0.16, 0.16), leaf_colors[i % leaf_colors.size()])
	for side in [-1.0, 1.0]:
		_add_box(world_root, origin + Vector3(side * 0.62, 0.48, -0.47), Vector3(0.12, 0.12, 0.08), Color(1.0, 0.35, 0.45))

func _add_light(pos: Vector3, energy: float, tint: Color) -> void:
	var light := DirectionalLight3D.new()
	light.position = pos
	light.rotation_degrees = Vector3(-42, -28, 0)
	light.light_energy = energy
	light.light_color = tint
	light.shadow_enabled = true
	add_child(light)

func _add_box(parent: Node3D, pos: Vector3, size: Vector3, tint: Color) -> MeshInstance3D:
	var mesh_instance := MeshInstance3D.new()
	var mesh := BoxMesh.new()
	mesh.size = size
	mesh_instance.mesh = mesh
	var mat := StandardMaterial3D.new()
	mat.albedo_color = tint
	mat.roughness = 0.88
	mesh_instance.material_override = mat
	mesh_instance.position = pos
	parent.add_child(mesh_instance)
	return mesh_instance

func _spawn_rabbit() -> void:
	var spot: Vector3 = bush_positions[rng.randi_range(0, bush_positions.size() - 1)]
	rabbit = Area3D.new()
	rabbit.name = "RabbitTarget"
	rabbit_home_position = spot + Vector3(0, 0.1, -0.1)
	rabbit.position = rabbit_home_position
	rabbit.collision_layer = 1
	rabbit.collision_mask = 0
	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = Vector3(2.0, 2.65, 1.45)
	collision.shape = shape
	collision.position.y = 1.1
	rabbit.add_child(collision)
	rabbit_visual = Node3D.new()
	rabbit.add_child(rabbit_visual)
	# Chunky white body, square head, pink inner ears, visible feet and cheeks.
	rabbit_ears.clear()
	_add_box(rabbit_visual, Vector3(0, 0.75, 0), Vector3(0.85, 0.95, 0.62), Color(0.91, 0.94, 1.0))
	_add_box(rabbit_visual, Vector3(0, 1.45, -0.03), Vector3(0.88, 0.78, 0.70), Color(1.0, 0.98, 0.94))
	_add_box(rabbit_visual, Vector3(-0.25, 1.52, -0.39), Vector3(0.12, 0.12, 0.05), Color(0.05, 0.07, 0.11))
	_add_box(rabbit_visual, Vector3(0.25, 1.52, -0.39), Vector3(0.12, 0.12, 0.05), Color(0.05, 0.07, 0.11))
	_add_box(rabbit_visual, Vector3(0, 1.34, -0.43), Vector3(0.18, 0.12, 0.06), Color(0.94, 0.43, 0.61))
	# Small block highlights make the face readable at a glance, even on a phone.
	_add_box(rabbit_visual, Vector3(-0.28, 1.59, -0.425), Vector3(0.045, 0.045, 0.025), Color(1.0, 1.0, 1.0))
	_add_box(rabbit_visual, Vector3(0.22, 1.59, -0.425), Vector3(0.045, 0.045, 0.025), Color(1.0, 1.0, 1.0))
	# Puffy pixel tail and a tiny forelock reinforce the toy-like voxel silhouette.
	_add_box(rabbit_visual, Vector3(0, 0.78, 0.36), Vector3(0.38, 0.38, 0.34), Color(1.0, 0.99, 0.94))
	_add_box(rabbit_visual, Vector3(0, 1.91, 0.0), Vector3(0.24, 0.16, 0.22), Color(1.0, 0.99, 0.94))
	for side in [-1.0, 1.0]:
		var ear_pivot := Node3D.new()
		ear_pivot.position = Vector3(side * 0.23, 1.82, 0.02)
		ear_pivot.name = "LeftEarPivot" if side < 0.0 else "RightEarPivot"
		rabbit_visual.add_child(ear_pivot)
		rabbit_ears.append(ear_pivot)
		_add_box(ear_pivot, Vector3(0, 0.28, 0), Vector3(0.24, 0.70, 0.22), Color(0.96, 0.95, 0.91))
		_add_box(ear_pivot, Vector3(0, 0.28, -0.115), Vector3(0.13, 0.50, 0.035), Color(0.95, 0.42, 0.63))
		_add_box(rabbit_visual, Vector3(side * 0.27, 0.15, -0.06), Vector3(0.34, 0.18, 0.48), Color(0.98, 0.94, 0.91))
		_add_box(rabbit_visual, Vector3(side * 0.27, 0.055, -0.29), Vector3(0.16, 0.045, 0.06), Color(0.94, 0.57, 0.68))
		_add_box(rabbit_visual, Vector3(side * 0.49, 1.32, -0.20), Vector3(0.15, 0.24, 0.08), Color(1.0, 0.65, 0.72))
	add_child(rabbit)
	# A quick, springy pop-in makes the target feel like it jumps out of the bush.
	rabbit.scale = Vector3(0.72, 0.18, 0.72)
	var pop_tween := create_tween()
	pop_tween.tween_property(rabbit, "scale", Vector3(1.06, 1.08, 1.06), 0.13).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	pop_tween.tween_property(rabbit, "scale", Vector3.ONE, 0.10).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	rabbit_age = 0.0
	rabbit_phase = 0.0
	var pace := clampf(float(score) / 3500.0, 0.0, 0.35)
	spawn_timer = rng.randf_range(SPAWN_MIN, SPAWN_MAX) * (1.0 - pace)

func _try_slap(screen_pos: Vector2) -> void:
	var from := camera.project_ray_origin(screen_pos)
	var direction := camera.project_ray_normal(screen_pos)
	var query := PhysicsRayQueryParameters3D.create(from, from + direction * 100.0)
	query.collision_mask = 1
	query.collide_with_areas = true
	var hit := get_world_3d().direct_space_state.intersect_ray(query)
	if not hit.is_empty() and rabbit and is_instance_valid(rabbit) and hit.collider == rabbit:
		var earned_points := 100 + combo * 15
		score += earned_points
		combo += 1
		if score > best:
			best = score
			_save_best()
		message_label.text = ["NICE SLAP!", "COMBO!", "BUNNY BONK!", "PERFECT!"][rng.randi_range(0, 3)]
		_spawn_voxel_burst(rabbit.position + Vector3(0, 1.25, 0))
		_spawn_score_popup(rabbit.position + Vector3(0, 2.25, 0), earned_points)
		_play_hit_feedback()
		_show_hit_fx()
		_remove_rabbit()
		spawn_timer = 0.35
	else:
		combo = 0
		message_label.text = "MISSED! WAIT FOR THE BUNNY"
		_show_miss_fx()
	_update_hud()

func _rabbit_lifetime() -> float:
	# Gentle, capped difficulty ramp; never becomes a near-impossible twitch test.
	return maxf(MIN_RABBIT_LIFETIME, BASE_RABBIT_LIFETIME - float(score) / 4200.0)


func _play_hit_feedback() -> void:
	# Brief camera jolt adds impact without permanently shifting the player's view.
	if camera and is_instance_valid(camera):
		var base_position := Vector3(0, 5.3, 11.5)
		var tween := create_tween()
		tween.tween_property(camera, "position", base_position + Vector3(0.045, -0.035, 0.0), 0.035)
		tween.tween_property(camera, "position", base_position + Vector3(-0.025, 0.02, 0.0), 0.045)
		tween.tween_property(camera, "position", base_position, 0.08).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func _show_hit_fx() -> void:
	if not hit_fx_label:
		return
	if hit_fx_tween and hit_fx_tween.is_valid():
		hit_fx_tween.kill()
	hit_fx_label.text = ["SLAP!", "POW!", "BONK!", "WHAM!"][rng.randi_range(0, 3)]
	hit_fx_label.scale = Vector2(0.45, 0.45)
	hit_fx_label.rotation = deg_to_rad(rng.randf_range(-9.0, 9.0))
	hit_fx_label.modulate = Color(1.0, 1.0, 1.0, 1.0)
	hit_fx_tween = create_tween()
	hit_fx_tween.set_parallel(true)
	hit_fx_tween.tween_property(hit_fx_label, "scale", Vector2(1.15, 1.15), 0.12).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	hit_fx_tween.tween_property(hit_fx_label, "rotation", 0.0, 0.22)
	hit_fx_tween.tween_property(hit_fx_label, "modulate:a", 0.0, 0.48).set_delay(0.24)

func _show_miss_fx() -> void:
	# Make a missed swipe legible without punishing the player with extra clutter.
	if not hit_fx_label:
		return
	if hit_fx_tween and hit_fx_tween.is_valid():
		hit_fx_tween.kill()
	hit_fx_label.text = "MISS!"
	hit_fx_label.scale = Vector2(0.55, 0.55)
	hit_fx_label.rotation = 0.0
	hit_fx_label.modulate = Color(1.0, 0.34, 0.30, 1.0)
	hit_fx_label.add_theme_color_override("font_color", Color(1.0, 0.42, 0.34))
	hit_fx_tween = create_tween()
	hit_fx_tween.set_parallel(true)
	hit_fx_tween.tween_property(hit_fx_label, "scale", Vector2(0.85, 0.85), 0.09).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	hit_fx_tween.tween_property(hit_fx_label, "rotation", deg_to_rad(-4.0), 0.06)
	hit_fx_tween.tween_property(hit_fx_label, "modulate:a", 0.0, 0.30).set_delay(0.08)
	hit_fx_tween.chain().tween_callback(func():
		hit_fx_label.add_theme_color_override("font_color", Color(1.0, 0.83, 0.18))
	)

func _spawn_score_popup(origin: Vector3, points: int) -> void:
	# Floating score text reinforces the reward without adding permanent HUD clutter.
	var popup := Label3D.new()
	popup.name = "ScorePopup"
	popup.text = "+%d" % points
	popup.position = origin
	popup.font_size = 48
	popup.pixel_size = 0.01
	popup.modulate = Color(1.0, 0.86, 0.22, 1.0)
	popup.outline_size = 8
	popup.outline_modulate = Color(0.10, 0.08, 0.16, 1.0)
	add_child(popup)
	var tween := create_tween()
	tween.set_parallel(true)
	tween.tween_property(popup, "position", origin + Vector3(0.0, 0.9, 0.0), 0.48).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(popup, "modulate:a", 0.0, 0.48).set_delay(0.12)
	tween.chain().tween_callback(popup.queue_free)

func _spawn_voxel_burst(origin: Vector3) -> void:
	# Comic-book hit burst: a denser ring of colored voxel shards with varied spin and travel.
	var palette := [Color(1.0, 0.80, 0.16), Color(1.0, 0.28, 0.52), Color(0.24, 0.91, 1.0), Color(0.91, 1.0, 0.63), Color(1.0, 0.98, 0.90)]
	for i in range(18):
		var piece_size := rng.randf_range(0.075, 0.20)
		var piece := _add_box(world_root, origin, Vector3.ONE * piece_size, palette[i % palette.size()])
		piece.rotation_degrees = Vector3(rng.randf_range(-35.0, 35.0), rng.randf_range(-35.0, 35.0), rng.randf_range(-35.0, 35.0))
		var destination := origin + Vector3(rng.randf_range(-1.45, 1.45), rng.randf_range(0.25, 1.75), rng.randf_range(-0.9, 0.8))
		var duration := rng.randf_range(0.24, 0.44)
		var tween := create_tween()
		tween.set_parallel(true)
		tween.tween_property(piece, "position", destination, duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		tween.tween_property(piece, "rotation_degrees", piece.rotation_degrees + Vector3(rng.randf_range(-180.0, 180.0), rng.randf_range(-180.0, 180.0), rng.randf_range(-180.0, 180.0)), duration)
		tween.tween_property(piece, "scale", Vector3.ZERO, duration * 0.82).set_delay(0.06)
		tween.tween_callback(piece.queue_free).set_delay(duration + 0.04)

func _load_best() -> void:
	var config := ConfigFile.new()
	if config.load(SAVE_PATH) == OK:
		best = int(config.get_value("progress", "best_score", 0))

func _save_best() -> void:
	var config := ConfigFile.new()
	config.set_value("progress", "best_score", best)
	config.save(SAVE_PATH)

func _escape_rabbit() -> void:
	combo = 0
	_remove_rabbit()
	spawn_timer = 0.3
	message_label.text = "IT GOT AWAY!"

func _remove_rabbit() -> void:
	if rabbit and is_instance_valid(rabbit):
		rabbit.queue_free()
	rabbit = null
	rabbit_visual = null

func _start_round() -> void:
	score = 0
	combo = 0
	round_time = ROUND_SECONDS
	playing = true
	spawn_timer = 0.25
	_remove_rabbit()
	overlay.visible = false
	message_label.text = "TAP THE RABBIT!"
	_update_hud()

func _end_round() -> void:
	playing = false
	_remove_rabbit()
	_show_overlay("ROUND OVER!", "Score: %d\nPersonal best: %d\nTap play to try again." % [score, best])
	play_button.text = "↻  PLAY AGAIN"

func _show_overlay(title_text: String, body_text: String) -> void:
	overlay_title.text = title_text
	overlay_body.text = body_text
	overlay.visible = true
	play_button.text = "▶  PLAY"

func _update_hud() -> void:
	if hud_score:
		hud_score.text = "SCORE  %04d" % score
		hud_time.text = "TIME  %02d" % maxi(0, int(ceil(round_time)))
		hud_combo.text = "COMBO  x%d" % combo
