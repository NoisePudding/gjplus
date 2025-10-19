extends Node2D
class_name Net

signal net_destroyed()
@onready var filter_rate: Timer = $FilterRate
var interact_array = []
var is_filtering = false
var health = 20
@onready var progress_bar: ProgressBar = $ProgressBar

@onready var sprite: Sprite2D = $StaticBody2D/Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	progress_bar.value = health


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _physics_process(_delta: float) -> void:
	if !interact_array.is_empty() and !is_filtering:
		filter_rate.start()
		is_filtering = true
		take_damage(1)
		for trash in interact_array:
			if trash.health > 1:
				trash.take_damage(1)

func _on_filter_area_body_entered(body: Node2D) -> void:
	interact_array.append(body)


func _on_filter_rate_timeout() -> void:
	is_filtering = false


func _on_filter_area_body_exited(body: Node2D) -> void:
	interact_array.erase(body)



func build_net():
	sprite.show()

func destroy_net():
	net_destroyed.emit()
	queue_free()

func take_damage(value: int):
	health -= value
	progress_bar.value = health
	if health <= 0:
		destroy_net()
