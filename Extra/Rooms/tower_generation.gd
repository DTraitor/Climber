extends Node2D

# Variables

@export var initial_room_count:int = 2
@export var room_scenes: Array[PackedScene]
@export var room_height:int  = 144

var active_rooms = []

@onready var rooms_container: Node2D = $Rooms
@onready var player: CharacterBody2D = $Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	print("Game started. Ready to initialize rooms.")
	active_rooms.clear()
	generate_rooms(initial_room_count)

func generate_rooms (count:int) -> void:
	var last_position = Vector2(0, -144)
	
	for i in range(count):
		var room = room_scenes[randi() % room_scenes.size()].instantiate()
		
		room.position = last_position
		
		rooms_container.add_child(room)
		active_rooms.append(room)
		
		last_position.y += -room_height

		print("Room generated at position: ", room.position)
