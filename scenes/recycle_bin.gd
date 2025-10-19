extends StaticBody2D
class_name TrashBin


signal trash_recycled(value: int)
signal full_bin()

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var texture_progress_bar: TextureProgressBar = $Control/TextureProgressBar
@export var counter = 0
@export var max_counter = 10
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	texture_progress_bar.max_value = max_counter


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func update_counter(value):
	counter += value
	texture_progress_bar.value = counter
	trash_recycled.emit(value)
	if counter >= max_counter:
		audio_stream_player.play()
		full_bin.emit()
		counter = 0
		max_counter += 5
		texture_progress_bar.value = counter
		texture_progress_bar.max_value = max_counter