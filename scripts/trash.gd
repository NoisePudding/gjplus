extends CharacterBody2D



var resource = preload("res://resources/trash_common.tres")
var health
var sprite
var stuck_height
var speed
func _ready() -> void:
	health = resource.health
	# sprite = resource.sprite
	stuck_height = resource.stuck_height
	speed = resource.speed
	velocity.y = speed

func _physics_process(_delta: float) -> void:

	velocity.y = speed
	move_and_slide()
