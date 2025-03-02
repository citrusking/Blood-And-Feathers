extends Control

@onready var menuTrack = preload("res://assets/sounds/Beasuce - Acid Dance.mp3")


# Called when the node enters the scene tree for the first time.
func _ready():
    $Music.stream = menuTrack
    $Music.pitch_scale = 1
    $Music.play()


func _on_play_button_pressed():
    pass


func _on_quit_button_pressed():
        get_tree().quit()
