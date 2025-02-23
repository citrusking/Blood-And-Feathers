extends Control

var accept_input = false
var key_pressed = false

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass
    

func _input(event):
    if event is InputEventKey and accept_input:
        $AnimationPlayer.play("text_select")
        key_pressed = true


func _on_title_sequence_animation_finished():
    accept_input = true
    if !key_pressed:
        await get_tree().create_timer(1).timeout
        $AnimationPlayer.play("flashing_text")


func _on_animation_player_animation_finished(anim_name):
    if anim_name == "text_select":
        await get_tree().create_timer(1).timeout
        $TitleSequence.visible = false
