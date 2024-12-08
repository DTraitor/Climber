extends CharacterBody2D


signal on_user_start_drag
signal on_user_drag(dir: Vector2, speed: float, gravity: Vector2, delta: float)
signal on_user_stop_drag

const speed = 700
const max_distance = 200
const move_speed = 15000

var pressed = false
var moving = false
var shot_scene: PackedScene
var desired_pos: Vector2


func _ready() -> void:
	shot_scene = preload("res://scenes/hook.tscn")


func _physics_process(delta: float) -> void:
	if moving:
		$MoveLine.clear_points()
		if(global_position.distance_to(desired_pos) <= 20):
			moving = false
			$CollisionShape2D.disabled = false
			velocity = Vector2.ZERO
			return
		velocity = (desired_pos - global_position).normalized() * delta * move_speed
		move_and_slide()
		$MoveLine.add_point(Vector2.ZERO)
		$MoveLine.add_point(desired_pos - global_position)
		return
	if not is_on_floor():
		velocity += get_gravity() * delta
		move_and_slide()
	
	if pressed:
		on_user_drag.emit(
			get_move_vector(),
			speed,
			get_gravity(), 
			delta
		)


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if moving or not event.is_action_pressed("left_click"):
		return
	pressed = true
	on_user_start_drag.emit()


func _unhandled_input(event: InputEvent) -> void:
	if not pressed or not event.is_action_released("left_click"):
		return
	pressed = false
	on_user_stop_drag.emit()
	
	var hook: Hook = shot_scene.instantiate()
	get_parent().add_child(hook)
	hook.position = position
	hook.terminate_position_y = global_position.y + 200
	hook.connect('hit_platform', on_platform_hit)
	hook.thrown(get_move_vector(), speed)


func get_move_vector() -> Vector2:
	var speed = (get_global_mouse_position() - $Centre.global_position)
	if get_global_mouse_position().distance_to($Centre.global_position) > max_distance:
		return speed.normalized() * -1
	return (speed / max_distance) * -1


func on_platform_hit(platform: Node2D) -> void:
	$MoveLine.clear_points()
	$MoveLine.add_point(Vector2.ZERO)
	$MoveLine.add_point(platform.get_node('desired_pos').global_position - global_position)
	desired_pos = platform.get_node('desired_pos').global_position
	moving = true
	pressed = false
	on_user_stop_drag.emit()
	$CollisionShape2D.disabled = true
