extends CharacterBody2D

@export var feather_scene : PackedScene
@export var speed : int
@onready var hit = preload("res://assets/sounds/gunhit.wav")
@onready var death = preload("res://assets/sounds/chicken-scream-made-with-Voicemod.mp3")
@onready var explosion = preload("res://assets/sounds/explosion_old.mp3")
@onready var cluck = preload("res://assets/sounds/chicken_1.mp3")
var player_node : CharacterBody2D
var player_position : Vector2
var hp : int = 1

var is_dying : bool = false
var in_radius : bool = false

func _ready():
    $AnimatedSprite2D.play("walk")

func _physics_process(delta):
    if !is_dying:
        if !in_radius:
            if (player_node != null):
                velocity = (player_position - global_position).normalized() * speed * delta
                look_at(player_node.global_position)
            player_position = player_node.global_position
            move_and_slide()
            if position.distance_to(player_position) < 300:
                in_radius = true
            if !$SFX/BirdSFX.playing:
                $SFX/BirdSFX.stream = cluck
                $SFX/BirdSFX.pitch_scale = randf_range(.85, 1.15)
                $SFX/BirdSFX.play()
        else:
            velocity = (player_position - global_position).normalized() * speed * delta
            move_and_slide()
            if get_slide_collision_count() != 0:
                die(false)
        if position.distance_to(player_position) < 3:
            die(false)
    
func die(feather_drop : bool):
    if !is_dying:
        $SFX/HurtSFX.stream = death
        $SFX/HurtSFX.pitch_scale = randf_range(.85, 1.15)
        $SFX/HurtSFX.play()
        $SFX/BirdSFX.stream = explosion
        $SFX/BirdSFX.pitch_scale = randf_range(.85, 1.15)
        $SFX/BirdSFX.play()
    $AnimatedSprite2D.play("die")
    $AnimatedSprite2D.scale = Vector2(1.5, 1.5)
    $CollisionShape2D.scale = Vector2(2.5, 2.5)
    $AnimatedSprite2D.z_index = 15
    #set_collision_layer_value(3, false)
    #set_collision_layer_value(4, true)
    if feather_drop && !is_dying:
        var feather_spawn = feather_scene.instantiate()
        feather_spawn.global_position = global_position
        get_tree().current_scene.add_child(feather_spawn)
    is_dying = true

func _on_animated_sprite_2d_animation_finished():
    if $AnimatedSprite2D.animation == "die":
        $CollisionShape2D.disabled = true
        $AnimatedSprite2D.visible = false

func _on_area_2d_body_entered(body):
    print(body)
    if is_dying:
        if body == player_node:
            body.take_damage(1)

func hurtAudio():
    if !is_dying:
        if hp > 0:
            $SFX/HurtSFX.stream = hit
            $SFX/HurtSFX.pitch_scale = randf_range(.85, 1.15)
            $SFX/HurtSFX.play()

func _on_hurt_sfx_finished() -> void:
    if $SFX/HurtSFX.stream == death:
        remove_from_group("enemies")
        queue_free()
    pass # Replace with function body.

func _on_bird_sfx_finished() -> void:
    if $SFX/BirdSFX.stream == cluck:
        $SFX/BirdSFX.stream = cluck
        $SFX/BirdSFX.pitch_scale = randf_range(.85, 1.15)
        $SFX/BirdSFX.play()
    pass # Replace with function body.
