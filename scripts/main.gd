extends Node2D

@onready var ui: Control = $CanvasLayer/UI
@export var river_status_max = 100
@export var river_status_value = 50

@onready var sprite: Sprite2D = $World/River/Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ui.set_progress_bar(river_status_value,river_status_max)



func _physics_process(delta: float) -> void:
	var trash_number = get_tree().get_nodes_in_group("Trash").size()
	_update_river_status(river_status_max - trash_number * 10, delta)
	if trash_number*10 >= river_status_max:
		_game_over()

func _update_river_status(value: float,delta:float):
	if value <= 50:
		sprite.modulate = lerp(sprite.modulate, Color.GRAY, delta*10.0)
	else:
		sprite.modulate = lerp(sprite.modulate, Color.BLUE, delta*10.0)
	ui.update_progress_bar(value)


func _game_over():
	ui.show_game_over()