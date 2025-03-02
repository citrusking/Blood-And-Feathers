extends Node2D

@export var title_sequence_scene : PackedScene
@export var main_menu_scene : PackedScene
@export var combat_scene : PackedScene
@export var shop_scene : PackedScene
var current_scene_instance

# Called when the node enters the scene tree for the first time.
func _ready():
    current_scene_instance = title_sequence_scene.instantiate()
    add_child(current_scene_instance)
    current_scene_instance.connect("change_scene", change_scene)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
    check_dev_keys()
    

func change_scene(scene_name : String):
    print("change scene to: " + scene_name)
    $AnimationPlayer.play("to_black")
    await $AnimationPlayer.animation_finished
    current_scene_instance.queue_free()
    
    match scene_name:
        "title":
            current_scene_instance = title_sequence_scene.instantiate()
        "main_menu":
            current_scene_instance = main_menu_scene.instantiate()
        "combat":
            current_scene_instance = combat_scene.instantiate()
        "shop":
            current_scene_instance = shop_scene.instantiate()
    
    add_child(current_scene_instance)
    $AnimationPlayer.play("from_black")
    
    
func check_dev_keys():
    if Input.is_action_just_pressed("dev_1"):
        change_scene("main_menu")
    elif Input.is_action_just_pressed("dev_2"):
        change_scene("combat")
    elif Input.is_action_just_pressed("dev_3"):
        change_scene("shop")
