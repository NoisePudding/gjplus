extends Control

@onready var epi_select: Control = $EpiSelect
@onready var progress_bar: ProgressBar = $RiverStatus/ProgressBar
@onready var trash_count: Label = $TrashCounter/Panel/Label


signal upgrade_chosen(choice : int)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	trash_count.text = "0/1"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func set_progress_bar(value: float, max_value: float):
	progress_bar.max_value = max_value
	progress_bar.value = value

func update_progress_bar(value:float):
	progress_bar.value = value


func show_game_over():
	$GameOver.show()
	get_tree().paused = true

func _on_retry_button_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()


func update_trash_count(trash_amount: int, trash_amount_max: int):
	trash_count.text = str(trash_amount) + "/" + str(trash_amount_max)

func display_epi_select():
	epi_select.show()
	get_tree().paused = true

#spagetti
func _on_glove_button_pressed() -> void:
	upgrade_chosen.emit(0)
	get_tree().paused = false
	epi_select.hide()

func _on_protection_button_pressed() -> void:
	upgrade_chosen.emit(1)
	get_tree().paused = false
	epi_select.hide()

func _on_boot_button_pressed() -> void:
	upgrade_chosen.emit(2)
	get_tree().paused = false
	epi_select.hide()
