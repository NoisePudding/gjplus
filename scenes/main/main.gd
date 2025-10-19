extends Node2D

@onready var ui: Control = $CanvasLayer/UI
@export var river_status_max = 100
@export var river_status_value = 50

@onready var sprite: Sprite2D = $World/River/Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ui.set_progress_bar(river_status_value, river_status_max)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _physics_process(delta: float) -> void:
	var trash_number = get_tree().get_nodes_in_group("Trash").size()
	_update_river_status(river_status_max - trash_number * 10, delta)
	if trash_number * 10 >= river_status_max:
		_game_over()

func _input(event: InputEvent) -> void:
	pass
	# if event.is_action_pressed("ui_cancel"):
	# 	get_tree().change_scene_to_file("res://scenes/menu.tscn")

func _update_river_status(value: float, _delta: float):
	river_status_value = value
	if value <= 50:
		#sprite.modulate = lerp(sprite.modulate, Color.GRAY, delta*10.0)
		sprite.material.set_shader_parameter("base_water_color", Color(0.454, 0.251, 0.119))
	else:
		#sprite.modulate = lerp(sprite.modulate, Color.BLUE, delta*10.0)
		sprite.material.set_shader_parameter("base_water_color", Color(0.314, 0.388, 0.769))
	ui.update_progress_bar(value)


func _game_over():
	ui.show_game_over()

func _on_recycle_bin_full_bin() -> void:
	ui.display_epi_select()


func _on_spawn_final_level() -> void:
	if river_status_value == river_status_max:
		get_tree().change_scene_to_file("res://scenes/menu.tscn")
