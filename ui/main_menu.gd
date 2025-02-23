extends Control

var accept_input = false
var key_pressed = false
var playPressed = false

# Called when the node enters the scene tree for the first time.
func _ready():
    $SceneTransition/ColorRect.color.a = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass
    

func _input(event):
    if event is InputEventKey and accept_input:
        $AnimationPlayer.play("text_select")
        key_pressed = true
        await $AnimationPlayer.animation_finished
        await get_tree().create_timer(1).timeout
        $TitleSequence.visible = false


func _on_title_sequence_animation_finished():
    accept_input = true
    if !key_pressed:
        await get_tree().create_timer(1).timeout
        $AnimationPlayer.play("flashing_text")


func _on_play_button_pressed():
    if !playPressed:
        playPressed = true
        $SceneTransition/AnimationPlayer.play("fade_to_black")
        await $SceneTransition/AnimationPlayer.animation_finished
        get_tree().change_scene_to_file("res://scenes/combat_map.tscn")


func _on_quit_button_pressed():
    if !playPressed:
        playPressed = true
        $SceneTransition/AnimationPlayer.play("fade_to_black")
        await $SceneTransition/AnimationPlayer.animation_finished
        get_tree().quit()
