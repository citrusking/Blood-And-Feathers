extends Node2D

signal change_scene(scene_name : String)

# Called when the node enters the scene tree for the first time.
func _ready():
    $AnimationPlayer.play("intro_cutscene")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
    if Input.is_anything_pressed():
        $AnimationPlayer.play("something_pressed")


func _on_animation_player_animation_finished(anim_name):
    if anim_name == "intro_cutscene":
        $AnimationPlayer.play("title")
    if anim_name == "title":
        $AnimationPlayer.play("flash_text")
    if anim_name == "something_pressed":
        change_scene.emit("main_menu")
