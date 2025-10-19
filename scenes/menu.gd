extends Control

@onready var play_button: Button = $PlayButton
@onready var quit_button: Button = $QuitButton
@onready var settings_button: Button = $SettingsButton
@onready var settings_panel: Panel = $SettingsPanel
@onready var sfx_check: CheckBox = $SettingsPanel/SFXCheck
@onready var volume_slider: HSlider = $SettingsPanel/VolumeSlider
@onready var volume_label: Label = $SettingsPanel/VolumeLabel
@onready var back_button: Button = $SettingsPanel/BackButton
@onready var restart_button: Button = $RestartButton

func _ready() -> void:
	$PlayButton.connect("pressed", _on_play_pressed)
	$QuitButton.connect("pressed", _on_quit_pressed)
	settings_button.connect("pressed", _on_settings_pressed)
	back_button.connect("pressed", _on_back_pressed)
	sfx_check.connect("toggled", _on_sfx_toggled)
	volume_slider.connect("value_changed", _on_volume_changed)
	restart_button.connect("pressed", _on_restart_pressed)
	load_settings()

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_settings_pressed() -> void:
	settings_panel.show()

func _on_back_pressed() -> void:
	settings_panel.hide()
	save_settings()

func _on_restart_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")

func _on_sfx_toggled(enabled: bool) -> void:
	AudioServer.set_bus_mute(AudioServer.get_bus_index("SFX"), !enabled)

func _on_volume_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(value / 100.0))
	volume_label.text = "Volume: " + str(int(value)) + "%"

func load_settings() -> void:
	var config = ConfigFile.new()
	var err = config.load("user://settings.cfg")
	if err == OK:
		sfx_check.button_pressed = config.get_value("audio", "sfx_enabled", true)
		volume_slider.value = config.get_value("audio", "volume", 100.0)
	else:
		sfx_check.button_pressed = true
		volume_slider.value = 100.0
	_on_sfx_toggled(sfx_check.button_pressed)
	_on_volume_changed(volume_slider.value)

func save_settings() -> void:
	var config = ConfigFile.new()
	config.set_value("audio", "sfx_enabled", sfx_check.button_pressed)
	config.set_value("audio", "volume", volume_slider.value)
	config.save("user://settings.cfg")