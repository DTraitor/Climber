class_name Hook
extends CharacterBody2D

signal hit_platform(platform: Node2D)


var terminate_position_y: float
var throw: bool = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if not throw:
		return
	velocity += get_gravity() * delta
	var collision = move_and_collide(velocity * delta, false, true, true)
	if collision:
		hit_platform.emit(collision.get_collider())
		queue_free()
		return

	if terminate_position_y < global_position.y:
		queue_free()
		return

	rotation = velocity.angle()


func thrown(dir: Vector2, speed: float) -> void:
	velocity = dir * speed
	throw = true
