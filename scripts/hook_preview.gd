extends Line2D


const max_points = 250

var last_dir: Vector2
var last_speed: float
var last_gravity: Vector2


func _show_line() -> void:
	visible = true


func _hide_line() -> void:
	visible = false


func update_trajectory(dir: Vector2, speed: float, gravity: Vector2, delta: float) -> void:
	if (dir == last_dir and speed == last_speed and gravity == last_gravity):
		return
	last_dir = dir
	last_speed = speed
	last_gravity = gravity
	clear_points()
	var pos: Vector2 = Vector2.ZERO
	var velocity = dir * speed
	add_point(pos)
	for i in max_points:
		velocity += gravity * delta

		var collision = $CollisionTest.move_and_collide(velocity * delta, false, true, true)

		pos += velocity * delta
		$CollisionTest.position = pos
		add_point(pos)

		if collision:
			break
