extends CharacterBody2D


const SPEED = 300.0

@export var trash_count_max = 1
@export var trash_count = 0
@export var damage = 1
@export var defense = 0
@export var speed_bonus = 0
@export var net_count = 0

var is_on_cooldown = false
var interact_array = []
var is_interacting = false
var is_full = false
var inventory = []
var is_step = false
var is_water = false


@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var no_room_player: AudioStreamPlayer = $NoRoomPlayer
@onready var prompt: Control = $Prompt
@onready var cooldown_timer: Timer = $Cooldown
@onready var ui: Control = get_tree().get_first_node_in_group("UI")
@onready var step_timer: Timer = $StepTimer
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var step_audio_array = [
	preload("res://sfx/sfx-passos-grama-001.ogg"),
	preload("res://sfx/sfx-passos-grama-002.ogg"),
	preload("res://sfx/sfx-passos-grama-003.ogg"),
	preload("res://sfx/sfx-passos-grama-004.ogg"),
	preload("res://sfx/sfx-passos-grama-005.ogg"),
	preload("res://sfx/sfx-passos-grama-006.ogg"),
]

var step_audio_array_water = [
	preload("res://sfx/sfx-passos-dentrodagua-001.ogg"),
	preload("res://sfx/sfx-passos-dentrodagua-002.ogg"),
	preload("res://sfx/sfx-passos-dentrodagua-003.ogg"),
	preload("res://sfx/sfx-passos-dentrodagua-004.ogg"),
	preload("res://sfx/sfx-passos-dentrodagua-005.ogg"),
	preload("res://sfx/sfx-passos-dentrodagua-006.ogg"),
	preload("res://sfx/sfx-passos-dentrodagua-007.ogg"),
]
func _ready() -> void:
	#ui.update_trash_count(trash_count,trash_count_m+x)
	pass

func _physics_process(_delta: float) -> void:
	var direction = Input.get_vector("left", "right", "up", "down")
	if direction and !is_interacting:
		velocity = direction * (SPEED + speed_bonus)
		animated_sprite.play("walk")
		if !audio_stream_player.playing && !is_step:
			step_timer.start()
			is_step = true
			if is_water:
				audio_stream_player.stream = step_audio_array_water.pick_random()
			else:
				audio_stream_player.stream = step_audio_array.pick_random()
			audio_stream_player.play()
		if direction.x < 0:
			animated_sprite.flip_h = true
		else:
			animated_sprite.flip_h = false
	else:
		animated_sprite.play("idle")
		velocity.x = move_toward(velocity.x, 0, SPEED + speed_bonus)
		velocity.y = move_toward(velocity.y, 0,  SPEED + speed_bonus)
		
	if is_interacting:
		_interact()

	if !interact_array.is_empty():
		prompt.show()
	else:
		prompt.hide()

	move_and_slide()


func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("interact"):
		is_interacting = true
	if Input.is_action_just_released("interact"):
		is_interacting = false


func _on_interact_area_body_entered(body: Node2D) -> void:
	interact_array.append(body)
	#prompt.show()


func _on_interact_area_body_exited(body: Node2D) -> void:
	interact_array.erase(body)
	#prompt.hide()

func on_trash_removed(drop_value: int):
	trash_count += drop_value
	ui.update_trash_count(trash_count,trash_count_max)
	if trash_count >= trash_count_max:
		is_full = true

func on_trash_recycled(drop_value: int):
	trash_count -= drop_value
	ui.update_trash_count(trash_count,trash_count_max)
	if trash_count < trash_count_max:
		is_full = false

func _on_cooldown_timeout() -> void:
	is_on_cooldown = false


func _interact():
	if !interact_array.is_empty():
		if interact_array[0] is TrashBin && trash_count>0 && !is_on_cooldown:
			interact_array[0].update_counter(1)
			is_on_cooldown = true
			cooldown_timer.start()
			is_interacting = false
		elif !is_on_cooldown && interact_array[0] is Trash:
			var closer_body = interact_array[0]
			for body in interact_array:
				if position.distance_to(body.global_position) < position.distance_to(closer_body.global_position):
					closer_body = body
			if !is_full:
				closer_body.take_damage(damage)
				is_on_cooldown = true
				cooldown_timer.start()
			else:
				if !no_room_player.playing:
					no_room_player.play()
				ui.play_no_room()
		elif interact_array[0] is NetBase:
			if !interact_array[0].is_net_on && net_count > 0:
				net_count -= 1
				ui.update_net_count(net_count)
				interact_array[0].build_net()
	
func on_upgrade_chosen(choice:int):
	match choice:
		0:
			damage += 1
			pass
		1:
			defense += 1
			pass
		2:
			speed_bonus += 100
			pass


func _on_step_timer_timeout() -> void:
	is_step = false


func _on_water_area_body_entered(body: Node2D) -> void:
	is_water = true


func _on_water_area_body_exited(body: Node2D) -> void:
	is_water = false
