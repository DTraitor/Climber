class_name Hook
extends CharacterBody2D


var throw: bool = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if not throw:
		return
	velocity += get_gravity() * delta
	var collision = move_and_collide(velocity * delta, false, true, true)
	if collision:
		queue_free()
		return
	rotation = velocity.angle()


func thrown(dir: Vector2, speed: float) -> void:
	velocity = dir * speed
	throw = true
