extends Spatial


var space_state
var camera : Camera
var inner_axis
var mouse_pos
var ray_result
var mid_btn_pressed : bool = false


func _ready():
	camera = get_node("InnerAxis/Camera")
	inner_axis = get_node("InnerAxis")


func _physics_process(delta):
	if Input.is_action_just_pressed("ui_middle_click"):
		mid_btn_pressed = true
		mouse_pos = get_viewport().get_mouse_position()
		var from = camera.project_ray_origin(mouse_pos)
		var to = camera.project_ray_normal(mouse_pos) * camera.far
		space_state = get_world().direct_space_state
		ray_result = space_state.intersect_ray(from, to, [self])
		if ray_result:
			var pos_difference = ray_result.position - global_transform.origin
			self.global_transform.origin = ray_result.position
			camera.global_translate(-pos_difference)
	elif Input.is_action_just_released("ui_middle_click"):
		mid_btn_pressed = false
	
	# middle button drag + SHIFT for camera pan
	if Input.is_key_pressed(KEY_SHIFT) and mid_btn_pressed and ray_result:
		var mouse_pos_current = get_viewport().get_mouse_position()
		var movement_diff = mouse_pos - mouse_pos_current
		var movement = tan(deg2rad(camera.fov / 2)) * movement_diff / (get_viewport().size.y / 2) 
		# multiply movement with distance of the camera to the gimbal's origin
		movement *= camera.transform.origin.length()
		mouse_pos = mouse_pos_current
		self.translate(Vector3(movement.x, 0, movement.y))
		
	# middle button drag for camera rotation
	elif mid_btn_pressed and ray_result:
		var mouse_pos_current = get_viewport().get_mouse_position()
		var movement_diff = mouse_pos - mouse_pos_current
		var distance_to_angle_constant = get_viewport().size.y * deg2rad(camera.fov)
		var angle_x = movement_diff.x / distance_to_angle_constant
		var angle_y = movement_diff.y / distance_to_angle_constant
		mouse_pos = mouse_pos_current
		inner_axis.rotate_object_local(Vector3.RIGHT, angle_y)
		self.rotate_object_local(Vector3.UP, angle_x)
		
	# scroll for camera zoom
	if Input.is_action_just_released("ui_scroll_up"):
		camera.translate_object_local(Vector3(0, 0, camera.transform.origin.length() / 5))
	elif Input.is_action_just_released("ui_scroll_down"):
		camera.translate_object_local(Vector3(0, 0, -camera.transform.origin.length() / 5))
