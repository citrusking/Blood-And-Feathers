extends CharacterBody2D

@export var feather_scene : PackedScene
@export var speed : int
@onready var hit = preload("res://assets/sounds/gunhit.wav")
@onready var death = preload("res://assets/sounds/budgieBlowup.mp3")
    
var player_node : CharacterBody2D
var hp : int = 2

var is_dying : bool = false

func _ready():
    $AnimatedSprite2D.play("walk")

func _physics_process(delta):
    if !is_dying:
        if (player_node != null):
            velocity = (player_node.global_position - global_position).normalized() * speed * delta
            look_at(player_node.global_position)
        move_and_slide()
    
func die(feather_drop : bool):
    $AnimatedSprite2D.play("die")
    is_dying = true
    set_collision_layer_value(3, false)
    set_collision_layer_value(4, false)
    remove_from_group("enemies") # this is so that the bullet will go through it while dying
    var feather_spawn = feather_scene.instantiate()
    feather_spawn.global_position = global_position
    get_tree().current_scene.add_child(feather_spawn)

func _on_animated_sprite_2d_animation_finished():
    if $AnimatedSprite2D.animation == "die":
        $CollisionShape2D.disabled = true
        $AnimatedSprite2D.visible = false

func hurtAudio():
    if hp > 0:
        $SFX/HurtSFX.stream = hit
        $SFX/HurtSFX.pitch_scale = randf_range(.85, 1.15)
        $SFX/HurtSFX.play()
    else:
        $SFX/HurtSFX.stream = death
        $SFX/HurtSFX.pitch_scale = randf_range(.85, 1.15)
        $SFX/HurtSFX.play()

func _on_hurt_sfx_finished() -> void:
    if $SFX/HurtSFX.stream == death:
        remove_from_group("enemies")
        queue_free()
    pass # Replace with function body.
