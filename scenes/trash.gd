extends CharacterBody2D
class_name Trash

signal trash_removed(value: int)

var resource = preload("res://resources/trash_common.tres")
@onready var sprite: Sprite2D = $Sprite2D
@onready var health = resource.health
@onready var stuck_height = resource.stuck_height
@onready var speed = resource.speed
@onready var drop_value = resource.drop_value
@onready var trash_type = resource.trash_type

@onready var progress_wheel: TextureProgressBar = $ProgressWheel

@onready var player = get_tree().get_first_node_in_group("Player")

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var ui: Control = get_tree().get_first_node_in_group("UI")

var sfx_array = [
	preload("res://sfx/sfx-pegar-objetos-var01.ogg"),
	preload("res://sfx/sfx-pegar-objetos-var02.ogg"),
	preload("res://sfx/sfx-pegar-objetos-var03.ogg"),
]


func _ready() -> void:

	sprite.texture = resource.sprite
	
	trash_removed.connect(player.on_trash_removed)


	progress_wheel.max_value = health
	progress_wheel.value = 0


func _physics_process(_delta: float) -> void:

	move_and_slide()


func take_damage(damage_value: int):
	progress_wheel.show()
	progress_wheel.value += damage_value 
	health -= damage_value
	if health <= 0:
		trash_removed.emit(drop_value)
		audio_stream_player.stream = sfx_array.pick_random()
		audio_stream_player.play()
		_drop_rng()
		hide()
		await audio_stream_player.finished
		queue_free()



func _collect():
	match trash_type:
		0:
			pass

func _drop_rng():
	if randf() > 0.8:
		player.net_count += 1
		ui.update_net_count(player.net_count)
