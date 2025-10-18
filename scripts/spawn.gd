extends Node2D



var pos_array: Array[float] = [100,32,-32,-100] 

var trash = preload("res://scenes/trash.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass



func _on_timer_timeout() -> void:
	var instance = trash.instantiate()
	instance.position.x = pos_array.pick_random()
	add_child(instance)
	
