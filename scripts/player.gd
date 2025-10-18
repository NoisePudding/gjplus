extends CharacterBody2D


const SPEED = 300.0

var trash_count = 0
var damage = 1
var is_on_cooldown = false
var interact_array = []
var is_interacting = false
@onready var cooldown_timer: Timer = $Cooldown

func _physics_process(_delta: float) -> void:
	var direction = Input.get_vector("left", "right", "up", "down")
	if direction and !is_interacting:
		velocity = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0,  SPEED)

	if is_interacting:
		_interact()
	move_and_slide()

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("interact"):
		is_interacting = true
	if Input.is_action_just_released("interact"):
		is_interacting = false

func _on_interact_area_body_entered(body: Node2D) -> void:
	interact_array.append(body)

func _on_interact_area_body_exited(body: Node2D) -> void:
	interact_array.erase(body)


func on_trash_removed(drop_value: int):
	trash_count += drop_value


func _on_cooldown_timeout() -> void:
	is_on_cooldown = false

func _interact():
	if  !interact_array.is_empty() && !is_on_cooldown:
		var closer_body = interact_array[0]
		for body in interact_array:
			if position.distance_to(body.global_position) < position.distance_to(closer_body.global_position):
				closer_body = body
		closer_body.take_damage(damage)
		is_on_cooldown = true
		cooldown_timer.start()
