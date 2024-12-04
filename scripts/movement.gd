extends CharacterBody2D


signal on_user_start_drag
signal on_user_drag(dir: Vector2, speed: float, gravity: Vector2, delta: float)
signal on_user_stop_drag

const speed = 700

var pressed = false
var shot_scene: PackedScene


func _ready() -> void:
	shot_scene = preload("res://scenes/hook.tscn")


func _physics_process(delta: float) -> void:
	if pressed:
		on_user_drag.emit(
			(get_global_mouse_position() - $Centre.global_position).normalized() * -1,
			speed,
			get_gravity(), 
			delta
		)


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if not event.is_action_pressed("left_click"):
		return
	pressed = true
	on_user_start_drag.emit()


func _unhandled_input(event: InputEvent) -> void:
	if not pressed or not event.is_action_released("left_click"):
		return
	pressed = false
	on_user_stop_drag.emit()
	
	var hook: Hook = shot_scene.instantiate()
	add_child(hook)
	hook.thrown((get_global_mouse_position() - $Centre.global_position).normalized() * -1, speed)
