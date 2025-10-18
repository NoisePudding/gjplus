extends CharacterBody2D

signal trash_removed(value: int)

var resource = preload("res://resources/trash_common.tres")
@onready var health = resource.health
@onready var sprite
@onready var stuck_height = resource.stuck_height
@onready var speed = resource.speed
@onready var drop_value = resource.drop_value

@onready var progress_wheel: TextureProgressBar = $ProgressWheel

@onready var player = get_tree().get_first_node_in_group("Player")
func _ready() -> void:

	# sprite = resource.sprite
	
	trash_removed.connect(player.on_trash_removed)


	progress_wheel.max_value = health
	progress_wheel.value = 0


func _physics_process(_delta: float) -> void:

	velocity.y = speed
	move_and_slide()


func take_damage(damage_value: int):
	progress_wheel.show()
	progress_wheel.value += damage_value 
	health -= damage_value
	if health <= 0:
		trash_removed.emit(drop_value)
		queue_free()
