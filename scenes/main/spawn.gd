extends Node2D

signal final_level()

var rng = RandomNumberGenerator.new()
var pos_array: Array[float] = [100,32,-32,-100] 

var level = 0
var spawn_array = [preload("res://resources/trash_common.tres"), preload("res://resources/trash_tire.tres")]
var is_final = false

var weights = PackedFloat32Array([1, 0])

# Prints one of the four elements in `my_array`.
# It is more likely to print "four", and less likely to print "one".
@onready var timer: Timer = $Timer
var spawn_counter = 0
var counter_limit = 10

var trash = preload("res://scenes/trash.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass



func _on_timer_timeout() -> void:
	if !is_final:
		var instance = trash.instantiate()
		instance.resource = spawn_array[rng.rand_weighted(weights)]
		spawn_counter += 1
		if spawn_counter >= counter_limit:
			level += 1
			level_change(level)
		instance.velocity.y = 300
		instance.position.x = pos_array.pick_random()

		add_child(instance)
	else:
		final_level.emit()
	

func level_change(value : int):
	match value:
		1:
			print("level 1")
			counter_limit = 20
			weights[0] = 1
			weights[1] = 1
			timer.wait_time = 5
		2:
			print("level 2")
			counter_limit = 30
			weights[0] = 2
			weights[1] = 3
			timer.wait_time = 4
		3:
			print("level 2")
			counter_limit = 40
			weights[0] = 1
			weights[1] = 3
			timer.wait_time = 3
		4:
			is_final = true
			
